global class BatchEventForExeclsheet implements Database.Batchable<sObject>, Database.Stateful { 
    global List<Opportunity> toBeBetterPricing;
    global Set<ID> setOfEvent;
    global Set<ID> setOfContact;
    global Map<Event,List<Contact>> mapEventContact;
    global Map<ID,Set<Id>> mapOfIDs;
    
    global BatchEventForExeclsheet(){
        setOfEvent = new Set<ID>();
        setOfContact = new Set<ID>();
        mapEventContact = new Map<Event,List<Contact>>();
        mapOfIDs = new Map<ID,Set<Id>>();
    }
    
	global Database.QueryLocator start(Database.BatchableContext BC) {
        String name = 'Jason Rufo';
        String emptyString = '';
        if(Test.isRunningTest()){
            String query = 'SELECT id, WhoCount,Owner.Name,Who.Name, StartDateTime,Oasis_Event_Purpose__c, CreatedDate,CreatedBy.Name,EndDateTime, Subject,Description,AccountId,Oasis_Event_Result__c,Type FROM Event';
        	return Database.getQueryLocator(query);
        }else{
           String query = 'SELECT id, WhoCount,Owner.Name,Who.Name, Oasis_Event_Purpose__c, StartDateTime, CreatedDate,CreatedBy.Name,EndDateTime, Subject,Description,AccountId,Oasis_Event_Result__c,Type FROM Event WHERE CreatedDate >= 2021-01-01T00:00:00Z AND CreatedDate < 2021-02-01T23:59:59Z AND Who.Name !=:emptyString ';
           return Database.getQueryLocator(query);
        }
        
    }
    
    global void execute(Database.BatchableContext BC, List<Event> eventList) {
        try {
            for(Event evt : eventList){
                setOfEvent.add(evt.Id);
            }
            List<EventWhoRelation> evntRelationList = [SELECT Id,EventId, Relation.ID FROM EventWhoRelation WHERE EventId IN : setOfEvent];
            for(EventWhoRelation event : evntRelationList){
                setOfContact.add(event.Relation.ID);
                if(mapOfIDs.containsKey(event.EventId)){
                    Set<Id> setOfContactIds = mapOfIDs.get(event.EventId);
                    setOfContactIds.add(event.Relation.ID);
                    mapOfIDs.put(event.EventId, setOfContactIds);
                }else{
                    Set<Id> setOfContactIds = new  Set<Id>();
                    setOfContactIds.add(event.Relation.ID);
                    mapOfIDs.put(event.EventId, setOfContactIds);
                }
            }

            List<Contact> conList =  [Select id,name,Attorney_ID__c from contact where ID IN: setOfContact];
            for(Event evt : eventList){
                if(mapOfIDs.containsKey(evt.Id)){
                    List<Contact> conList1 = [Select id,Name,Attorney_ID__c from Contact where ID IN:mapOfIDs.get(evt.Id)];
                    mapEventContact.put(evt,conList1);
                }
            }
            
        } catch(Exception e) {
            System.debug(e);
        }
        
    }   
    
    global void finish(Database.BatchableContext BC) {
         AsyncApexJob a = [SELECT id, ApexClassId,
                              JobItemsProcessed, TotalJobItems,
                              NumberOfErrors, CreatedBy.Email
                              FROM AsyncApexJob
                              WHERE id = :BC.getJobId()];
        if(mapEventContact.size()>0){
            String body = 'CSV is attached with applicable data.';
            String subject = 'Event List';
            // Define the email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            // Define email file attachment list
            Messaging.EmailFileAttachment[] emailAttList = new List<Messaging.EmailFileAttachment>();
        
             INTEGER count = 1;
            // Creating the CSV file for successful updates
            String finalstr = 'Unique ID, Name,Contact, WhoCount,Assigned, Start Date,CreatedDate, Atty_ID__c,CRM Contact ID,Result of Event,Type of Event,CreatedBy,End Date,Subject,Description,AccountId, Activity ID \n';
            String attName = 'Event List for Current Year .csv';
            String link = 'https://oasiscrm--uatsandbox.lightning.force.com/lightning/r/Opportunity/';
            for(Event evt  : mapEventContact.keySet()){
                String subject1 = String.isBlank(evt.Subject) ? 'NA' : evt.Subject;
                String type = String.isBlank(String.valueof(evt.Type)) ? 'NA' : evt.Type;
                 String resultOfLevel = String.isBlank(String.valueof(evt.Oasis_Event_Result__c)) ? 'NA' : evt.Oasis_Event_Result__c;
                String startDate = String.isBlank(String.valueof(evt.StartDateTime)) ? 'NA' : String.valueof(evt.StartDateTime);
                String EndDate = String.isBlank(String.valueof(evt.EndDateTime)) ? 'NA' : String.valueof(evt.EndDateTime);
                 String Description = String.isBlank(String.valueof(evt.Description)) ? 'NA' : String.valueof(evt.Description);
                String AccountId = String.isBlank(String.valueof(evt.AccountId)) ? 'NA' : String.valueof(evt.AccountId);
                String typeOfEvent = String.isBlank(String.valueof(evt.Oasis_Event_Purpose__c)) ? 'NA' : String.valueof(evt.Oasis_Event_Purpose__c);
                for(Contact con : mapEventContact.get(evt)){
                    String attId = String.isBlank(con.Attorney_ID__c) ? 'NA' : con.Attorney_ID__c;
                    String recordString = '"'+String.valueOf(count)+'","'+con.Name+'","'+evt.Who.Name+'","'+evt.WhoCount+'","'+evt.Owner.Name+'","'+startDate+'","'+evt.CreatedDate+'","'+attId+'","'+con.Id+'","'+resultOfLevel+'","'+typeOfEvent+'","'+evt.CreatedBy.Name+'","'+EndDate+'","'+subject1+'","'+Description+'","'+AccountId+'","'+evt.Id+'"\n';
                	finalstr = finalstr +recordString;

                }
                count++;
            }
            
            // Create the email attachment    
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(attName);
            efa.setBody(Blob.valueOf(finalstr));
            emailAttList.add(efa);
                     
            email.setSubject( subject );
            email.setToAddresses( new String[] {'sbattu@oasisfinancial.com'} );
            email.setPlainTextBody( body );
            email.setFileAttachments(emailAttList);
           
            Messaging.SendEmailResult [] r =
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
             
        }
  	}
}