/**
  * @Created Date 04/24/2019
  * @author    OASISFINANCIAL GROUP
  * @copyright Copyright (c) 2019-2020 
  * @license   
  * @Modified Date
  * @Description Sending request from salesforce to cashtrax
*/
public class PresetSalesforceToCasthraxController
{

private static Map<String,String> OperationMap = new Map<String,String>(); 

private static CommunicationCache ctxService = new CommunicationCache();
private static String SecurityToken='XXXX'; 
 



static {

    OperationMap.put('CreateFirm','/api/AttorneyFirm/AddFirmToCTX');
   OperationMap.put('UpdateFirm','/api/AttorneyFirm/UpdateFirmToCTX');
   OperationMap.put('CreateFirmLocation','/api/AttorneyFirm/AddFirmLocationToCTX');
   OperationMap.put('UpdateFirmLocation','/api/AttorneyFirm/UpdateFirmLocationToCTX');
   OperationMap.put('CreateAttorney','/api/AttorneyFirm/AddAttorneyToCTX');
   OperationMap.put('UpdateAttorney','/api/AttorneyFirm/UpdateAttorneyToCTX');
   OperationMap.put('CreateAttorneyAssistant','/api/AttorneyFirm/AddAttorneyAssistantToCTX');
   OperationMap.put('UpdateAttorneyAssistant','/api/AttorneyFirm/UpdateAttorneyAssistantToCTX');
   OperationMap.put('CreateCase','/api/Case/CreateCase');

}

/**
 * This method is used to sync with medilien and cashtrax.
 * @param Id accountId
 * @return String.
 * @exception Exception On input error.
 */
@auraEnabled
public static String SyncSystems(Id accountId)
{
    system.debug('------START-------->>'+accountId);
  String ret='';
    ret = PresetSyncSystems(accountId);
  
      //ret = MedlienSalesforceToSystemsController.MedlienSyncSystems(accountId);
  
  return ret; //'Successfully Updated';
}
/**
 * This method is used to sync with medilien and cashtrax.
 * @param Id accountId
 * @return String.
 * @exception Exception On input error.
 */
@auraEnabled
public static String SyncSystemsMedlien(Id accountId)
{
    system.debug('------START-------->>'+accountId);
  String ret='';
  //  ret = PresetSyncSystems(accountId);
  
      ret = MedlienSalesforceToSystemsController.MedlienSyncSystems(accountId);
  
  return ret; //'Successfully Updated';
}

/**
 * This method is make request to Preset Database.
 * @param String jsonRequest
 * @return String .
 * @exception Exception On input error.
 * @see 
*/
@auraEnabled
public static String PresetSyncSystems(Id accountId)
{
    
    String retMsg='',action='', err='';
  
  try{  
  

          List<Account> accList = [Select Id, ParentId, HeadQuarter__c,ParentFirm_CTXID__c, CTXFirmId__c, Name, Street2__c, BillingStreet, BillingCity, BillingState, BillingPostalCode, 
                                   BillingCountry,Phone, Fax,Website, RecordTypeId from Account where Id=:accountId and Type = 'LawFirm'];
                                 //  :Utility.getAccountRecTypeId('Attorney')];
  
          
          List<FirmData > toBeUpdatedLaterFirms  = new List<FirmData>();
          List<AttorneyData> toBeUpdatedLaterAttorneys  = new List<AttorneyData>();
          List<AttorneyAssistantData> toBeUpdatedLaterAttorneyAssitants  = new List<AttorneyAssistantData>();
           
          String ctxFirmId =null, ctxFirmLocationId=null;
          
          if(accList !=null && accList.size()>0 )
          {
          
                 Account acct = accList[0];
                  
                   if(acct.ParentId ==null)
                    {
                       if(!Test.isRunningTest())return 'Error:Current Account\'s Parent is Missing. Please create a parent account.';
                    }
              
                    if(String.isBlank(acct.BillingStreet) && String.isBlank(acct.BillingCity) &&  String.isBlank(acct.BillingState) && String.isBlank(acct.BillingPostalCode))
                    {
                        if(!Test.isRunningTest())return 'Error:Please fill Account Address Information';
                    }
                    
                    
                  
                     String sessionId = ctxService.login();
                     
                     if(test.isRunningTest()) { 
                     sessionId = UserInfo.getSessionId();
                    }
                  
                    if(sessionId ==null)
                    {
                       if(!Test.isRunningTest())return 'Error: There is some issue login to Cashtrax Service. Please talk to Administrator.';
                    }
              
                  
                  
                     ctxFirmLocationId = acct.CTXFirmId__c;
                     ctxFirmId = acct.ParentFirm_CTXID__c;
                     
                     system.debug('---0--ctxFirmLocationId,ctxFirmId--------'+ctxFirmLocationId+','+ctxFirmId);
                     //FirmLocation is not in Sync, create firmLocation, firm and attorney
                     if(String.isBlank(ctxFirmLocationId))
                     {
                       
                        //Check if the Parent Firm is in Sync
                        List<Account> accParentList = [Select Id, ParentId, HeadQuarter__c, CTXFirmId__c, Name, Street2__c, BillingStreet, BillingCity, BillingState, BillingPostalCode, 
                                                  BillingCountry,Phone, Fax, Website from Account where Id=:acct.ParentId];
                         
                        if(accParentList!=null && accParentList.size()>0)
                        {
                           Account parentAccount = accParentList[0];
                           ctxFirmId = parentAccount.CTXFirmId__c;
                           
                           //Parent account not in sync, create one in ctx
                           if(String.isBlank(ctxFirmId))
                           {
                                //Update Firm
                                SFEntities.Firm firm = CreateFirmCTX(parentAccount);
                                action = 'CreateFirm';
                                PSCommunicationCache__c cache = buildCache(action,JSON.serialize(firm),parentAccount.Id,'PS');
                                Map<String,Object> ctxResponse = sendToCache(cache,sessionId,'PS');
                               System.debug('@@ ctxResponse '+ctxResponse);
                              //  UpdateAccount(parentAccount,String.valueOf(ctxResponse.get('CTX_FirmID')));
                              if(ctxResponse!=null)
                              {
                                if(ctxResponse.get('StatusCode')==200){
                                  ctxFirmId = String.valueOf(ctxResponse.get('CTX_FirmID'));
                                }
                                FirmData fdata = new FirmData();
                                fdata.CTX_FirmId = ctxFirmId ;
                                fdata.cache = cache;
                                fdata.resp = ctxResponse;
                                fdata.acc = parentAccount;
                                fdata.HQ = true;
                                toBeUpdatedLaterFirms.add(fdata);
                                
                              }
                        
                           }
                        }
                        
                           if(ctxFirmId!=null)
                           {
                                //Create Firmlocation in cashtrax and Update FirmLocation in SF
                                SFEntities.FirmLocation firmLocation = CreateFirmLocationCTX(acct,ctxFirmId);
                                action = 'CreateFirmLocation';
                                PSCommunicationCache__c cache = buildCache(action,JSON.serialize(firmLocation),acct.Id,'PS');
                                Map<String,Object> ctxResponse = sendToCache(cache,sessionId,'PS');
                                //UpdateAccount(acct,String.valueOf(ctxResponse.get('CTX_FirmID')));
                                if(ctxResponse!=null)
                                {
                                system.debug('---------------->>'+ctxResponse);
                                  if(ctxResponse.get('StatusCode')==200){
                                    ctxFirmLocationId = String.valueOf(ctxResponse.get('CTX_FirmLocationID'));
                                  }
                                FirmData fdata = new FirmData();
                                fdata.CTX_FirmId = ctxFirmLocationId ;
                                fdata.cache = cache;
                                fdata.resp = ctxResponse;
                                fdata.HQ = false;
                                fdata.acc = acct;
                                toBeUpdatedLaterFirms.add(fdata);
                              }
                           }
                        
                        } //location not in sync
                  
                  
          
              //*****************Check all new Attorneys in custom obj  ************************/
             List<Account_Relation__c> accRelationList = [select Id, PresetID__c,Contact__c, Role__c,Account__c  from Account_Relation__c where  
                                                            Account__c = :acct.Id and Role__c='Attorney' ];//and PresetID__c = null
                                                            
             
             Map<Id,String> crmAttorneyCtxAttMap = new Map<Id,String>();
             
             system.debug('------1----ctxFirmLocationId------'+ctxFirmLocationId);
             
             if(accRelationList!=null && accRelationList.size()>0 )
             { 
             
               
                    if(ctxFirmLocationId !=null)
                    {
               
                      for(Account_Relation__c accRelation : accRelationList) 
                        {
                
                            //Need this here because we want the ctx attorney id for all attorneys for support contacts 
                            if(String.isBlank(accRelation.PresetID__c))
                            {
                                    //Create Attorney
                                    action = 'CreateAttorney';
                                    SFEntities.Attorney attorney = CreateAttorneyCTX(accRelation,ctxFirmId, ctxFirmLocationId);
                                    if(attorney!=null){  
                                         PSCommunicationCache__c cache = buildCache(action,JSON.serialize(attorney),accRelation.Contact__c, 'PS');
                                        Map<String,Object> ctxResponse= sendToCache(cache,sessionId,'PS');
                                       // UpdateAttorney(con,accRelation,String.valueOf(ctxResponse.get('CTX_AttorneyID')));
                                       if(ctxResponse!=null){
                                       AttorneyData attData = new AttorneyData();
                                       attData.relation = accRelation;
                                       //attData.cont = accRelation.Contact__c;
                                       attData.cache = cache;
                                       attData.resp = ctxResponse;
                                        if(ctxResponse.get('StatusCode')==200)
                                             attData.CTX_AttorneyID = String.valueOf(ctxResponse.get('CTX_AttorneyID'));
                                        else
                                             attData.CTX_AttorneyID='000';
                                                  
                                       toBeUpdatedLaterAttorneys.add(attData);
                                       
                                       crmAttorneyCtxAttMap.put(accRelation.Contact__c,String.valueOf(ctxResponse.get('CTX_AttorneyID')));
                                        
                                    } 
                                }
                            }else
                            {
                                crmAttorneyCtxAttMap.put(accRelation.Contact__c,accRelation.PresetID__c);
                                       
                            } 
                                
                         }//for    
                             
                            
                            //*****************Check all new Attorney Assistants in custom obj  ************************/ 
                            
                             system.debug('----------locationid------'+acct.Id);
                            //Check for Non-Attorneys too
                            List<Non_Attorney_Contact__c> supportList = [select Id, PresetID__c,Contact__c, Role__c, Firm_Name__c, Attorney__c  
                                                                         from Non_Attorney_Contact__c 
                                                                         where Firm_Name__c = :acct.Id and PresetID__c = null];
             
               
                            
                                
                            system.debug('------------------>>'+supportList+ '++++'+acct.id);
                            for(Non_Attorney_Contact__c supportRelation : supportList) 
                            {
                
                                    //Create Attorney Assistant
                                    action = 'CreateAttorneyAssistant';
                                    String ctxAttorneyId = crmAttorneyCtxAttMap.get(supportRelation.Attorney__c);
                                    system.debug('-----------ctxAttorneyId--------'+ctxAttorneyId);
                                    SFEntities.AttorneyAssistant attorneyasst = CreateAttorneyAssistantCTX(supportRelation,ctxAttorneyId,ctxFirmId, ctxFirmLocationId);
                                    if(attorneyasst!=null){  
                                   
                                        PSCommunicationCache__c cache = buildCache(action,JSON.serialize(attorneyasst),supportRelation.Contact__c, 'PS');
                                        Map<String,Object> ctxResponse= sendToCache(cache,sessionId,'PS');
                                    
                                       if(ctxResponse!=null){
                                       AttorneyAssistantData attData = new AttorneyAssistantData();
                                       attData.relation = supportRelation;
                                       attData.cache = cache;
                                       attData.resp = ctxResponse;
                                        if(ctxResponse.get('StatusCode')==200)
                                             attData.CTX_AttorneyAssistantID = String.valueOf(ctxResponse.get('CTX_AttorneyAssistantID'));
                                        else
                                            attData.CTX_AttorneyAssistantID ='000';
                                                   
                                       toBeUpdatedLaterAttorneyAssitants.add(attData); 
                                    } 
                                }
                         }//for    
                     
                             
                             
                             
                             
                    }//if
                }//accRelation  
                
                
                
              List<PSCommunicationCache__c> cacheToBeInsertedList = new List<PSCommunicationCache__c>();
              List<Account> accsToBeUpdated = new List<Account>();
              List<Account_Relation__c> contactRelsToBeUpdated = new List<Account_Relation__c>();
              List<Non_Attorney_Contact__c> nonattContactsToBeUpdated = new List<Non_Attorney_Contact__c>();
              
              //Update salesforce data here now
              for(FirmData fdata : toBeUpdatedLaterFirms) 
              {
                  Map<String,Object> resp = fdata.resp;
                  String status = String.valueOf(resp.get('Status'));
                  String firmId;
                 
                  
                  PSCommunicationCache__c  cache = fdata.cache;
                  cache.ResponseStatus__c = resp.get('StatusCode')+':'+status;
                  cache.ResponsePayload__c = JSON.serialize(resp);
                  
                  if(null==status || (!status.equalsIgnoreCase('Success')))
                  {
                    cache.IsError__c = true;
                    err='Error: There is some problem in Account Sync';
                  }
                  else
                  {
                      
                      if(fdata.HQ==true)
                        firmId  = String.valueOf(resp.get('CTX_FirmID'));
                      else  
                        firmId = String.valueOf(resp.get('CTX_FirmLocationID'));
                  }
                 
                   
                  Account acc = fdata.acc;
                  acc.CTXFirmId__c = firmId;
                  accsToBeUpdated.add(acc);
                 
                  cacheToBeInsertedList.add(cache); 
                 
                 
                  
               /*   //If status is not Success or OK , send email to admin
                  if(null==status || (!status.equalsIgnoreCase('Success')))
                  {
                    Utility.SendErrorEmail('SyncToBackendSystems',accountId, cache);
                  }
                 */ 
              }
              
              if(accsToBeUpdated.size()>0)
              {
                 update accsToBeUpdated;
              }
              
              //attorney
              for(AttorneyData att: toBeUpdatedLaterAttorneys)
              {
                
                  Map<String,Object> resp = att.resp;
                  String status = String.valueOf(resp.get('Status'));
                  String firmId='00'; 
                  
                  PSCommunicationCache__c  cache = att.cache;
                    cache.ResponseStatus__c = resp.get('StatusCode')+':'+status;
                  cache.ResponsePayload__c = JSON.serialize(resp);
                  
                  
                  if(null==status || (!status.equalsIgnoreCase('Success')))
                  {
                    cache.IsError__c = true;
                    err='Error: There is some problem in Attorney Contact Sync';
                  }
                 
             
                 //firmId = String.valueOf(resp.get('CTX_AttorneyID'));
                 Account_Relation__c rel = att.relation;
                 rel.PresetID__c = att.CTX_AttorneyID;
                 contactRelsToBeUpdated.add(rel);
                 
                 
                  cacheToBeInsertedList.add(cache); 
                 
              }
              
              
             
             
              if(contactRelsToBeUpdated.size()>0)
              {
                 update contactRelsToBeUpdated;
              }
              
              
              //Non attorney
              for(AttorneyAssistantData att: toBeUpdatedLaterAttorneyAssitants)
              {
              
                
                  Map<String,Object> resp = att.resp;
                  String status = String.valueOf(resp.get('Status'));
                 // String firmId = String.valueOf(resp.get('CTX_AttorneyAssistantID'));
                
                  PSCommunicationCache__c  cache = att.cache;
                  cache.ResponseStatus__c = resp.get('StatusCode')+':'+status;
                  cache.ResponsePayload__c = JSON.serialize(resp);
                  
                  
                  if(null==status || (!status.equalsIgnoreCase('Success')))
                  {
                    cache.IsError__c = true;
                    err='Error: There is some problem in Support Contact Sync';
                  }
                  
                  cacheToBeInsertedList.add(cache); 
             
              
                 Non_Attorney_Contact__c rel = att.relation;
                 rel.PresetID__c = Integer.valueOf(att.CTX_AttorneyAssistantID);
                 nonattContactsToBeUpdated.add(rel);
              }
              if(nonattContactsToBeUpdated.size()>0)
              {
                 update nonattContactsToBeUpdated;
              }
              
                                       
              if(cacheToBeInsertedList.size()>0)
              {
                  insert cacheToBeInsertedList;
              }                          
                                       
             // retMsg ='Data Successfully Posted to Cashtrax System. Posting to Backend Medlien System, is in Progress...';  
             if(String.IsBlank(err)){
                  retMsg ='Processing Medlien System, Please wait...';  
              }
              else
              { 
                 retMsg = err;
              }
          }// contactList
          else
          {
           retMsg = 'Processing. Please wait...';
          }
          
  
  }catch(Exception e)
  {
      System.debug('------Exception-----'+e.getMessage());
      retMsg = 'Error: Some issue posting data:'+e.getMessage();
  }
  
      return retMsg;  
}


/**
 * This method called from Contact to make a request to cashtrax database.
 * @param Id contactId
 * @return String.
 * @exception Exception On input error.
 */ 
@auraEnabled
public static String PushToCashtrax(Id contactId)
{
    
     String retMsg='',action='';
  
  try{  
            //Check for Attorney 
             List<Account_Relation__c> accRelationList = [select Id, PresetID__c,Contact__c, Account__c,Role__c  from Account_Relation__c where  
                                                               Contact__c = :contactId and Role__c='Attorney' and PresetID__c = null];
                
             if(accRelationList!=null && accRelationList.size()>0)
             {
                for(Account_Relation__c relation : accRelationList)
                {    
                    //commented on 26-May-2019
                    //SyncSystems(relation.Account__c);
                }
             }      
            
            
             //Check for Non-Attorneys too
             List<Non_Attorney_Contact__c> supportList = [select Id, PresetID__c,Contact__c, Role__c,Attorney__c,Firm_Name__c  
                                                          from Non_Attorney_Contact__c 
                                                          where Contact__c = :contactId and PresetID__c = null];
                     
             if(supportList!=null && supportList.size()>0)
             {
                for(Non_Attorney_Contact__c relation : supportList)
                {   
                                        //commented on 26-May-2019
                    //SyncSystems(relation.Firm_Name__c);
                }
             }      
            
            retMsg ='Data Successfully Posted to Server';
        
            
    }catch(Exception e)
    {
      System.debug('------Exception-----'+e.getMessage());
      retMsg = 'Some issue posting data:'+e.getMessage();
    }
  
      return retMsg;  
  
}

/**
 * This method is create quick add records.
 * @param String acase
 * @return 
 * @exception Exception On input error.
 * 
 */
@future(callout=true)
public static void createQuickAdd(String acase,Id oppId)
{    
     
     String sessionId = ctxService.login();
     if(test.isRunningTest()) { 
             sessionId = UserInfo.getSessionId();
     }
     
     if(sessionId==null)
     {
        return;
     }
     
     String action = 'CreateCase';
     
     //  Map<String,Object> ctxResponse= sendToCache(action,acase,sessionId, oppId,'PS');
      
      
            
          //Set HTTPRequest Method
          HttpRequest req = new HttpRequest();
          req.setMethod('POST');
          req.setHeader('content-type', 'application/json');
          req.setHeader('Content-Length', String.valueOf(acase.length()));
        
        
             req.setHeader('email',UserInfo.getUserEmail());
        
        
          
            req.setHeader('SessionID',sessionId);
           req.setEndpoint(ctxService.cashtraxEndPoint+OperationMap.get(action));
           system.debug('---------cashtraxEndPoint+operation----'+(ctxService.cashtraxEndPoint+action));     
       
       
          // setting body
          System.debug('Input Request:' + acase);
          req.setBody(acase);
          req.setTimeout(20000);
          //Execute web service call here     
          Http http = new Http();
          HTTPResponse res = http.send(req);
        
          //Helpful debug messages
          System.debug(res.toString());
          System.debug('STATUS:' + res.getStatus());
          System.debug('STATUS_CODE:' + res.getStatusCode());
          
       //build cache
          PSCommunicationCache__c  cache = buildCache(action,acase,oppId, 'PS');
      
        
       if (res.getStatusCode() == 200) {
                // Deserialize the JSON string into collections of primitive data types.
                //system.debug('-----res.getBody()---------'+res.getBody());
                 Map<String,Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                
        
          String status = String.valueOf(results.get('Status'));
        
         
          cache.ResponseStatus__c = results.get('StatusCode')+':'+status;
          cache.ResponsePayload__c = JSON.serialize(results);
          
                  
          if(null==status || (!status.equalsIgnoreCase('Success')))
          {
              cache.IsError__c = true;
              //err='Error: There is some problem in creating Quick Add';
          }
          else
          {
          
              String caseId = String.valueOf(results.get('CTX_CaseID'));
               system.debug('------------caseid-------------'+caseId);
               system.debug('------------oppId-------------'+oppId); 
               
              if(caseId!=null)
              {
                Opportunity opp = new Opportunity(Id = oppId);
                opp.Case_Number__c = Integer.valueOf(caseId);
                update opp;
              }
            }          
          
                                        
       }
       else
       {
       
       
          cache.ResponseStatus__c = res.getStatusCode()+':ERROR';
          cache.ResponsePayload__c = (res.getStatus());
         
       }
       insert cache;
       
}




