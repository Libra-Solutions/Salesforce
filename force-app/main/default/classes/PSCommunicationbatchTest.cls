@isTest
public class PSCommunicationbatchTest {

 @testsetup static void dataSetup(){
     List<String> genericName = new List<String>{'CreateFirm','UpdateFirm', 'CreateAttorney', 'UpdateAttorney', 'CreateCase', 'CreateAttorneyAssistant','UpdateAttorneyAssistant'};
     List<PSCommunicationCache__c  > cacheLst = new List<PSCommunicationCache__c>();
       
       cacheLst.add(getValue('CreateFirm'));
       cacheLst.add(getValue('UpdateFirm'));
       cacheLst.add(getValue('CreateAttorney'));
       cacheLst.add(getValue('UpdateAttorney'));
       cacheLst.add(getValue('CreateCase'));
       cacheLst.add(getValue('CreateAttorneyAssistant'));
       cacheLst.add(getValue('UpdateAttorneyAssistant'));
       insert cacheLst;
       
     
 }
/*
 static testMethod void testMethod1(){
     List<PSCommunicationCache__c > cahceLts = [Select GenericName__c ,Operation__c,FailedRetries__c , InputPayload__c , ResponseStatus__c, ResponsePayload__c  from PSCommunicationCache__c where Operation__c ='/api/AttorneyFirm/UpdateFirmLocationToCTXUndo' ];
     Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Database.executeBatch(new PSCommunicationbatch());
     Test.stopTest();
 }*/
 
 static PSCommunicationCache__c getValue(String genericName){
    PSCommunicationCache__c cache = new PSCommunicationCache__c();
    cache.GenericName__c = genericName;
    cache.Operation__c = '/api/AttorneyFirm/UpdateFirmLocationToCTXUndo';
    cache.InputPayload__c = '{"ZipCode":"78730-2315","State":"TX","FirmLocationName":"*The Christensen Law Firm","FirmLocationID":65572,"FirmID":61514,"CRM_FirmLocationID":"0014M00001gbTin","CRM_FirmID":"0014M00001gbTin","City":"Austin","Address2":"Ste 102","Address1":"6615 Vaught Ranch Rd"}';
    cache.ResponseStatus__c = '200:Success';
    cache.ResponsePayload__c = '{"Status":"Success"}';
    cache.FailedRetries__c = 2;
    return cache;
 }
 
 static testMethod void getCashTraxFirmId(){
    String inputPayload = '{"ZipCode":"78730-2315","State":"TX","FirmLocationName":"*The Christensen Law Firm","FirmLocationID":65572,"FirmID":61514,"CRM_FirmLocationID":"0014M00001gbTin","CRM_FirmID":"0014M00001gbTin","City":"Austin","Address2":"Ste 102","Address1":"6615 Vaught Ranch Rd"}';
    PSCommunicationbatch.getCashTraxFirmId(inputPayload);
 }
 
 static testMethod void testgetCashTraxFirmId(){
    List<String> genericName = new List<String>{'CreateFirm','UpdateFirm', 'CreateAttorney', 'UpdateAttorney', 'CreateCase', 'CreateAttorneyAssistant','UpdateAttorneyAssistant'};
    String inputPayload = '{"ZipCode":"78730-2315","State":"TX","FirmLocationName":"*The Christensen Law Firm","FirmLocationID":65572,"FirmID":61514,"CRM_FirmLocationID":"0014M00001gbTin","CRM_FirmID":"0014M00001gbTin","City":"Austin","Address2":"Ste 102","Address1":"6615 Vaught Ranch Rd"}';
    for(String oprationName: genericName) {
       PSCommunicationbatch.getCashTraxFirmId(inputPayload, oprationName);
      }
 }
 


}