public with sharing class XVA_BatchMergeContacts implements Database.Batchable<sObject> 
{

    List<SObjectField> mostRecentlyChangedMappedFields = new List<SObjectField>{
        Contact.FirstName, Contact.LastName, Contact.Phone, Contact.Title 
    };


    public XVA_BatchMergeContacts() {
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        XVA_Job_Orchestration.StartJobOrchestration(new List<string>{'XVA_BatchMergeContacts'});

        return Database.getQueryLocator([Select Id, Merge_To__c from Contact WHERE merge_to__c != null AND needs_to_be_merged__c = true]);
        
    }

    public void execute(Database.BatchableContext bc, List<Contact> scope) 
    {
        Set<Id> mergeSourceIds = new Map<Id, Contact>(scope).keySet();
        Set<Id> mergeTargetIds = new Set<Id>();
        for(Contact c : scope) {
            mergeTargetIds.add(c.merge_to__c);
        }

        Map<string, Set<Id>> idsMap = new Map<string, Set<Id>>();
        List<string> contactEditableFields = XVA_Utility.getEditableFields('Contact');

        string getContactQuery = 'Select Id, LastModifiedDate, CashTrax_Id__c, ' + string.join(contactEditableFields, ',') + ', (Select Id, WhatId from Tasks), (Select Id, WhatId from Events where IsChild = false), (Select Id, AccountId from AccountContactRelations), (Select Id, Account__c, Contact__c from Account_Relations__r) from Contact where Id in :contactIds';
        

        idsMap.put('contactIds', mergeTargetIds);
        
        Map<Id, Contact> destinationsWithEditableFields = new Map<Id, Contact>((List<Contact>)Database.queryWithBinds(getContactQuery, idsMap, AccessLevel.SYSTEM_MODE));
        idsMap.put('contactIds', mergeSourceIds);
        
        Map<Id, Contact> sourceContactsWithActivity = new Map<Id, Contact>((List<Contact>)Database.queryWithBinds(getContactQuery, idsMap, AccessLevel.SYSTEM_MODE));
        
        getContactQuery = 'Select Id, ' + string.join(contactEditableFields, ',') + ' from Contact where Id in :contactIds';
        idsMap.put('contactIds', mergeTargetIds);
        
        Map<Id, Contact> mergeContactsWithOnlyEditableFields = new Map<Id, Contact>((List<Contact>)Database.queryWithBinds(getContactQuery, idsMap, AccessLevel.SYSTEM_MODE));

        for(Contact contact : scope) 
        {
            if (!destinationsWithEditableFields.containsKey(contact.Merge_To__c) || !sourceContactsWithActivity.containsKey(contact.Id)) {
                contact.Merge_Errors__c = 'Destination contact cannot be found.';
                update contact;
                continue;
            }
            List<string> mergeValidationsErrors = new List<string>();

            Contact mergeFrom = sourceContactsWithActivity.get(contact.Id);
            Contact mergeToWithRelations = destinationsWithEditableFields.get(mergeFrom.Merge_To__c);
            Contact mergeTo = destinationsWithEditableFields.get(mergeFrom.Merge_To__c);
            
            Contact mostRecent = mergeFrom.LastModifiedDate > mergeTo.LastModifiedDate ? mergeFrom : mergeTo;


            mergeTo = mergeContactsWithOnlyEditableFields.get(mergeTo.Id);

            Contact mdUser = mergeFrom.MD_User_Id__c != null ? mergeFrom : mergeTo;
            Contact ctUser = mergeFrom.Cashtrax_Id__c != null ? mergeFrom : mergeTo;

            Savepoint sp = Database.setSavepoint();

            try {


            mergeTo.FirstName = mostRecent.FirstName;
            mergeTo.LastName = mostRecent.LastName;
            mergeTo.MobilePhone = mdUser.MobilePhone ?? ctUser.MobilePhone;
            mergeTo.Email = mdUser.Email ?? ctUser.Email;
            mergeTo.Phone = mdUser.Phone ?? ctUser.Phone;
            mergeTo.Phone_Extension__c = (!string.isBlank(mdUser.Phone) && mdUser.Phone_Extension__c != null) ? mdUser.Phone_Extension__c : ctUser.Phone_Extension__c;
            mergeTo.Title = mostRecent.Title ?? ctUser.Title ?? mdUser.Title;
            mergeTo.BarVerificationExpirationDate__c = ctUser.BarVerificationExpirationDate__c;
            //mergeTo.CRMFirmLocationId__c = ctUser.CRMFirmLocationId__c;
            mergeTo.Attorney_Contact_Id__c = ctUser.Attorney_Contact_Id__c;
            mergeTo.Attorney_ID__c = ctUser.Attorney_ID__c;

            for(Task t : mergeFrom.Tasks) {
                t.WhatId = mergeTo.AccountId;
            }
    
            for (Event e : mergeFrom.Events) {
                e.WhatId = mergeTo.AccountId;
            }

            

            if (mergeToWithRelations.AccountContactRelations != null && mergeToWithRelations.AccountContactRelations.size() > 0 && mergeFrom.AccountContactRelations != null && mergeFrom.AccountContactRelations.size() > 0) 
            {
                //if either set of relations is null, skip - we don't need to do anything
                List<AccountContactRelation> acrsToDelete = new List<AccountContactRelation>();
                Set<Id> acrAccountIds = new Set<Id>();

                for(AccountContactRelation acr : mergeToWithRelations.AccountContactRelations) 
                {
                    acrAccountIds.add(acr.AccountId);
                }

                for(AccountContactRelation acr : mergeFrom.AccountContactRelations) 
                {
                    if (acr.AccountId != mergeFrom.AccountId && acrAccountIds.contains(acr.AccountId)) 
                    {
                        acrsToDelete.add(acr);
                    }
                }

                if (acrsToDelete.size() > 0) delete acrsToDelete;

            }

            if (mergeToWithRelations.Account_Relations__r != null && mergeToWithRelations.Account_Relations__r.size() > 0 && 
                mergeFrom.Account_Relations__r != null && mergeFrom.Account_Relations__r.size() > 0) 
            {
                //if either set of relations is null, skip - we don't need to do anything
                List<Account_Relation__c> arsToDelete = new List<Account_Relation__c>();
                Set<Id> arAccountIds = new Set<Id>();

                for(Account_Relation__c ar : mergeToWithRelations.Account_Relations__r) 
                {
                    arAccountIds.add(ar.Account__c);
                }

                for(Account_Relation__c ar : mergeFrom.Account_Relations__r) 
                {
                    if (arAccountIds.contains(ar.Account__c)) 
                    {
                        arsToDelete.add(ar);
                    }
                }

                if (arsToDelete.size() > 0) delete arsToDelete;
            }

            //Database.update(mergeFrom.Tasks, false);
            //Database.update(mergeFrom.Events, false);

            string getSingleContactQuery = 'Select Id, ' + string.join(contactEditableFields, ',') + ' from Contact where Id = :contactId';
            mergeFrom = Database.queryWithBinds(getSingleContactQuery, new Map<string, Id> { 'contactId' => mergeFrom.Id }, AccessLevel.SYSTEM_MODE);

            mergeFrom.Needs_To_Be_Merged__c = false;
            mergeFrom.Merge_To__c = null;
            merge mergeTo mergeFrom;
            } catch (Exception e) {
             


                mergeValidationsErrors.add(e.getMessage());
                system.debug('++++ Error ++++');
                system.debug(e.getMessage());

                Database.rollback(sp);

                mergeFrom.Merge_Errors__c = string.join(mergeValidationsErrors, '\n');
                update mergeFrom;
            }

            system.debug('Merge Errors');
            system.debug(mergeFrom.Merge_Errors__c);

            Database.releaseSavePoint(sp);
        }
    }

    public void finish(Database.BatchableContext bc) 
    {
        XVA_Job_Orchestration.EndJobOrchestration(new Map<string, string>{'XVA_BatchMergeContacts' => 'XVA_BatchMergeContacts has completed successfully.'});

    }
}