     /**
     * This method is sending cache request.
     * @param PSCommunicationCache__c cache,String sessionId, String lob
     * @return Map<String,Object>
     * @exception Exception On input error.
     * @see 
    */
     @testVisible private static Map<String,Object> sendToCache( PSCommunicationCache__c cache,String sessionId, String lob)
     {
          Map<String, Object> results=null;
          
        //return ctxService.pushToCashtrax( cache, sessionId, lob);
        HTTPResponse  res= ctxService.doPost(sessionId,cache.Operation__c,cache.InputPayload__c,lob);
             if (res.getStatusCode() == 200) {
                // Deserialize the JSON string into collections of primitive data types.
                system.debug('-----res.getBody()---------'+res.getBody());
                results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                results.put('StatusCode',200);
              //  system.debug('-----------------'+results.get('CTX_CaseID'));
                
            }else
            {
                results = new Map<String,Object>();
                results.put('StatusCode', res.getStatusCode());
                results.put('Status','ERROR');
                results.put('RESPONSE',res.getStatus());
            }
      
      return results;  
     }
     
     /**
     * This method is build cache request.
     * @param String action, String payload,String objectId, String lob
     * @return PSCommunicationCache__c  
     * @exception Exception On input error.
     * @see 
    */
     @testVisible private static PSCommunicationCache__c  buildCache(String action, String payload,String objectId, String lob)
     {
     
         PSCommunicationCache__c cache = new PSCommunicationCache__c();
         cache.GenericName__c = action;
         cache.Operation__c = OperationMap.get(action);
         cache.InputPayload__c = payload;
         cache.LOB__c = lob;
         cache.ObjectId__c = objectId;
         
         return cache;
     }
 
     
     /**
     * For Opportunity ONLU
     * @param String action, String payload,String sessionId,String objectId, String lob
     * @return Map<String,Object>.
     * @exception Exception On input error.
     * @see 
    */
    /*
     @testVisible private static Map<String,Object> sendToCache(String action, String payload,String sessionId,String objectId, String lob)
     {
         PSCommunicationCache__c cache = new PSCommunicationCache__c();
         cache.GenericName__c = action;
         cache.Operation__c = OperationMap.get(action);
         cache.InputPayload__c = payload;
         cache.LOB__c = lob;
         cache.ObjectId__c = objectId;
         ctxService.pushToCashtrax( cache, sessionId,lob);
         
         insert cache;
         
         
       return null;
         
     }*/
     
 
    
