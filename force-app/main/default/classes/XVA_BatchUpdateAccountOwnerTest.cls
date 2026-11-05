@isTest
public with sharing class XVA_BatchUpdateAccountOwnerTest {

    static testMethod void testBatchUpdateAccountOwner() 
    {
        XVA_TestDataFactory testDataFactory = new XVA_TestDataFactory();
        Account testAccount = testDataFactory.TestAccount;
        User newUser = [Select Id from User where IsActive = true and Id != :testAccount.OwnerId limit 1];
        testAccount.API_Owner_Reassign__c = newUser.Id;
        update testAccount;

        Test.startTest();
        XVA_BatchUpdateAccountOwner batch = new XVA_BatchUpdateAccountOwner();
        Database.executeBatch(batch, 200);
        Test.stopTest();
        

    }

}