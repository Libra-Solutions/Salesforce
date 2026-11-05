public with sharing class ChildAccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getChildServiceLocations(Id parentAccountId) {
        return [
            SELECT Id, Name, Phone, BillingStreet, BillingCity, BillingState, BillingPostalCode
            FROM Account
            WHERE ParentId = :parentAccountId
            AND RecordType.DeveloperName = 'Provider_Service_Location'
            ORDER BY Name ASC
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getChildBillingLocations(Id parentAccountId) {
        return [
            SELECT Id, Name, Phone, BillingStreet, BillingCity, BillingState, BillingPostalCode
            FROM Account
            WHERE ParentId = :parentAccountId
            AND RecordType.DeveloperName = 'C3_Provider'
            ORDER BY Name ASC
        ];
    }
}