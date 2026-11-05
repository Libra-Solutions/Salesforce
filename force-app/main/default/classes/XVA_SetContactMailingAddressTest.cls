@isTest
public class XVA_SetContactMailingAddressTest {
    
    @testSetup
    static void setupTestData() {
        Account testAccount = new Account(
            Name = 'Test Account',
            BillingStreet = '123 Main St',
            BillingCity = 'New York',
            BillingState = 'NY',
            BillingStateCode = 'NY',
            BillingPostalCode = '10001',
            BillingCountry = 'United States',
            BillingCountryCode = 'US',
            Street2__c = 'Suite 400'
        );
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            AccountId = testAccount.Id,
            MailingStreet = '456 Other St',
            MailingCity = 'Los Angeles',
            MailingState = 'CA',
            MailingStateCode = 'CA',
            MailingPostalCode = '90001',
            MailingCountry = 'United States',
            MailingCountryCode = 'US',
            MailingStreet2__c = 'Apt 5B'
        );
        insert testContact;
        testContact.mailingstreet = '321 First Ave';
        update testContact;
    }

    @isTest
    static void testBatchExecution() {
        Contact beforeUpdate = [SELECT Id, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, MailingStreet2__c 
                                FROM Contact LIMIT 1];

        System.assertNotEquals('123 Main St', beforeUpdate.MailingStreet, 'MailingStreet should initially be different from BillingStreet');

        Test.startTest();
        XVA_SetContactMailingAddress batchJob = new XVA_SetContactMailingAddress();
        Database.executeBatch(batchJob);
        Test.stopTest();

        Contact afterUpdate = [SELECT Id, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, MailingStreet2__c 
                               FROM Contact WHERE Id = :beforeUpdate.Id];
        System.assertEquals('123 Main St', afterUpdate.MailingStreet, 'MailingStreet should be updated to match BillingStreet');
    }
}