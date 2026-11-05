@isTest
public with sharing class XVA_MergeContactTest {
    
    static testMethod void testContactMerge() 
    {
        XVA_TestDataFactory testData = new XVA_TestDataFactory();
        Contact sourceContact = testData.TestContact;
        Contact destinationContact = testData.createTestContactDefaults(sourceContact.AccountId);
        insert destinationContact;

        List<XVA_MergeContact.MergeContactParams> mergeContactParams = new List<XVA_MergeContact.MergeContactParams>();
        XVA_MergeContact.MergeContactParams params = new XVA_MergeContact.MergeContactParams();
        params.sourceContact = sourceContact;
        params.destinationContact = destinationContact;
        mergeContactParams.add(params);
        XVA_MergeContact.mergeContact(mergeContactParams);

    }

    static testMethod void testBulkContactMerge() 
    {
        XVA_TestDataFactory testData = new XVA_TestDataFactory();
        Contact sourceContact = testData.TestContact;
        Contact destinationContact = testData.createTestContactDefaults(sourceContact.AccountId);
        insert destinationContact;
        sourceContact.Merge_To__c = destinationContact.Id;
        sourceContact.Needs_To_Be_Merged__c = true;
        update sourceContact;

        XVA_BatchMergeContacts batch = new XVA_BatchMergeContacts();
        batch.execute(null, [Select Id, Needs_To_Be_Merged__c, Merge_To__c from Contact WHERE merge_to__c != null AND needs_to_be_merged__c = true]);

        
    }

    
    static testMethod void testBulkContactMergeWithRelations() 
    {
        XVA_TestDataFactory testData = new XVA_TestDataFactory();
        Contact sourceContact = testData.TestContact;
        Contact destinationContact = testData.createTestContactDefaults(sourceContact.AccountId);
        insert destinationContact;
        sourceContact.Merge_To__c = destinationContact.Id;
        sourceContact.Needs_To_Be_Merged__c = true;
        update sourceContact;

        XVA_BatchMergeContacts batch = new XVA_BatchMergeContacts();
        batch.execute(null, [Select Id, Needs_To_Be_Merged__c, Merge_To__c from Contact WHERE merge_to__c != null AND needs_to_be_merged__c = true]);

        
    }

    static testMethod void testBulkContactMergeWithACRJob() {
        XVA_TestDataFactory testData = new XVA_TestDataFactory();
        Contact sourceContact = testData.TestContact;
        Contact destinationContact = testData.createTestContactDefaults(sourceContact.AccountId);

        Account secondAccount = testData.createTestAccountDefaults();
        insert secondAccount;


        insert destinationContact;
        sourceContact.Merge_To__c = destinationContact.Id;
        sourceContact.Needs_To_Be_Merged__c = true;
        update sourceContact;


        List<AccountContactRelation> acrList = new List<AccountContactRelation>();
        acrList.add(new AccountContactRelation(AccountId = secondAccount.Id, ContactId = sourceContact.Id, Roles = 'Influencer'));  
        acrList.add(new AccountContactRelation(AccountId = secondAccount.Id, ContactId = destinationContact.Id, Roles = 'Influencer'));

        insert acrList;

        List<Account_Relation__c> accountRelationList = new List<Account_Relation__c>();
        accountRelationList.add(new Account_Relation__c(Account__c = sourceContact.AccountId, Contact__c = sourceContact.Id, Role__c = 'Attorney'));
        accountRelationList.add(new Account_Relation__c(Account__c = destinationContact.AccountId, Contact__c = destinationContact.Id, Role__c = 'Attorney'));
        insert accountRelationList;

        XVA_BatchMergeContacts batch = new XVA_BatchMergeContacts();
        Test.startTest();
        Database.executeBatch(batch);

        Contact sC = [Select id from Contact where Id = :sourceContact.Id];
        system.debug(sC);
        Test.stopTest();
    }


}