global class XVA_BatchMergeAccounts implements Database.Batchable<sObject> {
    //public boolean faulty = false;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        XVA_Job_Orchestration.StartJobOrchestration(new List<string>{'XVA_BatchMergeAccounts'});

        return Database.getQueryLocator([SELECT Id, needs_to_be_merged__c, merge_to__c, cimi_Id__c, BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry, street2__c,
                                        Type, ParentId, source_of_creation__c, HeadQuarter__c, phone, website, fax, UsingPortal__c, Description, Case_Mgmt_Software__c, target_level__c, 
                                        Provider_Merge_To__c,
                                                                                                            (SELECT Id, AccountId, whatId FROM Tasks ),
                                                                                                            (SELECT Id, whatId FROM Events),
                                                                                                            //(SELECT Id, Contact.AccountId, AccountId, IsActive, ContactId, IsDirect, EndDate, Roles, StartDate FROM AccountContactRelations),
                                                                                                            (SELECT Id, AccountId FROM Contacts),
                                                                                                            (SELECT Id, Account__c FROM Account_Relations__r),
                                                                                                            (SELECT Id, firm_name__c FROM Non_Attorney_Contacts__r),
                                                                                                            (SELECT Id, AccountId FROM Opportunities),
                                                                                                            (SELECT Id, LinkedEntityId FROM ContentDocumentLinks)
                                                                                                            FROM Account
                                                                                                            WHERE 
                                                                                                            (merge_to__c != null or Provider_Merge_To__c != null) AND 
                                                                                                            needs_to_be_merged__c = true]);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> scope) {
        processBatches(bc, scope);
    }



    
    global void processBatches(Database.BatchableContext bc, List<Account> scope) {
        List<Account> accountsToUpdate = new List<Account>();
        List<AccountContactRelation> accConRelToUpdate = new List<AccountContactRelation>();
        List<Task> tasksToUpdate = new List<Task>();
        List<Event> eventsToUpdate = new List<Event>();
        List<Contact> contactsToUpdate = new List<Contact>();
        List<Account_Relation__c> attorneyProvidersToUpdate = new List<Account_Relation__c>();
        List<Non_Attorney_Contact__c> nonAttorneyContactsToUpdate = new List<Non_Attorney_Contact__c>();
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        List<ContentDocumentLink> contentDocumentLinksToInsert = new List<ContentDocumentLink>();
        List<contact> conlist = new List<contact>();
        Set<Id> sourceIds = new Map<Id, Account>(scope).keySet();
        Set<String> accMergeToSet = new Set<String>();
        Set<string> accProviderMergeToSet = new Set<string>();
        Map<String, Account> mergeToMap = new Map<String, Account>();
        Map<String, Account> mergeFromMap = new Map<String, Account>();
        Map<string, Account> providerMergeFromMap = new Map<string, Account>();
        Map<id, string> errorMessages = new Map<Id, string>();
        
  
        for(Account acc: scope){
            if (acc.Merge_To__c != null) {
                accMergeToSet.add(acc.merge_to__c);
                mergeFromMap.put(acc.merge_to__c, acc);
            }

            if (acc.Provider_Merge_To__c != null) {
                accProviderMergeToSet.add(acc.Provider_Merge_To__c);
                providerMergeFromMap.put(acc.Provider_Merge_To__c, acc);
            }
        }


        List<Account> cimiAccMergeToList = [Select Id, needs_to_be_merged__c, merge_to__c, cimi_Id__c, BillingStreet, BillingState, BillingCity, BillingCountry, BillingPostalCode, street2__c,
        Type, ParentId, source_of_creation__c, HeadQuarter__c, phone, website, fax, UsingPortal__c, Description, Case_Mgmt_Software__c, target_level__c,
        Provider_Id_c__c
        FROM Account
        WHERE cimi_id__c IN :accMergeToSet or Id IN :accMergeToSet
        or Provider_Id_c__c in :accProviderMergeToSet or Id in :accProviderMergeToSet
        ];

        Map<Id, Account> mergeToMapOfACRS = new Map<Id, Account>([Select Id, 
        Provider_Id_c__c,
        (SELECT Id, Contact.AccountId, AccountId, IsActive, ContactId, IsDirect, EndDate, Roles, StartDate FROM AccountContactRelations)
        FROM Account
        WHERE cimi_id__c IN :accMergeToSet 
        or Id IN :accMergeToSet 
        or Provider_Id_c__c in :accProviderMergeToSet or Id in :accProviderMergeToSet
        ]);

        /* Arohi Code
        
        List<Account> mergeToAccounts = [
                SELECT Id FROM Account 
                WHERE cimi_id__c IN :accMergeToSet 
           ]; 

           Set<Id> mergeToAccountIds = new Set<Id>();
           for (Account a : mergeToAccounts) {
                mergeToAccountIds.add(a.Id)
           }

           List<AccountContactRelation> acrList = [
               SELECT Id, ContactId, AccountId, IsDirect, EndDate, oles, StartDate
               FROM AccountContactRelation
               WHERE AccountId IN :mergeToAccountIds
           ];

           Map<Id, List<AccountContactRelation>> acrMap = new Map<Id, List<AccountContactRelation>>();
           
           for(AccountContactRelation acr :acrList) {
               
               if (!acrMap.containskey(acr.AccountId)){
                acrMap.put(acr.AccountId, new List<AccountContactRelation>());
               }
           acrMap.get(acr.AccountId).add(acr);
           }
    
            */

        //get global list of ACRS for all accounts in this batch
        List<AccountContactRelation> acrs = [SELECT Id, Contact.AccountId, AccountId, IsActive, ContactId, IsDirect, EndDate, Roles, StartDate
                                                    FROM AccountContactRelation
                                                    WHERE AccountId IN :accMergeToSet or AccountId in :sourceIds
                                                    or AccountId in :accProviderMergeToSet or AccountId in :providerMergeFromMap.keySet()];

                                                    
        Map<Id, List<AccountContactRelation>> acrMap = new Map<Id, List<AccountContactRelation>>();
        for(AccountContactRelation acr : acrs) {
            if (!acrMap.containsKey(acr.AccountId)) {
                acrMap.put(acr.AccountId, new List<AccountContactRelation>());
            }
            acrMap.get(acr.AccountId).add(acr);
        }                                               



        system.debug('cimi merge to list size '+cimiAccMergeToList.size());
        for(Account acc : cimiAccMergeToList){
            List<AccountContactRelation> acrsToDelete = new List<AccountContactRelation>();

            mergeToMap.put(acc.cimi_Id__c,acc);
            Account mergeFromAccount = GetMergeFromAccount(mergeFromMap, providerMergeFromMap, acc);

            if(mergeFromAccount == null) {
                system.debug('no merge from account found for merge to account: ' + acc.Id);
                continue;
            }

            acc.BillingStreet = (acc.BillingStreet == null) ? (mergeFromAccount.BillingStreet == null ? acc.BillingStreet : mergeFromAccount.BillingStreet) : acc.BillingStreet;
            acc.BillingCity = (acc.BillingCity == null) ? (mergeFromAccount.BillingCity == null ? acc.BillingCity : mergeFromAccount.BillingCity) : acc.BillingCity;
            acc.BillingState = (acc.BillingState == null) ? (mergeFromAccount.BillingState == null ? acc.BillingState : mergeFromAccount.BillingState) : acc.BillingState;
            acc.BillingPostalCode = (acc.BillingPostalCode == null) ? (mergeFromAccount.BillingPostalCode == null ? acc.BillingPostalCode : mergeFromAccount.BillingPostalCode) : acc.BillingPostalCode;
            acc.street2__c = (acc.street2__c == null) ? (mergeFromAccount.street2__c == null ? acc.street2__c : mergeFromAccount.street2__c) : acc.street2__c;
            acc.BillingCountry = (acc.BillingCountry == null) ? (mergeFromAccount.BillingCountry == null ? acc.BillingCountry : mergeFromAccount.BillingCountry) : acc.BillingCountry;
            acc.Type = (acc.Type == null) ? (mergeFromAccount.Type == null ? acc.Type : mergeFromAccount.Type) : acc.Type;
            //acc.ParentId = (acc.ParentId == null) ? (mergeFromAccount.ParentId == null ? acc.ParentId : mergeFromAccount.ParentId) : acc.ParentId;
            acc.source_of_creation__c = (acc.source_of_creation__c == null) ? (mergeFromAccount.source_of_creation__c == null ? acc.source_of_creation__c : mergeFromAccount.source_of_creation__c) : acc.source_of_creation__c;
            //acc.HeadQuarter__c = (acc.HeadQuarter__c == null) ? (mergeFromAccount.HeadQuarter__c == null ? acc.HeadQuarter__c : mergeFromAccount.HeadQuarter__c) : acc.HeadQuarter__c;
            acc.phone = (acc.phone == null) ? (mergeFromAccount.phone == null ? acc.phone : mergeFromAccount.phone) : acc.phone;
            acc.website = (acc.website == null) ? (mergeFromAccount.website == null ? acc.website : mergeFromAccount.website) : acc.website;
            acc.fax = (!String.isBlank(acc.fax)) ? acc.fax : (!String.isBlank(mergeFromAccount.fax)) ? mergeFromAccount.fax : acc.fax;
            acc.UsingPortal__c = (acc.UsingPortal__c == null) ? (mergeFromAccount.UsingPortal__c == null ? acc.UsingPortal__c : mergeFromAccount.UsingPortal__c) : acc.UsingPortal__c;
            acc.Description = (acc.Description == null) ? (mergeFromAccount.Description == null ? acc.Description : mergeFromAccount.Description) : acc.Description;
            acc.Case_Mgmt_Software__c = (acc.Case_Mgmt_Software__c == null) ? (mergeFromAccount.Case_Mgmt_Software__c == null ? acc.Case_Mgmt_Software__c : mergeFromAccount.Case_Mgmt_Software__c) : acc.Case_Mgmt_Software__c;
            acc.target_level__c = (acc.target_level__c == null) ? (mergeFromAccount.target_level__c == null ? acc.target_level__c : mergeFromAccount.target_level__c) : acc.target_level__c;

            Set<Id> toContactIds = new Set<Id>();
            Set<Id> fromContactIds = new Set<Id>();

            /* removing to avoid child query issue 

            if (mergeFromAccount.AccountContactRelations != null) 
            {
                system.debug('merge from account relations: ' + mergeFromAccount.AccountContactRelations.size());
                for (AccountContactRelation acr : mergeFromAccount.AccountContactRelations) 
                {
                    fromContactIds.add(acr.ContactId);
                    if (!acr.IsDirect && acr.Contact.AccountId == acc.Id) acrsToDelete.add(acr);
                }
            } */

            if (acrMap.containsKey(mergeFromAccount.Id)) {
                system.debug('merge from account relations from map: ' + acrMap.get(mergeFromAccount.Id).size());
                for (AccountContactRelation acr : acrMap.get(mergeFromAccount.Id)) 
                {
                    fromContactIds.add(acr.ContactId);
                    if (!acr.IsDirect && acr.Contact.AccountId == acc.Id) acrsToDelete.add(acr);
                }
            }



            if (acrMap.containsKey(acc.Id)) {
                system.debug('merge to account relations: ' + acrMap.get(acc.Id).size());
                for (AccountContactRelation acr : acrMap.get(acc.Id)) 
                {
                    
                    if (!acr.IsDirect 
                        && (acr.Contact.AccountId == mergeFromAccount.Id || fromContactIds.contains(acr.ContactId))
                    ) acrsToDelete.add(acr);
                }
            }
           
            /*
             List<AccountContactRelation> mergeToACRs = acrMap.get(acc.Id);

      if (mergeToACRs != null) {
          system.debug('merge to account relations: ' + mergeToACRs.size());
          for (AccountContactRelation acr : mergeToACRs) {
              if (!acr.IsDirect 
                    && (acr.Contact.AccountId == mergeFromAccount.Id || fromContactIds.contains(acr.ContactId))
              ) {
              acrsToDelete.add(acr);
              }
        }
      
             */
            
            system.debug('removing account contact relations');
            system.debug(acrsToDelete.size());

            delete acrsToDelete;

            try{
                Merge acc mergeFromAccount;
            }catch(Exception e){
                system.debug('merge error '+e.getMessage());
                string message = e.getMessage();
                errorMessages.put(acc.Id, message.length() > 255 ? message.substring(0, 255) : message);

            }
            
        }
       
        if (errorMessages.keySet().size() > 0) {
            List<Account> accountsToUpdateWithErrors = new List<Account>();
            for (Id accId : errorMessages.keySet()) {
                
                Account accToUpdate = new Account(Id = accId, Merge_Error__c = errorMessages.get(accId));
                accountsToUpdateWithErrors.add(accToUpdate);
            }
            update accountsToUpdateWithErrors;
        }

    }

    private Account GetMergeFromAccount(Map<string, Account> cimiMergeFromMap, Map<string, Account> providerMergeFromMap, Account mergeToAccount) 
    {
        for(string key : cimiMergeFromMap.keySet()) 
        {
            Account cimiFromAccount = cimiMergeFromMap.get(key);
            if (IsSalesforceId(cimiFromAccount.Merge_To__c) && mergeToAccount.Id == cimiFromAccount.Merge_To__c) return cimiFromAccount;
            if (mergeToAccount.Cimi_Id__c != null && mergeToAccount.Cimi_Id__c == cimiFromAccount.Merge_To__c) return cimiFromAccount;
            
        }

        for(string key: providerMergeFromMap.keySet()) 
        {
            Account providerFromAccount = providerMergeFromMap.get(key);
            if (IsSalesforceId(providerFromAccount.Provider_Merge_To__c) && mergeToAccount.Id == providerFromAccount.Provider_Merge_To__c) return providerFromAccount;
            if (mergeToAccount.Provider_Id_c__c != null && mergeToAccount.Provider_Id_c__c == providerFromAccount.Provider_Merge_To__c) return providerFromAccount;
        }

        return null;
    }

    private boolean IsSalesforceId(string testString) {
        try {
            Id idStr = testString;
            return true;
        } catch(Exception ex) {
            return false;
        }
    }
    
    global void finish(Database.BatchableContext bc) 
    {
        XVA_Job_Orchestration.EndJobOrchestration(new Map<string, string>{'XVA_BatchMergeAccounts' => 'XVA_BatchMergeAccounts has completed successfully.'});
    } 
}