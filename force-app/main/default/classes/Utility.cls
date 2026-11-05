/**
* Requirement: Sending the request from cashtrax to salesforce
* @param
* @author
* @return type
* @created date
* @modification
**/
public class Utility {

  /**
  * Create dynamic query at runtime.
  * @param String theObject, List<String> theFields, String theFilter, String sortField, String sortOrder
  * @return List<sObject>.
  * @exception Exception On input error.
  * @see 
 */
  public static List<sObject> queryObjects(String theObject, List<String> theFields, String theFilter, String sortField, String sortOrder) {
          String theQuery = 'SELECT ' + string.join(theFields, ',');
          theQuery += ' FROM ' + theObject;
          if(!String.isEmpty(theFilter)) {
               theQuery += ' WHERE ' + theFilter;
          }
          if(!String.isEmpty(sortField)) {
               theQuery += ' ORDER BY ' + sortField;
               if(!String.isEmpty(sortOrder)) {
                    theQuery += ' ' + sortOrder;
               }
          }
          return database.query(theQuery);
     }
   
   /**
    * Creating error logs.
    * @param String errmessage, String srcMethod, String srcObj
    * @return Error_Logs__c.
    * @exception Exception On input error.
    * @see 
   */
   public static Error_Logs__c craeteErrorLogs(String errmessage, String srcMethod, String srcObj){
        
        Error_Logs__c errorLogs = new Error_Logs__c(
            Exception_Message__c = errmessage, Source_Method__c =srcMethod,
            Source_Object__c = srcObj);
        return errorLogs;
    }
    
   /**
    * Prepare the csv attachment.
    * @param String fileName,String Body
    * @return Messaging.EmailFileAttachment.
    * @exception Exception On input error.
    * @see 
   */ 
   public static Messaging.EmailFileAttachment prepareCSVAttachment(String fileName,String Body)  
   {  
     Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();  
     attachment.setBody(Blob.valueOf(Body));  
     attachment.setContentType('text/csv');  
     attachment.setFileName(fileName);  
     attachment.setinline(false);  
     return attachment;  
   }  
   
   /**
    * Send Email with attachment {csv, excel}.
    * @param List<String> toAddresses,String subject,String mailBody,String senderName,List<Messaging.EmailFileAttachment> attachments
    * @return boolean.
    * @exception Exception On input error.
    * @see 
   */
   public static boolean sendEmailWithAttachment(List<String> toAddresses,String subject,String mailBody,String senderName,List<Messaging.EmailFileAttachment> attachments)  
   {  
     boolean flagSendEmail = false;
     try{
     List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();  
     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
     mail.setToAddresses(toAddresses);  
     mail.setReplyTo('hitmprashant@gmail.com');  
     mail.setSenderDisplayName(senderName);  
     mail.setSubject(subject);  
     mail.setHtmlBody(mailBody);  
     mail.setFileAttachments(attachments);  
     mails.add(mail);  
     Messaging.sendEmail(mails);
     flagSendEmail = true; 
     } catch (Exception e) {
       flagSendEmail = false;
       e.getMessage();
       
     }
      return flagSendEmail;
   }  
   
   
   
   /**
    * Send Email with text body
    * @param List<String> toAddresses,String subject,String mailBody,String senderName,List<Messaging.EmailFileAttachment> attachments
    * @return boolean.
    * @exception Exception On input error.
    * @see 
   */
   public static boolean sendEmail(List<String> toAddresses,String subject,String mailBody,String senderName)  
   {  
     boolean flagSendEmail = false;
     try{
     List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();  
     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
     mail.setToAddresses(toAddresses);  
     mail.setReplyTo('cchauhan@oasisfinancial.com');  
     mail.setSenderDisplayName(senderName);  
     mail.setSubject(subject);  
     mail.setHtmlBody(mailBody);  
    
     mails.add(mail);  
     Messaging.sendEmail(mails);
     flagSendEmail = true; 
     } catch (Exception e) {
       flagSendEmail = false;
       e.getMessage();
       
     }
      return flagSendEmail;
   }  
   
   
   /**
    * Send Error Email with text body
    * @param List<String> action, String object Id ,  PSCommunicationCache__c cache
    * @return void.
    * @exception Exception On input error.
    * @see 
   */
   public static void SendErrorEmail(String action, String objectId, PSCommunicationCache__c cache)
   {
       
       String adminEmails='';
       
       for (IntegrationSettings__mdt cashTraxDEndPoint : [select Id, MasterLabel, DeveloperName, PSEndPoint__c,MLEndPoint__c, 
                                                            MLSecurityToken__c,value__c,Envrionment_Flag__c,AdminEmail__c From IntegrationSettings__mdt]){
           adminEmails = cashTraxDEndPoint.AdminEmail__c;
       }
       
       if(String.isNotBlank(adminEmails)){
            
            List<String> toAddresses = adminEmails.split(',');
            toAddresses.add(UserInfo.getUserEmail());
            String body = 'Dear '+UserInfo.getFirstName()+','+
                           '<br/>There is some problem performing the following operation-'+action+'.'+
                           '<br/>Please reach out to your Administrator for further action. Please see details about the issue below:'+
                            '<br/><br/>'+cache+
                            '<br/><br/>Thanks'+
                            '<br/>Salesforce Admin';
                            
            SendEmail(toAddresses,'Sync Error for Action - '+action,body,'Salesforce Admin');
            
       }
   }
   
   /**
    * Get Record Type Id based on Name.
    * @param String recordTypeLabel
    * @return Id.
    * @exception Exception On input error.
    * @see 
   */
   
   public static Id getAccountRecTypeId(String recordTypeLabel){
       
        Id recid = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
        return recid;
        
    }
    
    
  /**
    * Get Record Type Id based on Name.
    * @param String recordTypeLabel
    * @return Id.
    * @exception Exception On input error.
    * @see 
   */
     
  public static Id getContactRecTypeId(String recordTypeLabel){
       
        Id recid = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
        return recid;
        
    }
    
    
   public static Id getOppRecTypeId(String recordTypeLabel){
       
        Id recid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
        return recid;
        
    }
    
    //Check for Null and 0
    public static boolean IsNonZero(String a)
    {
        if(String.isNotBlank(a)){
          if( a=='0'){
              return false;
          }
          return true;
        }
        else
        {
          return false;
        }
        //return true;
    }      
    
    //Check for Null and 0
    public static boolean IsBlank(String a)
    {
        if(String.isNotBlank(a)){
          if( a=='0'){
              return true;
          }
          return false;
        }
        else
        {
          return true;
        }
        
    }      
    
}