/**
  * @Created Date 04/24/2019
  * @author    OASISFINANCIAL GROUP
  * @copyright Copyright (c) 2019-2020 
  * @license   
  * @Modified Date
  * @Description Storing the cache into PSCommunication object when request failed from salesforce to cashtrax
*/
public class CommunicationCache {

    public String cashtraxEndPoint;
    public String medlienEndPoint;
    public String cashtraxSecretToken;
    public String MLSecurityToken=null;
    
    public CommunicationCache() {
        
    for (IntegrationSettings__mdt cashTraxDEndPoint : [select Id, MasterLabel, DeveloperName, PSEndPoint__c,MLEndPoint__c, 
                                                            MLSecurityToken__c,value__c,Envrionment_Flag__c From IntegrationSettings__mdt]){
        
        if(cashTraxDEndPoint.MasterLabel == Constant.CASHTRAX_QA && cashTraxDEndPoint.Envrionment_Flag__c) {
          cashtraxEndPoint = cashTraxDEndPoint.PSEndPoint__c;
          cashtraxSecretToken = cashTraxDEndPoint.value__c;
          
          medlienEndPoint = cashTraxDEndPoint.MLEndPoint__c;
          MLSecurityToken = cashTraxDEndPoint.MLSecurityToken__c;
        } 
        
        if(cashTraxDEndPoint.MasterLabel == Constant.CASHTRAX_UAT && cashTraxDEndPoint.Envrionment_Flag__c) {
          cashtraxEndPoint = cashTraxDEndPoint.PSEndPoint__c;
          cashtraxSecretToken = cashTraxDEndPoint.value__c;
          medlienEndPoint = cashTraxDEndPoint.MLEndPoint__c;
          MLSecurityToken = cashTraxDEndPoint.MLSecurityToken__c;
        }
        
        //TODO for Prod, Staging etc.
    }
    //Get from Meta settings
    //cashtraxEndPoint = 'http://sfapitest.oasislegal.com';
    //cashtraxSecretToken = '992DB949-BF50-49ED-89DA-2243C802F95C';
    
  //  cashtraxEndPoint='http://salesforceqa.keyhealth.net';
    
    }
     
     
    /* Used to authenticate with the Cashtrax webservice 
     * Input : static key from custom setting 
       Returns the dyanamic Security token by the service
     */

    /**
     * Used to authenticate with the Cashtrax webservice
     * @param 
     * @return String.
     * @exception Exception On input error.
     * @see 
    */
    
    public String loginML()
    {
        return MLSecurityToken;
    }
    public String login()
    {
    
        String sessionId=null;
    
        //Set HTTPRequest Method
          HttpRequest req = new HttpRequest();
          req.setMethod('POST');
          System.debug('email='+UserInfo.getUserEmail());
          
          req.setHeader('email',UserInfo.getUserEmail());
          req.setHeader('securitytoken',cashtraxSecretToken);
        
          String operation = '/api/login/login';
          req.setEndpoint(cashtraxEndPoint+operation);
        
          req.setBody('');
        
          //Execute web service call here     
          Http http = new Http();
          HTTPResponse resp = http.send(req);
        
          //Helpful debug messages
          System.debug(resp.toString());
          System.debug('STATUS:' + resp.getStatus());
          System.debug('STATUS_CODE:' + resp.getStatusCode());
          String responseJson = resp.getBody();
          System.debug('responseJson:' + responseJson);
        
            if (resp.getStatusCode() == 200) {
                // Deserialize the JSON string into collections of primitive data types.
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
                if(results!=null && results.size()>0)
                {
                    sessionId = String.valueOf(results.get('SessionID'));
                    System.debug('sessionId:' + sessionId);
                }
             }
        
            return sessionId;
        
       
    }
    
    
    /**
     * Save the Communicaton record to DB
     * @param 
     * @return Id.
     * @exception Exception On input error.
     * @see 
    */
    public Id add(PSCommunicationCache__c cache)
    {
       insert cache;
       return cache.Id;
    }
    
    

