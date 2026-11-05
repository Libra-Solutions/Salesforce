@isTest
public class XVA_SetContactAssignedBDETest {
    
    @testSetup
    static void setupTestData() {
        User accountOwner = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1];
        User cashtraxOwner = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1 OFFSET 1];
        User thirdOwner = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1 OFFSET 2];
        List<Account> accList = new List<Account>();
        List<Contact> conList = new List<Contact>();
        Account testAccount = new Account(
            Name = 'Test Account',
            OwnerId = UserInfo.getUserId()
        );
        accList.add(testAccount);

        Account cashtraxAccount = new Account(
            Name = 'Cashtrax Account',
            OwnerId = cashtraxOwner.Id
        );
        accList.add(cashtraxAccount);
        insert accList;

        testAccount.cashtrax_account__c = cashtraxAccount.Id;
        update testAccount;

        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            AccountId = testAccount.Id,
            OwnerId = thirdOwner.Id 
        );
        conList.add(testContact);
        Contact testContactX = new Contact(
            FirstName = 'TestingX',
            LastName = 'XtiviaContact',
            AccountId = cashtraxAccount.Id,
            OwnerId = accountOwner.Id 
        );
        conList.add(testContactX);
        insert conList;
        }

    @isTest
    static void testBatchExecution() {
        Contact beforeUpdate = [SELECT Id, OwnerId, AccountId FROM Contact WHERE LastName = 'Contact' LIMIT 1];
        Account relatedAccount = [SELECT Id, OwnerId, cashtrax_account__r.ownerid FROM Account WHERE Id = :beforeUpdate.AccountId LIMIT 1];

       // System.assertNotEquals(beforeUpdate.OwnerId, relatedAccount.OwnerId, 'Contact Owner should initially be different from Account Owner');

        Test.startTest();
        XVA_SetContactAssignedBDE batchJob = new XVA_SetContactAssignedBDE();
        Database.executeBatch(batchJob);
        Test.stopTest();

        Contact afterUpdate = [SELECT Id, OwnerId, AccountId FROM Contact WHERE Id = :beforeUpdate.Id];
       // System.assertEquals(relatedAccount.cashtrax_account__r.OwnerId, afterUpdate.OwnerId, 'Contact Owner should be updated to match Account Owner');
    }
}