global class XVA_SetContactMailingAddress implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        string query = 'SELECT Id,name,MailingStreet,MailingCity,MailingPostalCode,MailingStateCode,MailingState,MailingCountry,MailingCountryCode, MailingStreet2__c, OtherStreet, OtherCity,OtherStateCode,OtherState,OtherCountry,OtherCountryCode, OtherPostalCode, otherstreet2__c, account.BillingStreet, account.BillingCity, account.BillingState, account.BillingStateCode, account.BillingPostalCode, account.BillingCountry, account.BillingCountryCode, account.street2__c FROM Contact';

        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Contact> scope) {
        List<Contact> contactsToUpdate = new List<Contact>();
        for(Contact con : scope) {
            if(con.MailingStreet != con.account.BillingStreet || con.MailingCity != con.account.BillingCity || con.MailingState != con.account.BillingState
             || con.MailingPostalCode != con.account.BillingPostalCode || con.MailingCountry != con.account.BillingCountry || con.MailingStreet2__c != con.account.Street2__c) {
                con.otherstreet = con.mailingstreet != null ? con.mailingstreet : null;
                con.othercity = con.mailingcity != null ? con.mailingcity : null;
                con.otherstate = con.mailingstate != null ? con.mailingstate : null;
                con.otherstatecode = con.mailingstatecode != null ? con.mailingstatecode : null;
                con.otherpostalcode = con.mailingpostalcode != null ? con.mailingpostalcode : null;
                con.othercountry = con.mailingcountry != null ? con.mailingcountry : 'United States';
                con.othercountrycode = con.mailingcountrycode != null ? con.mailingcountrycode : 'US';
                con.otherstreet2__c = con.mailingstreet2__c != null ? con.mailingstreet2__c : null;
                con.MailingStreet = con.account.BillingStreet != null ? con.account.BillingStreet : null;
                con.MailingCity = con.account.BillingCity != null ? con.account.BillingCity : null;
                con.MailingState = con.account.BillingState != null ? con.account.BillingState : null;
                con.MailingPostalCode = con.account.BillingPostalCode != null ? con.account.BillingPostalCode : null;
                con.MailingCountry = con.account.BillingCountry != null ? con.account.BillingCountry : 'United States';
                con.MailingCountryCode = con.account.BillingCountryCode != null ? con.account.BillingCountryCode : 'US';
                con.MailingStreet2__c = con.account.street2__c != null ? con.account.street2__c : null;
                contactsToUpdate.add(con);
            }
        }
        if(!contactsToUpdate.isEmpty()) {
            Database.update(contactsToUpdate,false);
        }
    }

        global void finish(Database.BatchableContext bc) {
    }
}