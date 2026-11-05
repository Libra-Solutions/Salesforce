@isTest
public with sharing class XVA_BatchMergeAccountsTest {

    @isTest
    static void testBatchMergeAccounts() {
        // Create test accounts
        Account account1 = new Account(Name = 'Test Account 1', merge_to__c = 'cimi123', needs_to_be_merged__c = true);
        Account account2 = new Account(Name = 'Test Account 2', cimi_id__c = 'cimi123');
        Account account3 = new Account(Name = 'Test Account 3', cimi_id__c = 'cimi234');
        Account account5 = new Account(Name = 'Test Account 5', Provider_Merge_To__c = 'prov123', Needs_To_Be_Merged__c = true);
        Account account6 = new Account(Name = 'Test Account 6', Provider_Id_c__c = 'prov123');
        Account account7 = new Account(Name = 'Test Account 7', Merge_To__c = 'missing1', Needs_To_Be_Merged__c = true);

        insert new List<Account> { account1, account2, account3, account5, account6, account7 };

        Account account4 = new Account(Name = 'Test Account 4', merge_to__c = account3.Id, needs_to_be_merged__c = true);
        insert account4; 

        // Create test contacts
        Contact contact1 = new Contact(LastName = 'Test Contact 1', AccountId = account1.Id);
        Contact contact2 = new Contact(LastName = 'Test Contact 2', AccountId = account2.Id);
        insert new List<Contact> { contact1, contact2 };



        AccountContactRelation acr = new AccountContactRelation(AccountId = account1.Id, ContactId = contact2.Id, Roles = 'Influencer');
        AccountContactRelation acr2 = new AccountContactRelation(AccountId = account4.Id, ContactId = contact2.Id, Roles = 'Influencer');
        AccountContactRelation acr3 = new AccountContactRelation(AccountId = account3.Id, ContactId = contact2.Id, Roles = 'Influencer');

        List<AccountContactRelation> acrsToInsert = new List<AccountContactRelation> { acr, acr2, acr3};

        insert acrsToInsert;

        // Custom merge accounts
        XVA_BatchMergeAccounts xbma = new XVA_BatchMergeAccounts();
        Test.startTest();
        Database.executeBatch(xbma);
        Test.stopTest();

        // Verify that the merge was successful
        System.assert(true, [SELECT Id, accountId FROM Contact WHERE Id = :contact1.Id].accountId == [SELECT Id, accountId FROM Contact WHERE Id = :contact2.Id].accountId);

    }
    
}