    /**
     * This method is creating firm records.
     * @param Account act
     * @return SFEntities.Firm
     * @exception Exception On input error.
     * @see 
    */
    @testVisible private static SFEntities.Firm CreateFirmCTX(Account act) {
              SFEntities.Firm request    = new SFEntities.Firm();
              
               request.CRM_FirmID = act.Id;  
              // request.HeadQuarter = (act.HeadQuarter__c==true) ? 1 : 0;
               //keep it as ws needs it
               request.FirmID = 0; //(String.isNotBlank(act.CTXFirmId__c) ? Integer.valueOf(act.CTXFirmId__c) : null);
               request.FirmName =  act.Name;
               /*request.Address1 =String.valueOf(act.BillingStreet); 
               request.Address2 =act.Street2__c;
               request.City = act.BillingCity;
               request.State = act.BillingState;
               request.ZipCode = act.BillingPostalCode;
              */
               request.PhoneNumber = removeNull(act.Phone);
        	   request.PhoneNumber = request.PhoneNumber.replaceAll( '[^0-9]', '' );
        System.debug('@@ request.PhoneNumber 1 '+request.PhoneNumber);
                if(request.PhoneNumber.length()==11){
                 	request.PhoneNumber = request.PhoneNumber.substring(1, request.PhoneNumber.length() - 1);   
                }
         System.debug('@@ request.PhoneNumber 2 '+request.PhoneNumber);
               request.Fax = removeNull(act.Fax);
               request.Website = removeNull(act.Website);
            
          return request;      
     }
    
