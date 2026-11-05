public class EventTriggerHandler {
    public static boolean isInserted = false;
    public static Boolean isEventPresetCalloutDone = true;
    public static void beforeinsert(list<event> lstEvent){
        
        set<string> huntIds = new set<string>();
        
        for(event evt : lstEvent){
            if(evt.WhatId !=Null){
                if(evt.WhatId.getSObjectType().getDescribe().getName()=='Hunt_List__c')
                {
                    
                    huntIds.add(evt.whatId);        
                }}
        }
        
        if(huntIds.size() > 0){
            
            map<string,Hunt_List__c> mapHunt = new map<string,Hunt_List__c>();
            
            for(Hunt_List__c objHunt : [SELECT id,Attorney_1__c,Attorney_Firm_1__c,Attorney_Firm_1__r.Description,
                                        Attorney_Firm_1__r.billingStreet,Attorney_Firm_1__r.Street2__c,Attorney_Firm_1__r.billingCity,Attorney_Firm_1__r.billingstate,
                                        Attorney_Firm_1__r.billingCountry,Attorney_Firm_1__r.billingPostalCode FROM Hunt_List__c 
                                        WHERE id =: huntIds]){
                                            mapHunt.put(objHunt.id,objHunt);                            
                                        }
            
            for(event evt : lstEvent){
                if(evt.WhatId !=Null){
                    if(evt.WhatId.getSObjectType().getDescribe().getName()=='Hunt_List__c' && mapHunt.containsKey(evt.whatId))
                    {                                        
                        // evt.whoId = mapHunt.get(evt.whatId).Attorney_1__c;
                        //  evt.Description = mapHunt.get(evt.whatId).Attorney_Firm_1__r.Description;
                        evt.Location = mapHunt.get(evt.whatId).Attorney_Firm_1__r.billingStreet +','+
                            mapHunt.get(evt.whatId).Attorney_Firm_1__r.Street2__c +','+
                            mapHunt.get(evt.whatId).Attorney_Firm_1__r.billingCity +','+
                            mapHunt.get(evt.whatId).Attorney_Firm_1__r.billingState +','+
                            mapHunt.get(evt.whatId).Attorney_Firm_1__r.billingPostalCode +','+
                            mapHunt.get(evt.whatId).Attorney_Firm_1__r.billingCountry;
                        evt.Description = evt.Description  + 'Link to Salesforce - https://oasiscrm.lightning.force.com/lightning/r/Contact/' +mapHunt.get(evt.whatId).Attorney_1__c+'/view';              
                    }
                }}
        }
    }
    
    
    
    @future
    public static void linkContactFutureMethod(set<string> evtIds,set<string> huntIds)
    {   
        
        if(huntIds.size() > 0){
            
            map<string,Hunt_List__c> mapHunt = new map<string,Hunt_List__c>();
            list<event> allEvt = new list<event>();
            
            for(Hunt_List__c objHunt : [SELECT id,Attorney_1__c FROM Hunt_List__c WHERE id =: huntIds]){
                mapHunt.put(objHunt.id,objHunt);                            
            }
            
            for(event evt : [SELECT id,WhatId FROM event WHERE id =: evtIds]){
                if(evt.WhatId !=Null){
                    if(mapHunt.containsKey(evt.whatId))
                    {                      
                        event objEvt = new event();  
                        objEvt.id = evt.id;   
                        objEvt.whoId = mapHunt.get(evt.whatId).Attorney_1__c;
                        allEvt.add(ObjEvt);
                    }
                }
            }
            
            if(allEvt.size() > 0){
                update allEvt;
                
            }
        }
    }
    
    public static void crmActivitysPreset(Map<id,Event> newMapRecords){
        Set<id> setOfActivityIds=new Set<id>();
        //check Account and contact task Records
        for(id ids:newMapRecords.keyset()){
            if((newMapRecords.get(ids).Whatid!=null && (newMapRecords.get(ids).Whatid).getSObjectType()+''=='Account')||
               (newMapRecords.get(ids).WhoID!=null && (newMapRecords.get(ids).WhoID).getSObjectType()+''=='Contact')){
                   setOfActivityIds.add(ids);
               }
        }
        if(!test.isrunningtest()){
            system.debug('EventTrigger');
            System.enqueueJob(new PresetCRMActivityQueuebleJob (setOfActivityIds));
        }
    } 
    
   /* public static void SendEmailWhenEventCreationOrUpdation(Event[] newEvents, String isUpdated){
        if(isUpdated.equals('Created')){
            isInserted = true;
        }
        
        if(isInserted && isUpdated.equals('Updated')) return;
        Set<id> ownerids = new Set<id>();
        Set<id> createdids = new Set<id>();
        Set<id> whoIds = new Set<id>();
        Map<Id, List<Event>> whatIds = new Map<Id, List<Event>>{};
            
            for(Event evt: newEvents) {
                ownerids.add(evt.ownerid);
                whoIds.add(evt.WhoId);
                createdids.add(evt.CreatedById);
                
            }
        Map<Id, User> mapOwnerEmail = new Map<Id, User>();
        Map<Id, User> mapCreatedUser = new Map<Id, User>();
        Map<Id, Contact> mapWhoID = new Map<Id, Contact>();
        for(User owner: [SELECT id, Name,email FROM User WHERE id IN:ownerids ]) {
            mapOwnerEmail.put(owner.id, owner);
        }
        for(User owner: [SELECT id, Name,email,createdById FROM User WHERE id IN:createdids ]) {
            mapCreatedUser.put(owner.id, owner);
        }
        For (Contact a : [Select Id, Name from Contact where Id in :whoIds]){
            mapWhoID.put(a.id, a);            
        }
        
        For (Event e1 : newEvents){
            if(e1.Oasis_Event_Purpose__c == 'BDR - Appointment Scheduled' || e1.Oasis_Event_Purpose__c == 'BDR - Appointment Held'){
                Datetime current = e1.StartDateTime;
                String dtStartTime = current.format('yyyy-MM-dd hh:mm:ss a', String.valueof(UserInfo.getTimeZone()));                
                system.debug('====== dtStartTime '+dtStartTime);
                
                Datetime endDateTime = e1.EndDateTime;
                String dtEndTime = endDateTime.format('yyyy-MM-dd hh:mm:ss a', String.valueof(UserInfo.getTimeZone()));  
                system.debug('====== endInput '+dtEndTime);
                String location = 'NA';
                if(!String.isBlank(e1.Location)){
                    location = e1.Location;
                }
                String link = 'https://oasiscrm--uatsandbox.lightning.force.com/'+e1.id;
                String body = '<p style="font-family:Times New Roman;font-size:20px"><b>New Event</b></p>';
                body += 'To: '+mapOwnerEmail.get(e1.ownerid).Name+  '<br>';
                body += mapCreatedUser.get(e1.CreatedById).Name+' has Assigned you the following new Event'+  '<br><br>' ;
                body += ' Subject: '+e1.Subject +  '<br>';
                body += ' Contact: '+mapWhoID.get(e1.WhoId).Name +  '<br>';
                body += ' Start Date: '+dtStartTime +  '<br>';
                body += ' End Date: '+dtEndTime +  '<br>';
                body += ' Description: '+e1.Description +  '<br>';
                body += ' Location: '+location +  '<br>';
                body += 'For more details, click the following link'+'<br><br>'; 
                body += link;
                
                String[] toAddresses = new String[] {mapOwnerEmail.get(e1.ownerid).email};
                    String subject = 'Event '+isUpdated;
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(e1.OwnerID);
                mail.setWhatId(e1.id);     
                mail.setUseSignature(false);
                mail.setBccSender(false);
                mail.setSaveAsActivity(false);  
                mail.setSubject(subject);
                mail.setToAddresses(toAddresses);
                mail.setHtmlBody(body);
                // mail.setPlainTextBody(body);
                System.debug('@@ email '+toAddresses);
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            }              
        } 
    }  */
    
    public static void updateContactBDRFields(list<event> lstEventt){
       /* Set<Id> usrSet = new Set<Id>();
        Set<Id> contactIds = new Set<Id>();
        for(Event evt : lstEventt){
            usrSet.add(evt.LastModifiedById);
            String s1 = String.valueof(evt.WhoId);
			if(s1.startsWith('003'))
            	contactIds.add(evt.WhoId);
        }
        
        Map<Id,Contact> mapCon = new Map<Id,Contact>([Select id,Department,Last_BDR_Activity_Date__c,Last_BDR_Activity_Type__c,name from Contact where id in:contactIds]);
        List<User> usrList = [Select id, Name, Email, Profile.Name from user where id in: usrSet AND Profile.Name =  'Business Development'];
        if(usrList.size()>0){
            for(Event evt : lstEventt){
                if(mapCon.containsKey(evt.WhoId)){
                    Contact con = mapCon.get(evt.WhoId);
                    con.Last_BDR_Activity_Date__c = evt.CreatedDate;
                    con.Last_BDR_Activity_Type__c = evt.Oasis_Event_Purpose__c;
                    con.Last_BDR_Activity_Sub_Type__c = '';
                   	mapCon.put(con.Id,con);
                }
            }
            update mapCon.values();
        }*/
    }
    
    // public static void checkEventUpdationAfter30Days(List<Event>eventList){
    //     if(!eventList.isEmpty()){
    //         Id profileId = userInfo.getProfileId();
    //         List<Profile> profileName = [SELECT Name FROM Profile where Id = :profileId];
    //         String loggedInUserProfile = profileName != null ? String.valueOf(profileName.get(0).Name) : '';
    //         if(String.isBlank(loggedInUserProfile)){
    //             return;
    //         }
    //          //= [SELECT Name FROM Profile where Id = :profileId].Name;
    //         DateTime dateAfter1Month;
    //         for(Event evt : eventList){
    //             Integer daysInMonth = date.daysInMonth(Date.valueOf(evt.StartDateTime).Year(), Date.valueOf(evt.StartDateTime).Month());
    //             Integer DaysRemaining = (daysInMonth - Date.valueOf(evt.StartDateTime).Day());
    //             dateAfter1Month = evt.StartDateTime.addDays(DaysRemaining);
    //             for(integer i=0;i<=5;i++){
    //                 if(dateAfter1Month.format('EEEE') == 'Saturday' || dateAfter1Month.format('EEEE') == 'Sunday'){
    //                     dateAfter1Month = dateAfter1Month.addDays(2);
    //                 }else{
    //                     dateAfter1Month = dateAfter1Month.addDays(1);
    //                 }
    //             } 
    //             if(dateAfter1Month < system.now() 
    //                && (loggedInUserProfile != 'Power User' && loggedInUserProfile != 'Executive' && loggedInUserProfile != 'System Administrator')){
    //                 evt.addError('Editing period expired. You cannot update events with a Start Date of last month or before.');         
    //             }
    //         }
            
    //     }
    // }    
    
    public static void updateDueDateWithCreatedDate(list<Event> lstEvent){
        List<Event> updateEvent = new List<Event>();
        for(Event event : lstEvent){
           event.ActivityDate = event.CreatedDate.Date();
           event.Date__c = event.CreatedDate.Date();
            updateEvent.add(event);
        }
        if(updateEvent.size()>0){
            update updateEvent;
        }	 
    }

    public static void updateRelatedContactNames(List<Event> lstEvent){
        Set<Id> eventIds = new Set<Id>();
        for (Event e : lstEvent) {
             {
                eventIds.add(e.Id);
            }
        }
        List<EventRelation> lstEventRelation = [SELECT Id, EventId, Relation.Name FROM EventRelation WHERE EventId IN :eventIds order by eventId, Relation.Name];
        if (!lstEventRelation.isEmpty()) {
            for (Event e : lstEvent) {
                String contactLinks = '';
                for (EventRelation er : lstEventRelation) {
                    if (er.EventId == e.Id && e.whoId != null && (e.WhoId.getSObjectType() == Contact.SObjectType || e.WhoId.getSObjectType() == Lead.SObjectType)){
                        
                        //skip account relationships
                        if(!(er.RelationId.getSObjectType() == Contact.SObjectType || er.RelationId.getSObjectType() == Lead.SObjectType))
                            continue;


                        system.debug('updateRelatedContactName');
                        system.debug(contactLinks);
                        system.debug(contactLinks.length());
                        system.debug(er.Relation.Name);
                        system.debug(er.Relation.Name.length());
                        if ((contactLinks.length() + ((er.Relation.Name ?? '') + ', ').length() > 255)) {
                            // If adding this relation exceeds the limit, we stop adding more
                            break;
                        }

                        if (contactLinks != '') contactLinks += ', ';
                        String contactLink = er.Relation.Name;
                        contactLinks += contactLink;
                    }
                }
                e.Related_Contact_Names__c = contactLinks;
            }
        }

    }
}