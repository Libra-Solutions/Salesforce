@isTest
public class CommunicationCacheTest {

  @testSetup static void setUpData(){
    new CommunicationCache().cashtraxEndPoint = 'https://www.hhh.com';
    new CommunicationCache().medlienEndPoint = 'https://www.hhh.com';
    new CommunicationCache().cashtraxSecretToken = '2323ererer';
    new CommunicationCache().MLSecurityToken = '23eererer';
    PSCommunicationCache__c cache = new PSCommunicationCache__c();
    cache.GenericName__c = 'UpdateFirmLocation';
    cache.Operation__c = '/api/AttorneyFirm/UpdateFirmLocationToCTXUndo';
    cache.InputPayload__c = '{"ZipCode":"78730-2315","State":"TX","FirmLocationName":"*The Christensen Law Firm","FirmLocationID":65572,"FirmID":61514,"CRM_FirmLocationID":"0014B00000ezBrBQAU","CRM_FirmID":"0014B00000ez0ToQAI","City":"Austin","Address2":"Ste 102","Address1":"6615 Vaught Ranch Rd"}';
    cache.ResponseStatus__c = '200:Success';
    cache.ResponsePayload__c = '{"Status":"Success"}';
    insert cache;
    
  }
  
  testMethod static void testlogin(){
    Test.startTest();
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       new CommunicationCache().login();
     Test.stopTest();
    
  }
  
  testMethod static void testloginML(){
       new CommunicationCache().loginML();
  }
  
  
  
  
  testMethod static void testpushToCashtrax(){
    PSCommunicationCache__c cache = [select GenericName__c,Operation__c,InputPayload__c,ResponseStatus__c,ResponsePayload__c from PSCommunicationCache__c];
    
     Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        new CommunicationCache().pushToCashtrax(cache, 'sdsder2345', 'Start');
     Test.stopTest();
  }
  
  testMethod static void testAddCache(){
   PSCommunicationCache__c cache = new PSCommunicationCache__c();
    cache.GenericName__c = 'UpdateFirmLocation';
    cache.Operation__c = '/api/AttorneyFirm/UpdateFirmLocationToCTXUndo';
    cache.InputPayload__c = '{"ZipCode":"78730-2315","State":"TX","FirmLocationName":"*The Christensen Law Firm","FirmLocationID":65572,"FirmID":61514,"CRM_FirmLocationID":"0014B00000ezBrBQAU","CRM_FirmID":"0014B00000ez0ToQAI","City":"Austin","Address2":"Ste 102","Address1":"6615 Vaught Ranch Rd"}';
    cache.ResponseStatus__c = '200:Success';
    cache.ResponsePayload__c = '{"Status":"Success"}';
    new CommunicationCache().add(cache);
     
  }

  testMethod static void testdoPost(){
    PSCommunicationCache__c cache = [select GenericName__c,Operation__c,InputPayload__c,ResponseStatus__c,ResponsePayload__c from PSCommunicationCache__c];
    
     Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        new CommunicationCache().doPost('ddfrtg567', cache.Operation__c, cache.InputPayload__c, 'REALSTATE');
     Test.stopTest();
  }
  
  testMethod static void testdoGet(){
    PSCommunicationCache__c cache = [select GenericName__c,Operation__c,InputPayload__c,ResponseStatus__c,ResponsePayload__c from PSCommunicationCache__c];
    
     Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        new CommunicationCache().doGet('https://api.cashtrax.com/v1/send', cache.Operation__c);
     Test.stopTest();
  }
  
  


}