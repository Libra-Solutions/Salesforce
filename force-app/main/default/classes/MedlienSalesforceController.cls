/**
* Requirement: Handling the request from Medlien systems to salesforce
* @param
* @author
* @return type
* @created date
* @modification
**/
@RestResource(urlMapping='/medlien/*')
global with sharing class MedlienSalesforceController {


 public enum URL_MAPPING_STRING {
  createFirm,
  updateFirm,
  createFirmLocation,
  updateFirmLocation,
  createContact,
  updateContact
  
 }
 
 /**
  * Send request to medlien system
  * @param List<Contact>
  * @return Nothing.
  * @exception Exception On input error.
  * @see 
 */ 
  @HttpPost
 global static void doPost(){
   String presetResponse;
   try{
       RestRequest req = RestContext.request;
       String presetReq = req.requestBody.toString();
       
       System.debug('REQUEST BODY-----------'+presetReq);
       
       presetResponse = requestService(req,presetReq );
       
       System.debug('ML RESPONSE-----------'+presetResponse );
       
       
   } catch (Exception e) {
       MedlienResponse response = new MedlienResponse();
       response.errorMessage = e.getStackTraceString();
       response.errorStackTrace = e.getMessage();
       presetResponse = JSON.serialize(response);
   }
   RestContext.response.addHeader('Content-Type', 'application/json');
   RestContext.response.responseBody = Blob.valueOf(presetResponse);
   System.debug('RESPONSE ' + presetResponse);
 }
 
 /**
  * Call services according to url from medlien
  * @param RestRequest , String 
  * @return Nothing.
  * @exception Exception On input error.
  * @see 
 */ 
 private static String requestService(RestRequest request, String presetRequest) {
     /*Remove Medlien Api calls
     system.debug('-------URL------'+request.requestURI);
     
     if(request.requestURI.endsWith(URL_MAPPING_STRING.createFirm.name())) {
        return new MedlienSalesforceService().createFirm(presetRequest);
     }
     
    
     if(request.requestURI.endsWith(URL_MAPPING_STRING.updateFirm.name())) {
        //return new MedlienSalesforceService().updateFirm(presetRequest);
        return NotSupported();
     }
     
     
       if(request.requestURI.endsWith(URL_MAPPING_STRING.createFirmLocation.name())) {
        return new MedlienSalesforceService().createFirmLocation(presetRequest);
     }
     
  
     if(request.requestURI.endsWith(URL_MAPPING_STRING.updateFirmLocation.name())) {
        //return new MedlienSalesforceService().updateFirmLocation(presetRequest);
        return NotSupported();
     }
     
     
     
     
     if(request.requestURI.endsWith(URL_MAPPING_STRING.createContact.name())) {
        return new MedlienSalesforceService().createContact(presetRequest);
     }
     
     if(request.requestURI.endsWith(URL_MAPPING_STRING.updateContact.name())) {
        //return new MedlienSalesforceService().updateContact(presetRequest);
        return NotSupported();
     }
     */
    return NotSupported();
 }


private static String NotSupported()
{
    
    MedlienResponse response = new MedlienResponse();
    response.errorMessage = 'This Operation is not Supported. Please contact the Administrator.' ;
    return JSON.serialize(response);
}

 global class MedlienResponse {
  public String errorMessage;
  public String errorStackTrace;
 }

}