    /**
     * This method is creating firm location to cashtrax db.
     * @param Account act,String ctxFirmId
     * @return SFEntities.FirmLocation
     * @exception Exception On input error.
     * @see 
    */
    @testVisible private static SFEntities.FirmLocation CreateFirmLocationCTX(Account act,String ctxFirmId) {
              SFEntities.FirmLocation request    = new SFEntities.FirmLocation();
              
               request.CRM_FirmID = act.ParentId;  
               request.CRM_FirmLocationID = act.Id;  
               //request.HeadQuarter = (act.HeadQuarter__c==true) ? 1 : 0;
               request.FirmID =   Integer.valueOf(ctxFirmId); //String.IsNotBlank(act.ParentFirm_CTXID__c)? Integer.valueOf(act.ParentFirm_CTXID__c.trim()):0;
               //keep it as ws needs it
               request.FirmLocationID = 0;
              
               request.FirmLocationName =  act.Name;
               request.Address1 =removeNull(String.valueOf(act.BillingStreet)); 
               request.Address2 =removeNull(act.Street2__c);
               request.City = removeNull(act.BillingCity);
               request.State = removeNull(act.BillingState);
               request.ZipCode = removeNull(act.BillingPostalCode);
                  
          return request;      
     }
  
   /**
     * This method is creating attorney into Cashtrax db.
     * @param Account_Relation__c relation,String firmID,String firmLocationId
     * @return SFEntities.Attorney
     * @exception Exception On input error.
     * @see 
    */
   @testVisible private static SFEntities.Attorney CreateAttorneyCTX(Account_Relation__c relation,String firmID,String firmLocationId) 
   {
    
         List<Contact> contactList  = [Select Id,AccountId, Account.CTXFirmId__c, FirstName,LastName,MiddleName__c,MailingStreet,MailingStreet2__c, 
                                MailingCity,MailingState,MailingPostalCode,Phone,Fax,Email,BirthDate,ContactInstructions__c
                                from Contact where Id=: relation.Contact__c and accountId != null ];         
         if(contactList!=null && contactList.size()>0)
         {
            
            
              Contact cnt = contactList[0];
              
              SFEntities.Attorney request = new SFEntities.Attorney();
              
              request.CRM_FirmLocationId = relation.Account__c;
               request.CRM_AttorneyID = cnt.Id;  
               
               system.debug('------------firmid--------'+firmId+','+firmLocationId);
               request.FirmID = (String.isNotBlank(firmId))?Integer.valueOf(firmId):0;
               request.FirmLocationID = Integer.valueOf(firmLocationId);
               
               
               request.AttorneyID = 0;
               request.FirstName = removeNull(cnt.FirstName);
               request.LastName= removeNull(cnt.LastName);
           
               request.email = removeNull(cnt.Email);
               request.PhoneNumber = removeNull(cnt.Phone);
               request.PhoneNumber = request.PhoneNumber.replaceAll( '[^0-9]', '' );
               if(request.PhoneNumber.length()==11){
                 	request.PhoneNumber = request.PhoneNumber.substring(1, request.PhoneNumber.length() - 1);   
               }
               request.Fax = removeNull(cnt.Fax);
               request.Birthday = cnt.BirthDate;
               request.ContactInformation = removeNull(cnt.ContactInstructions__c);
            
               return request;
         }
         
         return null;        
     }
     
  
   /**
     * This method is creating attorney assistant into cashtrax db.
     * @param Non_Attorney_Contact__c relation,String attorneyId, String firmID,String firmLocationId
     * @return SFEntities.AttorneyAssistant
     * @exception Exception On input error.
     * @see 
    */  
   @testVisible private static SFEntities.AttorneyAssistant CreateAttorneyAssistantCTX(Non_Attorney_Contact__c relation,String attorneyId, String firmID,String firmLocationId) 
   {
    
         List<Contact> contactList  = [Select Id,AccountId, Account.CTXFirmId__c, FirstName,LastName,MiddleName__c,MailingStreet,MailingStreet2__c, 
                                MailingCity,MailingState,MailingPostalCode,Phone,Fax,Email,BirthDate,ContactInstructions__c
                                from Contact where Id=: relation.Contact__c and accountId != null ];    
                                     
         if(contactList!=null && contactList.size()>0)
         {
            
            
              Contact cnt = contactList[0];
              
              SFEntities.AttorneyAssistant request = new SFEntities.AttorneyAssistant();
              
               request.CRM_AttorneyAssistantID = cnt.Id;  
            //   request.FirmID = Integer.valueOf(firmId);
             //  request.FirmLocationID = Integer.valueOf(firmLocationId);
               request.AttorneyID = Integer.valueOf(attorneyId);
               request.AttorneyAssistantID = 0;
               
               request.Name = removeNull(cnt.FirstName)+ ' '+removeNull(cnt.LastName);
               request.AttorneyAssistantType = relation.Role__c;
               request.email = removeNull(cnt.Email);
               request.PhoneNumber = removeNull(cnt.Phone);
               request.PhoneNumber = request.PhoneNumber.replaceAll( '[^0-9]', '' );
               if(request.PhoneNumber.length()==11){
                 	request.PhoneNumber = request.PhoneNumber.substring(1, request.PhoneNumber.length() - 1);   
               }
               return request;
         }
         
         return null;        
     }
 
