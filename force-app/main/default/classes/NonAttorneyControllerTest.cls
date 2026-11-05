@isTest
public class NonAttorneyControllerTest{

  @testSetup static void testDataSetup(){
    Contact cnt = new Contact(FirstName = 'First', LastName='Last', email='hitmprashant@gmail.com');
    insert cnt;
  }

  testMethod static void testgetPickValues(){
    NonAttorneyController.getPickValues('Account', 'AccountSource');
  }
  
  testMethod static void testsaveReocrds(){
    Contact cnt = [Select Id, email from Contact where email = 'hitmprashant@gmail.com'];
    String contact = JSON.serialize(cnt);

    NonAttorneyController.saveReocrds(contact, cnt.Id);
  }
  
  testMethod static void testsaveReocrds1(){
     Account act = new Account();
       act.name = 'test';
       act.CTXFirmId__c = '123dfg';
       act.AtticusId__c = '123fghd';
       act.GRSId__c = 1234.99;
       act.KeyMedsID__c = 123456;
       act.BillingStreet = 'Street';
       act.BillingCity = 'city';
       act.BillingState = 'LA';
       act.BillingPostalCode = '12345';
       insert act;
    Contact cnt1 = [Select Id from Contact where email = 'hitmprashant@gmail.com'];
    Contact cnt = new Contact();
    cnt.firstname = 'ddd';
    cnt.lastname = 'eee';
    cnt.accountId = act.Id;
    cnt.email = 'df@gmail.com';
    String contact = JSON.serialize(cnt);
    NonAttorneyController.saveReocrds(contact, cnt1.Id);
  }




}