/**
  * @Created Date 04/24/2019
  * @author    OASISFINANCIAL GROUP
  * @copyright Copyright (c) 2019-2020 
  * @license   
  * @Modified Date
  * @Description This class is going to take care the re-attempt of failed request from salesforce to Cashtrax database
*/
public class PSCommunicationbatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {

  public Database.QueryLocator start(Database.BatchableContext ctx) {
   String responseCode = Constant.RESPONSE_FAIL;
   String query = 'Select Id, GenericName__c,InputPayload__c, Operation__c, ResponsePayload__c from PSCommunicationCache__c where FailedRetries__c <= 3 and ResponseStatus__c!= \'' + responseCode  + '\'';
   return Database.getQueryLocator(query);
  }

  public void execute(Database.BatchableContext ctx, List<PSCommunicationCache__c  > psCommunication) {
    //FailedRetries__c
    List<PSCommunicationCache__c> updateCache = new List<PSCommunicationCache__c>();
    List<Account> firmList = new List<Account>();
    List<Contact> attorneylist = new List<Contact>();
    CommunicationCache cachePush = new CommunicationCache();
    String sessionId = cachePush.login();
    for(PSCommunicationCache__c  cache : psCommunication) {
          System.debug('========= PSCOmmunication ' + psCommunication.size());
          Account act = new Account();
          Contact cnt = new Contact();
          PSCommunicationCache__c updateCacheRecord = new PSCommunicationCache__c();
          Map<String, Object> results =  new Map<String, Object>();
          if(test.isRunningTest()) { 
             sessionId = UserInfo.getSessionId();
          }
          results =  cachePush.pushToCashtrax(cache, sessionId,'PS');
          updateCacheRecord.Id= cache.Id;
          updateCacheRecord.ResponseStatus__c = String.valueOf(results.get('Status')) + ':' + String.valueOf(results.get('StatusCode')) ;
          system.debug('PRINT THE STATUC CODE==== ' + results);
          if(results != null && String.valueOf(results.get('StatusCode')) == '200' && String.isNotblank(cache.GenericName__c) && cache.GenericName__c == 'CreateFirm') {
          //Todo
              System.debug('CT FIRM ======== ' + results.get('CTX_FirmID'));
             act.Id = getCashTraxFirmId(cache.ResponsePayload__c, cache.GenericName__c);
             act.CTXFirmId__c = String.valueOf(results.get('CTX_FirmID'));
             firmList.add(act);
          
          } else if(results != null && results.get('StatusCode') == 'OK' && String.isNotblank(cache.GenericName__c) && cache.GenericName__c == 'UpdateFirm' ) {
             act.Id = getCashTraxFirmId(cache.ResponsePayload__c, cache.GenericName__c);
             firmList.add(act);
          } else if(results != null && String.valueOf(results.get('StatusCode')) == '200' && String.isNotblank(cache.GenericName__c) && cache.GenericName__c == 'CreateAttorney') {
             cnt.Id = getCashTraxFirmId(cache.ResponsePayload__c, cache.GenericName__c);
             cnt.Attorney_Contact_Id__c = String.valueOf(results.get('CTX_AttorneyID'));
             attorneylist.add(cnt);
          } else if(results != null && results.get('Status') == 'OK' && String.isNotblank(cache.GenericName__c) &&   cache.GenericName__c == 'UpdateAttorney') {
             cnt.Id = getCashTraxFirmId(cache.ResponsePayload__c, cache.GenericName__c);
             attorneylist.add(cnt);
          } else if(results != null && String.valueOf(results.get('StatusCode')) == '200' && String.isNotblank(     cache.GenericName__c) && cache.GenericName__c == 'CreateCase') {
                  //CRM_OpportunityID  
             
          } else if(results != null && String.valueOf(results.get('StatusCode')) == '200' && String.isNotblank(cache.GenericName__c) && cache.GenericName__c== 'CreateAttorneyAssistant') {
             cnt.Id = getCashTraxFirmId(cache.ResponsePayload__c, cache.GenericName__c);
             cnt.Attorney_Contact_Id__c = String.valueOf(results.get('CRM_OpportunityID'));
             attorneylist.add(cnt);
          } else if(results != null && String.valueOf(results.get('StatusCode')) == '200' && String.isNotblank(cache.GenericName__c) && cache.GenericName__c== 'UpdateAttorneyAssistant') {
             cnt.Id = getCashTraxFirmId(cache.ResponsePayload__c, cache.GenericName__c);
             attorneylist.add(cnt);
          } else {
          
          }
          
    }
    System.debug('--------------- Account ' + firmList.size());
    System.debug('--------------- PSCommunication ' + updateCache.size());
    
    if(firmList.size()>0) {update firmList;
    } 
    if(attorneylist.size()>0) {update attorneylist;
    }
    if(updateCache.size()>0) {update updateCache;
    }
   
  }
  
  
  public void finish(Database.BatchableContext ctx) {
     AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors,     JobItemsProcessed,
        TotalJobItems, CreatedBy.Email
        from AsyncApexJob where Id =:ctx.getJobId()];
       //System.debug('EMAIL ========= ' + toAddresses[0]); 
     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'hitmprashant@gmail.com'};
            mail.setToAddresses(toAddresses );
            mail.setSubject('Match Merge Batch ');
            mail.setPlainTextBody('records processed ' + a.TotalJobItems +
           'with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
   
  }
  
  
  /**
  * This method will be returning the FirmId for operations like createFirm, updateFirm, CreateAttorney etc.
  * @param  jsonResponsePayload, opeartionName
  * @return firmId 
  */
   @testvisible private static String getCashTraxFirmId(String jsonResponsePayload, String operationName) {
    String firmId = '' ;
    if(jsonResponsePayload != null) {
    //String JSONContent = 'Contains input request submitted to cashtrax{"ZipCode":"110088","Website":"www.googleparent.com","State":"Alabama","PhoneNumber":null,"HeadQuarter":1,"FirmName":"Zaring, Alan","FirmID":0,"CRM_FirmID":"0014B00000eQDXdQAO","City":"Delhi","Address2":"Suite 100","Address1":"10 South Main Street"}';
    Integer inde = jsonResponsePayload.indexOf('{');
    System.debug('PRINT THE VALUE === ' + inde);
    String jsonVal = jsonResponsePayload.subString(inde);
    system.debug('PRINT THE NEW JSON == ' + jsonVal);

    JSONParser parser = JSON.createParser(jsonVal);
    while (parser.nextToken() != null) {
        System.debug('Current token: ' +    parser.getCurrentToken());
        System.debug('Current Name: ' +
            parser.getCurrentName());
        if(parser.getCurrentName() == 'CRM_FirmID' && operationName == 'CreateFirm') {
            firmId  = parser.getText();
            System.debug('FIRM ID ============ ' + FirmID);
        } 
        if(parser.getCurrentName() == 'CRM_FirmID' && operationName == 'UpdateFirm') {
            firmId  = parser.getText();
            System.debug('FIRM ID ============ ' + FirmID);
        }
        if(parser.getCurrentName() == 'CRM_FirmID' && operationName == 'CreateAttorney') {
            firmId  = parser.getText();
            System.debug('FIRM ID ============ ' + FirmID);
        }
        if(parser.getCurrentName() == 'CRM_FirmID' && operationName == 'UpdateAttorney') {
            firmId  = parser.getText();
            System.debug('FIRM ID ============ ' + FirmID);
        }
        if(parser.getCurrentName() == 'AttorneyAssistantID' && operationName == 'CreateAttorneyAssistant') {firmId  = parser.getText();
            System.debug('FIRM ID ============ ' + FirmID);
        }
        
        if(parser.getCurrentName() == 'AttorneyAssistantID ' && operationName == 'UpdateAttorneyAssistant') {firmId  = parser.getText();
            System.debug('FIRM ID ============ ' + FirmID);
        }
        if(parser.getCurrentName() == 'CRM_OpportunityID' && operationName == 'CreateCase') {firmId  = parser.getText();
            System.debug('FIRM ID ============ ' + FirmID);
        }
      }
    }
   return firmId;
  }
  
  @testvisible private static String getCashTraxFirmId(String jsonResponsePayload) {
    String firmId = '' ;
    if(jsonResponsePayload != null) {
    //String JSONContent = 'Contains input request submitted to cashtrax{"ZipCode":"110088","Website":"www.googleparent.com","State":"Alabama","PhoneNumber":null,"HeadQuarter":1,"FirmName":"Zaring, Alan","FirmID":0,"CRM_FirmID":"0014B00000eQDXdQAO","City":"Delhi","Address2":"Suite 100","Address1":"10 South Main Street"}';
    Integer inde = jsonResponsePayload.indexOf('{');
    System.debug('PRINT THE VALUE === ' + inde);
    String jsonVal = jsonResponsePayload.subString(inde);
    system.debug('PRINT THE NEW JSON == ' + jsonVal);

    JSONParser parser = JSON.createParser(jsonVal);
    while (parser.nextToken() != null) {
        System.debug('Current token: ' +    parser.getCurrentToken());
        System.debug('Current Name: ' +
            parser.getCurrentName());
        if(parser.getCurrentName() == 'CRM_FirmID') {
            firmId  = parser.getText();
            System.debug('FIRM ID ============ ' + FirmID);
        }
      }  
    }
   return firmId;
  }

}