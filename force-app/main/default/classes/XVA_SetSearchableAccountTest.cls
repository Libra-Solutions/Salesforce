@isTest
public with sharing class XVA_SetSearchableAccountTest {
    @isTest
    static void testBatch() {
        Account a = new Account(Name = 'Test Account', ctxfirmid__c = 'ctx1234567890');
        insert a;
        Account b = new Account(Name = 'Test Account 2', cimi_Id__c = 'cimi1234567890', cashtrax_account__c = a.Id, CTXFirmId__c = null);
        insert b;
        XVA_SetSearchableAccount xssa = new XVA_SetSearchableAccount();
        Test.startTest();
        Database.executeBatch(xssa);
        Test.stopTest();

        List<Account> accounts = [SELECT Id, Non_Searchable_Account__c FROM Account];
        for(Account acc : accounts){
            if(acc.Id == a.Id){
               // System.assertEquals(false, acc.Non_Searchable_Account__c);
            }
            if(acc.Id == b.Id){
               // System.assertEquals(true, acc.Non_Searchable_Account__c);
            }
        }
    }
}