global class XVA_ClearAccountCimiCashTraxLinks implements Database.Batchable<SObject> {

    global List<Account> start(Database.BatchableContext BC) {
        //return Database.getQueryLocator('SELECT Id, name, Non_Searchable_Account__c, CashTrax_Account__c, CTXFirmId__c, Cimi_Id__c, Cimi_Account__c, ParentId FROM Account WHERE (cimi_id__c != null and (CashTrax_Account__c != null OR ParentId != null or Non_Searchable_Account__c = true)) OR (CTXFirmId__c != null and (Cimi_Account__c != null or Non_Searchable_Account__c = true))');
        
        XVA_Job_Orchestration.StartJobOrchestration(new List<string>{'XVA_ClearAccountCimiCashTraxLinks'});

        return [SELECT Id, name, Non_Searchable_Account__c, CashTrax_Account__c, CTXFirmId__c, Cimi_Id__c, Cimi_Account__c, ParentId, Case_Mgmt_Software__c, CMS_Integrated_with_MoveDocs__c,
            (Select Id from Account_Relations__r where System_Generated__c = true)
            FROM Account WHERE (cimi_id__c != null and (CashTrax_Account__c != null OR ParentId != null or Non_Searchable_Account__c = true)) OR (CTXFirmId__c != null and (Cimi_Account__c != null or Non_Searchable_Account__c = true))];
    }

    global void execute(Database.BatchableContext BC, List<Account> scope) {
        List<Account> ctxAccountsToUpdate = new List<Account>();
        List<Account> cimiAccountsToUpdate = new List<Account>();
        List<Account_Relation__c> accountRelationsToDelete = new List<Account_Relation__c>();

        for(Account a : scope) {
            if(a.CTXFirmId__c != null){
                a.Cimi_Account__c = null;
                a.Non_Searchable_Account__c = false;
                a.Case_Mgmt_Software__c = null;
                a.CMS_Integrated_with_MoveDocs__c = null;
                ctxAccountsToUpdate.add(a);
                if (a.Account_Relations__r != null){
                    accountRelationsToDelete.addAll(a.Account_Relations__r);
                }
            }
            if(a.Cimi_id__c != null){
                a.CashTrax_Account__c = null;
                a.parentId = null;
                a.Non_Searchable_Account__c = false;
                cimiAccountsToUpdate.add(a);
                if (a.Account_Relations__r != null){
                    accountRelationsToDelete.addAll(a.Account_Relations__r);
                }
            }

            
        }
        update ctxAccountsToUpdate;
        update cimiAccountsToUpdate;
        if (accountRelationsToDelete.size() > 0) delete accountRelationsToDelete;
    }

    global void finish(Database.BatchableContext BC) 
    {
        XVA_Job_Orchestration.EndJobOrchestration(new Map<string, string>{'XVA_ClearAccountCimiCashTraxLinks' => 'XVA_ClearAccountCimiCashTraxLinks has completed successfully.'});
    }
}