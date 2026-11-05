/**
  * @Created Date 04/24/2019
  * @author  OASISFINANCIAL GROUP
  * @copyright Copyright (c) 2019-2020 
  * @license   
  * @Modified Date
  * @Description This class is going to take care the re-attempt of failed request from salesforce to Cashtrax database
*/
global class PSCommunicationFailedRecordBatch implements Database.Batchable<sObject>, Database.Stateful {
   
    global String csvColumnHeader = 'FormattedDate, Id, CreatedBy, RetryCount, OperationName, ResponsePayload, ResponseCode, InputPayload\n';
    global List<String> csvRowValues = new List<String>();
   
    global Database.QueryLocator start(Database.BatchableContext BC){
        String responseCode = Constant.RESPONSE_SUCCESS;
        String query = 'Select Id, createdDate,createdById,FailedRetries__c, GenericName__c,InputPayload__c, Operation__c, ResponsePayload__c from PSCommunicationCache__c where FailedRetries__c <= 3 and CreatedDate  <= LAST_N_DAYS:30 and ResponseStatus__c!= \'' + responseCode  + '\'';
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<PSCommunicationCache__c> scope){
        System.debug('LIST SIZE === ' + scope.size());
        integer i = 0;
        for(PSCommunicationCache__c cache :  scope){
            
            String formattedDate = cache.CreatedDate.format('M/d/yyyy h:mm:ss a z');
            String id = cache.Id;
            String createdBy = cache.createdById;
            String retryCount = String.valueOf(cache.FailedRetries__c);
            String OperationName = cache.Operation__c != null ? cache.Operation__c : '';
            String responsePayload = cache.ResponsePayload__c != null ? cache.ResponsePayload__c : '';
            String responseCode = Constant.RESPONSE_SUCCESS;
            String inputPayload = cache.InputPayload__c;
                      
            String rowStr = formattedDate + ',' + id + ',' + createdBy + ',' + retryCount + ',' + OperationName + ',' + responsePayload   + ','+ responseCode + ',' + inputPayload;
            csvRowValues.add(rowStr);
            i++;
        }
        
        System.debug('INTEGER SIZE === ' + i);
        
        //TODO CSV File Send
         
         List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();  
         String csvFile = csvColumnHeader + String.join(csvRowValues,'\n');
         attachments.add(Utility.prepareCSVAttachment('CSVFile.csv',csvFile));  
         List<String> emails = new List<String>();  
         emails.add('hitmprashant@gmail.com');  
         boolean flag = Utility.sendEmailWithAttachment(emails,'Test Mail Subject','Hi,<br></br> This is my Mail Body.<br></br> Thanks.','Test Sender',attachments); 
        
        //TODO PURGE ---> Check if file send successfully and check count as well
        if(flag && scope.size() == i){
        
          System.debug('INSIDE MAIL SEND');
          delete scope;
        }
    }
   
    global void finish(Database.BatchableContext BC){
        
        
    }
}