  //======================UPDATE SCENENARIOS =============================================
  
    
    
    
    /**
     * Called from Update trigger. In trigger, check of the CTX ID exists or not.Handles both Firm and FirmLocation Update
     * @param String jsonRequest
     * @return String .
     * @exception Exception On input error.
     * @see 
    */
    @future(callout=true)
    public static void  UpdateFirmCTX(Id accountId) {
        
         List<Account> accParentList = [Select Id, ParentId, HeadQuarter__c, CTXFirmId__c, Name, Street2__c, BillingStreet, BillingCity, BillingState, BillingPostalCode, 
                                                  BillingCountry,Phone, Fax, Website,ParentFirm_CTXID__c from Account where Id=:accountId];
                         
         if(accParentList!=null && accParentList.size()>0)
         {
            Account act = accParentList[0];
            
            if(Utility.IsNonZero(act.CTXFirmId__c))
            {
                
                //PARENT UPDATE 
                if(act.HeadQuarter__c ==true)
                {
                
                  SFEntities.Firm request    = new SFEntities.Firm();
                  request.CRM_FirmID = act.Id;  
                  // request.HeadQuarter = (act.HeadQuarter__c==true) ? 1 : 0;
                   
                   //keep it as ws needs it
                   request.FirmID = Integer.valueOf(act.CTXFirmId__c);
                   request.FirmName =  act.Name;
                   request.PhoneNumber = removeNull(act.Phone);
                   request.PhoneNumber = request.PhoneNumber.replaceAll( '[^0-9]', '' );
                   if(request.PhoneNumber.length()==11){
                 		request.PhoneNumber = request.PhoneNumber.substring(1, request.PhoneNumber.length() - 1);   
               		}
                   request.Fax = removeNull(act.Fax);
                   request.Website = removeNull(act.Website);
            
            
                    String sessionId = ctxService.login();
                    
                    if(sessionId==null)
                    {
                        if(!Test.isRunningTest())return;
                    }  
                    if(Test.isRunningTest()){
                        sessionId = UserInfo.getSessionId();
                    }  
                      
                      
                    String action = 'UpdateFirm';
                    PSCommunicationCache__c cache = buildCache(action,JSON.serialize(request),act.Id,'PS');
                    Map<String,Object> ctxResponse = sendToCache(cache,sessionId,'PS');
                    String ret='';
                    if(ctxResponse!=null)
                    {
                        ret = String.valueOf(ctxResponse.get('Status'));
                    }
                    cache.ResponseStatus__c = ctxResponse.get('StatusCode')+':'+ret;
                    cache.ResponsePayload__c = JSON.serialize(ctxResponse);
                    
                      if(null==ret || (!ret.equalsIgnoreCase('Success')))
                      {
                        cache.IsError__c = true;
                      }
                      
                    insert cache;
                }
                else  //Location Update
                {
            
                       SFEntities.FirmLocation request    = new SFEntities.FirmLocation();
                       request.CRM_FirmID = act.ParentId;  
                       request.CRM_FirmLocationID = act.Id;  
                       //request.HeadQuarter = (act.HeadQuarter__c==true) ? 1 : 0;
                       request.FirmID =   String.IsNotBlank(act.ParentFirm_CTXID__c)? Integer.valueOf(act.ParentFirm_CTXID__c.trim()):0;
                       //keep it as ws needs it
                       request.FirmLocationID = Integer.valueOf(act.CTXFirmId__c);
                      
                       request.FirmLocationName =  act.Name;
                       request.Address1 =removeNull(String.valueOf(act.BillingStreet)); 
                       request.Address2 =removeNull(act.Street2__c);
                       request.City = removeNull(act.BillingCity);
                       request.State = removeNull(act.BillingState);
                       request.ZipCode = removeNull(act.BillingPostalCode);
                       
            
                    String sessionId = ctxService.login();
                    if(sessionId==null)
                     {
                        return;
                     }
                
              
                    String action = 'UpdateFirmLocation';
                    PSCommunicationCache__c cache = buildCache(action,JSON.serialize(request),act.Id,'PS');
                    Map<String,Object> ctxResponse = sendToCache(cache,sessionId,'PS');
                    String ret='';
                    if(ctxResponse!=null)
                    {
                        ret = String.valueOf(ctxResponse.get('Status'));
                    }
                     cache.ResponseStatus__c = ctxResponse.get('StatusCode')+':'+ret;
                    cache.ResponsePayload__c = JSON.serialize(ctxResponse);
                    
                    
                      if(null==ret || (!ret.equalsIgnoreCase('Success')))
                      {
                        cache.IsError__c = true;
                      }
                  
                    insert cache;
            
                    
                }
                
                
                
            }
            else
            {
                //No action needed..its still a new account
                system.debug('CTX ID Missing .No action taken '+act);
            }
            
         }
     }
     
  
     
