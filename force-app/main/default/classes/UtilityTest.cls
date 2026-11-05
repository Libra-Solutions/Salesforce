@isTest
public class UtilityTest {


 @isTest
  private static void testqueryObjects(){
   List<String> theFields = new List<String>{'Id', 'Name'};  
      String theFilter = '';  
      String sortField = 'Name';  
      String sortOrder = 'ASC';  
      List<Account> all = Utility.queryObjects('Account', theFields, theFilter, sortField, sortOrder);  
  
 }
 
 @isTest
  private static void testcreateErrorLogs(){
   String errmessage = 'Error on Account';
   String srcMethod = 'Test Method';
   String srcObj = 'Account';
   Utility.craeteErrorLogs(errmessage ,srcMethod ,srcObj );
  }
  
  
  @isTest
  private static void testprepareCSVAttachment(){
   String csvColumnHeader = 'FormattedDate, Id, CreatedBy, RetryCount, OperationName, ResponsePayload, ResponseCode, InputPayload\n';
   List<String> csvRowValues = new List<String>();
   List<PSCommunicationCache__c > psCommList = [Select Id, createdDate,createdById,FailedRetries__c, GenericName__c,InputPayload__c, Operation__c, ResponsePayload__c from PSCommunicationCache__c where FailedRetries__c <= 3 and CreatedDate  <= LAST_N_DAYS:30 and ResponseStatus__c!='200:Success'];
    integer i = 0;
        for(PSCommunicationCache__c cache :  psCommList ){
            
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
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();  
         String csvFile = csvColumnHeader + String.join(csvRowValues,'\n');
         attachments.add(Utility.prepareCSVAttachment('CSVFile.csv',csvFile));  
         List<String> emails = new List<String>();  
         emails.add('hitmprashant@gmail.com');  
         boolean flag = Utility.sendEmailWithAttachment(emails,'Test Mail Subject','Hi,<br></br> This is my Mail Body.<br></br> Thanks.','Test Sender',attachments); 
  }

  @isTest
  private static void testgetAccountRecTypeId(){
      String recordTypeLabel = 'Provider';
      Utility.getAccountRecTypeId(recordTypeLabel);  
  }
 
  @isTest
  private static void testgetContactRecTypeId(){
      String recordTypeLabel = 'Provider';
      Utility.getContactRecTypeId(recordTypeLabel);  
 }
 
 @isTest
  private static void testgetOppRecTypeId(){
      String recordTypeLabel = 'Provider';
      Utility.getOppRecTypeId(recordTypeLabel);  
 }
 
 
 @isTest
  private static void testSendEmail(){
        
         List<String> emails = new List<String>();  
         emails.add('hitmprashant@gmail.com');  
         boolean flag = Utility.sendEmail(emails,'Test Mail Subject','Hi,<br></br> This is my Mail Body.<br></br> Thanks.','Test Sender'); 
  }
  
  @isTest
  private static void testSendErrorEmail(){
        
         List<String> emails = new List<String>();  
         emails.add('hitmprashant@gmail.com');  
         Utility.SendErrorEmail('insert','123erty56789',new PSCommunicationCache__c()); 
  }
 
 
 


}