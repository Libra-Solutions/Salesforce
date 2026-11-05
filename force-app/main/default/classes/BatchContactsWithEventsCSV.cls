global class BatchContactsWithEventsCSV implements Database.Batchable<sObject>, Database.Stateful { 
    global List<Contact> toBeSaved;
    global BatchContactsWithEventsCSV(){
       toBeSaved = new List<Contact>();
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String recordType = 'Attorney';
        // collect the batches of records or objects to be passed to execute
        if(!Test.isRunningTest()){// AND createdDate <= 2021-08-31T00:00:00Z
            String query = 'SELECT Id, Name, AccountId,Account.Name, Account.Billing_Street__c, Account.Billing_City__c, Account.Billing_State__c, Account.BillingCountry, Account.Zip__c,createdDate , (SELECT subject,Oasis_Event_Result__c,Oasis_Event_Purpose__c, type,EventSubtype, Description, WhatId, whoId,StartDateTime,EndDateTime FROM Events) FROM Contact WHERE createdDate >= 2021-01-01T00:00:00Z  AND Attorney_ID__c = null AND RecordType.Name =: recordType';
            return Database.getQueryLocator(query);
        }else{
            String query = 'SELECT Id, Name, AccountId,Account.Name, Account.Billing_Street__c, Account.Billing_City__c, Account.Billing_State__c, Account.BillingCountry, Account.Zip__c,createdDate , (SELECT subject,Oasis_Event_Result__c,Oasis_Event_Purpose__c, type,EventSubtype, Description, WhatId, whoId,StartDateTime,EndDateTime FROM Events) FROM Contact WHERE createdDate >= 2021-01-01T00:00:00Z AND Attorney_ID__c = null';
            return Database.getQueryLocator(query);
        }
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> conList) {
        try {
            // process each batch of records
            toBeSaved.addAll(conList);
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
        String body = 'Your batch job '
            + 'BatchContactsWithEventsCSV '
            + 'has finished. \n'
            + 'There were total '
            + toBeSaved.size()
            + ' records. Please find the attached success records CSV.';
        String subject = 'Account - Apex Batch Result for BatchContactsWithEventCSV';
        // Define the email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        // Define email file attachment list
        Messaging.EmailFileAttachment[] emailAttList = new List<Messaging.EmailFileAttachment>();
        
        if(toBeSaved.size()>0) {
            // Creating the CSV file for successful updates
            String finalstr = 'Id, Name, AccountId,AccountName, Street, City, State,BillingCountry, Zip, CreatedDate, Subject,Result of Event, Type of Event, Type,EventSubType, Description, Name, RelatedTo, StartDate, EndDate \n'; 
            String attName = 'Contacts with Events List' + system.now().format('YYYYMMDDhhmm') + '.csv';
            for( Contact con  : toBeSaved){
                 
                for(Event t : con.events){
                    String accId = String.isBlank(con.AccountId) ? 'NA' : con.AccountId;
                    String accName = String.isBlank(con.Account.Name) ? 'NA' : con.Account.Name;
                    
                    String street = String.isBlank(con.Account.Billing_Street__c) ? 'NA' : con.Account.Billing_Street__c;
                    String city = String.isBlank(con.Account.Billing_City__c) ? 'NA' : con.Account.Billing_City__c;
                    String state = String.isBlank(con.Account.Billing_State__c) ? 'NA' : con.Account.Billing_State__c;
                    String country = String.isBlank(con.Account.BillingCountry) ? 'NA' : con.Account.BillingCountry;
                    String zip = String.isBlank(con.Account.Zip__c) ? 'NA' : con.Account.Zip__c;
                    
                    string recordString = '"'+con.id+'","'+con.Name+'","'+accId+'","'+accName+'","'+street+'","'+city+'","'+state+'","'+country+'","'+zip+'","'+con.CreatedDate+'","';
                    
                    
                    String Subject1 = String.isBlank(t.Subject) ? 'NA' : t.Subject;
                    String OasisEventResult = String.isBlank(t.Oasis_Event_Result__c) ? 'NA' : t.Oasis_Event_Result__c;
                    String Oasis_Event_Purpose = String.isBlank(t.Oasis_Event_Purpose__c) ? 'NA' : t.Oasis_Event_Purpose__c;
                    String Type = String.isBlank(t.Type) ? 'NA' : t.Type;
                    String EventSubType = String.isBlank(t.EventSubType) ? 'NA' :t.EventSubType;
                    
                    String Description = String.isBlank(t.Description) ? 'NA' : t.Description;
                    String whoId = String.isBlank(t.whoId) ? 'NA' : t.whoId;
                    String whatId = String.isBlank(t.whatId) ? 'NA' : t.whatId;
                    String StartDateTime = String.isBlank(String.valueOf(t.StartDateTime)) ? 'NA' : String.valueOf(t.StartDateTime);
                    String EndDateTime = String.isBlank(String.valueOf(t.EndDateTime)) ? 'NA' : String.valueOf(t.EndDateTime);
                    recordString = recordString + Subject1+'","'+ OasisEventResult+'","'+ Oasis_Event_Purpose+'","'+Type+'","'+EventSubType+'","'+t.Description+'","'+ t.whoId +'","'+t.whatId+'","'+StartDateTime+'","'+EndDateTime+'"\n';
                   // recordString = recordString + '"'+' '+'","'+' '+'","'+' '+'","'+' '+'","'+' '+'","';
                	//recordString = recordString + '"\n';
                	finalstr = finalstr +recordString;
                }
                
            }
            
            // Create the email attachment    
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(attName);
            efa.setBody(Blob.valueOf(finalstr));
            emailAttList.add(efa);
            
        }
        // Sets the paramaters of the email
        email.setSubject( subject );
        email.setToAddresses( new String[] {'sbattu@oasisfinancial.com','skhandelwal295@gmail.com'}   );
        email.setPlainTextBody( body );
        email.setFileAttachments(emailAttList);
        
        // Sends the email
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
}