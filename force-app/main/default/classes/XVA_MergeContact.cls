public with sharing class XVA_MergeContact 
{
    @InvocableMethod(label='Merge Contact' description='Merge two contacts')
    public static void mergeContact(List<MergeContactParams> mergeContactParams) 
    {
        MergeContactParams params = mergeContactParams[0];

        Contact sourceContact = params.sourceContact;
        Contact destinationContact = params.destinationContact;

        Map<string, Id> idMap = new Map<string, Id>();
        idMap.put('contactId', destinationContact.Id);

        List<string> contactEditableFields = XVA_Utility.getEditableFields('Contact');

        string getContactQuery = 'Select Id, ' + string.join(contactEditableFields, ',') + ', (Select Id, WhatId from Tasks), (Select Id, WhatId from Events where isChild = false) from Contact where Id = :contactId';
        
        Contact destinationWithEditableFields = Database.queryWithBinds(getContactQuery, idMap, AccessLevel.SYSTEM_MODE);
        idMap.put('contactId', sourceContact.Id);
        Contact sourceContactWithActivity = Database.queryWithBinds(getContactQuery, idMap, AccessLevel.SYSTEM_MODE);

        for(Task t : sourceContactWithActivity.Tasks) {
            t.WhatId = destinationContact.AccountId;
        }

        for (Event e : sourceContactWithActivity.Events) {
            e.WhatId = destinationContact.AccountId;
        }

        
        Database.update(sourceContactWithActivity.Tasks, false);
        Database.update(sourceContactWithActivity.Events, false);
        //update sourceContactWithActivity.Tasks;
        //update sourceContactWithActivity.Events;

        idMap.put('contactId', destinationContact.Id);
        getContactQuery = 'Select Id, ' + string.join(contactEditableFields, ',') + ' from Contact where Id = :contactId';
        destinationWithEditableFields = Database.queryWithBinds(getContactQuery, idMap, AccessLevel.SYSTEM_MODE);
        idMap.put('contactId', sourceContact.Id);
        sourceContactWithActivity = Database.queryWithBinds(getContactQuery, idMap, AccessLevel.SYSTEM_MODE);


        merge sourceContactWithActivity destinationWithEditableFields;
    }


    


    public class MergeContactParams {
        @InvocableVariable(label='Source Contact' description='The contact to merge from')
        public Contact sourceContact;

        @InvocableVariable(label='Destination Contact' description='The contact to merge to')
        public Contact destinationContact;
    }


}