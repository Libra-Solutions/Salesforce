global class XVA_SetContactAssignedBDE implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id,name, ownerid, account.cashtrax_account__c, account.cashtrax_account__r.ownerid, accountid, account.ownerId FROM Contact');
    }
    
    global void execute(Database.BatchableContext bc, List<Contact> scope) {
        List<Contact> contactsToUpdate = new List<Contact>();
        for(Contact con : scope) {
            if(con.AccountId != null && con.Account.cashtrax_account__c != null && con.account.cashtrax_account__r.ownerid != null && con.ownerId != con.account.cashtrax_account__r.ownerid) {
                con.ownerId = con.account.cashtrax_account__r.ownerid;
                contactsToUpdate.add(con);
            }
            else if(con.AccountId != null && con.account.ownerId != null && con.ownerId != con.account.ownerId ){
                con.ownerId = con.account.ownerId;
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