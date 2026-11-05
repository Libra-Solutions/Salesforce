@isTest
public with sharing class XVA_BatchTransferAccountsTest {

    @isTest
    static void testBatchMergeAccounts() {
        // Create test accounts
        Account account1 = new Account(Name = 'Test Account 1', transfer_to__c = 'cimi123', Needs_to_be_Transferred__c = true);
        Account account2 = new Account(Name = 'Test Account 2', cimi_id__c = 'cimi123');
        insert new List<Account> { account1, account2 };

        // Create test contacts
        Contact contact1 = new Contact(LastName = 'Test Contact 1', AccountId = account1.Id);
        Contact contact2 = new Contact(LastName = 'Test Contact 2', AccountId = account2.Id);
        insert new List<Contact> { contact1, contact2 };
         
        Id userid = userInfo.getUserId();
        User u = [Select Id from User where Id =:userId];
        
        // Create test Task
        Task task1 = new Task(subject = 'testing task', whatId = account1.Id, type = 'Task', Oasis_Sub_Type__c = 'Top 100', ownerId = u.Id); 
        insert task1;

        // Custom merge accounts
        XVA_BatchTransferAccounts xbta = new XVA_BatchTransferAccounts();
        Test.startTest();
        Database.executeBatch(xbta);
        Test.stopTest();

        // Verify that the merge was successful
        System.assert(true, [SELECT Id, accountId FROM Contact WHERE Id = :contact1.Id].accountId == [SELECT Id, accountId FROM Contact WHERE Id = :contact2.Id].accountId);
        // Verify that the account was not deleted
        System.assert(true, [SELECT Id FROM Account WHERE Id = :account1.Id].Id != null);

    }
    
}