    /**
     * Called from Update trigger. In trigger, check of the CTX ID exists or not.Handles both Attorney and Non-Attorney Update
     * @param String jsonRequest
     * @return String .
     * @exception Exception On input error.
     * @see 
    */
    @future(callout=true)
    public static void  UpdateContactCTX(Id contactId) 
    {
        
        
        List<Contact> contactList  = [Select Id,AccountId, Account.CTXFirmId__c, FirstName,LastName,MiddleName__c,MailingStreet,MailingStreet2__c, 
                                     MailingCity,MailingState,MailingPostalCode,Phone,Fax,Email,BirthDate,ContactInstructions__c
                                    from Contact where Id= :contactId and accountId != null ];  
                                     
         if(contactList!=null && contactList.size()>0)
         {
         
             Contact cnt = contactList[0];
             
             //Check for Attorney 
             List<Account_Relation__c> accRelationList = [select Id, PresetID__c,Contact__c, Account__c,Account__r.CTXFirmId__c, Role__c  
                                                          from Account_Relation__c 
                                                          where Contact__c = :contactId and Role__c='Attorney' and PresetID__c != null];
                
             List<PSCommunicationCache__c>  cacheToBeInserted = new List<PSCommunicationCache__c>();
              
             if(accRelationList!=null && accRelationList.size()>0)
             {
                for(Account_Relation__c relation : accRelationList)
                {
                    PSCommunicationCache__c cache = UpdateAttorneyCTX(cnt,relation,String.valueOf(relation.Account__r.CTXFirmId__c));
                    cacheToBeInserted.add(cache);
                }
             }      
            
            
             //Check for Non-Attorneys too
             List<Non_Attorney_Contact__c> supportList = [select Id, PresetID__c,Contact__c, Role__c,Attorney__c, Firm_Name__c  
                                                          from Non_Attorney_Contact__c where  
                                                          Contact__c = :contactId and PresetID__c != null];
                     
             if(supportList!=null && supportList.size()>0)
             {
                for(Non_Attorney_Contact__c relation : supportList)
                {
                    PSCommunicationCache__c cache =UpdateAttorneyAssistantCTX(cnt,relation);
                    cacheToBeInserted.add(cache);
                }
             }      
        
            
            if(cacheToBeInserted.size()>0)
            {
                insert cacheToBeInserted;
            }
       }
    }   
    
    
    /**
     * Called from Non_Attorney_Contact Update trigger. In trigger, role is changeed and needs to be pushed to CTX
     * @param String 
     * @return String .
     * @exception Exception On input error.
     * @see 
    */
   /* 
    @future(callout=true)
    public static void  UpdateContactCTX(Id contactId, Id nonAttorneyRelationId) 
    {
        List<Contact> contactList  = [Select Id,AccountId, Account.CTXFirmId__c, FirstName,LastName,MiddleName__c,MailingStreet,MailingStreet2__c, 
                                     MailingCity,MailingState,MailingPostalCode,Phone,Fax,Email,BirthDate,ContactInstructions__c
                                    from Contact where Id= :contactId and accountId != null ];  
         
         
         List<PSCommunicationCache__c>  cacheToBeInserted = new List<PSCommunicationCache__c>();                            
         if(contactList!=null && contactList.size()>0)
         {
         
             Contact cnt = contactList[0];
        
            
             //Check for Non-Attorneys too
             List<Non_Attorney_Contact__c> supportList = [select Id, PresetID__c,Contact__c, Role__c,Attorney__c, Firm_Name__c  
                                                          from Non_Attorney_Contact__c where  
                                                          Id = :nonAttorneyRelationId and PresetID__c != null];
                     
             if(supportList!=null && supportList.size()>0)
             {
                 PSCommunicationCache__c cache =UpdateAttorneyAssistantCTX(cnt,supportList[0]);
                 cacheToBeInserted.add(cache);
                    
                    if(cacheToBeInserted.size()>0)
                    {
                        insert cacheToBeInserted;
                    }
             }
         }
    }   
    */
      
