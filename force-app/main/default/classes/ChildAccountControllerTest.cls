@isTest
public with sharing class ChildAccountControllerTest {
    
    static testMethod void testGetChildServiceLocations() {
        // Create a parent account
        Account parentAccount = new Account(Name = 'Parent Account');
        insert parentAccount;

        // Create child service location accounts
        List<Account> childServiceLocations = new List<Account>();
        for (Integer i = 0; i < 3; i++) {
            childServiceLocations.add(new Account(
                Name = 'Child Service Location ' + i,
                ParentId = parentAccount.Id,
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Service_Location').getRecordTypeId()
            ));
        }
        insert childServiceLocations;

        // Call the method to get child service locations
        List<Account> result = ChildAccountController.getChildServiceLocations(parentAccount.Id);

        // Verify the results
        System.assertEquals(3, result.size(), 'Expected 3 child service locations');
    }

    static testMethod void testGetChildBillingLocations() {
        // Create a parent account
        Account parentAccount = new Account(Name = 'Parent Billing Account');
        insert parentAccount;   
        // Create child billing location accounts   
        List<Account> childBillingLocations = new List<Account>();
        for (Integer i = 0; i < 3; i++) {
            childBillingLocations.add(new Account(
                Name = 'Child Billing Location ' + i,
                ParentId = parentAccount.Id,
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('C3_Provider').getRecordTypeId()
            ));
        }
        insert childBillingLocations;

        // Call the method to get child billing locations
        List<Account> result = ChildAccountController.getChildBillingLocations(parentAccount.Id);

        // Verify the results
        System.assertEquals(3, result.size(), 'Expected 3 child billing locations');
    }

}