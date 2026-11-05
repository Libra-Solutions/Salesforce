/**
  * @Created Date 04/24/2019
  * @author    OASISFINANCIAL GROUP
  * @copyright Copyright (c) 2019-2020 
  * @license   
  * @Modified Date
  * @Description 
*/
public class MedlienSalesforceToSystemsController {


private static Map<String,String> MLOperationMap = new Map<String,String>(); 

private static CommunicationCache ctxService = new CommunicationCache();

 
public MedlienSalesforceToSystemsController(){}


static {


   MLOperationMap.put('CreateFirm','/api/CreateFirm');
   MLOperationMap.put('UpdateFirm','/api/UpdateFirm');
   MLOperationMap.put('CreateFirmLocation','/api/CreateFirmLocation');
   MLOperationMap.put('UpdateFirmLocation','/api/UpdateFirmLocation');
   MLOperationMap.put('CreateContact','/api/CreateContact');
   MLOperationMap.put('UpdateContact','/api/UpdateContact');

}



/**
 * Called from Opportunity trigger when it is closed-won
 * @param Id accountId
 * @return 
 * @exception Exception On input error.
 * @see 
*/

@future(callout=true)
public static void MedlienSyncSystemsForProvider(Id accountId)
{
    MedlienSyncSystems(accountId,true);
}


//Called from Flow
@InvocableMethod
public static void MedlienSyncSystemsForProviderManaulUpload(List<Id> accountIds)
{

  if(accountIds.size()>0)
  {
    MedlienSyncSystems(accountIds.get(0),true);
  }
    
}




/**
 * This method is called from Sync button
 * @param Id accountId
 * @return String
 * @exception Exception On input error.
 * @see 
*/
public static String MedlienSyncSystems(Id accountId)
{   
/* 
      String userIds='';
       boolean authorisedUser=false;
       for (IntegrationSettings__mdt cashTraxDEndPoint : [select Id, MasterLabel, DeveloperName, Override_Sync_Button_Users__c From IntegrationSettings__mdt]){
           userIds= cashTraxDEndPoint.Override_Sync_Button_Users__c;
       }
   
     if(String.IsNotBlank(userIds)){
        
        if(userIds.contains(','))
        {
           for(String s : userIds.split(','))
           {
              Id userId = UserInfo.getUserId();
              if(userId== (Id)s)
              {
                authorisedUser = true;
                break;
              }
           }
        }
        
     }
     
     system.debug('--------------authorisedUser---------'+authorisedUser+','+userIds);
   */
   return MedlienSyncSystems(accountId,false);
}

/**
 * This method is for syncing the data to medlien db
 * @param Id accountId
 * @return String
 * @exception Exception On input error.
 * @see 
*/
public static String MedlienSyncSystems(Id accountId, boolean oppFlag)
{    
    System.debug('--------------- '+ accountId);
    String retMsg='',action='', err='';
  
  try{  
  

          List<Account> accList = [Select Id, ParentId, HeadQuarter__c,GRSId__c, KeyMedsID__c,AtticusId__c,
                                    ParentFirm_KeyMedsID__c,ParentFirm_AtticusId__c, ParentFirm_GRSID__c,
                                    Name, Street2__c, BillingStreet, BillingCity, BillingState, BillingPostalCode, 
                                   BillingCountry,Phone, Fax,Website, Type ,Contracted__c,
                                   Atticus__c,Accident_Meds__c,Core__c,GRS__c,PreSet__c
                                   //Tax_Id_Number__c,Start_Date__c,NPI__c,Legal_Name__c,Billing_name__c,Billing_address__c,
                                   // Billing_city__c,Billing_state__c,Billing_zip__c,W9_1099_name__c,W9_1099_address__c,
                                   // W9_1099_city__c,W9_1099_state__c,W9_1099_zip__c
                                   from Account where Id=:accountId];
  
          
          List<FirmData> toBeUpdatedLaterFirms  = new List<FirmData>();
          List<ContactData> toBeUpdatedLaterAttorneys  = new List<ContactData>();
          List<ContactAssttData> toBeUpdatedLaterAttorneyAssitants  = new List<ContactAssttData>();
           
          String keyMedsId=null,atticusId=null,grsId=null;
          String firmLocationKeyMedsId=null,firmLocationAtticusId=null,firmLocationGrsId=null;
          
          if(accList !=null && accList.size()>0 )
          {
          
              
                   Account acct = accList[0];
                   if(acct.ParentId ==null)
                    {
                       if(!Test.isRunningTest())return 'Current Account\'s Parent is Missing. If this is a HQ, Please go to the Account Location.';
                    }
                    if(String.isBlank(acct.BillingStreet) && String.isBlank(acct.BillingCity) &&  String.isBlank(acct.BillingState) && String.isBlank(acct.BillingPostalCode))
                    {
                        if(!Test.isRunningTest())return 'Please fill Account Address Information';
                    }
                   
                  
                     // firmLocationKeyMedsId = String.valueOf(acct.KeyMedsID__c);
                     // firmLocationAtticusId = String.valueOf(acct.AtticusId__c);
                     // firmLocationGrsId = String.valueOf(acct.GRSId__c);
                     firmLocationKeyMedsId = (String.valueOf(acct.KeyMedsID__c) != NULL ||  String.valueOf(acct.KeyMedsID__c) != 'NULL') ? String.valueOf(acct.KeyMedsID__c) : '' ;
                     firmLocationAtticusId = (String.valueOf(acct.AtticusId__c) != NULL ||  String.valueOf(acct.AtticusId__c) != 'NULL') ? String.valueOf(acct.AtticusId__c) : '' ;
                     firmLocationGrsId = (String.valueOf(acct.GRSId__c) != NULL ||  String.valueOf(acct.GRSId__c) != 'NULL') ? String.valueOf(acct.GRSId__c) : '' ;
                     
                     system.debug('-------flids----------'+firmLocationKeyMedsId +','+firmLocationAtticusId +','+firmLocationGrsId );
                     
                  boolean passFlagA=false,passFlagB=false;
                     
                     if(oppFlag==false)
                     {     
             
              
                         // if atleast one Id is populated , allow it
                         if((Utility.IsNonZero(firmLocationKeyMedsId) || Utility.IsNonZero(firmLocationAtticusId) || Utility.IsNonZero(firmLocationGrsId)))
                         {
                            passFlagA=true;
                         }
                         
                          // allow only if it is not lawfirm ;  or contracted is checked but id's not populated
                          if( acct.Type.contains('LawFirm') || ( (acct.Contracted__c ==true && 
                             ((Utility.IsBlank(firmLocationKeyMedsId) && Utility.IsBlank(firmLocationAtticusId) && Utility.IsBlank(firmLocationGrsId)))
                             
                              )))
                           {
                              passFlagB=true;
                           }
                         
                         
                         if(passFlagA==false && passFlagB==false)
                         {
                           if(!Test.isRunningTest())return 'This Provider Location has not been contracted yet, hence cannot send to Backend System';
                         }
                     
                    }        
                    String sessionId = ctxService.loginML();
                
              
                     keyMedsId=String.valueOf(acct.ParentFirm_KeyMedsID__c);
                     atticusId=String.valueOf(acct.ParentFirm_AtticusID__c);
                     grsId=String.valueOf(acct.ParentFirm_GRSID__c);
                     
                     
                     system.debug('-------fids----------'+keyMedsId +','+atticusId +','+grsId );
                     
                     //FirmLocation is not in Sync, create firmLocation, firm and contact
                     if((Utility.IsBlank(firmLocationKeyMedsId) && Utility.IsBlank(firmLocationAtticusId) && Utility.IsBlank(firmLocationGrsId)))
                     {
                       
                        //Check if the Parent Firm is in Sync
                        List<Account> accParentList = [Select Id, ParentId, HeadQuarter__c,GRSId__c, KeyMedsID__c,AtticusId__c,
                                                    Name, Street2__c, BillingStreet, BillingCity, BillingState, BillingPostalCode, 
                                                    BillingCountry,Phone, Fax,Website, Type
                                                    //Tax_Id_Number__c,Start_Date__c,NPI__c,Legal_Name__c,Billing_name__c,Billing_address__c,
                                                    //Billing_city__c,Billing_state__c,Billing_zip__c,W9_1099_name__c,W9_1099_address__c,
                                                    //W9_1099_city__c,W9_1099_state__c,W9_1099_zip__c
                                                    from Account where Id=:acct.ParentId];
  
  
                        if(accParentList!=null && accParentList.size()>0)
                        {
                           Account parentAccount = accParentList[0];
    
                   
                             keyMedsId = String.valueOf(parentAccount.KeyMedsID__c);
                             atticusId = String.valueOf(parentAccount.AtticusId__c);
                             grsId = String.valueOf(parentAccount.GRSId__c);
                           
                           
                           //Parent account not in sync, create one in ml
                          if((Utility.IsBlank(keyMedsId) && Utility.IsBlank(atticusId) && Utility.IsBlank(grsId)))
                           {
                                //Add Firm
                                MedlienEntities.SFFirm firm = CreateFirmML(parentAccount,acct);
                                action = 'CreateFirm';
                                PSCommunicationCache__c cache = buildCache(action,JSON.serialize(firm),parentAccount.Id,'ML');
                                Map<String,Object> ctxResponse = sendToCache(cache,sessionId,'ML');
                             
                                  if(ctxResponse!=null)
                                  {
                                    
                                    FirmData fdata = new FirmData();
                                    if(ctxResponse.get('StatusCode')==200){
                                    
                                    keyMedsId = String.valueOf(ctxResponse.get('FirmID_KM'));
                                    atticusId = String.valueOf(ctxResponse.get('FirmID_AT'));
                                    grsId = String.valueOf(ctxResponse.get('FirmID_GL'));
                                    
                                    
                                    fdata.FirmID_KM = (keyMedsId!=null)? Integer.valueOf(keyMedsId):null;
                                    fdata.FirmID_AT = atticusId;
                                    fdata.FirmID_GL = (grsId!=null)? Integer.valueOf(grsId):null;
                                    }
                                    fdata.cache = cache;
                                    fdata.resp = ctxResponse;
                                    fdata.acc = parentAccount;
                                    fdata.HQ = true;
                                    toBeUpdatedLaterFirms.add(fdata);
                                    
                                  }
                        
                           }
                        }
                        
                        system.debug('-------flids compare----------'+keyMedsId +','+firmLocationKeyMedsId+ '|'+atticusId +','+ firmLocationAtticusId + '|' + grsId + ',' + firmLocationGrsId);
                       //  if(Utility.IsNonZero(keyMedsId) || Utility.IsNonZero(atticusId) || Utility.IsNonZero(grsId))
                       //  Only create a firm location if needed - we have a parent without a Location
                         if( 
                                ( Utility.IsNonZero(keyMedsId) && Utility.IsBlank( firmLocationKeyMedsId ) ) || 
                                ( Utility.IsNonZero(atticusId) && Utility.IsBlank(firmLocationAtticusId) ) || 
                                ( Utility.IsNonZero(grsId) && Utility.IsBlank(firmLocationGrsId) )
                            )
                           {
                                //Create Firmlocation in cashtrax and Update FirmLocation in SF
                                MedlienEntities.SFFirmLocation firmLocation = CreateFirmLocationML(acct,keyMedsId,atticusId,grsId);
                                action = 'CreateFirmLocation';
                                PSCommunicationCache__c cache = buildCache(action,JSON.serialize(firmLocation),acct.Id,'ML');
                                Map<String,Object> ctxResponse = sendToCache(cache,sessionId,'ML');
                               
                                if(ctxResponse!=null)
                                {
                               
                                    FirmData fdata = new FirmData();
                                    if(ctxResponse.get('StatusCode')==200){
                                   
                                        firmLocationKeyMedsId = String.valueOf(ctxResponse.get('FirmID_KM'));
                                        firmLocationAtticusId = String.valueOf(ctxResponse.get('FirmID_AT'));
                                        firmLocationGrsId = String.valueOf(ctxResponse.get('FirmID_GL'));
                                       
                                       
                                        fdata.FirmID_KM = (firmLocationKeyMedsId!=null)? Integer.valueOf(firmLocationKeyMedsId):null;
                                        fdata.FirmID_AT = firmLocationAtticusId;
                                        fdata.FirmID_GL = (firmLocationGrsId!=null)? Integer.valueOf(firmLocationGrsId):null;
                                      } 
                                    fdata.cache = cache;
                                    fdata.resp = ctxResponse;
                                    fdata.HQ = false;
                                    fdata.acc = acct;
                                    toBeUpdatedLaterFirms.add(fdata);
                              }
                           }
          
                        
                        
                      } //location not in sync
                  
                  
                  
            //*****************Check all new Attorneys in custom obj  ************************/
             List<Account_Relation__c> accRelationList = [select Id, GRSId__c, KeyMedsID__c,AtticusId__c,Contact__c, Role__c,Account__c  
             from Account_Relation__c 
             where  Account__c = :acct.Id and Role__c IN ('Attorney','Physician') ];
                                                            
             
             Map<Id,String> crmAttorneyCtxAttMap = new Map<Id,String>();
             
             system.debug('------1----firmLocationKeyMedsId------'+firmLocationKeyMedsId+'---att---'+accRelationList.size());
             
             if(accRelationList!=null && accRelationList.size()>0 )
             { 
                     
                    //if firm location is synced 
                    if( Utility.IsNonZero(firmLocationKeyMedsId) || Utility.IsNonZero(firmLocationAtticusId) || Utility.IsNonZero(firmLocationGrsId))
                    {
               
                      for(Account_Relation__c accRelation : accRelationList) 
                      {
                
                            //Need this here because we want the ctx attorney id for all attorneys for support contacts 
                            if(Utility.isBlank(accRelation.KeyMedsID__c) && Utility.isBlank(accRelation.AtticusID__c) && Utility.isBlank(accRelation.GRSId__c))
                            {
                                    //Create Attorney
                                    action = 'CreateContact';
                                    MedlienEntities.SFContact attorney = CreateContactML(accRelation,accRelation.Role__c,firmLocationKeyMedsId,firmLocationAtticusId, firmLocationGRSId);
                                    if(attorney!=null)
                                    {   
                                        PSCommunicationCache__c cache = buildCache(action,JSON.serialize(attorney),accRelation.Contact__c, 'ML');
                                        Map<String,Object> ctxResponse= sendToCache(cache,sessionId,'ML');
                                       
                                       if(ctxResponse!=null)
                                       {
                                           ContactData attData = new ContactData();
                                           attData.relation = accRelation;
                                           attData.cache = cache;
                                           attData.resp = ctxResponse;
                                          
                                           if(ctxResponse.get('StatusCode')==200){
                                   
                                           attData.ContactID_KM  = (String.valueOf(ctxResponse.get('ContactID_KM'))!=null)? Integer.valueOf(String.valueOf(ctxResponse.get('ContactID_KM'))):null;
                                           attData.ContactID_AT = String.valueOf(ctxResponse.get('ContactID_AT'));
                                           attData.ContactID_GL = (String.valueOf(ctxResponse.get('ContactID_GL'))!=null)? Integer.valueOf(String.valueOf(ctxResponse.get('ContactID_GL'))):null;
                                           }
                                           
                                           toBeUpdatedLaterAttorneys.add(attData);
                                           
                                           //crmAttorneyCtxAttMap.put(accRelation.Contact__c,String.valueOf(ctxResponse.get('CTX_AttorneyID')));
                                            
                                       } 
                                    }
                            }
                            else
                            {
                                //crmAttorneyCtxAttMap.put(accRelation.Contact__c,accRelation.PresetID__c);
                                       
                            } 
                                
                         }//for 
                       }
                    }   
                    
                            //*****************Check all new Attorney Assistants in custom obj  ************************/ 
                            
                             system.debug('----------locationid------'+acct.Id);
                            //Check for Non-Attorneys too
                            List<Non_Attorney_Contact__c> supportList = [select Id,  GRSId__c, KeyMedsID__c,AtticusId__c,Contact__c, Role__c,Attorney__c, Firm_Name__c  
                                                                         from Non_Attorney_Contact__c 
                                                                         where Firm_Name__c = :acct.Id and  ((GRSId__c=null or GRSId__c=0) and (KeyMedsID__c = null or KeyMedsID__c = 0)  and (AtticusId__c = null or AtticusId__c='0'))];
             
               
                            for(Non_Attorney_Contact__c supportRelation : supportList) 
                            {
                
                                    //Create Attorney Assistant
                                    action = 'CreateContact';
                                   // String ctxAttorneyId = crmAttorneyCtxAttMap.get(supportRelation.Attorney__c);
                                    MedlienEntities.SFContact attorneyasst = CreateContactAssttML(supportRelation,supportRelation.Role__c,firmLocationKeyMedsId,firmLocationAtticusId, firmLocationGRSId);
                                    if(attorneyasst!=null){  
                                   
                                        PSCommunicationCache__c cache = buildCache(action,JSON.serialize(attorneyasst),supportRelation.Contact__c, 'ML');
                                        Map<String,Object> ctxResponse= sendToCache(cache,sessionId,'ML');
                                    
                                       if(ctxResponse!=null)
                                       {
                                           ContactAssttData attData = new ContactAssttData();
                                           attData.relation = supportRelation;
                                           attData.cache = cache;
                                           attData.resp = ctxResponse;
                                           if(ctxResponse.get('StatusCode')==200){
                                               attData.ContactID_KM  = (String.valueOf(ctxResponse.get('ContactID_KM'))!=null)? Integer.valueOf(String.valueOf(ctxResponse.get('ContactID_KM'))):null;
                                               attData.ContactID_AT = String.valueOf(ctxResponse.get('ContactID_AT'));
                                               attData.ContactID_GL = (String.valueOf(ctxResponse.get('ContactID_GL'))!=null)? Integer.valueOf(String.valueOf(ctxResponse.get('ContactID_GL'))):null;
                                            }
                                           toBeUpdatedLaterAttorneyAssitants.add(attData);
                                           
                                           //crmAttorneyCtxAttMap.put(accRelation.Contact__c,String.valueOf(ctxResponse.get('CTX_AttorneyID')));
                                            
                                       } 
                                    }
                                }//for    
                  
                  
                  
          
         }//if acclist
                
                
                
              List<PSCommunicationCache__c> cacheToBeInsertedList = new List<PSCommunicationCache__c>();
              List<Account> accsToBeUpdated = new List<Account>();
              List<Account_Relation__c> contactRelsToBeUpdated = new List<Account_Relation__c>();
              List<Non_Attorney_Contact__c> nonattContactsToBeUpdated = new List<Non_Attorney_Contact__c>();
              
              //Update salesforce data here now
              for(FirmData fdata : toBeUpdatedLaterFirms) 
              {
                  Map<String,Object> resp = fdata.resp;
                  String status = String.valueOf(resp.get('Status'));
                  
                  PSCommunicationCache__c  cache = fdata.cache;
                  cache.ResponseStatus__c = resp.get('StatusCode')+':'+status;
                  cache.ResponsePayload__c = JSON.serialize(resp);
                  
                  if(null==status || (!status.equalsIgnoreCase('Ok')))
                  {
                    cache.IsError__c = true;
                    err='Error: There is some problem in Account Sync';
                  }
                  else{

                      String firmID_KM = String.valueOf(resp.get('FirmID_KM'));
                      String firmID_AT = String.valueOf(resp.get('FirmID_AT'));
                      String firmID_GL = String.valueOf(resp.get('FirmID_GL'));
                    
                       
                      Account acc = fdata.acc;
                      acc.KeyMedsID__c = (String.IsNotBlank(firmID_KM))?Integer.valueOf(firmID_KM):null;
                      acc.AtticusId__c = (String.IsNotBlank(firmID_AT))?(firmID_AT):null;
                      acc.GRSId__c = (String.IsNotBlank(firmID_GL))?Integer.valueOf(firmID_GL):null;
                      
                      system.debug('---------------acc------------'+acc);
                      
                      accsToBeUpdated.add(acc);
                  }
                  
                  
                  cacheToBeInsertedList.add(cache); 
              }
              
              
                  
              if(accsToBeUpdated.size()>0)
              {
                 update accsToBeUpdated;
              }
              
              
              //attorney
              for(ContactData att: toBeUpdatedLaterAttorneys)
              {
                
                  Map<String,Object> resp = att.resp;
                  String status = String.valueOf(resp.get('Status'));
                  
                  
                  PSCommunicationCache__c  cache = att.cache;
                  cache.ResponseStatus__c = resp.get('StatusCode')+':'+status;
                  cache.ResponsePayload__c = JSON.serialize(resp);
                  
                  
                  if(null==status || (!status.equalsIgnoreCase('Ok')))
                  {
                    cache.IsError__c = true;
                    err='Error: There is some problem in Attorney Contact Sync';
                  }
                 else
                 {     
                    
                    String contactID_KM = String.valueOf(resp.get('ContactID_KM'));
                    String contactID_AT = String.valueOf(resp.get('ContactID_AT'));
                    String contactID_GL = String.valueOf(resp.get('ContactID_GL'));
                      
                     Account_Relation__c rel = att.relation;
                     rel.KeyMedsID__c =contactID_KM;
                     rel.AtticusId__c =contactID_AT;
                     rel.GRSId__c =contactID_GL;
                     
                     contactRelsToBeUpdated.add(rel);
                  }

                 cacheToBeInsertedList.add(cache); 
             
              }
           
             
              if(contactRelsToBeUpdated.size()>0)
              {
                 update contactRelsToBeUpdated;
              }
              
              //Non attorney
              for(ContactAssttData att: toBeUpdatedLaterAttorneyAssitants)
              {
                      Map<String,Object> resp = att.resp;
                      String status = String.valueOf(resp.get('Status'));
                      
                          
                          PSCommunicationCache__c  cache = att.cache;
                          cache.ResponseStatus__c = resp.get('StatusCode')+':'+status;
                          cache.ResponsePayload__c = JSON.serialize(resp);
                  
                          if(null==status || (!status.equalsIgnoreCase('Ok')))
                          {
                            cache.IsError__c = true;
                            err='Error: There is some problem in Support Contact Sync';
                          }
                          else
                          {           
                         
                              String contactID_KM = String.valueOf(resp.get('ContactID_KM'));
                              String contactID_AT = String.valueOf(resp.get('ContactID_AT'));
                              String contactID_GL = String.valueOf(resp.get('ContactID_GL'));
                     
                            
                             Non_Attorney_Contact__c rel = att.relation;
                             rel.KeyMedsID__c = (contactID_KM!=null)? Integer.valueOf(contactID_KM):null;
                             rel.AtticusId__c =contactID_AT;
                             rel.GRSId__c =(contactID_GL!=null)? Integer.valueOf(contactID_GL):null;
                             nonattContactsToBeUpdated.add(rel);
                          }
                         
                          cacheToBeInsertedList.add(cache); 
                     
              }
              
              if(nonattContactsToBeUpdated.size()>0)
              {
                 update nonattContactsToBeUpdated;
              }
                              
              
              if(cacheToBeInsertedList.size()>0)
              {
                  insert cacheToBeInsertedList;
              }
              
              if(String.isBlank(err))
              {
                  retMsg ='Data Successfully Posted to all Backend Systems.'; 
              }
              else
              {
                retMsg = err;
              } 
    //  }// contactList
    
 }
 catch(Exception e)
 {
      System.debug('------Exception-----'+e.getMessage());
      retMsg = 'Some issue posting ML data:'+e.getMessage();
 }
  
      return retMsg;  
}

/**
 * This method is pust the data to medlien
 * @param Id accountId
 * @return String
 * @exception Exception On input error.
 * @see 
*/
@auraEnabled
public static String PushToMedlien(Id contactId)
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
                    MedlienSyncSystems(relation.Account__c);
                }
             }      
            
            
             //Check for Non-Attorneys too
             List<Non_Attorney_Contact__c> supportList = [select Id, PresetID__c,Contact__c, Role__c,Attorney__c,Firm_Name__c  from Non_Attorney_Contact__c where  
                                                           Contact__c = :contactId and PresetID__c = null];
                     
             if(supportList!=null && supportList.size()>0)
             {
                for(Non_Attorney_Contact__c relation : supportList)
                {
                    MedlienSyncSystems(relation.Firm_Name__c);
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

 
     @testvisible private static Map<String,Object> sendToCache( PSCommunicationCache__c cache,String sessionId,String lob)
     {
         
        return ctxService.pushToCashtrax( cache, sessionId, lob);
     }
    
     @testvisible private static PSCommunicationCache__c  buildCache(String action, String payload,Id objectId , String lob)
     {
     
         PSCommunicationCache__c cache = new PSCommunicationCache__c();
         cache.GenericName__c = action;
         cache.Operation__c = MLOperationMap.get(action);
         cache.InputPayload__c = payload;
         cache.LOB__c = lob;
         cache.ObjectId__c = objectId;
         return cache;
     }
 /*
     private static Map<String,Object> sendToCache(String action, String payload,String sessionId)
     {
         PSCommunicationCache__c cache = new PSCommunicationCache__c();
         cache.GenericName__c = action;
         cache.Operation__c = OperationMap.get(action);
         cache.InputPayload__c = payload;
         
         ctxService.pushToCashtrax( cache, sessionId);
         
         insert cache;
         
         
       return null;
         
     }
   */  
 
    /**
     * This method is creating firm ml records into medlient db
     * @param Account act
     * @return MedlienEntities.SFFirm
     * @exception Exception On input error.
     * @see 
    */
    @testvisible private static MedlienEntities.SFFirm CreateFirmML(Account act, Account location) {
               MedlienEntities.SFFirm request    = new MedlienEntities.SFFirm();
              
               request.CRM_FirmID = act.Id;  
               request.HeadQuarter = true;
               
               //keep it as ws needs it
               request.FirmName =  act.Name;
               request.Address1 =String.valueOf(act.BillingStreet); 
               request.Address2 =act.Street2__c;
               request.City = act.BillingCity;
               request.State = act.BillingState;
               request.ZipCode = act.BillingPostalCode;
              
               request.PhoneNumber = removeNull(act.Phone);
               request.Fax = removeNull(act.Fax);
               request.Website = removeNull(act.Website);
               request.Type = (removeNull(act.Type).equalsIgnoreCase('LawFirm')) ? 'Payer' : 'Vendor';
            
            
                
               request.Preset = location.PreSet__c;
               request.Core = location.Core__c;
               request.Atticus= location.Atticus__c;
               request.AccidentMeds = location.Accident_Meds__c;
               request.GRS = location.GRS__c;
                           
               
            
          return request;      
     }
    
    /**
     * This method is creating firm location ml records into medlient db
     * @param Account act,String keyMedsId, String atticusId, String grsId
     * @return MedlienEntities.SFFirmLocation
     * @exception Exception On input error.
     * @see 
    */
    @testvisible private static MedlienEntities.SFFirmLocation CreateFirmLocationML(Account act,String keyMedsId, String atticusId, String grsId) {
              
               MedlienEntities.SFFirmLocation request    = new MedlienEntities.SFFirmLocation();
              
               request.CRM_ParentFirmID = act.ParentId;  
               request.HeadQuarter = false;
             
               request.CRM_FirmID = act.Id;  
               
               request.ParentFirmID_KM =   (keyMedsId!=null)?Integer.valueOf(keyMedsId):0; 
               request.ParentFirmID_AT =  atticusId; 
               request.ParentFirmID_GL =   (grsId!=null) ?Integer.valueOf(grsId):0; 
               
               
               //keep it as ws needs it
               //request.FirmLocationID = 0;
              
               request.FirmName =  act.Name;
               request.Address1 =removeNull(String.valueOf(act.BillingStreet)); 
               request.Address2 =removeNull(act.Street2__c);
               request.City = removeNull(act.BillingCity);
               request.State = removeNull(act.BillingState);
               request.ZipCode = removeNull(act.BillingPostalCode);
               request.PhoneNumber = removeNull(act.Phone);
               request.Fax = removeNull(act.Fax);
          
               request.Preset = act.PreSet__c;
               request.Core = act.Core__c;
               request.Atticus= act.Atticus__c;
               request.AccidentMeds = act.Accident_Meds__c;
               request.GRS = act.GRS__c;
                           
               
               request.Type = (removeNull(act.Type).equalsIgnoreCase('LawFirm')) ? 'PayerLocation' : 'VendorLocation';
              return request;  
                  
        
     }
  
    @testvisible private static MedlienEntities.SFContact CreateContactML(Account_Relation__c relation,String ptype,String firmLocationKeyMedsId,String firmLocationAtticusId, String firmLocationGRSId)
     {
    
              MedlienEntities.SFContact request = null;//new MedlienEntities.SFContact();
              
              List<Contact> contactList  = [Select Id,AccountId, Account.HeadQuarter__c, Account.Type, Account.CTXFirmId__c, FirstName,
                                            LastName,MiddleName__c,MailingStreet,MailingStreet2__c, 
                                            MailingCity,MailingState,MailingPostalCode,Phone,Fax,Email,BirthDate,ContactInstructions__c,
                                            Salutation, IsActive__c,
                                            Preferred_Contact_Phone__c,Preferred_Contact_Fax__c,Preferred_Contact_Email__c,DoNotCall,HasOptedOutOfFax,
                                            HasOptedOutOfEmail,Atticus__c,GRS__c,PreSet__c,Core__c,Accident_Meds__c
                                            from Contact where Id=: relation.Contact__c and accountId != null
                                            and (Atticus__c=true or GRS__c=true or Core__c=true or Accident_Meds__c=true)];    
                                     
                 if(contactList!=null && contactList.size()>0)
                 {
                    
                    request = new MedlienEntities.SFContact();
                      Contact cnt = contactList[0];
                      
                    
                      
                            request.CRM_FirmLocationId = relation.Account__c;
                            request.CRM_ContactID = cnt.Id;
                        
                           request.FirmLocationID_KM = (firmLocationKeyMedsId!=null)?Integer.valueOf(firmLocationKeyMedsId):0;
                           request.FirmLocationID_AT = (firmLocationAtticusId);
                           request.FirmLocationID_GL = (firmLocationGRSId!=null)?Integer.valueOf(firmLocationGRSId):0;
                           
                           
                           request.FirstName = removeNull(cnt.FirstName);
                           request.LastName= removeNull(cnt.LastName);
                           request.email = removeNull(cnt.Email);
                           request.PhoneNumber = removeNull(cnt.Phone);
                           request.Fax = removeNull(cnt.Fax);
                           request.Birthday = cnt.BirthDate;
                           request.ContactInformation = removeNull(cnt.ContactInstructions__c);
                           request.Type = ptype;
                          
                           request.PreferredContactPhone = cnt.Preferred_Contact_Phone__c;
                           request.PreferredContactFax = cnt.Preferred_Contact_Fax__c;
                           request.PreferredContactEmail = cnt.Preferred_Contact_Email__c;
                        
                           request.DoNotContactPhone = cnt.DoNotCall;
                           request.DoNotContactFax = cnt.HasOptedOutOfFax;
                           request.DoNotContactEmail = cnt.HasOptedOutOfEmail;
                           request.IsActive = cnt.IsActive__c;
                           request.Suffix = removeNull(cnt.Salutation);
                           
                           boolean HQ = cnt.Account.HeadQuarter__c;
                           
                           request.CRM_FirmType = (removeNull(cnt.Account.Type).equalsIgnoreCase('LawFirm')) ? 
                                                        ((HQ==true)?'Payer' : 'PayerLocation') : 
                                                        ((HQ==true)?'Vendor' : 'VendorLocation');
                           
                                       
                           request.Preset = cnt.PreSet__c;
                           request.Core = cnt.Core__c;
                           request.Atticus= cnt.Atticus__c;
                           request.AccidentMeds = cnt.Accident_Meds__c;
                           request.GRS = cnt.GRS__c;
                                       
                           
               
                 }
          return request;      
     }
    
    /**
     * This method is creating contact assistant ml records into medlient db
     * @param Non_Attorney_Contact__c relation,String ptype,String firmLocationKeyMedsId,String firmLocationAtticusId, String firmLocationGRSId
     * @return MedlienEntities.SFContact
     * @exception Exception On input error.
     * @see 
    */
    @testvisible private static MedlienEntities.SFContact CreateContactAssttML(Non_Attorney_Contact__c relation,String ptype,String firmLocationKeyMedsId,String firmLocationAtticusId, String firmLocationGRSId)
    {
    
              MedlienEntities.SFContact request = null; //new MedlienEntities.SFContact();
    
             system.debug('--------Asst Relation------'+relation);          
             List<Contact> contactList  = [Select Id,AccountId, Account.HeadQuarter__c, Account.Type, Account.CTXFirmId__c, FirstName,LastName,MiddleName__c,MailingStreet,MailingStreet2__c, 
                                MailingCity,MailingState,MailingPostalCode,Phone,Fax,Email,BirthDate,ContactInstructions__c,
                                Salutation, IsActive__c,Atticus__c,GRS__c,PreSet__c,Core__c,Accident_Meds__c,
                                Preferred_Contact_Phone__c,Preferred_Contact_Fax__c,Preferred_Contact_Email__c,DoNotCall,HasOptedOutOfFax,HasOptedOutOfEmail
                                from Contact where Id=: relation.Contact__c and accountId != null 
                                and (Atticus__c=true or GRS__c=true or Core__c=true or Accident_Meds__c=true)];    
                                     
                 if(contactList!=null && contactList.size()>0)
                 {
                    
                    request = new MedlienEntities.SFContact();
                    
                      Contact cnt = contactList[0];
                      
                           request.CRM_FirmLocationId = relation.Firm_Name__c;
                           request.CRM_ContactID = cnt.Id;
                        
                           request.FirmLocationID_KM = (firmLocationKeyMedsId!=null)?Integer.valueOf(firmLocationKeyMedsId):0;
                           request.FirmLocationID_AT = (firmLocationAtticusId);
                           request.FirmLocationID_GL = (firmLocationGRSId!=null)?Integer.valueOf(firmLocationGRSId):0;
                           
                           request.FirstName = removeNull(cnt.FirstName);
                           request.LastName= removeNull(cnt.LastName);
                           request.email = removeNull(cnt.Email);
                           request.PhoneNumber = removeNull(cnt.Phone);
                           request.Fax = removeNull(cnt.Fax);
                           request.Birthday = cnt.BirthDate;
                           request.ContactInformation = removeNull(cnt.ContactInstructions__c);
                           request.Type = ptype;
                          
                           request.PreferredContactPhone = cnt.Preferred_Contact_Phone__c;
                           request.PreferredContactFax = cnt.Preferred_Contact_Fax__c;
                           request.PreferredContactEmail = cnt.Preferred_Contact_Email__c;
                        
                           request.DoNotContactPhone = cnt.DoNotCall;
                           request.DoNotContactFax = cnt.HasOptedOutOfFax;
                           request.DoNotContactEmail = cnt.HasOptedOutOfEmail;
                           request.IsActive = cnt.IsActive__c;
                           
                           request.Suffix = removeNull(cnt.Salutation);
                           
                           boolean HQ = cnt.Account.HeadQuarter__c;
                           
                           request.CRM_FirmType = (removeNull(cnt.Account.Type).equalsIgnoreCase('LawFirm')) ? 
                                                        ((HQ==true)?'Payer' : 'PayerLocation') : 
                                                        ((HQ==true)?'Vendor' : 'VendorLocation');
                         
                         
                          request.Preset = cnt.PreSet__c;
                           request.Core = cnt.Core__c;
                           request.Atticus= cnt.Atticus__c;
                           request.AccidentMeds = cnt.Accident_Meds__c;
                           request.GRS = cnt.GRS__c;
                           
                 }
                 
          return request;      
     }
    
   //======================UPDATE SCENENARIOS =============================================
  
    
    
    /**
     * Called from Update trigger. In trigger, check of the ML ID exists or not.
     * @param Id accountId
     * @return 
     * @exception Exception On input error.
     * @see 
    */
    @future(callout=true)
    public static void  UpdateFirmML(Id accountId,boolean flagLOBUpdate) {
        
         List<Account> accParentList = [Select Id, ParentId, HeadQuarter__c, GRSId__c, KeyMedsID__c,AtticusId__c,
                                    ParentFirm_KeyMedsID__c,ParentFirm_AtticusId__c, ParentFirm_GRSID__c, Name, 
                                    Street2__c, BillingStreet, BillingCity, BillingState, BillingPostalCode, 
                                    BillingCountry,Phone, Fax, Website,ParentFirm_CTXID__c ,Type,
                                    Atticus__c,GRS__c,PreSet__c,Core__c,Accident_Meds__c
                                    //Tax_Id_Number__c,Start_Date__c,NPI__c,Legal_Name__c,Billing_name__c,Billing_address__c,
                                    //Billing_city__c,Billing_state__c,Billing_zip__c,W9_1099_name__c,W9_1099_address__c,
                                    //W9_1099_city__c,W9_1099_state__c,W9_1099_zip__c

                                    from Account where Id=:accountId];
                         
           List<PSCommunicationCache__c> cacheToBeInsertedList = new List<PSCommunicationCache__c>();
           List<Account> accsToBeUpdated = new List<Account>();
           
           String FirmID_KM='0';
           String FirmID_GL='0';
           String FirmID_AT=null;                  
                         
         if(accParentList!=null && accParentList.size()>0)
         {
            Account act = accParentList[0];
            
            if(Utility.IsNonZero(String.valueOf(act.KeyMedsID__c)) || Utility.IsNonZero(act.AtticusId__c) || Utility.IsNonZero(String.valueOf(act.GRSId__c)))
            {
                
                String sessionId = ctxService.loginML();
              
                FirmID_KM = String.valueOf(act.ParentFirm_KeyMedsID__c);
                FirmID_GL = String.valueOf(act.ParentFirm_GRSID__c);
                FirmID_AT = act.ParentFirm_AtticusId__c;
              
                system.debug('------accids----------'+FirmID_KM +','+FirmID_GL+','+FirmID_AT );
                
                //PARENT UPDATE or LOB is updated
                if(act.HeadQuarter__c ==true)// || flagLOBUpdate==true)
                {
                
                  MedlienEntities.SFFirm request    = new MedlienEntities.SFFirm();
                  request.CRM_FirmID = act.Id;  
                  request.HeadQuarter =  true;
                   
                   //keep it as ws needs it
                   request.FirmID_KM = (act.KeyMedsID__c!=null)?Integer.valueOf(act.KeyMedsID__c):0;
                   request.FirmID_AT = (act.AtticusId__c);
                   request.FirmID_GL = (act.GRSId__c!=null)?Integer.valueOf(act.GRSId__c):0;
                   
               
                   request.FirmName =  act.Name;
                   request.Address1 =String.valueOf(act.BillingStreet); 
                   request.Address2 =act.Street2__c;
                   request.City = act.BillingCity;
                   request.State = act.BillingState;
                   request.ZipCode = act.BillingPostalCode;
                  
                   request.PhoneNumber = removeNull(act.Phone);
                   request.Fax = removeNull(act.Fax);
                   request.Website = removeNull(act.Website);
                   request.Type = (removeNull(act.Type).equalsIgnoreCase('LawFirm')) ? 'Payer' : 'Vendor';
            
                       request.Preset = act.PreSet__c;
                       request.Core = act.Core__c;
                       request.Atticus= act.Atticus__c;
                       request.AccidentMeds = act.Accident_Meds__c;
                       request.GRS = act.GRS__c;
                                   
                
                    String action = 'UpdateFirm';
                    PSCommunicationCache__c cache = buildCache(action,JSON.serialize(request),act.Id,'ML');
                    Map<String,Object> ctxResponse = sendToCache(cache,sessionId,'ML');
                    String ret='';
                    if(ctxResponse!=null)
                    {
                        ret = String.valueOf(ctxResponse.get('Status'));
                    }
                    cache.ResponseStatus__c = ctxResponse.get('StatusCode')+':'+ret;
                    cache.ResponsePayload__c = JSON.serialize(ctxResponse);
                    
                    if(null==ret || (!ret.equalsIgnoreCase('Ok')))
                    {
                       cache.IsError__c = true;
                       //err='Error: There is some problem in Firm Sync';
 
                    }
                    
                    else
                    {
                    
                           firmID_KM = String.valueOf(ctxResponse.get('FirmID_KM'));
                           firmID_AT = String.valueOf(ctxResponse.get('FirmID_AT'));
                           firmID_GL = String.valueOf(ctxResponse.get('FirmID_GL'));
                          
                          Account acc = new Account(Id= act.Id);
                          if(Utility.IsNonZero(firmID_KM)) acc.KeyMedsID__c = (String.IsNotBlank(firmID_KM))?Integer.valueOf(firmID_KM):null;
                          if(Utility.IsNonZero(firmID_AT)) acc.AtticusId__c = (String.IsNotBlank(firmID_AT))?(firmID_AT):null;
                          if(Utility.IsNonZero(firmID_GL)) acc.GRSId__c = (String.IsNotBlank(firmID_GL))?Integer.valueOf(firmID_GL):null;
                          
                          //update only for vendor
                          if(act.Type.startsWith('Vendor')){
                             accsToBeUpdated.add(acc); 
                          }
                    }
                  
                    cacheToBeInsertedList.add(cache); 
                    //insert cache;
                    
                    //===========================================================================
                    if(flagLOBUpdate==true)
                    {
                       //update locations
                       
                       
                       List<Account> accList = [Select Id, ParentId, HeadQuarter__c, GRSId__c, KeyMedsID__c,AtticusId__c,
                                                ParentFirm_KeyMedsID__c,ParentFirm_AtticusId__c, ParentFirm_GRSID__c, Name, 
                                                Street2__c, BillingStreet, BillingCity, BillingState, BillingPostalCode, 
                                                BillingCountry,Phone, Fax, Website,ParentFirm_CTXID__c ,Type,
                                                Atticus__c,GRS__c,PreSet__c,Core__c,Accident_Meds__c
                                                //,Start_Date__c,NPI__c,Legal_Name__c,Billing_name__c,Billing_address__c,
                                                //Billing_city__c,Billing_state__c,Billing_zip__c,W9_1099_name__c,W9_1099_address__c,
                                                //W9_1099_city__c,W9_1099_state__c,W9_1099_zip__c
                                                from Account where HeadQuarter__c=false and ParentId = :act.Id];
                                   
                              for(Account acc: accList)
                              {
                                  if(acc.Core__c==true && Utility.IsBlank(String.valueOf(acc.KeyMedsID__c)) || 
                                     acc.Atticus__c==true && Utility.IsBlank(acc.AtticusId__c) ||
                                     acc.GRS__c==true && Utility.IsBlank(String.valueOf(acc.GRSId__c)))
                                     {
            
                                        //--------------UPDATE FIRM LOCATION--------------                         
                                                  
                                                   MedlienEntities.SFFirmLocation request2    = new MedlienEntities.SFFirmLocation();
              
                                                   request2.CRM_ParentFirmID = acc.ParentId;  
                                                   request2.HeadQuarter = false;
                                                 
                                                   request2.CRM_FirmID = acc.Id;  
                                                   
                                                   request2.FirmID_KM =   ((acc.KeyMedsID__c)!=null)?Integer.valueOf(acc.KeyMedsID__c):0; 
                                                   request2.FirmID_AT =  acc.AtticusId__c; 
                                                   request2.FirmID_GL =    ((acc.GRSID__c)!=null)?Integer.valueOf(acc.GRSID__c):0; 
                                               
                                               
                                                   request2.ParentFirmID_KM =  Utility.IsNonZero(FirmID_KM) ? Integer.valueOf(FirmID_KM):0; 
                                                   request2.ParentFirmID_AT =  FirmID_AT ; 
                                                   request2.ParentFirmID_GL =  Utility.IsNonZero(firmID_GL) ? Integer.valueOf(FirmID_GL):0; 
                                               
                                                   
                                                   request2.FirmName =  acc.Name;
                                                   request2.Address1 =removeNull(String.valueOf(acc.BillingStreet)); 
                                                   request2.Address2 =removeNull(acc.Street2__c);
                                                   request2.City = removeNull(acc.BillingCity);
                                                   request2.State = removeNull(acc.BillingState);
                                                   request2.ZipCode = removeNull(acc.BillingPostalCode);
                                                   request2.PhoneNumber = removeNull(acc.Phone);
                                                   request2.Fax = removeNull(acc.Fax);
                                                       
                                                   request2.Type = (removeNull(acc.Type).equalsIgnoreCase('LawFirm')) ? 'PayerLocation' : 'VendorLocation';
                                                   
                                                   request2.Preset = acc.PreSet__c;
                                                   request2.Core = acc.Core__c;
                                                   request2.Atticus= acc.Atticus__c;
                                                   request2.AccidentMeds = acc.Accident_Meds__c;
                                                   request2.GRS = acc.GRS__c;
                                                               
                                            
                                                  //  String sessionId = ctxService.loginML();
                                              
                                                    String action2 = 'UpdateFirmLocation';
                                                    PSCommunicationCache__c cache2 = buildCache(action2,JSON.serialize(request2),acc.Id,'ML');
                                                    Map<String,Object> ctxResponse2 = sendToCache(cache2,sessionId,'ML');
                                                    String ret2='';
                                                    if(ctxResponse2!=null)
                                                    {
                                                        ret2 = String.valueOf(ctxResponse2.get('Status'));
                                                    }
                                                    cache2.ResponseStatus__c = ctxResponse2.get('StatusCode')+':'+ret2;
                                                    cache2.ResponsePayload__c = JSON.serialize(ctxResponse2);
                                                    
                                                    if(null==ret2 || (!ret2.equalsIgnoreCase('Ok')))
                                                    {
                                                       cache2.IsError__c = true;
                                                       //err='Error: There is some problem in Firm Sync';
                                 
                                                    }
                                                    else
                                                    {
                                                    
                                                          String firmLocationID_KM = String.valueOf(ctxResponse2.get('FirmID_KM'));
                                                          String firmLocationID_AT = String.valueOf(ctxResponse2.get('FirmID_AT'));
                                                          String firmLocationID_GL = String.valueOf(ctxResponse2.get('FirmID_GL'));
                                                          
                                                          Account lacc = acc;
                                                          if(Utility.IsNonZero(firmLocationID_KM)) lacc.KeyMedsID__c = (String.IsNotBlank(firmLocationID_KM))?Integer.valueOf(firmLocationID_KM):0;
                                                          if(Utility.IsNonZero(firmLocationID_AT)) lacc.AtticusId__c = (String.IsNotBlank(firmLocationID_AT))?(firmLocationID_AT):null;
                                                          if(Utility.IsNonZero(firmLocationID_GL)) lacc.GRSId__c = (String.IsNotBlank(firmLocationID_GL))?Integer.valueOf(firmLocationID_GL):0;
                                                            
                                                          //update only for vendor
                                                          if(acc.Type.startsWith('Vendor')){
                                                             accsToBeUpdated.add(lacc); 
                                                          }  
                                                                                          
                                                           
                                                    }
                                              
                                                cacheToBeInsertedList.add(cache2); 
                                                //insert cache;
                                                
                                                
                                            }
                                                  
                                                  
                                                  
                                       //==========================================================           
                                     } //for
                                  
                                  
                              }
                        
                    } //HQ
                    
                    
                  
                 //Location Update
                 if(act.HeadQuarter__c ==false)// || flagLOBUpdate==true)
                {
            
                       MedlienEntities.SFFirmLocation request    = new MedlienEntities.SFFirmLocation();
              
                       request.CRM_ParentFirmID = act.ParentId;  
                       request.HeadQuarter = false;
                     
                       request.CRM_FirmID = act.Id;  
                       
                       request.FirmID_KM =   ((act.KeyMedsID__c)!=null)?Integer.valueOf(act.KeyMedsID__c):0; 
                       request.FirmID_AT =  act.AtticusId__c; 
                       request.FirmID_GL =    ((act.GRSID__c)!=null)?Integer.valueOf(act.GRSID__c):0; 
                   
                   
                       request.ParentFirmID_KM =  Utility.IsNonZero(FirmID_KM) ? Integer.valueOf(FirmID_KM):0; 
                       request.ParentFirmID_AT =  FirmID_AT ; 
                       request.ParentFirmID_GL =  Utility.IsNonZero(firmID_GL) ? Integer.valueOf(FirmID_GL):0; 
                   
                       
                       request.FirmName =  act.Name;
                       request.Address1 =removeNull(String.valueOf(act.BillingStreet)); 
                       request.Address2 =removeNull(act.Street2__c);
                       request.City = removeNull(act.BillingCity);
                       request.State = removeNull(act.BillingState);
                       request.ZipCode = removeNull(act.BillingPostalCode);
                       request.PhoneNumber = removeNull(act.Phone);
                       request.Fax = removeNull(act.Fax);
                           
                       request.Type = (removeNull(act.Type).equalsIgnoreCase('LawFirm')) ? 'PayerLocation' : 'VendorLocation';
                       
                       request.Preset = act.PreSet__c;
                       request.Core = act.Core__c;
                       request.Atticus= act.Atticus__c;
                       request.AccidentMeds = act.Accident_Meds__c;
                       request.GRS = act.GRS__c;
                                   
            
                  //  String sessionId = ctxService.loginML();
              
                    String action = 'UpdateFirmLocation';
                    PSCommunicationCache__c cache = buildCache(action,JSON.serialize(request),act.Id,'ML');
                    Map<String,Object> ctxResponse = sendToCache(cache,sessionId,'ML');
                    String ret='';
                    if(ctxResponse!=null)
                    {
                        ret = String.valueOf(ctxResponse.get('Status'));
                    }
                     cache.ResponseStatus__c = ctxResponse.get('StatusCode')+':'+ret;
                    cache.ResponsePayload__c = JSON.serialize(ctxResponse);
                    
                    if(null==ret || (!ret.equalsIgnoreCase('Ok')))
                    {
                       cache.IsError__c = true;
                       //err='Error: There is some problem in Firm Sync';
 
                    }
                    else
                    {
                    
                          String firmLocationID_KM = String.valueOf(ctxResponse.get('FirmID_KM'));
                          String firmLocationID_AT = String.valueOf(ctxResponse.get('FirmID_AT'));
                          String firmLocationID_GL = String.valueOf(ctxResponse.get('FirmID_GL'));
                          
                          Account acc = act;
                          if(Utility.IsNonZero(firmLocationID_KM)) acc.KeyMedsID__c = (String.IsNotBlank(firmLocationID_KM))?Integer.valueOf(firmLocationID_KM):0;
                          if(Utility.IsNonZero(firmLocationID_AT)) acc.AtticusId__c = (String.IsNotBlank(firmLocationID_AT))?(firmLocationID_AT):null;
                          if(Utility.IsNonZero(firmLocationID_GL)) acc.GRSId__c = (String.IsNotBlank(firmLocationID_GL))?Integer.valueOf(firmLocationID_GL):0;

                          //update only for vendor
                          if(act.Type.startsWith('Vendor')){
                             accsToBeUpdated.add(acc); 
                          }                            
                           
                    }
                  
                    cacheToBeInsertedList.add(cache); 
                    //insert cache;
                    
                    
                }
                
                //check contacts
                try{
                List<SObject> relationsToBeUpdated= new List<SObject>();
                
                    for(Account acc: accsToBeUpdated){
                     if(acc.HeadQuarter__c ==false){
                       decimal KeyMedsID = acc.KeyMedsID__c;
                       String AtticusId = acc.AtticusId__c;
                       decimal GRSId = acc.GRSId__c ;
                    
                       ContactUpdateDataSync cdata = UpdateContactMLSync(acc.Id,KeyMedsID,AtticusId,GRSId);
                       if(cdata.cacheToBeInserted!=null && cdata.cacheToBeInserted.size()>0)
                            cacheToBeInsertedList.addAll(cdata.cacheToBeInserted);    
                        
                       if(cdata.relationToBeUpdated!=null && cdata.relationToBeUpdated.size()>0)
                           relationsToBeUpdated.addAll(cdata.relationToBeUpdated);    
                       }
                       
                     }
                     
                     if(relationsToBeUpdated.size()>0) update relationsToBeUpdated;
                
                
                
                }catch(Exception e) { system.debug('----------------------'+e.getMessage()); }
                
                
                
                if(cacheToBeInsertedList.size()>0) insert cacheToBeInsertedList;
                if(accsToBeUpdated.size()>0) update accsToBeUpdated;
                
                
            }
            else
            {
                //No action needed..its still a new account
                system.debug('Still new Account .No action taken '+act);
            }
            
         }
     } 
    
    //Called from Updatefirm and location  method to maintain seq
    public static ContactUpdateDataSync UpdateContactMLSync(Id accountId,decimal KeyMedsID,String AtticusId, decimal GRSId) 
    {
        
             //Check for Attorney 
             List<Account_Relation__c> accRelationList = [select Id, GRSId__c, KeyMedsID__c,AtticusId__c,Contact__c, Account__c,Role__c , Account__r.Type,
                                                          Account__r.GRSId__c,Account__r.KeyMedsID__c, Account__r.AtticusId__c ,
                                                          Contact__r.Atticus__c,Contact__r.GRS__c,Contact__r.Core__c,Contact__r.Accident_Meds__c
                                                          from Account_Relation__c 
                                                          where Account__c = :accountId and Role__c IN ('Attorney','Physician') 
                                                          and ((GRSId__c !=null and GRSId__c!='0') or (KeyMedsID__c!=null and KeyMedsID__c!='0') or AtticusId__c!=null) ];
                
             List<PSCommunicationCache__c>  cacheToBeInserted = new List<PSCommunicationCache__c>();
             List<SObject> relationToBeUpdated = new List<SObject>();
              
             if(accRelationList!=null && accRelationList.size()>0)
             {
                for(Account_Relation__c relation : accRelationList)
                {
                    
                    //compare flags
                    if(relation.Contact__r.Atticus__c==true && Utility.IsBlank(relation.AtticusId__c) ||
                     relation.Contact__r.GRS__c==true && Utility.IsBlank(relation.GRSId__c) ||
                     (relation.Contact__r.Core__c==true || relation.Contact__r.Accident_Meds__c) && Utility.IsBlank(relation.KeyMedsID__c))
                     {
                        
                        ContactUpdateData cdata = UpdateAttorneyML(relation.Contact__c,relation, relation.Account__r.Type,KeyMedsID,AtticusId,GRSId);
                        cacheToBeInserted.add(cdata.cache);
                        relationToBeUpdated.add(cdata.relation);
                     }
                 }
             }      
            
            
             //Check for Non-Attorneys too
             List<Non_Attorney_Contact__c> supportList = [select Id, GRSId__c, KeyMedsID__c,AtticusId__c,Contact__c, Role__c,Attorney__c, Firm_Name__c,Firm_Name__r.Type,
                                                          Firm_Name__r.GRSId__c,Firm_Name__r.KeyMedsID__c, Firm_Name__r.AtticusId__c ,
                                                          Contact__r.Atticus__c,Contact__r.GRS__c,Contact__r.Core__c,Contact__r.Accident_Meds__c
                                                          from Non_Attorney_Contact__c 
                                                          where Firm_Name__c= :accountId   
                                                           and ((GRSId__c !=null and GRSId__c!=0) or (KeyMedsID__c!=null and KeyMedsID__c!=0) or AtticusId__c!=null) ];
                
                
             if(supportList!=null && supportList.size()>0)
             {
                for(Non_Attorney_Contact__c relation : supportList)
                {
                
                
                    //compare flags
                    if(relation.Contact__r.Atticus__c==true && Utility.IsBlank(relation.AtticusId__c) ||
                     relation.Contact__r.GRS__c==true && Utility.IsBlank(String.valueOf(relation.GRSId__c)) ||
                     (relation.Contact__r.Core__c==true || relation.Contact__r.Accident_Meds__c) && Utility.IsBlank(String.valueOf(relation.KeyMedsID__c)))
                     {
                            
                        ContactUpdateData cdata =UpdateAttorneyAssistantML(relation.Contact__c,relation,relation.Firm_Name__r.Type,KeyMedsID,AtticusId,GRSId);
                        cacheToBeInserted.add(cdata.cache);
                        relationToBeUpdated.add(cdata.relation);
                    }
                }
             }      
            
            ContactUpdateDataSync cdata = new ContactUpdateDataSync();
            cdata.cacheToBeInserted = cacheToBeInserted;
            cdata.relationToBeUpdated = relationToBeUpdated;
            /*
            if(cacheToBeInserted.size()>0)
            {
                insert cacheToBeInserted;
            }
            if(relationToBeUpdated.size()>0)
            { 
                update relationToBeUpdated;
            }*/
            
            return cdata;
       
    }   
    
    
    
        //Called from Update trigger. In trigger, check of the CTX ID exists or not.
    //Handles both Attorney and Non-Attorney Update
  
  
    @future(callout=true)
    public static void  UpdateContactML(Id contactId) 
    {
        
        
         List<Contact> contactList  = [Select Id,AccountId, Account.HeadQuarter__c, Account.Type, Account.CTXFirmId__c, FirstName,LastName,MiddleName__c,MailingStreet,MailingStreet2__c, 
                                MailingCity,MailingState,MailingPostalCode,Phone,Fax,Email,BirthDate,ContactInstructions__c,
                                Salutation, IsActive__c,
                                Preferred_Contact_Phone__c,Preferred_Contact_Fax__c,Preferred_Contact_Email__c,DoNotCall,HasOptedOutOfFax,HasOptedOutOfEmail,
                                Atticus__c,GRS__c,PreSet__c,Core__c,Accident_Meds__c
                                from Contact where Id=: contactId and accountId != null ];  
                                     
                                         
         if(contactList!=null && contactList.size()>0)
         {
         
             Contact cnt = contactList[0];
             
             //Check for Attorney 
             List<Account_Relation__c> accRelationList = [select Id, GRSId__c, KeyMedsID__c,AtticusId__c,Contact__c, Account__c,Role__c , Account__r.Type,
                                                          Account__r.GRSId__c,Account__r.KeyMedsID__c, Account__r.AtticusId__c 
                                                          from Account_Relation__c 
                                                          where Contact__c = :contactId and Role__c IN ('Attorney','Physician') 
                                                          and ((GRSId__c !=null and GRSId__c!='0') or (KeyMedsID__c!=null and KeyMedsID__c!='0') or AtticusId__c!=null) ];
                
             List<PSCommunicationCache__c>  cacheToBeInserted = new List<PSCommunicationCache__c>();
             List<SObject> relationToBeUpdated = new List<SObject>();
              
             if(accRelationList!=null && accRelationList.size()>0)
             {
                for(Account_Relation__c relation : accRelationList)
                {
                    ContactUpdateData cdata = UpdateAttorneyML(cnt,relation, relation.Account__r.Type,relation.Account__r.KeyMedsID__c,relation.Account__r.AtticusId__c,relation.Account__r.GRSId__c);
                    cacheToBeInserted.add(cdata.cache);
                    relationToBeUpdated.add(cdata.relation);
                }
             }      
            
            
             //Check for Non-Attorneys too
             List<Non_Attorney_Contact__c> supportList = [select Id, GRSId__c, KeyMedsID__c,AtticusId__c,Contact__c, Role__c,Attorney__c, Firm_Name__c,Firm_Name__r.Type,
                                                          Firm_Name__r.GRSId__c,Firm_Name__r.KeyMedsID__c, Firm_Name__r.AtticusId__c 
                                                          from Non_Attorney_Contact__c 
                                                          where Contact__c = :contactId   
                                                           and ((GRSId__c !=null and GRSId__c!=0) or (KeyMedsID__c!=null and KeyMedsID__c!=0) or AtticusId__c!=null) ];
                
                
             if(supportList!=null && supportList.size()>0)
             {
                for(Non_Attorney_Contact__c relation : supportList)
                {
                    ContactUpdateData cdata =UpdateAttorneyAssistantML(cnt,relation,relation.Firm_Name__r.Type,relation.Firm_Name__r.KeyMedsID__c, relation.Firm_Name__r.AtticusId__c,relation.Firm_Name__r.GRSId__c);
                    cacheToBeInserted.add(cdata.cache);
                    relationToBeUpdated.add(cdata.relation);
                }
             }      
        
            
            if(cacheToBeInserted.size()>0)
            {
                insert cacheToBeInserted;
            }
            if(relationToBeUpdated.size()>0)
            { 
                update relationToBeUpdated;
            }
       }
    }   
    
    
    /*
    Called fron non-attorney_contact trigger on Role Change
    */
   /* 
     @future(callout=true)
    public static void  UpdateContactML(Id contactId, Id nonAttorneyRelationId) 
    {
        
        
         List<Contact> contactList  = [Select Id,AccountId, Account.HeadQuarter__c, Account.Type, Account.CTXFirmId__c, FirstName,LastName,MiddleName__c,MailingStreet,MailingStreet2__c, 
                                MailingCity,MailingState,MailingPostalCode,Phone,Fax,Email,BirthDate,ContactInstructions__c,
                                Salutation, IsActive__c,
                                Preferred_Contact_Phone__c,Preferred_Contact_Fax__c,Preferred_Contact_Email__c,DoNotCall,HasOptedOutOfFax,HasOptedOutOfEmail,
                                Atticus__c,GRS__c,PreSet__c,Core__c,Accident_Meds__c
                                from Contact where Id=: contactId  and accountId != null ]; 
                                     
            List<PSCommunicationCache__c>   cacheToBeInserted = new List<PSCommunicationCache__c>(); 
         if(contactList!=null && contactList.size()>0)
         {
         
             Contact cnt = contactList[0];
                        
             //Check for Non-Attorneys too
             List<Non_Attorney_Contact__c> supportList = [select Id, GRSId__c, KeyMedsID__c,AtticusId__c,Contact__c, Role__c,Attorney__c, Firm_Name__c,Firm_Name__r.Type,
                                                          Firm_Name__r.GRSId__c,Firm_Name__r.KeyMedsID__c, Firm_Name__r.AtticusId__c 
                                                          from Non_Attorney_Contact__c 
                                                          where Id = :nonAttorneyRelationId   and (GRSId__c !=null and  KeyMedsID__c!=null and AtticusId__c!=null) ];
            
             if(supportList!=null && supportList.size()>0)
             {
                 Non_Attorney_Contact__c relation = supportList[0];
                 PSCommunicationCache__c cache =UpdateAttorneyAssistantML(cnt,relation,relation.Firm_Name__r.Type,relation.Firm_Name__r.KeyMedsID__c, relation.Firm_Name__r.AtticusId__c,relation.Firm_Name__r.GRSId__c);
                 cacheToBeInserted.add(cache);
                 
                
                if(cacheToBeInserted.size()>0)
                {
                    insert cacheToBeInserted;
                }
              }
         }
    }   
    */
    
     
      @testvisible private static ContactUpdateData UpdateAttorneyAssistantML(Contact cnt,Non_Attorney_Contact__c relation,String atype,decimal firmLocationKeyMedsId, String firmLocationAtticusId, decimal firmLocationGRSId) 
      {
    
               MedlienEntities.SFContact request = new  MedlienEntities.SFContact();
              
              
               request.CRM_FirmLocationID = relation.Firm_Name__c;  
               request.CRM_ContactID = cnt.Id;  
               
            
                   request.CRM_ContactID = cnt.Id;
        
                   request.FirmLocationID_KM = (firmLocationKeyMedsId!=null)?Integer.valueOf(firmLocationKeyMedsId):0;
                   request.FirmLocationID_AT = (firmLocationAtticusId);
                   request.FirmLocationID_GL = (firmLocationGRSId!=null) ?Integer.valueOf(firmLocationGRSId):0;
        
                   request.ContactID_KM =  (relation.KeyMedsID__c!=null)?Integer.valueOf(relation.KeyMedsID__c):0;
                   request.ContactID_AT = relation.AtticusId__c;
                   request.ContactID_GL = (relation.KeyMedsID__c!=null)?Integer.valueOf(relation.GRSId__c):0;
                   
                   request.FirstName = removeNull(cnt.FirstName);
                   request.LastName= removeNull(cnt.LastName);
                   request.email = removeNull(cnt.Email);
                   request.PhoneNumber = removeNull(cnt.Phone);
                   request.Fax = removeNull(cnt.Fax);
                   request.Birthday = cnt.BirthDate;
                   request.ContactInformation = removeNull(cnt.ContactInstructions__c);
                   request.Type = relation.Role__c;
                  
                   request.PreferredContactPhone = cnt.Preferred_Contact_Phone__c;
                           request.PreferredContactFax = cnt.Preferred_Contact_Fax__c;
                           request.PreferredContactEmail = cnt.Preferred_Contact_Email__c;
                        
                           request.DoNotContactPhone = cnt.DoNotCall;
                           request.DoNotContactFax = cnt.HasOptedOutOfFax;
                           request.DoNotContactEmail = cnt.HasOptedOutOfEmail;
                           request.IsActive = cnt.IsActive__c;
                           request.Suffix = removeNull(cnt.Salutation);
                           
                           boolean HQ = cnt.Account.HeadQuarter__c;
                           
                           request.CRM_FirmType = (atype.equalsIgnoreCase('LawFirm')) ? 
                                                        ((HQ==true)?'Payer' : 'PayerLocation') : 
                                                        ((HQ==true)?'Vendor' : 'VendorLocation');
       
                            request.Preset = cnt.PreSet__c;
                           request.Core = cnt.Core__c;
                           request.Atticus= cnt.Atticus__c;
                           request.AccidentMeds = cnt.Accident_Meds__c;
                           request.GRS = cnt.GRS__c;
       
       
                    String sessionId = ctxService.loginML();
              
                    String action = 'UpdateContact';
                    PSCommunicationCache__c cache = buildCache(action,JSON.serialize(request),cnt.Id,'ML');
                    Map<String,Object> ctxResponse = sendToCache(cache,sessionId,'ML');
                    String ret='';
                    if(ctxResponse!=null)
                    {
                        ret = String.valueOf(ctxResponse.get('Status'));
                    }
                     cache.ResponseStatus__c = ctxResponse.get('StatusCode')+':'+ret;
                    cache.ResponsePayload__c = JSON.serialize(ctxResponse);
                 
                    if(null==ret || (!ret.equalsIgnoreCase('Ok')))
                    {
                       cache.IsError__c = true;
                    }
                    else
                    {
                       if(Utility.IsNonZero(String.valueOf(ctxResponse.get('ContactID_GL'))))  relation.GRSId__c = Integer.valueOf(String.valueOf(ctxResponse.get('ContactID_GL')));
                       if(Utility.IsNonZero(String.valueOf(ctxResponse.get('ContactID_KM')))) relation.KeyMedsID__c = Integer.valueOf(String.valueOf(ctxResponse.get('ContactID_KM')));
                       if(Utility.IsNonZero(String.valueOf(ctxResponse.get('ContactID_AT')))) relation.AtticusId__c = String.valueOf(ctxResponse.get('ContactID_AT'));
                    }
                    ContactUpdateData  cdata = new ContactUpdateData();    
                    cdata.cache = cache;
                    cdata.relation = relation;
                                   
                    return cdata;
                  
     }
  
  
        @testvisible private static ContactUpdateData UpdateAttorneyML(Contact cnt,Account_Relation__c relation,String atype,decimal firmLocationKeyMedsId, String firmLocationAtticusId, decimal firmLocationGRSId) {
    
              
               MedlienEntities.SFContact request = new MedlienEntities.SFContact();
              
                            request.CRM_FirmLocationId = relation.Account__c;
                            request.CRM_ContactID = cnt.Id;
                        
                           request.FirmLocationID_KM = (firmLocationKeyMedsId!=null)? Integer.valueOf(firmLocationKeyMedsId):0;
                           request.FirmLocationID_AT = (firmLocationAtticusId);
                           request.FirmLocationID_GL = (firmLocationGRSId!=null )?Integer.valueOf(firmLocationGRSId):0;
                           
                           request.ContactID_KM = (relation.KeyMedsID__c!=null) ? Integer.valueOf(relation.KeyMedsID__c):0;
                           request.ContactID_AT = relation.AtticusId__c;
                           request.ContactID_GL = (relation.GRSId__c!=null)?Integer.valueOf(relation.GRSId__c):0;
                           
                           request.FirstName = removeNull(cnt.FirstName);
                           request.LastName= removeNull(cnt.LastName);
                           request.email = removeNull(cnt.Email);
                           request.PhoneNumber = removeNull(cnt.Phone);
                           request.Fax = removeNull(cnt.Fax);
                           request.Birthday = cnt.BirthDate;
                           request.ContactInformation = removeNull(cnt.ContactInstructions__c);
                           request.Type = relation.Role__c;
                          
                           request.PreferredContactPhone = cnt.Preferred_Contact_Phone__c;
                           request.PreferredContactFax = cnt.Preferred_Contact_Fax__c;
                           request.PreferredContactEmail = cnt.Preferred_Contact_Email__c;
                        
                           request.DoNotContactPhone = cnt.DoNotCall;
                           request.DoNotContactFax = cnt.HasOptedOutOfFax;
                           request.DoNotContactEmail = cnt.HasOptedOutOfEmail;
                           request.IsActive = cnt.IsActive__c;
                           request.Suffix = removeNull(cnt.Salutation);
                           
                           boolean HQ = cnt.Account.HeadQuarter__c;
                           
                           request.CRM_FirmType = (atype.equalsIgnoreCase('LawFirm')) ? 
                                                        ((HQ==true)?'Payer' : 'PayerLocation') : 
                                                        ((HQ==true)?'Vendor' : 'VendorLocation');
            
            
                           request.Preset = cnt.PreSet__c;
                           request.Core = cnt.Core__c;
                           request.Atticus= cnt.Atticus__c;
                           request.AccidentMeds = cnt.Accident_Meds__c;
                           request.GRS = cnt.GRS__c;
            
                    String sessionId = ctxService.loginML();
              
                    String action = 'UpdateContact';
                    PSCommunicationCache__c cache = buildCache(action,JSON.serialize(request),cnt.Id,'ML');
                    Map<String,Object> ctxResponse = sendToCache(cache,sessionId,'ML');
                    String ret='';
                    if(ctxResponse!=null)
                    {
                        ret = String.valueOf(ctxResponse.get('Status'));
                    }
                    cache.ResponseStatus__c = ctxResponse.get('StatusCode')+':'+ret;
                    cache.ResponsePayload__c = JSON.serialize(ctxResponse);
                    
                    if(null==ret || (!ret.equalsIgnoreCase('Ok')))
                    {
                       cache.IsError__c = true;
                    }
                     else
                    {
                    
                      if(Utility.IsNonZero(String.valueOf(ctxResponse.get('ContactID_GL'))))  relation.GRSId__c = String.valueOf(ctxResponse.get('ContactID_GL'));
                      if(Utility.IsNonZero(String.valueOf(ctxResponse.get('ContactID_KM'))))  relation.KeyMedsID__c = String.valueOf(ctxResponse.get('ContactID_KM'));
                      if(Utility.IsNonZero(String.valueOf(ctxResponse.get('ContactID_AT'))))  relation.AtticusId__c = String.valueOf(ctxResponse.get('ContactID_AT'));
                    
                    }
  
                    ContactUpdateData  cdata = new ContactUpdateData();    
                    cdata.cache = cache;
                    cdata.relation = relation;
                                   
                    return cdata;
                  
     }
  
    
    
    
      private static ContactUpdateData UpdateAttorneyAssistantML(Id contactId,Non_Attorney_Contact__c relation,String atype,decimal firmLocationKeyMedsId, String firmLocationAtticusId, decimal firmLocationGRSId) 
      {
    
      
         List<Contact> contactList  = [Select Id,AccountId, Account.HeadQuarter__c, Account.Type, Account.CTXFirmId__c, FirstName,LastName,MiddleName__c,MailingStreet,MailingStreet2__c, 
                                MailingCity,MailingState,MailingPostalCode,Phone,Fax,Email,BirthDate,ContactInstructions__c,
                                Salutation, IsActive__c,
                                Preferred_Contact_Phone__c,Preferred_Contact_Fax__c,Preferred_Contact_Email__c,DoNotCall,HasOptedOutOfFax,HasOptedOutOfEmail,
                                Atticus__c,GRS__c,PreSet__c,Core__c,Accident_Meds__c
                                from Contact where Id=: contactId and accountId != null ];  
                                     
                                         
         if(contactList!=null && contactList.size()>0)
         {
         
             Contact cnt = contactList[0];
             
      
      
               MedlienEntities.SFContact request = new  MedlienEntities.SFContact();
              
              
               request.CRM_FirmLocationID = relation.Firm_Name__c;  
               request.CRM_ContactID = cnt.Id;  
               
            
                   request.CRM_ContactID = cnt.Id;
        
                   request.FirmLocationID_KM = (firmLocationKeyMedsId!=null)?Integer.valueOf(firmLocationKeyMedsId):0;
                   request.FirmLocationID_AT = (firmLocationAtticusId);
                   request.FirmLocationID_GL = (firmLocationGRSId!=null) ?Integer.valueOf(firmLocationGRSId):0;
        
                   request.ContactID_KM =  (relation.KeyMedsID__c!=null)?Integer.valueOf(relation.KeyMedsID__c):0;
                   request.ContactID_AT = relation.AtticusId__c;
                   request.ContactID_GL = (relation.KeyMedsID__c!=null)?Integer.valueOf(relation.GRSId__c):0;
                   
                   request.FirstName = removeNull(cnt.FirstName);
                   request.LastName= removeNull(cnt.LastName);
                   request.email = removeNull(cnt.Email);
                   request.PhoneNumber = removeNull(cnt.Phone);
                   request.Fax = removeNull(cnt.Fax);
                   request.Birthday = cnt.BirthDate;
                   request.ContactInformation = removeNull(cnt.ContactInstructions__c);
                   request.Type = relation.Role__c;
                  
                   request.PreferredContactPhone = cnt.Preferred_Contact_Phone__c;
                           request.PreferredContactFax = cnt.Preferred_Contact_Fax__c;
                           request.PreferredContactEmail = cnt.Preferred_Contact_Email__c;
                        
                           request.DoNotContactPhone = cnt.DoNotCall;
                           request.DoNotContactFax = cnt.HasOptedOutOfFax;
                           request.DoNotContactEmail = cnt.HasOptedOutOfEmail;
                           request.IsActive = cnt.IsActive__c;
                           request.Suffix = removeNull(cnt.Salutation);
                           
                           boolean HQ = cnt.Account.HeadQuarter__c;
                           
                           request.CRM_FirmType = (atype.equalsIgnoreCase('LawFirm')) ? 
                                                        ((HQ==true)?'Payer' : 'PayerLocation') : 
                                                        ((HQ==true)?'Vendor' : 'VendorLocation');
       
                            request.Preset = cnt.PreSet__c;
                           request.Core = cnt.Core__c;
                           request.Atticus= cnt.Atticus__c;
                           request.AccidentMeds = cnt.Accident_Meds__c;
                           request.GRS = cnt.GRS__c;
       
       
                    String sessionId = ctxService.loginML();
              
                    String action = 'UpdateContact';
                    PSCommunicationCache__c cache = buildCache(action,JSON.serialize(request),cnt.Id,'ML');
                    Map<String,Object> ctxResponse = sendToCache(cache,sessionId,'ML');
                    String ret='';
                    if(ctxResponse!=null)
                    {
                        ret = String.valueOf(ctxResponse.get('Status'));
                    }
                     cache.ResponseStatus__c = ctxResponse.get('StatusCode')+':'+ret;
                    cache.ResponsePayload__c = JSON.serialize(ctxResponse);
                 
                    if(null==ret || (!ret.equalsIgnoreCase('Ok')))
                    {
                       cache.IsError__c = true;
                    }
                    else
                    {
                       if(Utility.IsNonZero(String.valueOf(ctxResponse.get('ContactID_GL'))))  relation.GRSId__c = Integer.valueOf(String.valueOf(ctxResponse.get('ContactID_GL')));
                       if(Utility.IsNonZero(String.valueOf(ctxResponse.get('ContactID_KM')))) relation.KeyMedsID__c = Integer.valueOf(String.valueOf(ctxResponse.get('ContactID_KM')));
                       if(Utility.IsNonZero(String.valueOf(ctxResponse.get('ContactID_AT')))) relation.AtticusId__c = String.valueOf(ctxResponse.get('ContactID_AT'));
                    }
                    ContactUpdateData  cdata = new ContactUpdateData();    
                    cdata.cache = cache;
                    cdata.relation = relation;
                                   
                    return cdata;
           }
           
           return null;
                  
     }
  
  
    
    private static ContactUpdateData UpdateAttorneyML(Id contactId,Account_Relation__c relation,String atype,decimal firmLocationKeyMedsId, String firmLocationAtticusId, decimal firmLocationGRSId) {
    
        
         List<Contact> contactList  = [Select Id,AccountId, Account.HeadQuarter__c, Account.Type, Account.CTXFirmId__c, FirstName,LastName,MiddleName__c,MailingStreet,MailingStreet2__c, 
                                MailingCity,MailingState,MailingPostalCode,Phone,Fax,Email,BirthDate,ContactInstructions__c,
                                Salutation, IsActive__c,
                                Preferred_Contact_Phone__c,Preferred_Contact_Fax__c,Preferred_Contact_Email__c,DoNotCall,HasOptedOutOfFax,HasOptedOutOfEmail,
                                Atticus__c,GRS__c,PreSet__c,Core__c,Accident_Meds__c
                                from Contact where Id=: contactId and accountId != null ];  
                                     
                                         
         if(contactList!=null && contactList.size()>0)
         {
         
             Contact cnt = contactList[0];
             
                        
              
               MedlienEntities.SFContact request = new MedlienEntities.SFContact();
              
                            request.CRM_FirmLocationId = relation.Account__c;
                            request.CRM_ContactID = cnt.Id;
                        
                           request.FirmLocationID_KM = (firmLocationKeyMedsId!=null)? Integer.valueOf(firmLocationKeyMedsId):0;
                           request.FirmLocationID_AT = (firmLocationAtticusId);
                           request.FirmLocationID_GL = (firmLocationGRSId!=null )?Integer.valueOf(firmLocationGRSId):0;
                           
                           request.ContactID_KM = (relation.KeyMedsID__c!=null) ? Integer.valueOf(relation.KeyMedsID__c):0;
                           request.ContactID_AT = relation.AtticusId__c;
                           request.ContactID_GL = (relation.GRSId__c!=null)?Integer.valueOf(relation.GRSId__c):0;
                           
                           request.FirstName = removeNull(cnt.FirstName);
                           request.LastName= removeNull(cnt.LastName);
                           request.email = removeNull(cnt.Email);
                           request.PhoneNumber = removeNull(cnt.Phone);
                           request.Fax = removeNull(cnt.Fax);
                           request.Birthday = cnt.BirthDate;
                           request.ContactInformation = removeNull(cnt.ContactInstructions__c);
                           request.Type = relation.Role__c;
                          
                           request.PreferredContactPhone = cnt.Preferred_Contact_Phone__c;
                           request.PreferredContactFax = cnt.Preferred_Contact_Fax__c;
                           request.PreferredContactEmail = cnt.Preferred_Contact_Email__c;
                        
                           request.DoNotContactPhone = cnt.DoNotCall;
                           request.DoNotContactFax = cnt.HasOptedOutOfFax;
                           request.DoNotContactEmail = cnt.HasOptedOutOfEmail;
                           request.IsActive = cnt.IsActive__c;
                           request.Suffix = removeNull(cnt.Salutation);
                           
                           boolean HQ = cnt.Account.HeadQuarter__c;
                           
                           request.CRM_FirmType = (atype.equalsIgnoreCase('LawFirm')) ? 
                                                        ((HQ==true)?'Payer' : 'PayerLocation') : 
                                                        ((HQ==true)?'Vendor' : 'VendorLocation');
            
            
                           request.Preset = cnt.PreSet__c;
                           request.Core = cnt.Core__c;
                           request.Atticus= cnt.Atticus__c;
                           request.AccidentMeds = cnt.Accident_Meds__c;
                           request.GRS = cnt.GRS__c;
            
                    String sessionId = ctxService.loginML();
              
                    String action = 'UpdateContact';
                    PSCommunicationCache__c cache = buildCache(action,JSON.serialize(request),cnt.Id,'ML');
                    Map<String,Object> ctxResponse = sendToCache(cache,sessionId,'ML');
                    String ret='';
                    if(ctxResponse!=null)
                    {
                        ret = String.valueOf(ctxResponse.get('Status'));
                    }
                    cache.ResponseStatus__c = ctxResponse.get('StatusCode')+':'+ret;
                    cache.ResponsePayload__c = JSON.serialize(ctxResponse);
                    
                    if(null==ret || (!ret.equalsIgnoreCase('Ok')))
                    {
                       cache.IsError__c = true;
                    }
                     else
                    {
                    
                      if(Utility.IsNonZero(String.valueOf(ctxResponse.get('ContactID_GL'))))  relation.GRSId__c = String.valueOf(ctxResponse.get('ContactID_GL'));
                      if(Utility.IsNonZero(String.valueOf(ctxResponse.get('ContactID_KM'))))  relation.KeyMedsID__c = String.valueOf(ctxResponse.get('ContactID_KM'));
                      if(Utility.IsNonZero(String.valueOf(ctxResponse.get('ContactID_AT'))))  relation.AtticusId__c = String.valueOf(ctxResponse.get('ContactID_AT'));
                    
                    }
  
                    ContactUpdateData  cdata = new ContactUpdateData();    
                    cdata.cache = cache;
                    cdata.relation = relation;
                                   
                    return cdata;
          }
          
          return null;          
                  
     }
  
    
  
  //===============================================================================================  
  
  
  public class ContactUpdateDataSync {
  
   public List<PSCommunicationCache__c>  cacheToBeInserted {get;set;}
   public List<SObject> relationToBeUpdated {get;set; }
   
  }         
            
  public class ContactUpdateData {
  
   public PSCommunicationCache__c cache {get;set;}
   public SObject relation {get;set; }
   
  }
    
  public class ContactData {
     
      public String CTX_AttorneyID{set;get;} 
      public Account_Relation__c relation {get;set; }
      public PSCommunicationCache__c cache {get;set;}
      public Map<String,Object> resp {get;set;}
      public integer ContactID_KM {get;set;}
      public String ContactID_AT {get;set;}
      public integer ContactID_GL {get;set;}
  }
 
  public class ContactAssttData {
     
      public String CTX_AttorneyID{set;get;} 
      public Non_Attorney_Contact__c relation {get;set; }
      public PSCommunicationCache__c cache {get;set;}
      public Map<String,Object> resp {get;set;}
      public integer ContactID_KM {get;set;}
      public String ContactID_AT {get;set;}
      public integer ContactID_GL {get;set;}
  }
 
 

 public class FirmData {
 
  public String CTX_FirmId { get;set; }
  public Account acc { get;set; }
  public PSCommunicationCache__c cache {get;set;}
  public Map<String,Object> resp {get;set;}
  public boolean HQ { get;set; }
  
 //FOR ML
   public integer  FirmID_KM { get;set; } 
   public String FirmID_AT { get;set; } 
   public integer FirmID_GL { get;set; } 
   
  
 }
 
  @testvisible private static String removeNull(String str)
   {
      //return (str==null)?'':str.trim(); 
      system.debug('------>'+str);
      return (String.isBlank(str))?'':str.trim(); 
   } 
    
}