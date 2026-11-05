global class XVA_BatchTransferAccounts implements Database.Batchable<sObject>, Database.Stateful {
    Set<Id> successfulTransfers = new Set<Id>();

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, needs_to_be_transferred__c, transfer_to__c, cimi_Id__c, BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry, street2__c,
                                        Type, ParentId, source_of_creation__c, HeadQuarter__c, phone, website, fax, UsingPortal__c, Description, Case_Mgmt_Software__c, target_level__c,
                                                                                                            (SELECT Id, AccountId, IsActive, ContactId, IsDirect, EndDate, Roles, StartDate
                                                                                                            FROM AccountContactRelations),
                                                                                                            (SELECT AccountId, whatId, ownerId, CallDurationInSeconds, CallObject, CallDisposition,
                                                                                                            CallType, Description, CompletedDateTime, IsRecurrence, ActivityDate, WhoId,
                                                                                                            Priority, RecurrenceInterval, IsReminderSet, RecurrenceRegeneratedType, Status,
                                                                                                            Subject, REcordTypeId, TaskSubtype, ActivityQualification__c, Appointment_Status__c, AttorneyNoteId__c,
                                                                                                            BackendSystem_OwnerName__c, Batch_Name__c, Closed_for_no_response__c,
                                                                                                            Contact_Attempts__c, Created_Inclusive__c, Cross_Sell__c, Date__c, Oasis_Event_Result__c, Oasis_Sub_Type__c,
                                                                                                            Oasis_Type__c, Oasis_Event_Purpose__c, Type
                                                                                                            FROM Tasks ),
                                                                                                            (SELECT Id, whatId, isAllDayEvent, OwnerId, ActivityDate, Description, DurationInMinutes, EndDateTime,
                                                                                                            RecordTypeId, EventSubType, Location, IsPrivate, IsReminderSet, IsREcurrence2, ShowAs, StartDateTime,
                                                                                                            Subject, ActivityDateTime, Type, WhoId,  ActivityQualification__c, Appointment_Status__c, AttorneyNoteId__c,
                                                                                                            BackendSystem_OwnerName__c, Batch_Name__c, Closed_for_no_response__c,
                                                                                                            Contact_Attempts__c, Created_Inclusive__c, Cross_Sell__c, Date__c, Oasis_Event_Result__c, Oasis_Sub_Type__c,
                                                                                                            Oasis_Type__c, Oasis_Event_Purpose__c 
                                                                                                            FROM Events),
                                                                                                            (SELECT Id, AccountId 
                                                                                                            FROM Contacts),
                                                                                                            (SELECT Id, name, Account__c, contact__c, role__c, Address1__c, Address2__c, AtticusId__c, PresetID__c, Cimi__c,
                                                                                                            City__c, Contact_Email__c, Contact_Fax__c, Contact_Phone__c, Flow_Flag__c, GRSId__c,KeymedsId__c,
                                                                                                            OwnerId, PostalCode__c, State__c
                                                                                                            FROM Account_Relations__r),
                                                                                                            (SELECT Id, firm_name__c, AtticusId__c, Cimi__c, Email__c, Extension__c, Oasis_GRSId_Display__c, GRSId__c,
                                                                                                            Oasis_KeyMedsId_Display__c, KeyMedsId__c, OwnerId, Oasis_Preset_Id_display__c, PresetId__c, Role__c, Contact__c
                                                                                                            FROM Non_Attorney_Contacts__r),
                                                                                                            (SELECT Id, AccountId, cimi_account__c 
                                                                                                            FROM Opportunities),
                                                                                                            (SELECT Id, LinkedEntityId FROM ContentDocumentLinks)
                                                                                                            FROM Account
                                                                                                            WHERE transfer_to__c != null AND needs_to_be_transferred__c = true]);
    }
    
    
    global void execute(Database.BatchableContext bc, List<Account> scope) {
        List<Account> accountsToUpdate = new List<Account>();
        List<AccountContactRelation> accConRelToInsert = new List<AccountContactRelation>();
        List<Task> tasksToInsert = new List<Task>();
        List<Event> eventsToInsert = new List<Event>();
        List<Contact> contactsToUpdate = new List<Contact>();
        List<Account_Relation__c> attorneyProvidersToInsert = new List<Account_Relation__c>();
        List<Non_Attorney_Contact__c> nonAttorneyContactsToUpdate = new List<Non_Attorney_Contact__c>();
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        List<ContentDocumentLink> contentDocumentLinksToInsert = new List<ContentDocumentLink>();
        Set<String> accTransferredToSet = new Set<String>();
        Map<String, Account> transferToMap = new Map<String, Account>();
        Map<String, Account> transferFromMap = new Map<String, Account>();
        Set<Id> accountIds = new Set<Id>();
        Map<Id, Contact> contactIds = new Map<Id, Contact>();

        for(Account acc: scope){
            accTransferredToSet.add(acc.transfer_to__c);
            transferFromMap.put(acc.transfer_to__c, acc);
            accountIds.add(acc.Id);
            if(acc.Contacts != null) 
            {
                for(Contact con : acc.Contacts) {
                    contactIds.put(con.Id, con);
                }
            }
            
                
            
        }

        List<Event> eventsToClone = [SELECT Id, AccountId, whatId, isAllDayEvent, OwnerId, ActivityDate, Description, DurationInMinutes, EndDateTime,
        RecordTypeId, EventSubType, Location, IsPrivate, IsReminderSet, IsREcurrence2, ShowAs, StartDateTime,
        Subject, ActivityDateTime, Type, WhoId,  ActivityQualification__c, Appointment_Status__c, AttorneyNoteId__c,
        BackendSystem_OwnerName__c, Batch_Name__c, Closed_for_no_response__c,
        Contact_Attempts__c, Created_Inclusive__c, Cross_Sell__c, Date__c, Oasis_Event_Result__c, Oasis_Sub_Type__c,
        Oasis_Type__c, Oasis_Event_Purpose__c, Cloned_From_ID__c
        FROM Event where whatId in :accountIds or AccountId in :accountIds];

        List<Task> tasksToClone = [SELECT AccountId, whatId, ownerId, CallDurationInSeconds, CallObject, CallDisposition,
        CallType, Description, CompletedDateTime, IsRecurrence, ActivityDate, WhoId,
        Priority, RecurrenceInterval, IsReminderSet, RecurrenceRegeneratedType, Status,
        Subject, REcordTypeId, TaskSubtype, ActivityQualification__c, Appointment_Status__c, AttorneyNoteId__c,
        BackendSystem_OwnerName__c, Batch_Name__c, Closed_for_no_response__c,
        Contact_Attempts__c, Created_Inclusive__c, Cross_Sell__c, Date__c, Oasis_Event_Result__c, Oasis_Sub_Type__c,
        Oasis_Type__c, Oasis_Event_Purpose__c, Type, Cloned_From_ID__c
        FROM Task where whatId in :accountIds or AccountId in :accountIds];

        /*

        Code to associate tasks with accounts and events with parent accounts


        Set<Id> taskIds = [Select TaskId 
        from TaskWhoRelation 
        where RelationId in :contactIds]  

        List<Task> contactRelatedEvents = [Select Id, AccountId, whatId, ownerId, CallDurationInSeconds, CallObject, CallDisposition,
        CallType, Description, CompletedDateTime, IsRecurrence, ActivityDate, WhoId,
        Priority, RecurrenceInterval, IsReminderSet, RecurrenceRegeneratedType, Status,
        Subject, REcordTypeId, TaskSubtype, ActivityQualification__c, Appointment_Status__c, AttorneyNoteId__c,
        BackendSystem_OwnerName__c, Batch_Name__c, Closed_for_no_response__c,
        Contact_Attempts__c, Created_Inclusive__c, Cross_Sell__c, Date__c, Oasis_Event_Result__c, Oasis_Sub_Type__c,
        Oasis_Type__c, Oasis_Event_Purpose__c, Type,
        (Select RelationId from TaskWhoRelations)
            from Task 
            where Id in (Select TaskId 
                            from TaskWhoRelation 
                            where RelationId in :contactIds)]; 
                            
                
        Map<Id, List<Event>> contactRelatedEventsMap = new Map<Id, List<Event>>();
        for(Task t : contactRelatedEvents) {
 
             Id accountId;
 
             for(TaskWhoRelation who :t.TaskWhoRelations)
             {
                 Id tempAccountId = contactIds.get(who.RelationId).AccountId;
                 if (accountIds.contains(tempAccountId))
                 { 
                     accountId = tempAccountId;
                     break;
                 }
             }
 
             if(tasksMap.containsKey(accountId)) tasksMap.get(accountId).add(t);
             else tasksMap.put(accountId, new List<Task>{t});
 
         } 
                            
                            
                            */

        Map<Id, List<Event>> eventsMap = new Map<Id, List<Event>>();
        for(Event ev : eventsToClone) 
        {
            Id accountId = ev.AccountId != null ? ev.AccountId : ev.WhatId;
            if(eventsMap.containsKey(accountId))    eventsMap.get(accountId).add(ev);
            else eventsMap.put(accountId, new List<Event>{ev});
        }

        Map<Id, List<Task>> tasksMap = new Map<Id, List<Task>>();
        for(Task t : tasksToClone) {
            Id accountId = t.AccountId != null ? t.AccountId : t.WhatId;
            if(tasksMap.containsKey(accountId)) tasksMap.get(accountId).add(t);
            
            else tasksMap.put(accountId, new List<Task>{t});
            
        }




        List<Account> cimiAccTransferToList = [Select Id, needs_to_be_transferred__c, transfer_to__c, cimi_Id__c, BillingStreet, BillingState, BillingCity, BillingCountry, BillingPostalCode, street2__c,
        Type, ParentId, source_of_creation__c, HeadQuarter__c, phone, website, fax, UsingPortal__c, Description, Case_Mgmt_Software__c, target_level__c
        FROM Account
        WHERE cimi_id__c IN :accTransferredToSet];
        system.debug('cimi merge to list size '+cimiAccTransferToList.size());
        for(Account acc : cimiAccTransferToList){
            transferToMap.put(acc.cimi_Id__c,acc);
            acc.BillingStreet = (acc.BillingStreet == null) ? (transferFromMap.get(acc.cimi_id__c).BillingStreet == null ? acc.BillingStreet : transferFromMap.get(acc.cimi_id__c).BillingStreet) : acc.BillingStreet;
            acc.BillingCity = (acc.BillingCity == null) ? (transferFromMap.get(acc.cimi_id__c).BillingCity == null ? acc.BillingCity : transferFromMap.get(acc.cimi_id__c).BillingCity) : acc.BillingCity;
            acc.BillingState = (acc.BillingState == null) ? (transferFromMap.get(acc.cimi_id__c).BillingState == null ? acc.BillingState : transferFromMap.get(acc.cimi_id__c).BillingState) : acc.BillingState;
            acc.BillingPostalCode = (acc.BillingPostalCode == null) ? (transferFromMap.get(acc.cimi_id__c).BillingPostalCode == null ? acc.BillingPostalCode : transferFromMap.get(acc.cimi_id__c).BillingPostalCode) : acc.BillingPostalCode;
            acc.street2__c = (acc.street2__c == null) ? (transferFromMap.get(acc.cimi_id__c).street2__c == null ? acc.street2__c : transferFromMap.get(acc.cimi_id__c).street2__c) : acc.street2__c;
            acc.BillingCountry = (acc.BillingCountry == null) ? (transferFromMap.get(acc.cimi_id__c).BillingCountry == null ? acc.BillingCountry : transferFromMap.get(acc.cimi_id__c).BillingCountry) : acc.BillingCountry;
            acc.Type = (acc.Type == null) ? (transferFromMap.get(acc.cimi_id__c).Type == null ? acc.Type : transferFromMap.get(acc.cimi_id__c).Type) : acc.Type;
            //acc.ParentId = (acc.ParentId == null) ? (transferFromMap.get(acc.cimi_id__c).ParentId == null ? acc.ParentId : transferFromMap.get(acc.cimi_id__c).ParentId) : acc.ParentId;
            acc.source_of_creation__c = (acc.source_of_creation__c == null) ? (transferFromMap.get(acc.cimi_id__c).source_of_creation__c == null ? acc.source_of_creation__c : transferFromMap.get(acc.cimi_id__c).source_of_creation__c) : acc.source_of_creation__c;
            //acc.HeadQuarter__c = (acc.HeadQuarter__c == null) ? (transferFromMap.get(acc.cimi_id__c).HeadQuarter__c == null ? acc.HeadQuarter__c : transferFromMap.get(acc.cimi_id__c).HeadQuarter__c) : acc.HeadQuarter__c;
            acc.phone = (acc.phone == null) ? (transferFromMap.get(acc.cimi_id__c).phone == null ? acc.phone : transferFromMap.get(acc.cimi_id__c).phone) : acc.phone;
            acc.website = (acc.website == null) ? (transferFromMap.get(acc.cimi_id__c).website == null ? acc.website : transferFromMap.get(acc.cimi_id__c).website) : acc.website;
            acc.fax = (!String.isBlank(acc.fax)) ? acc.fax : (!String.isBlank(transferFromMap.get(acc.cimi_id__c).fax)) ? transferFromMap.get(acc.cimi_id__c).fax : acc.fax;
            acc.UsingPortal__c = (acc.UsingPortal__c == null) ? (transferFromMap.get(acc.cimi_id__c).UsingPortal__c == null ? acc.UsingPortal__c : transferFromMap.get(acc.cimi_id__c).UsingPortal__c) : acc.UsingPortal__c;
            acc.Description = (acc.Description == null) ? (transferFromMap.get(acc.cimi_id__c).Description == null ? acc.Description : transferFromMap.get(acc.cimi_id__c).Description) : acc.Description;
            acc.Case_Mgmt_Software__c = (acc.Case_Mgmt_Software__c == null) ? (transferFromMap.get(acc.cimi_id__c).Case_Mgmt_Software__c == null ? acc.Case_Mgmt_Software__c : transferFromMap.get(acc.cimi_id__c).Case_Mgmt_Software__c) : acc.Case_Mgmt_Software__c;
            acc.target_level__c = (acc.target_level__c == null) ? (transferFromMap.get(acc.cimi_id__c).target_level__c == null ? acc.target_level__c : transferFromMap.get(acc.cimi_id__c).target_level__c) : acc.target_level__c;

            accountsToUpdate.add(acc);
        }
        for(Account acc: scope){
            Id toAccId = transferToMap.get(acc.transfer_to__c).Id;
            system.debug('acc billing street '+acc.BillingStreet);
            system.debug('acc billing city '+acc.BillingCity);
            system.debug('acc billing state '+acc.BillingState);
            system.debug('acc billing postal code '+acc.BillingPostalCode);
            system.debug('acc billing country '+acc.BillingCountry);
            system.debug('acc street2 '+acc.street2__c);
            system.debug('acc Merge to '+transferToMap.get(acc.transfer_to__c));    


            

            //if(acc.Tasks != null){
            if(tasksMap.containsKey(acc.Id))
            {

                List<Task> tasks = tasksMap.get(acc.Id);
                system.debug('task size '+acc.Tasks.size());
                for(Task tsk: tasks){
                    system.debug('task what id before '+tsk.whatId);
                    Task cimiTask = new Task();
                    system.debug('task size - clone '+acc.Tasks.size());
                    cimiTask = tsk.clone(false, true, true, false);
                    cimiTask.whatId = toAccId;
                    cimiTask.Cloned_From_ID__c = tsk.Id;
                    //cimiTask.AccountId = toAccId;
                    //tsk.whatId = toAccId;
                    system.debug('task size-clone-after'+acc.Tasks.size());
                    system.debug('task what id after '+cimiTask.whatId);
                    tasksToInsert.add(cimiTask);
                }
            }
                system.debug('task list size '+tasksToInsert.size());
                

                
            if (eventsMap.containsKey(acc.Id)) {
                //if(acc.Events != null){
                    List<Event> events = eventsMap.get(acc.Id);
                    system.debug('event size '+acc.Events.size());
                    for(Event evt: events){
                        system.debug('event what id before '+evt.whatId);
                        Event cimiEvent = new Event();
                        system.debug('event size-clone '+acc.Events.size());
                        cimiEvent = evt.clone(false, true, true, false);
                        cimiEvent.whatId = toAccId;
                        cimiEvent.Cloned_From_ID__c = evt.Id;
                        //evt.whatId = toAccId;
                        system.debug('event size-clone-after'+acc.Events.size());
                        system.debug('event what id after '+cimiEvent.whatId);
                        eventsToInsert.add(cimiEvent);
                    }
            }
                system.debug('event list size '+eventsToInsert.size());
                
                /*
                 if(acc.Contacts != null){
                    for(Contact con: acc.Contacts){
                        system.debug('contact what id before '+con.AccountId);
                        con.AccountId = toAccId;
                        system.debug('contact what id after '+con.AccountId);
                        contactsToUpdate.add(con);
                    }
                } */

                if(acc.AccountContactRelations != null){
                    for(AccountContactRelation acr: acc.AccountContactRelations){
                        AccountContactRelation accConRel = new AccountContactRelation();
                        accConRel = acr.clone(false, true, false, false);
                        accConRel.AccountId = toAccId;
                        accConRelToInsert.add(accConRel);
                    }
                }

                if(acc.Account_Relations__r != null){
                    for(Account_Relation__c ar: acc.Account_Relations__r){
                       Account_Relation__c accRel = new Account_Relation__c();
                       accRel = ar.clone(false, true, false, false);
                       accRel.Account__c = toAccId;
                       attorneyProvidersToInsert.add(accRel);
                    }
                }

                if(acc.Non_Attorney_Contacts__r != null){
                    for(Non_Attorney_Contact__c nac: acc.Non_Attorney_Contacts__r){
                        Non_Attorney_Contact__c supCon = new Non_Attorney_Contact__c();
                        supCon = nac.clone(false, true, false, false);
                        supCon.firm_name__c = toAccId;
                        nonAttorneyContactsToUpdate.add(supCon);
                        //nac.firm_name__c = toAccId;
                        //nonAttorneyContactsToUpdate.add(nac);
                    }
                }

                if(acc.Opportunities != null){
                    for(Opportunity opp: acc.Opportunities){
                        opp.cimi_account__c = toAccId;
                        opportunitiesToUpdate.add(opp);
                    }
                }

                if(acc.ContentDocumentLinks != null){
                    for(ContentDocumentLink cdl: acc.ContentDocumentLinks){
                        ContentDocumentLink condoclnk = cdl.clone(false, false, true, true);
                        condoclnk.LinkedEntityId = toAccId;
                        contentDocumentLinksToInsert.add(condoclnk);
                    }
                }
                
        }   
        
       
        //system.debug('taskupdate size '+tasksToupdate.size());
        system.debug('events update size '+eventsToInsert.size());
        system.debug('contacts to update size '+contactsToUpdate.Size());
        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }
        if(!tasksToInsert.isEmpty()){
            insert tasksToInsert;
        }
        if(!eventsToInsert.isEmpty()){
            insert eventsToInsert;
        }
        if(!contactsToUpdate.isEmpty()){
            Database.update(contactsToUpdate, false);
        }
        if(!accConRelToInsert.isEmpty()){
            Database.insert(accConRelToInsert, false);
        }
        if(!attorneyProvidersToInsert.isEmpty()){
            insert attorneyProvidersToInsert;
        }
        if(!nonAttorneyContactsToUpdate.isEmpty()){
            insert nonAttorneyContactsToUpdate;
        }
        if(!opportunitiesToUpdate.isEmpty()){
            update opportunitiesToUpdate;
        }
        if(!contentDocumentLinksToInsert.isEmpty()){
            Database.insert(contentDocumentLinksToInsert, false);
        }

        for(Account acc: scope){
            successfulTransfers.add(acc.Id);
        }
        
    }
    
    global void finish(Database.BatchableContext bc) {
        List<Account> transferredAccounts = [SELECT id, needs_to_be_transferred__c
                                        FROM Account
                                        WHERE transfer_to__c != null AND needs_to_be_transferred__c = true and Id in :successfulTransfers];
        for(Account acc : transferredAccounts){
            acc.needs_to_be_transferred__c = false;
        }
        update transferredAccounts; 
     } 
}