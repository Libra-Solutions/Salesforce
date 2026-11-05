@isTest
private class PresetControllerTest {

 /*@isTest
 private static void testException(){
   //Test.startTest();
   RestRequest request = new RestRequest ();
   RestResponse response = new RestResponse ();
   request.requestUri = URL.getSalesforceBaseUrl() + '';
   System.debug(request.requestUri);
   request.httpMethod = 'POST';
   request.requestBody = Blob.valueOf('{"CRM_FirmID" : 343,"CRM_AttorneyID":"1234","AttorneyAssistantID":123,"AttorneyAssistantType":"Assistant","FirstName":"FirstName","LastName":"LastName","email":"test346@gmail.com","PhoneNumber":"1234567890","Fax"  : "3323232"}');
   RestContext.request = request;
   RestContext.response = response;
   PresetController.doPost();
   Test.stopTest();
 }*/

  @isTest
  private static void testCreateAttorneyAssistant(){
   //Test.startTest();
   RestRequest request = new RestRequest ();
   RestResponse response = new RestResponse ();
   request.requestUri = URL.getSalesforceBaseUrl() + '/services/apexrest/createAttorneyAssistant';
   System.debug(request.requestUri);
   request.httpMethod = 'POST';
   request.requestBody = Blob.valueOf('{"CRM_FirmID" : 343,"CRM_AttorneyID":"1234","AttorneyAssistantID":123,"AttorneyAssistantType":"Assistant","FirstName":"FirstName","LastName":"LastName","email":"test346@gmail.com","PhoneNumber":"1234567890","Fax"  : "3323232"}');
   RestContext.request = request;
   RestContext.response = response;
   PresetController.doPost();
   //Test.stopTest();
  
  }
  
  @isTest
  private static void testUpdateAttorneyAssistant(){
   //Test.startTest();
   RestRequest request = new RestRequest ();
   RestResponse response = new RestResponse ();
   request.requestUri = URL.getSalesforceBaseUrl() + '/services/apexrest/updateAttorneyAssistant';
   System.debug(request.requestUri);
   request.httpMethod = 'POST';
   request.requestBody = Blob.valueOf('{"CRM_FirmID" : 343,"CRM_AttorneyID":"0034B00000XbgA8QAJ","AttorneyAssistantID":123,"AttorneyAssistantType":"Assistant","FirstName":"FirstName","LastName":"LastName","email":"test346@gmail.com","PhoneNumber":"1234567890","Fax"  : "3323232"}');
   RestContext.request = request;
   RestContext.response = response;
   PresetController.doPost();
   //Test.stopTest();
  
  }
  
  @isTest
  private static void testCreateCTXAttorney(){
   //Test.startTest();
   RestRequest request = new RestRequest ();
   RestResponse response = new RestResponse ();
   request.requestUri = URL.getSalesforceBaseUrl() + '/services/apexrest/createCTXAttorney';
   System.debug(request.requestUri);
   request.httpMethod = 'POST';
   request.requestBody = Blob.valueOf('{"CRM_FirmID" : "0014B00000eRRbv","FirmName": "Prashant","FirstName": "Kumar Last","CTX_FirmID": 1234567,"LastName": "Test Last Name","MiddleName":"","Address1":"","Address2":"","City":"","State":"","Zip":"","DayPhone":"","Fax":"","Email":"","AttorneyID":123567,"Type":"Payer"}');
   RestContext.request = request;
   RestContext.response = response;
   PresetController.doPost();
   //Test.stopTest();
  
  }
  
  @isTest
  private static void testupdateCTXAttorney(){
   //Test.startTest();
   RestRequest request = new RestRequest ();
   RestResponse response = new RestResponse ();
   request.requestUri = URL.getSalesforceBaseUrl() + '/services/apexrest/updateCTXAttorney';
   System.debug(request.requestUri);
   request.httpMethod = 'POST';
   request.requestBody = Blob.valueOf('{"CRM_FirmID" : "0014B00000eRRbv","FirmName": "Prashant","FirstName": "Kumar Last","CTX_FirmID": 1234567,"LastName": "Test Last Name","MiddleName":"","Address1":"","Address2":"","City":"","State":"","Zip":"","DayPhone":"","Fax":"","Email":"","AttorneyID":123567,"Type":"Payer"}');
   RestContext.request = request;
   RestContext.response = response;
   PresetController.doPost();
   //Test.stopTest();
  
  }
  