      /**
     * This method is updating attorney assistant into cashtrax db.
     * @param Contact cnt,Non_Attorney_Contact__c relation
     * @return PSCommunicationCache__c 
     * @exception Exception On input error.
     * @see 
    */
      @testVisible private static PSCommunicationCache__c UpdateAttorneyAssistantCTX(Contact cnt,Non_Attorney_Contact__c relation) {
    
               SFEntities.AttorneyAssistant request = new SFEntities.AttorneyAssistant();
              
               request.CRM_FirmID = '0'; 
               request.CRM_FirmLocationID = relation.Firm_Name__c;  
               request.CRM_AttorneyAssistantID = cnt.Id;  
               
            
                //Get Attorney CTX ID from relation
                List<Account_Relation__c> accRelationList = [select Id, PresetID__c,Contact__c, Account__c,Role__c  
                                                             from Account_Relation__c 
                                                             where Contact__c = :relation.Attorney__c and Role__c='Attorney' 
                                                             and Account__c = :relation.Firm_Name__c and PresetID__c != null];
            
                if(accRelationList!=null && accRelationList.size()>0)
                {
                    request.AttorneyID= Integer.valueOf(accRelationList[0].PresetID__c);    
                }
                else
                {
                    system.debug('------preset id does not exists for attorney');
                }
                   
               //request.FirmLocationID = Integer.valueOf(cnt.Account.CTXFirmId__c);
               
               //request.AttorneyID= Integer.valueOf(attorneyId);
               
               request.AttorneyAssistantID = Integer.valueOf(relation.PresetID__c);
            
               request.Name = removeNull(cnt.FirstName)+ ' '+removeNull(cnt.LastName);
               request.AttorneyAssistantType = relation.Role__c;
               request.email = removeNull(cnt.Email);
               request.PhoneNumber = removeNull(cnt.Phone);
               request.PhoneNumber = request.PhoneNumber.replaceAll( '[^0-9]', '' );
               if(request.PhoneNumber.length()==11){
                 	request.PhoneNumber = request.PhoneNumber.substring(1, request.PhoneNumber.length() - 1);   
               }
               String sessionId = ctxService.login();
                    String action = 'UpdateAttorneyAssistant';
                    PSCommunicationCache__c cache = buildCache(action,JSON.serialize(request),cnt.Id,'PS');
               
               if(sessionId==null)
               {
                    cache.ResponseStatus__c = '400'+':ERROR';
                    cache.ResponsePayload__c = 'Login Failed';
                    return cache;
               }               
               
               
               
                    Map<String,Object> ctxResponse = sendToCache(cache,sessionId,'PS');
          			
                    String ret='';
                    if(ctxResponse!=null)
                    {
                        ret = String.valueOf(ctxResponse.get('Status'));
                    }
                     cache.ResponseStatus__c = ctxResponse.get('StatusCode')+':'+ret;
                    cache.ResponsePayload__c = JSON.serialize(ctxResponse);
          			
                     if(null==ret || (!ret.equalsIgnoreCase('Success')))
                     {
                        cache.IsError__c = true;
                     }
                      
                    return cache;
                  
     }
  
