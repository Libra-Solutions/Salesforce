/**
  * @Created Date 04/24/2019
  * @author    OASISFINANCIAL GROUP
  * @copyright Copyright (c) 2019-2020 
  * @license   
  * @Modified Date
  * @Description This class is going to take care the re-attempt of failed request from salesforce to Cashtrax database
*/
@RestResource(urlMapping='/Preset/*')
global with sharing class PresetController {


 public enum URL_MAPPING_STRING {
  createCTXFirm,
  updateCTXFirm,
  createCTXFirmLocation,
  updateCTXFirmLocation,
  createCTXAttorney,
  updateCTXAttorney,
  createAttorneyAssistant,
  updateAttorneyAssistant,
  caseFunded,
  createAttorneyNote,
  fetchActivities,
  fetchNotes,
  fetchEvents,
  deleteFirmLocation,
  deleteFirmInCRM,
  updateActivity
  /*mergeFirmLocation,
  mergeParentFirms,
  mergeContact,
  moveContact*/
 }
 
 /**
  * This method is getting request from cashtrax to salesforce .
  * @param 
  * @return .
  * @exception Exception On input error.
  * @see 
 */
 @HttpPost
 global static void doPost(){
   String presetResponse;
   try{
       RestRequest req = RestContext.request;
       String presetReq = req.requestBody.toString();
       presetResponse = requestService(req,presetReq );
   } catch (Exception e) {
       CashTraxResponse response = new CashTraxResponse();
       response.errorMessage = e.getStackTraceString();
       response.errorStackTrace = e.getMessage();
       presetResponse = JSON.serialize(response);
   }
   RestContext.response.addHeader('Content-Type', 'application/json');
   RestContext.response.responseBody = Blob.valueOf(presetResponse);
   System.debug('RESPONSE ' + presetResponse);
 }
 
 /**
  * This method is getting request from cashtrax to salesforce and redirect to method as per url mapping.
  * @param RestRequest request, String presetRequest
  * @return String.
  * @exception Exception On input error.
  * @see 
 */
 private static String requestService(RestRequest request, String presetRequest) {
     
     if(request.requestURI.endsWith(URL_MAPPING_STRING.createCTXFirm.name())) {
        return new PresetCastTraxService().createCTXFirm(presetRequest);
     }
     
     
     if(request.requestURI.endsWith(URL_MAPPING_STRING.updateCTXFirm.name())) {
        return new PresetCastTraxService().updateCTXFirm(presetRequest);
     }
     
     
       if(request.requestURI.endsWith(URL_MAPPING_STRING.createCTXFirmLocation.name())) {
        return new PresetCastTraxService().createCTXFirmLocation(presetRequest);
     }
     
     
     if(request.requestURI.endsWith(URL_MAPPING_STRING.updateCTXFirmLocation.name())) {
        return new PresetCastTraxService().updateCTXFirmLocation(presetRequest);
     }
         
     
     
     if(request.requestURI.endsWith(URL_MAPPING_STRING.createCTXAttorney.name())) {
        return new PresetCastTraxService().createCTXAttorney(presetRequest);
     }
     if(request.requestURI.endsWith(URL_MAPPING_STRING.updateCTXAttorney.name())) {
        return new PresetCastTraxService().updateCTXAttorney(presetRequest);
     }
     if(request.requestURI.endsWith(URL_MAPPING_STRING.createAttorneyAssistant.name())) {
        return new PresetCastTraxService().createAttorneyAssistant(presetRequest);
     }
     if(request.requestURI.endsWith(URL_MAPPING_STRING.updateAttorneyAssistant.name())) {
        return new PresetCastTraxService().updatedAttorneyAssistant(presetRequest);
     }
     if(request.requestURI.endsWith(URL_MAPPING_STRING.caseFunded.name())) {
        return new PresetCastTraxService().caseFunded(presetRequest);
     }
    
    if(request.requestURI.endsWith(URL_MAPPING_STRING.createAttorneyNote.name())) {
        return new PresetCastTraxService().createAttorneyNote(presetRequest);
     }

    if(request.requestURI.endsWith(URL_MAPPING_STRING.fetchActivities.name())) {
        return new PresetCastTraxService().fetchActivities(presetRequest);
     }

     if(request.requestURI.endsWith(URL_MAPPING_STRING.fetchNotes.name())) {
        return new PresetCastTraxService().fetchNotes(presetRequest);
     }

    if(request.requestURI.endsWith(URL_MAPPING_STRING.fetchEvents.name())) {
        return new PresetCastTraxService().fetchEvents(presetRequest);
     }

     if(request.requestURI.endsWith(URL_MAPPING_STRING.deleteFirmInCRM.name())) {
        return new PresetCastTraxService().deleteFirmInCRM(presetRequest);
     }
     
     if(request.requestURI.endsWith(URL_MAPPING_STRING.deleteFirmLocation.name())) {
        return new PresetCastTraxService().deleteFirmLocation(presetRequest);
     }
     
     if(request.requestURI.endsWith(URL_MAPPING_STRING.updateActivity.name())) {
        return new PresetCastTraxService().updateCTXActivity(presetRequest);
     }
         
  	 /*if(request.requestURI.endsWith(URL_MAPPING_STRING.mergeFirmLocation.name())) {
        return new PresetCastTraxService().mergeFirmLocation(presetRequest);
     }
     
     if(request.requestURI.endsWith(URL_MAPPING_STRING.mergeParentFirms.name())) {
        return new PresetCastTraxService().mergeParentFirms(presetRequest);
     }

	 if(request.requestURI.endsWith(URL_MAPPING_STRING.mergeContact.name())) {
        return new PresetCastTraxService().mergeContact(presetRequest);
     }  
     
     if(request.requestURI.endsWith(URL_MAPPING_STRING.moveContact.name())) {
        return new PresetCastTraxService().moveContact(presetRequest);
     }*/

    return null;
 }

 global class CashTraxResponse {
  public String errorMessage;
  public String errorStackTrace;
 }


}