  @isTest
  private static void testcreateCTXFirm(){
   //Test.startTest();
   RestRequest request = new RestRequest ();
   RestResponse response = new RestResponse ();
   request.requestUri = URL.getSalesforceBaseUrl() + '/services/apexrest/createCTXFirm';
   System.debug(request.requestUri);
   request.httpMethod = 'POST';
   request.requestBody = Blob.valueOf('{"CRM_FirmID" : "0014B00000eRRbv","FirmName": "Prashant","FirstName": "Kumar Last","CTX_FirmID": 1234567,"LastName": "Test Last Name","MiddleName":"","Address1":"","Address2":"","City":"","State":"","Zip":"","DayPhone":"","Fax":"","Email":"","AttorneyID":123567,"Type":"Payer"}');
   RestContext.request = request;
   RestContext.response = response;
   PresetController.doPost();
   //Test.stopTest();
  
  }
  
  @isTest
  private static void testupdateCTXFirm(){
   //Test.startTest();
   RestRequest request = new RestRequest ();
   RestResponse response = new RestResponse ();
   request.requestUri = URL.getSalesforceBaseUrl() + '/services/apexrest/updateCTXFirm';
   System.debug(request.requestUri);
   request.httpMethod = 'POST';
   request.requestBody = Blob.valueOf('{"CRM_FirmID" : "0014B00000eRRbv","FirmName": "Prashant","FirstName": "Kumar Last","CTX_FirmID": 1234567,"LastName": "Test Last Name","MiddleName":"","Address1":"","Address2":"","City":"","State":"","Zip":"","DayPhone":"","Fax":"","Email":"","AttorneyID":123567,"Type":"Payer"}');
   RestContext.request = request;
   RestContext.response = response;
   PresetController.doPost();
   //Test.stopTest();
  
  }
  
  @isTest
  private static void testcreateCTXFirmLocation(){
   //Test.startTest();
   RestRequest request = new RestRequest ();
   RestResponse response = new RestResponse ();
   request.requestUri = URL.getSalesforceBaseUrl() + '/services/apexrest/createCTXFirmLocation';
   System.debug(request.requestUri);
   request.httpMethod = 'POST';
   request.requestBody = Blob.valueOf('{"CRM_FirmID" : "0014B00000eRRbv","FirmName": "Prashant","FirstName": "Kumar Last","CTX_FirmID": 1234567,"LastName": "Test Last Name","MiddleName":"","Address1":"","Address2":"","City":"","State":"","Zip":"","DayPhone":"","Fax":"","Email":"","AttorneyID":123567,"Type":"Payer"}');
   RestContext.request = request;
   RestContext.response = response;
   PresetController.doPost();
   //Test.stopTest();
  
  }
  
  @isTest
  private static void testupdateCTXFirmLocation(){
   //Test.startTest();
   RestRequest request = new RestRequest ();
   RestResponse response = new RestResponse ();
   request.requestUri = URL.getSalesforceBaseUrl() + '/services/apexrest/updateCTXFirmLocation';
   System.debug(request.requestUri);
   request.httpMethod = 'POST';
   request.requestBody = Blob.valueOf('{"CRM_FirmID" : "0014B00000eRRbv","FirmName": "Prashant","FirstName": "Kumar Last","CTX_FirmID": 1234567,"LastName": "Test Last Name","MiddleName":"","Address1":"","Address2":"","City":"","State":"","Zip":"","DayPhone":"","Fax":"","Email":"","AttorneyID":123567,"Type":"Payer"}');
   RestContext.request = request;
   RestContext.response = response;
   PresetController.doPost();
   //Test.stopTest();
  
  }
  
  @isTest
  private static void testcreateActivities(){
   //Test.startTest();
   RestRequest request = new RestRequest ();
   RestResponse response = new RestResponse ();
   request.requestUri = URL.getSalesforceBaseUrl() + '/services/apexrest/fetchActivities';
   System.debug(request.requestUri);
   request.httpMethod = 'POST';
   request.requestBody = Blob.valueOf('{"CRMNoteID" : "Test","Attorney" : "Test" ,"Title" : "Test","NoteText" : "Law Firm" ,"OwnerName" : "Test","CreatedBy" : "Prashant","CreatedDate" : "2014-01-01T23:28:56.782Z"}');
   RestContext.request = request;
   RestContext.response = response;
   PresetController.doPost();
   //Test.stopTest();
  
  }
  