        /**
         * This method is updating the attorney records into cashtrax db
         * @param Contact cnt,Account_Relation__c relation,String firmLocationId
         * @return PSCommunicationCache__c 
         * @exception Exception On input error.
         * @see 
        */
        @testVisible private static PSCommunicationCache__c UpdateAttorneyCTX(Contact cnt,Account_Relation__c relation,String firmLocationId) {
    
              
               SFEntities.Attorney request = new SFEntities.Attorney();
              
               request.CRM_FirmLocationID = relation.Account__c;  
               request.CRM_AttorneyID = cnt.Id;  
               
               request.FirmID = 0;//Integer.valueOf(cnt.Account.CTXFirmId__c);
               request.FirmLocationID = Integer.valueOf(firmLocationId);
               
               request.AttorneyID = Integer.valueOf(relation.PresetID__c);
            
               request.FirstName = removeNull(cnt.FirstName);
               request.LastName= removeNull(cnt.LastName);
               request.email = removeNull(cnt.Email);
               request.PhoneNumber = removeNull(cnt.Phone);
           	   request.PhoneNumber = request.PhoneNumber.replaceAll( '[^0-9]', '' );
            	if(request.PhoneNumber.length()==11){
                 	request.PhoneNumber = request.PhoneNumber.substring(1, request.PhoneNumber.length() - 1);   
                }
               request.Fax = removeNull(cnt.Fax);
               request.Birthday = cnt.BirthDate;
               request.ContactInformation = removeNull(cnt.ContactInstructions__c);
            
               String sessionId = ctxService.login();
              
                    String action = 'UpdateAttorney';
                    PSCommunicationCache__c cache = buildCache(action,JSON.serialize(request),cnt.Id,'PS');
                    
                    
                        
                   if(sessionId==null)
                   {
                        cache.ResponseStatus__c = '400'+':ERROR';
                        cache.ResponsePayload__c = 'Login Failed';
                        return cache;
                   }               
                    
                    
                    Map<String,Object> ctxResponse = sendToCache(cache,sessionId,'PS');
            		System.debug('@@ ctxResponse '+JSON.serialize(ctxResponse));
                    String ret='';
                    if(ctxResponse!=null)
                    {
                        ret = String.valueOf(ctxResponse.get('Status'));
                    }
                     cache.ResponseStatus__c = ctxResponse.get('StatusCode')+':'+ret;
                    cache.ResponsePayload__c = JSON.serialize(ctxResponse);
                    
                     if(null==ret || (!ret.equalsIgnoreCase('Success')))
                     {
                        cache.IsError__c = true;
                     }
                      
                    return cache;
                  
     }
     
     
  
    @future(callout=true)
     public static void wolfPackAttorney(Id oppId, Id contactId)
     {
        Opportunity opp = new Opportunity(id=oppId);
        opp.Attorney__c = contactId;
            update opp;
     }
  
  //===============================================================================================  
    
  public class AttorneyData {
     
      public String CTX_AttorneyID{set;get;} 
  //    public Id cont { get;set; }
      public Account_Relation__c relation {get;set; }
      public PSCommunicationCache__c cache {get;set;}
      public Map<String,Object> resp {get;set;}
  }
 
  public class AttorneyAssistantData {
     
      public String CTX_AttorneyAssistantID{set;get;} 
    //  public Id attorney { get;set; }  //attorney
    //  public Id accId { get;set; }  //firm location
    //  public Id cont { get;set; }  //contact assistant
      public Non_Attorney_Contact__c relation {get;set; }
      public PSCommunicationCache__c cache {get;set;}
      public Map<String,Object> resp {get;set;}
  
  
  }
 public class FirmData {
 
  public String CTX_FirmId { get;set; }
  public Account acc { get;set; }
  public boolean HQ { get;set; }
  public PSCommunicationCache__c cache {get;set;}
  public Map<String,Object> resp {get;set;}
  
 
 }
 
  @testVisible private static String removeNull(String str)
   {
      //return (str==null)?'':str.trim(); 
      system.debug('------>'+str);
      return (String.isBlank(str))?'':str.trim(); 
   } 
    
}