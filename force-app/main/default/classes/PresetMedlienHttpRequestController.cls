/*
    Name           :    PresetMedlienHttpRequestController
    Date           :    10 Oct 2019
    Author         :    OasisFinancial
    Description    :    Preset and Medlien server Callout Request 
    TestClass      :    PresetMedlienHttpRequestControllerTest
*/

public  class PresetMedlienHttpRequestController{
   
   public static HTTPResponse request(String reqBody ,String reqName,String urlParameters ){
       HttpRequest req = new HttpRequest();
       req.setHeader('email',UserInfo.getUserEmail());
       try{
        Preset_Medlien_Configuration__c  objReq =Preset_Medlien_Configuration__c.getAll().get(reqName);
        
        
        req.setMethod('POST');
        req.setEndpoint(objReq.End_Point__c);
        req.setHeader('content-type', 'application/json');
        req.setBody(reqBody);
        req.setHeader('Content-Length', String.valueOf(reqBody .length()));
      //  req.setHeader('email',UserInfo.getUserEmail());         
       // req.setHeader('email',objReq.User_Email__c);
       // req.setHeader('email',objReq.getUserEmail());
        req.setTimeout(120000);
        
        if(reqBody!=null && reqBody.trim().length()>0 && objReq.Server_Type__c=='Preset'){
            req.setHeader('SessionID',objReq.Token__c);
        }else{
            req.setHeader('SecurityToken',objReq.Token__c);
        }
        
        if(urlParameters!=''){ req.setEndpoint(objReq.End_Point__c+'?'+urlParameters); }
            
      }catch(Exception ex){
          if(!Test.isRunningTest()){  request(reqBody ,reqName,urlParameters ); }
           
        
      }
      return new Http().send(req);
   }

}