  @isTest
  private static void testcaseFunded(){
   //Test.startTest();
   RestRequest request = new RestRequest ();
   RestResponse response = new RestResponse ();
   request.requestUri = URL.getSalesforceBaseUrl() + '/services/apexrest/caseFunded';
   System.debug(request.requestUri);
   request.httpMethod = 'POST';
   request.requestBody = Blob.valueOf('{"plaintiffName" : "Test","caseNumber" : 10123 ,"amount" : 10.0,"CRM_FirmID" : "Test","CRM_FirmLocationID" : "Test","CRM_AttorneyID" : "Test"}');
   RestContext.request = request;
   RestContext.response = response;
   PresetController.doPost();
   //Test.stopTest();
  
  }
  
  @isTest
  private static void testcreateAttorneyNote(){
   //Test.startTest();
   RestRequest request = new RestRequest ();
   RestResponse response = new RestResponse ();
   request.requestUri = URL.getSalesforceBaseUrl() + '/services/apexrest/createAttorneyNote';
   System.debug(request.requestUri);
   request.httpMethod = 'POST';
   request.requestBody = Blob.valueOf('{"FirmID" : "1234fghj","FirmName" : "Test" ,"HeadQuarter" : true,"PhoneNumber" : "+19089787867" ,"Website" : "Hello.com","Fax" : "19089787867" }');
   RestContext.request = request;
   RestContext.response = response;
   PresetController.doPost();
   //Test.stopTest();
  
  }
    
     @isTest
  private static void testDeleteFirmInCRM(){
   //Test.startTest();
   RestRequest request = new RestRequest ();
   RestResponse response = new RestResponse ();
   request.requestUri = URL.getSalesforceBaseUrl() + '/services/apexrest/deleteFirmInCRM';
   System.debug(request.requestUri);
   request.httpMethod = 'POST';
   request.requestBody = Blob.valueOf('{"CRM_FirmID" : "0014B00000eRRbv","FirmName": "Prashant","FirstName": "Kumar Last","CTX_FirmID": 1234567,"LastName": "Test Last Name","MiddleName":"","Address1":"","Address2":"","City":"","State":"","Zip":"","DayPhone":"","Fax":"","Email":"","AttorneyID":123567,"Type":"Payer"}');
   RestContext.request = request;
   RestContext.response = response;
   PresetController.doPost();
   //Test.stopTest();
  
  }
    
     @isTest
  private static void testDeleteFirmLocation(){
   //Test.startTest();
   RestRequest request = new RestRequest ();
   RestResponse response = new RestResponse ();
   request.requestUri = URL.getSalesforceBaseUrl() + '/services/apexrest/deleteFirmLocation';
   System.debug(request.requestUri);
   request.httpMethod = 'POST';
   request.requestBody = Blob.valueOf('{"CRM_FirmID" : "0014B00000eRRbv","FirmName": "Prashant","FirstName": "Kumar Last","CTX_FirmID": 1234567,"LastName": "Test Last Name","MiddleName":"","Address1":"","Address2":"","City":"","State":"","Zip":"","DayPhone":"","Fax":"","Email":"","AttorneyID":123567,"Type":"Payer"}');
   RestContext.request = request;
   RestContext.response = response;
   PresetController.doPost();
   //Test.stopTest();
  
  }
  
  /*@isTest 
  private static void testfetchNotes(){
   //Date : 17 June 2019 : Unable to access the page
   Test.startTest();
   RestRequest request = new RestRequest ();
   RestResponse response = new RestResponse ();
   request.requestUri = URL.getSalesforceBaseUrl() + '/services/apexrest/fetchNotes';
   System.debug(request.requestUri);
   request.httpMethod = 'POST';
   request.requestBody = Blob.valueOf('{"CRM_FirmLocationID" : "Test","CRM_AttorneyID" : "Test" ,"count" : 1}');
   RestContext.request = request;
   RestContext.response = response;
   PresetController.doPost();
   Test.stopTest();
  
  }*/
  
  
  

}