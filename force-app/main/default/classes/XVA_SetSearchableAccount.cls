global class XVA_SetSearchableAccount implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, CTXFirmId__c, Cimi_Id__c, Non_Searchable_Account__c, cimi_account__c, cashtrax_account__c FROM Account WHERE CTXFirmId__c = null AND Cimi_Id__c != null AND cashtrax_account__c != null');
    }
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        for(Account a : scope) {
            a.Non_Searchable_Account__c = true;
        }
        update scope;
    }
    global void finish(Database.BatchableContext BC) {
    }
   
}