    /**
     * Sends the Request to Cashtrax and saves the response in DB
     * @param 
     * @return Id.
     * @exception Exception On input error.
     * @see 
    */
    public Map<String, Object> pushToCashtrax( PSCommunicationCache__c cache, String sessionId,String lob)
    {
        HTTPResponse res=null ;
         Map<String, Object> results = null;
         
      //  List<PSCommunicationCache__c>  cacheList = [select GenericName__c,Operation__c,InputPayload__c,ResponseStatus__c,ResponsePayload__c from PSCommunicationCache__c where Id = :rid ];
      //  if(cacheList!=null && cacheList.size()>0){
        
      //  PSCommunicationCache__c cache = cacheList[0];
        
       // String sessionId = login();
       
    try{   
        if(sessionId!=null){ 
            res =  doPost(sessionId,cache.Operation__c,cache.InputPayload__c,lob);
            
            //cache.ResponseStatus__c = res.getStatusCode()+':'+res.getStatus();
            //cache.ResponsePayload__c = res.getBody();
            //update cache;
         
            if (res.getStatusCode() == 200) {
                // Deserialize the JSON string into collections of primitive data types.
                //system.debug('-----res.getBody()---------'+res.getBody());
                results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                results.put('StatusCode',200);
              //  system.debug('-----------------'+results.get('CTX_CaseID'));
                
            }else
            {
                results = new Map<String,Object>();
                results.put('StatusCode', res.getStatusCode());
                results.put('Status','ERROR');
                results.put('RESPONSE',+res.getStatus());
            }
        }
         
      }//try
      catch(Exception e)
      {
          results = new Map<String,Object>();
          results.put('StatusCode', 999);
          results.put('Status','ERROR');
          results.put('RESPONSE',+e.getMessage());
      }
      
        return results ;
                     
    }


    /* Performs HTTP POST 
       Input :  sessionId from login call
       Input :  Operation - should start with /api/ 
       Input : input JSON Payload
       Return : HTTPResponse - Calling method needs to handle the response accordingly
    */   
    public HTTPResponse doPost(String sessionId,String operation, String inputPayload,String lob)
    {
    
         
                
          //Set HTTPRequest Method
          HttpRequest req = new HttpRequest();
          req.setMethod('POST');
          req.setHeader('content-type', 'application/json');
          req.setHeader('Content-Length', String.valueOf(inputPayload.length()));
        
        
         req.setHeader('email',UserInfo.getUserEmail());
        
        
        if(lob.equalsIgnoreCase('PS'))
        {   
          
            req.setHeader('SessionID',sessionId);
           req.setEndpoint(cashtraxEndPoint+operation);
           system.debug('---------cashtraxEndPoint+operation----'+(cashtraxEndPoint+operation));     
       }
       else
       {
             req.setHeader('SecurityToken',sessionId);
            req.setEndpoint(medlienEndPoint+operation);
            system.debug('---------medlienEndPoint+operation----'+(medlienEndPoint+operation));
       }
       
        
       
          // setting body
          System.debug('Input Request:' + inputPayload);
          req.setBody(inputPayload);
          req.setTimeout(60*1000);  //120 sec  : changed 27th july'19
          //Execute web service call here     
          Http http = new Http();
          HTTPResponse res = http.send(req);
        
          //Helpful debug messages
          System.debug(res.toString());
          System.debug('STATUS:' + res.getStatus());
          System.debug('STATUS_CODE:' + res.getStatusCode());
          
        //  String responseJson = res.getBody();
        //  System.debug('responseJson:' + responseJson);
        
          //String responseJson = res.getBody();
          //System.debug('responseJson:' + responseJson);
          
        
            return res;
        
        }


     /* Performs HTTP GET 
         Used for Login at present
         TODO :  Pass security token if required
     */ 
    @testvisible private HTTPResponse doGet(String endPoint, String operation)
     {
         //Set HTTPRequest Method
          HttpRequest req = new HttpRequest();
          req.setMethod('GET');
          req.setEndpoint(endPoint+operation);
       
        
          //Execute web service call here     
          Http http = new Http();
          HTTPResponse res = http.send(req);
        
          //Helpful debug messages
          System.debug(res.toString());
          System.debug('STATUS:' + res.getStatus());
          System.debug('STATUS_CODE:' + res.getStatusCode());
          
          return res;
        
        }

}