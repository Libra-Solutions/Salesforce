@isTest
private class MedlienSalesforceControllerTest {

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
   //RestContext.response = response;
   MedlienSalesforceController.doPost();
   //Test.stopTest();
 }*/

  
  @isTest
  private static void testcreateCTXFirm(){
   //Test.startTest();
   RestRequest request = new RestRequest ();
   RestResponse response = new RestResponse ();
   request.requestUri = URL.getSalesforceBaseUrl() + '/services/apexrest/createFirm';
   System.debug(request.requestUri);
   request.httpMethod = 'POST';
   request.requestBody = Blob.valueOf('{"CRM_FirmID" : "0014B00000eRRbv","FirmName": "Prashant","FirstName": "Kumar Last","CTX_FirmID": 1234567,"LastName": "Test Last Name","MiddleName":"","Address1":"","Address2":"","City":"","State":"","Zip":"","DayPhone":"","Fax":"","Email":"","AttorneyID":123567,"Type":"Payer"}');
   RestContext.request = request;
   RestContext.response = response;
   MedlienSalesforceController.doPost();
   //Test.stopTest();
  
  }
  
  @isTest
  private static void testupdateCTXFirm(){
   //Test.startTest();
   RestRequest request = new RestRequest ();
   RestResponse response = new RestResponse ();
   request.requestUri = URL.getSalesforceBaseUrl() + '/services/apexrest/updateFirm';
   System.debug(request.requestUri);
   request.httpMethod = 'POST';
   request.requestBody = Blob.valueOf('{"CRM_FirmID" : "0014B00000eRRbv","FirmName": "Prashant","FirstName": "Kumar Last","CTX_FirmID": 1234567,"LastName": "Test Last Name","MiddleName":"","Address1":"","Address2":"","City":"","State":"","Zip":"","DayPhone":"","Fax":"","Email":"","AttorneyID":123567,"Type":"Payer"}');
   RestContext.request = request;
   RestContext.response = response;
   MedlienSalesforceController.doPost();
   //Test.stopTest();
  
  }
  
  @isTest
  private static void testcreateCTXFirmLocation(){
   //Test.startTest();
   RestRequest request = new RestRequest ();
   RestResponse response = new RestResponse ();
   request.requestUri = URL.getSalesforceBaseUrl() + '/services/apexrest/createFirmLocation';
   System.debug(request.requestUri);
   request.httpMethod = 'POST';
   request.requestBody = Blob.valueOf('{"CRM_FirmID" : "0014B00000eRRbv","FirmName": "Prashant","FirstName": "Kumar Last","CTX_FirmID": 1234567,"LastName": "Test Last Name","MiddleName":"","Address1":"","Address2":"","City":"","State":"","Zip":"","DayPhone":"","Fax":"","Email":"","AttorneyID":123567,"Type":"Payer"}');
   RestContext.request = request;
   RestContext.response = response;
   MedlienSalesforceController.doPost();
   //Test.stopTest();
  
  }
  
  @isTest
  private static void testupdateCTXFirmLocation(){
   //Test.startTest();
   RestRequest request = new RestRequest ();
   RestResponse response = new RestResponse ();
   request.requestUri = URL.getSalesforceBaseUrl() + '/services/apexrest/updateFirmLocation';
   System.debug(request.requestUri);
   request.httpMethod = 'POST';
   request.requestBody = Blob.valueOf('}');
   RestContext.request = request;
   RestContext.response = response;
   MedlienSalesforceController.doPost();
   //Test.stopTest();
  
  }
  
  @isTest
  private static void testcreateContact(){
   //Test.startTest();
   RestRequest request = new RestRequest ();
   RestResponse response = new RestResponse ();
   request.requestUri = URL.getSalesforceBaseUrl() + '/services/apexrest/createContact';
   System.debug(request.requestUri);
   request.httpMethod = 'POST';
   request.requestBody = Blob.valueOf('{"CRM_ContactID": "123ert","ContactID_KM": 12567,"ContactID_AT": "der4567", "ContactID_GL": 127890, "FirstName": "test", "LastName":"test", "MiddleName":"test", "Email": "test@gmail.com","PhoneNumber":"9560682173", "Fax":"9560682173", "Birthday":"2014-01-01T23:28:56.782Z", "ContactInformation":"Hello","Type":"test","PreferredContactPhone":true,"PreferredContactFax": true,"PreferredContactEmail: true,"DoNotContactPhone": false,"DoNotContactFax": false,"DoNotContactEmail":false,"IsActive": true,"Suffix": "test"}');
   RestContext.request = request;
   RestContext.response = response;
   MedlienSalesforceController.doPost();
   //Test.stopTest();
  
  }
  
  
  @isTest
  private static void testupdateContact(){
   //Test.startTest();
   RestRequest request = new RestRequest ();
   RestResponse response = new RestResponse ();
   request.requestUri = URL.getSalesforceBaseUrl() + '/services/apexrest/updateContact';
   System.debug(request.requestUri);
   request.httpMethod = 'POST';
   request.requestBody = Blob.valueOf('{"CRM_ContactID": "123ert","ContactID_KM": 12567,"ContactID_AT": "der4567", "ContactID_GL": 127890, "FirstName": "test", "LastName":"test", "MiddleName":"test", "Email": "test@gmail.com","PhoneNumber":"9560682173", "Fax":"9560682173", "Birthday":"2014-01-01T23:28:56.782Z", "ContactInformation":"Hello","Type":"test","PreferredContactPhone":true,"PreferredContactFax": true,"PreferredContactEmail: true,"DoNotContactPhone": false,"DoNotContactFax": false,"DoNotContactEmail":false,"IsActive": true,"Suffix": "test"}');
   RestContext.request = request;
   RestContext.response = response;
   MedlienSalesforceController.doPost();
   //Test.stopTest();
  
  }
    
     @isTest
  private static void testErrorContact(){
   //Test.startTest();
   RestRequest request = new RestRequest ();
   RestResponse response = new RestResponse ();
   request.requestUri = URL.getSalesforceBaseUrl() + '/services/apexrest/updateContact';
   System.debug(request.requestUri);
   RestContext.request = request;
   RestContext.response = response;
   MedlienSalesforceController.doPost();
   //Test.stopTest();
  
  }
  
  
  
  

}