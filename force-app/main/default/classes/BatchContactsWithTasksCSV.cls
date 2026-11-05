global class BatchContactsWithTasksCSV implements Database.Batchable<sObject>, Database.Stateful { 
    global List<Contact> toBeSaved;
    global Datetime start;
    global Datetime last;
    global BatchContactsWithTasksCSV(Datetime start, Datetime last){
       toBeSaved = new List<Contact>();
        this.start = start;
        this.last = last;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        if(!Test.isRunningTest()){
            String query = 'SELECT Id, Name, AccountId,Account.Name, createdDate , (SELECT subject, type, status, Priority, TaskSubtype, Description, WhatId, whoId,ActivityDate FROM Tasks) FROM Contact WHERE createdDate >=: start AND createdDate <=: last AND Attorney_ID__c = null';
            return Database.getQueryLocator(query);
        }else{
            String query = 'SELECT Id, Name, AccountId,Account.Name, createdDate , (SELECT subject, type, status, Priority, TaskSubtype, Description, WhatId, whoId,ActivityDate FROM Tasks) FROM Contact WHERE createdDate >= 2021-01-01T00:00:00Z AND Attorney_ID__c = null';
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
            + 'BatchContactsWithTasksCSV '
            + 'has finished. \n'
            + 'There were total '
            + toBeSaved.size()
            + ' records. Please find the attached success records CSV.';
        String subject = 'Account - Apex Batch Result for BatchContactsWithTasksCSV';
        // Define the email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        // Define email file attachment list
        Messaging.EmailFileAttachment[] emailAttList = new List<Messaging.EmailFileAttachment>();
        
        if(toBeSaved.size()>0) {
            // Creating the CSV file for successful updates
            String finalstr = 'Id, Name, AccountId, AccountName,CreatedDate, Subject, Type, Status, Priority, TaskSubType, Name, RelatedTo, DueDate \n'; 
            String attName = 'Contacts with Tasks List' + system.now().format('YYYYMMDDhhmm') + '.csv';
            for( Contact con  : toBeSaved){
                string recordString = '';
                for(Task t : con.tasks){
                    String accId = String.isBlank(con.AccountId) ? 'NA' : con.AccountId;
                    String accName = String.isBlank(con.Account.Name) ? 'NA' : con.Account.Name;
                     
                    recordString = '"'+con.id+'","'+con.Name+'","'+accId+'","'+accName+'","'+con.CreatedDate+'","';
                    
                    String Subject1 = String.isBlank(t.Subject) ? 'NA' : t.Subject;
                    String Type = String.isBlank(t.Type) ? 'NA' : t.Type;
                    String Status = String.isBlank(t.Status) ? 'NA' : t.Status;
                    String Priority = String.isBlank(t.Priority) ? 'NA' : t.Priority;
                    String TaskSubType = String.isBlank(t.TaskSubType) ? 'NA' :t.TaskSubType;
                    
                    String Description = String.isBlank(t.Description) ? 'NA' : t.Description;
                    String whoId = String.isBlank(t.whoId) ? 'NA' : t.whoId;
                    String whatId = String.isBlank(t.whatId) ? 'NA' : t.whatId;
                    String ActivityDate = String.isBlank(String.valueOf(t.ActivityDate)) ? 'NA' : String.valueOf(t.ActivityDate);
                    recordString = recordString + Subject1+'","'+Type+'","'+Status+'","'+Priority+'","'+TaskSubType+'","'+ whoId +'","'+whatId+'","'+ActivityDate+'"\n';
                   // recordString = recordString + '"'+' '+'","'+' '+'","'+' '+'","'+' '+'","'+' '+'","';
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