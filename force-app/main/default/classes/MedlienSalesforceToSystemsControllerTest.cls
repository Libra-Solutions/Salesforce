@isTest
public class MedlienSalesforceToSystemsControllerTest{

  @testSetup static void dataSetup(){
    
    Account act = new Account();
       //act.ParentId = '00300000003T2PGAA0';
       //act.HeadQuarter__c = true;
       act.GRSId__c = 123456;
       act.KeyMedsID__c = 44444444 ;
       act.AtticusId__c = 'wewewe4444';
       act.Name = 'ssfdf';
       act.Street2__c = 'erer4545';
       act.BillingStreet = 'erer4545';
       act.BillingCity = 'CA';
       act.BillingState = 'TX';
       act.BillingPostalCode = '123ER';
       act.BillingCountry = 'United States';
       act.Phone = '9560682173';
       act.Fax = '9560682173';
       act.Website = 'https://www.google.com';
       act.type = 'Payor';
       insert act;
       
       Account act1 = new Account();
       //act.ParentId = '00300000003T2PGAA0';
       act1 .HeadQuarter__c = true;
       act1 .GRSId__c = 123456;
       act1.KeyMedsID__c = 44444444 ;
       act1.AtticusId__c = 'wewewe4444';
       act1.Name = 'titu';
       act1.Street2__c = 'erer4545';
       act1.BillingStreet = '';
       act1.BillingCity = '';
       act1.BillingState = '';
       act1.BillingPostalCode = '';
       act1.BillingCountry = '';
       act1.Phone = '9560682173';
       act1.Fax = '9560682173';
       act1.Website = 'https://www.google.com';
       act1.type = 'Payor';
       insert act1;
       
       Contact cnt = new Contact();
       cnt.firstname = 'first';
       cnt.lastname = 'last';
       cnt.AccountId = act.Id ;
       cnt.Role__c ='Paralegal';
       cnt.Email = 'hitmprashant@gmail.com';
       cnt.Phone = '9560682173';
       cnt.Fax = '9560682173';
       cnt.BirthDate = Date.newInstance(2000, 09, 09);
       cnt.ContactInstructions__c = 'fff';
       cnt.Preferred_Contact_Phone__c = true;
       cnt.Preferred_Contact_Fax__c = true;
       cnt.Preferred_Contact_Email__c = true;
       cnt.DoNotCall = true;
       cnt.HasOptedOutOfFax = true;
       cnt.HasOptedOutOfEmail = true;
       cnt.IsActive__C = true;
       cnt.Salutation = 'Mr';

       insert cnt;
       
       Account_Relation__c actRel= new Account_Relation__c();
       
       actRel.Role__c = 'Attorney' ;
       actRel.Contact__c = cnt.Id ;
       actRel.Account__c = act.Id ;
       actRel.KeyMedsID__c = '1111';
       actRel.AtticusId__c = '111' ;
       actRel.GRSId__c = '2222';
       List<Account_Relation__c > actLst = new List<Account_Relation__c >();
       actLst.add(actRel);
       insert actLst;
  }
  
  /*testMethod static void testMedlienSyncSystemsForProvider(){
    Id id = Id.valueOf('123erty');
    Test.startTest();
    MedlienSalesforceToSystemsController.MedlienSyncSystemsForProvider(id);
    Test.stopTest();
  }*/
  
  testMethod static void testMedlienSyncSystemsForProvider1(){
   Account act = new Account();
       //act.ParentId = '00300000003T2PGAA0';
       act.HeadQuarter__c = true;
       act.GRSId__c = 123456;
       act.KeyMedsID__c = 44444444 ;
       act.AtticusId__c = 'wewewe4444';
       act.Name = 'ssfdf';
       act.Street2__c = 'erer4545';
       act.BillingStreet = 'erer4545';
       act.BillingCity = 'CA';
       act.BillingState = 'TX';
       act.BillingPostalCode = '123ER';
       act.BillingCountry = 'United States';
       act.Phone = '9560682173';
       act.Fax = '9560682173';
       act.Website = 'https://www.google.com';
       act.type = 'Payor';
       insert act;
       
       Contact cnt = new Contact();
       cnt.firstname = 'first1';
       cnt.lastname = 'last';
       cnt.AccountId = act.Id ;
       cnt.Role__c ='Paralegal';
       cnt.Email = 'hitmprashant1@gmail.com';
       cnt.Phone = '9560682173';
       cnt.Fax = '9560682173';
       cnt.BirthDate = Date.newInstance(2000, 09, 09);
       cnt.ContactInstructions__c = 'fff';
       cnt.Preferred_Contact_Phone__c = true;
       cnt.Preferred_Contact_Fax__c = true;
       cnt.Preferred_Contact_Email__c = true;
       cnt.DoNotCall = true;
       cnt.HasOptedOutOfFax = true;
       cnt.HasOptedOutOfEmail = true;
       cnt.IsActive__C = true;
       cnt.Salutation = 'Mr';

       insert cnt;
       
       Account_Relation__c actRel= new Account_Relation__c();
       
       actRel.Role__c = 'Attorney' ;
       actRel.Contact__c = cnt.Id ;
       actRel.Account__c = act.Id ;
       
       List<Account_Relation__c > actLst = new List<Account_Relation__c >();
       actLst.add(actRel);
       insert actLst;

       
       Non_Attorney_Contact__c nonAttorney = new Non_Attorney_Contact__c();
       nonAttorney.Role__c = 'Paralegal';
       //nonAttorney.Contact__c = cnt.Id;
       nonAttorney.Firm_Name__c = act.Id;
       //nonAttorney.KeyMedsID__c = 111;
       //nonAttorney.GRSId__c = 11;
       //nonAttorney.AtticusId__c = 'eee';
       nonAttorney.Role__c = 'Paralegal';
              
       insert nonAttorney;
       Test.startTest();       
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       MedlienSalesforceToSystemsController.MedlienSyncSystemsForProvider(act.id);
       Test.stopTest();
 }
  
  testMethod static void testMedlienSyncSystemsForProvider11(){
       Account pact = new Account();
       //act.ParentId = '00300000003T2PGAA0';
       pact.HeadQuarter__c = true;    
       pact.GRSId__c = 123456;
       pact.KeyMedsID__c = 44444444 ;
       pact.AtticusId__c = 'wewewe4444';   
       pact.Name = 'Test Account';
       pact.Street2__c = 'erer4545';
       pact.BillingStreet = 'erer4545';
       pact.BillingCity = 'CA';
       pact.BillingState = 'TX';
       pact.BillingPostalCode = '123ER';
       pact.BillingCountry = 'United States';
       pact.Phone = '9560682173';
       pact.Fax = '9560682173';
       pact.Website = 'https://www.google.com';
       pact.type = 'Payor';
       insert pact;
       Account act = new Account();
       act.ParentId = pact.id;
       act.Name = 'Test Account2';
       act.Street2__c = 'erer4545';
       act.BillingStreet = 'erer4545';
       act.BillingCity = 'CA';
       act.BillingState = 'TX';
       act.BillingPostalCode = '123ER';
       act.BillingCountry = 'United States';
       act.Phone = '9560682173';
       act.Fax = '9560682173';
       act.Website = 'https://www.google.com';
       act.type = 'Payor';
       insert act;
       
       Contact cnt = new Contact();
       cnt.firstname = 'first1';
       cnt.lastname = 'last';
       cnt.AccountId = act.Id ;
       cnt.Role__c ='Paralegal';
       cnt.Email = 'hitmprashant1@gmail.com';
       cnt.Phone = '9560682173';
       cnt.Fax = '9560682173';
       cnt.BirthDate = Date.newInstance(2000, 09, 09);
       cnt.ContactInstructions__c = 'fff';
       cnt.Preferred_Contact_Phone__c = true;
       cnt.Preferred_Contact_Fax__c = true;
       cnt.Preferred_Contact_Email__c = true;
       cnt.DoNotCall = true;
       cnt.HasOptedOutOfFax = true;
       cnt.HasOptedOutOfEmail = true;
       cnt.IsActive__C = true;
       cnt.Salutation = 'Mr';

       insert cnt;
       
       Account_Relation__c actRel= new Account_Relation__c();
       
       actRel.Role__c = 'Attorney' ;
       actRel.Contact__c = cnt.Id ;
       actRel.Account__c = act.Id ;
       actRel.KeyMedsID__c = '1111';
       actRel.AtticusId__c = '111' ;
       actRel.GRSId__c = '2222';
       List<Account_Relation__c > actLst = new List<Account_Relation__c >();
       actLst.add(actRel);
       insert actLst;

       
       Non_Attorney_Contact__c nonAttorney = new Non_Attorney_Contact__c();
       nonAttorney.Role__c = 'Paralegal';
       //nonAttorney.Contact__c = cnt.Id;
       nonAttorney.Firm_Name__c = act.Id;
       nonAttorney.KeyMedsID__c = 111;
       nonAttorney.GRSId__c = 11;
       nonAttorney.AtticusId__c = 'eee';
       nonAttorney.Role__c = 'Paralegal';
              
       insert nonAttorney;
       Test.startTest();       
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       MedlienSalesforceToSystemsController.MedlienSyncSystemsForProvider(act.id);
       Test.stopTest();
 }
  testMethod static void testMedlienSyncSystemsForProvider12(){
       Account pact = new Account();
       //act.ParentId = '00300000003T2PGAA0';
       pact.HeadQuarter__c = true;    
       //pact.GRSId__c = 123456;
       //pact.KeyMedsID__c = 44444444 ;
       //pact.AtticusId__c = 'wewewe4444';   
       pact.Name = 'Test Account';
       pact.Street2__c = 'erer4545';
       pact.BillingStreet = 'erer4545';
       pact.BillingCity = 'CA';
       pact.BillingState = 'TX';
       pact.BillingPostalCode = '123ER';
       pact.BillingCountry = 'United States';
       pact.Phone = '9560682173';
       pact.Fax = '9560682173';
       pact.Website = 'https://www.google.com';
       pact.type = 'Payor';
       insert pact;
       Account act = new Account();
       act.ParentId = pact.id;
       act.Name = 'Test Account2';
       act.Street2__c = 'erer4545';
       act.BillingStreet = 'erer4545';
       act.BillingCity = 'CA';
       act.BillingState = 'TX';
       act.BillingPostalCode = '123ER';
       act.BillingCountry = 'United States';
       act.Phone = '9560682173';
       act.Fax = '9560682173';
       act.Website = 'https://www.google.com';
       act.type = 'Payor';
       insert act;
       
       Contact cnt = new Contact();
       cnt.firstname = 'first1';
       cnt.lastname = 'last';
       cnt.AccountId = act.Id ;
       cnt.Role__c ='Paralegal';
       cnt.Email = 'hitmprashant1@gmail.com';
       cnt.Phone = '9560682173';
       cnt.Fax = '9560682173';
       cnt.BirthDate = Date.newInstance(2000, 09, 09);
       cnt.ContactInstructions__c = 'fff';
       cnt.Preferred_Contact_Phone__c = true;
       cnt.Preferred_Contact_Fax__c = true;
       cnt.Preferred_Contact_Email__c = true;
       cnt.DoNotCall = true;
       cnt.HasOptedOutOfFax = true;
       cnt.HasOptedOutOfEmail = true;
       cnt.IsActive__C = true;
       cnt.Salutation = 'Mr';

       insert cnt;
       
       Account_Relation__c actRel= new Account_Relation__c();
       
       actRel.Role__c = 'Attorney' ;
       actRel.Contact__c = cnt.Id ;
       actRel.Account__c = act.Id ;
       actRel.KeyMedsID__c = '1111';
       actRel.AtticusId__c = '111' ;
       actRel.GRSId__c = '2222';
       List<Account_Relation__c > actLst = new List<Account_Relation__c >();
       actLst.add(actRel);
       insert actLst;

       
       Non_Attorney_Contact__c nonAttorney = new Non_Attorney_Contact__c();
       nonAttorney.Role__c = 'Paralegal';
       //nonAttorney.Contact__c = cnt.Id;
       nonAttorney.Firm_Name__c = act.Id;
       nonAttorney.KeyMedsID__c = 111;
       nonAttorney.GRSId__c = 11;
       nonAttorney.AtticusId__c = 'eee';
       nonAttorney.Role__c = 'Paralegal';
              
       insert nonAttorney;
       Test.startTest();       
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       MedlienSalesforceToSystemsController.MedlienSyncSystemsForProvider(act.id);
       Test.stopTest();
 }
  testMethod static void testMedlienSyncSystems12(){
   Account act = new Account();
       //act.ParentId = '0014B00000eQDXcQAO';
       act.HeadQuarter__c = true;
       act.GRSId__c = 123456;
       act.KeyMedsID__c = 44444444 ;
       act.AtticusId__c = 'wewewe4444';
       act.Name = 'ssfdf';
       act.Street2__c = '';
       act.BillingStreet = '';
       act.BillingCity = '';
       act.BillingState = '';
       act.BillingPostalCode = '';
       act.BillingCountry = '';
       act.Phone = '9560682173';
       act.Fax = '9560682173';
       act.Website = 'https://www.google.com';
       act.type = 'Payor';
      
       insert act;
       
       Contact cnt = new Contact();
       cnt.firstname = 'first1';
       cnt.lastname = 'last';
       cnt.AccountId = act.Id ;
       cnt.Role__c ='Paralegal';
       cnt.Email = 'hitmprashant1@gmail.com';
       cnt.Phone = '9560682173';
       cnt.Fax = '9560682173';
       cnt.BirthDate = Date.newInstance(2000, 09, 09);
       cnt.ContactInstructions__c = 'fff';
       cnt.Preferred_Contact_Phone__c = true;
       cnt.Preferred_Contact_Fax__c = true;
       cnt.Preferred_Contact_Email__c = true;
       cnt.DoNotCall = true;
       cnt.HasOptedOutOfFax = true;
       cnt.HasOptedOutOfEmail = true;
       cnt.IsActive__C = true;
       cnt.Salutation = 'Mr';

       insert cnt;
       
       Account_Relation__c actRel= new Account_Relation__c();
       
       actRel.Role__c = 'Attorney' ;
       actRel.Contact__c = cnt.Id ;
       actRel.Account__c = act.Id ;
       actRel.KeyMedsID__c = '1111';
       actRel.AtticusId__c = '111' ;
       actRel.GRSId__c = '2222';
       List<Account_Relation__c > actLst = new List<Account_Relation__c >();
       actLst.add(actRel);
       insert actLst;

       
       Non_Attorney_Contact__c nonAttorney = new Non_Attorney_Contact__c();
       nonAttorney.Role__c = 'Paralegal';
       //nonAttorney.Contact__c = cnt.Id;
       nonAttorney.Firm_Name__c = act.Id;
       nonAttorney.KeyMedsID__c = 111;
       nonAttorney.GRSId__c = 11;
       nonAttorney.AtticusId__c = 'eee';
       nonAttorney.Role__c = 'Paralegal';
              
       insert nonAttorney;
       Test.startTest();       
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       MedlienSalesforceToSystemsController.MedlienSyncSystems(act.id);
       Test.stopTest();
 }
  
  testMethod static void testMedlienSyncSystems(){
    Account act = [Select Id from Account where Name = 'ssfdf'];
    MedlienSalesforceToSystemsController.MedlienSyncSystems(act.id);
  }
  
  testMethod static void testMedlienSyncSystems1(){
    Account act = [Select Id from Account where Name = 'titu'];
    MedlienSalesforceToSystemsController.MedlienSyncSystems(act.id);
  }

   testMethod static void testContactData(){
   MedlienSalesforceToSystemsController.ContactData sfEnt = new MedlienSalesforceToSystemsController.ContactData();
   sfEnt.CTX_AttorneyID= '1234ert';
   sfEnt.relation = new Account_Relation__c();
   sfEnt.cache = new PSCommunicationCache__c();
   sfEnt.resp = new Map<String,Object>();
   sfEnt.ContactID_KM = 111 ;
   sfEnt.ContactID_AT = '222';
   sfEnt.ContactID_GL = 222;
   
   System.assertNotEquals(null, sfEnt.CTX_AttorneyID);
   System.assertEquals(new Account_Relation__c(), sfEnt.relation );
   System.assertEquals(new PSCommunicationCache__c(), sfEnt.cache);
   System.assertEquals(new Map<String,Object>(), sfEnt.resp);
   System.assertNotEquals(0, sfEnt.ContactID_KM);
   System.assertNotEquals(null, sfEnt.ContactID_AT );
   System.assertNotEquals(0, sfEnt.ContactID_GL );
   
 
 }
 
 testMethod static void testContactAssttData(){
   MedlienSalesforceToSystemsController.ContactAssttData sfEnt = new MedlienSalesforceToSystemsController.ContactAssttData();
   sfEnt.CTX_AttorneyID= '1234ert';
   sfEnt.relation = new Non_Attorney_Contact__c();
   sfEnt.cache = new PSCommunicationCache__c();
   sfEnt.resp = new Map<String,Object>();
   sfEnt.ContactID_KM = 111 ;
   sfEnt.ContactID_AT = '222';
   sfEnt.ContactID_GL = 222;
   
   System.assertNotEquals(null, sfEnt.CTX_AttorneyID);
   System.assertEquals(new Non_Attorney_Contact__c(), sfEnt.relation );
   System.assertEquals(new PSCommunicationCache__c(), sfEnt.cache);
   System.assertEquals(new Map<String,Object>(), sfEnt.resp);
   System.assertNotEquals(0, sfEnt.ContactID_KM);
   System.assertNotEquals(null, sfEnt.ContactID_AT );
   System.assertNotEquals(0, sfEnt.ContactID_GL );
   
 
 }
 
 
 testMethod static void testFirmData(){
   MedlienSalesforceToSystemsController.FirmData sfEnt = new MedlienSalesforceToSystemsController.FirmData();
   sfEnt.CTX_FirmId = '1234ert';
   sfEnt.acc = new Account();
   sfEnt.cache = new PSCommunicationCache__c();
   sfEnt.resp = new Map<String,Object>();
   sfEnt.HQ = true ;
   sfEnt.FirmID_KM= 111 ;
   sfEnt.FirmID_AT = '222';
   sfEnt.FirmID_GL = 222;
   
   System.assertNotEquals(null, sfEnt.CTX_FirmId );
   System.assertEquals(new Account(), sfEnt.acc );
   System.assertEquals(new PSCommunicationCache__c(), sfEnt.cache);
   System.assertEquals(new Map<String,Object>(), sfEnt.resp);
   System.assertEquals(true , sfEnt.HQ);
   System.assertNotEquals(0, sfEnt.FirmID_KM);
   System.assertNotEquals(null, sfEnt.FirmID_AT );
   System.assertNotEquals(0, sfEnt.FirmID_GL);
   
 
 }
 
 testMethod static void testRemoveNull(){
   List<String> lst = new List<String>{'test', '', null};
   for(String val : lst) {
    MedlienSalesforceToSystemsController.removeNull(val);
   }
 }
 
 testMethod static void testUpdateAttorneyMl(){
   Account act = new Account();
       //act.ParentId = '00300000003T2PGAA0';
       act.HeadQuarter__c = true;
       act.GRSId__c = 123456;
       act.KeyMedsID__c = 44444444 ;
       act.AtticusId__c = 'wewewe4444';
       act.Name = 'ssfdf';
       act.Street2__c = 'erer4545';
       act.BillingStreet = 'erer4545';
       act.BillingCity = 'CA';
       act.BillingState = 'TX';
       act.BillingPostalCode = '123ER';
       act.BillingCountry = 'United States';
       act.Phone = '9560682173';
       act.Fax = '9560682173';
       act.Website = 'https://www.google.com';
       act.type = 'Payor';
       insert act;
       
       Contact cnt = new Contact();
       cnt.firstname = 'first1';
       cnt.lastname = 'last';
       cnt.AccountId = act.Id ;
       cnt.Role__c ='Paralegal';
       cnt.Email = 'hitmprashant1@gmail.com';
       cnt.Phone = '9560682173';
       cnt.Fax = '9560682173';
       cnt.BirthDate = Date.newInstance(2000, 09, 09);
       cnt.ContactInstructions__c = 'fff';
       cnt.Preferred_Contact_Phone__c = true;
       cnt.Preferred_Contact_Fax__c = true;
       cnt.Preferred_Contact_Email__c = true;
       cnt.DoNotCall = true;
       cnt.HasOptedOutOfFax = true;
       cnt.HasOptedOutOfEmail = true;
       cnt.IsActive__C = true;
       cnt.Salutation = 'Mr';

       insert cnt;
       
       Account_Relation__c actRel= new Account_Relation__c();
       
       actRel.Role__c = 'Attorney' ;
       actRel.Contact__c = cnt.Id ;
       actRel.Account__c = act.Id ;
       actRel.KeyMedsID__c = '1111';
       actRel.AtticusId__c = '111' ;
       actRel.GRSId__c = '2222';
       List<Account_Relation__c > actLst = new List<Account_Relation__c >();
       actLst.add(actRel);
       insert actLst;
       Test.startTest();
       
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       MedlienSalesforceToSystemsController.UpdateAttorneyML(cnt, actRel, 'LawFirm', 1.2, '222', 3.3);
       Test.stopTest();
 }
 
 testMethod static void testUpdateAttorneyAssistantML(){
   Account act = new Account();
       //act.ParentId = '00300000003T2PGAA0';
       act.HeadQuarter__c = true;
       act.GRSId__c = 123456;
       act.KeyMedsID__c = 44444444 ;
       act.AtticusId__c = 'wewewe4444';
       act.Name = 'ssfdf';
       act.Street2__c = 'erer4545';
       act.BillingStreet = 'erer4545';
       act.BillingCity = 'CA';
       act.BillingState = 'TX';
       act.BillingPostalCode = '123ER';
       act.BillingCountry = 'United States';
       act.Phone = '9560682173';
       act.Fax = '9560682173';
       act.Website = 'https://www.google.com';
       act.type = 'Payor';
       insert act;
       
       Contact cnt = new Contact();
       cnt.firstname = 'first1';
       cnt.lastname = 'last';
       cnt.AccountId = act.Id ;
       cnt.Role__c ='Paralegal';
       cnt.Email = 'hitmprashant1@gmail.com';
       cnt.Phone = '9560682173';
       cnt.Fax = '9560682173';
       cnt.BirthDate = Date.newInstance(2000, 09, 09);
       cnt.ContactInstructions__c = 'fff';
       cnt.Preferred_Contact_Phone__c = true;
       cnt.Preferred_Contact_Fax__c = true;
       cnt.Preferred_Contact_Email__c = true;
       cnt.DoNotCall = true;
       cnt.HasOptedOutOfFax = true;
       cnt.HasOptedOutOfEmail = true;
       cnt.IsActive__C = true;
       cnt.Salutation = 'Mr';

       insert cnt;
       
       Account_Relation__c actRel= new Account_Relation__c();
       
       actRel.Role__c = 'Attorney' ;
       actRel.Contact__c = cnt.Id ;
       actRel.Account__c = act.Id ;
       actRel.KeyMedsID__c = '1111';
       actRel.AtticusId__c = '111' ;
       actRel.GRSId__c = '2222';
       List<Account_Relation__c > actLst = new List<Account_Relation__c >();
       actLst.add(actRel);
       insert actLst;

       
       Non_Attorney_Contact__c nonAttorney = new Non_Attorney_Contact__c();
       nonAttorney.Role__c = 'Paralegal';
       //nonAttorney.Contact__c = cnt.Id;
       nonAttorney.Firm_Name__c = act.Id;
       nonAttorney.KeyMedsID__c = 111;
       nonAttorney.GRSId__c = 11;
       nonAttorney.AtticusId__c = 'eee';
       nonAttorney.Role__c = 'Paralegal';
              
       insert nonAttorney;
       Test.startTest();       
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       MedlienSalesforceToSystemsController.UpdateAttorneyAssistantML(cnt, nonAttorney, 'LawFirm', 1.2, '222', 3.3);
       Test.stopTest();
 }
 
 testMethod static void testUpdateContactML(){
   Account act = new Account();
       //act.ParentId = '00300000003T2PGAA0';
       act.HeadQuarter__c = true;
       act.GRSId__c = 123456;
       act.KeyMedsID__c = 44444444 ;
       act.AtticusId__c = 'wewewe4444';
       act.Name = 'ssfdf';
       act.Street2__c = 'erer4545';
       act.BillingStreet = 'erer4545';
       act.BillingCity = 'CA';
       act.BillingState = 'TX';
       act.BillingPostalCode = '123ER';
       act.BillingCountry = 'United States';
       act.Phone = '9560682173';
       act.Fax = '9560682173';
       act.Website = 'https://www.google.com';
       act.type = 'Payor';
       insert act;
       
       Contact cnt = new Contact();
       cnt.firstname = 'first1';
       cnt.lastname = 'last';
       cnt.AccountId = act.Id ;
       cnt.Role__c ='Paralegal';
       cnt.Email = 'hitmprashant1@gmail.com';
       cnt.Phone = '9560682173';
       cnt.Fax = '9560682173';
       cnt.BirthDate = Date.newInstance(2000, 09, 09);
       cnt.ContactInstructions__c = 'fff';
       cnt.Preferred_Contact_Phone__c = true;
       cnt.Preferred_Contact_Fax__c = true;
       cnt.Preferred_Contact_Email__c = true;
       cnt.DoNotCall = true;
       cnt.HasOptedOutOfFax = true;
       cnt.HasOptedOutOfEmail = true;
       cnt.IsActive__C = true;
       cnt.Salutation = 'Mr';

       insert cnt;
       
       Account_Relation__c actRel= new Account_Relation__c();
       
       actRel.Role__c = 'Attorney' ;
       actRel.Contact__c = cnt.Id ;
       actRel.Account__c = act.Id ;
       actRel.KeyMedsID__c = '1111';
       actRel.AtticusId__c = '111' ;
       actRel.GRSId__c = '2222';
       List<Account_Relation__c > actLst = new List<Account_Relation__c >();
       actLst.add(actRel);
       insert actLst;

       
       Non_Attorney_Contact__c nonAttorney = new Non_Attorney_Contact__c();
       nonAttorney.Role__c = 'Paralegal';
       //nonAttorney.Contact__c = cnt.Id;
       nonAttorney.Firm_Name__c = act.Id;
       nonAttorney.KeyMedsID__c = 111;
       nonAttorney.GRSId__c = 11;
       nonAttorney.AtticusId__c = 'eee';
       nonAttorney.Role__c = 'Paralegal';
              
       insert nonAttorney;
       Test.startTest();       
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        //MedlienSalesforceToSystemsController.UpdateContactML(cnt.Id, nonAttorney.Id);
       Test.stopTest();
 }
 
 testMethod static void testUpdateContactML1(){
   Account act = new Account();
       //act.ParentId = '00300000003T2PGAA0';
       act.HeadQuarter__c = true;
       act.GRSId__c = 123456;
       act.KeyMedsID__c = 44444444 ;
       act.AtticusId__c = 'wewewe4444';
       act.Name = 'ssfdf';
       act.Street2__c = 'erer4545';
       act.BillingStreet = 'erer4545';
       act.BillingCity = 'CA';
       act.BillingState = 'TX';
       act.BillingPostalCode = '123ER';
       act.BillingCountry = 'United States';
       act.Phone = '9560682173';
       act.Fax = '9560682173';
       act.Website = 'https://www.google.com';
       act.type = 'Payor';
       insert act;
       
       Contact cnt = new Contact();
       cnt.firstname = 'first1';
       cnt.lastname = 'last';
       cnt.AccountId = act.Id ;
       cnt.Role__c ='Paralegal';
       cnt.Email = 'hitmprashant1@gmail.com';
       cnt.Phone = '9560682173';
       cnt.Fax = '9560682173';
       cnt.BirthDate = Date.newInstance(2000, 09, 09);
       cnt.ContactInstructions__c = 'fff';
       cnt.Preferred_Contact_Phone__c = true;
       cnt.Preferred_Contact_Fax__c = true;
       cnt.Preferred_Contact_Email__c = true;
       cnt.DoNotCall = true;
       cnt.HasOptedOutOfFax = true;
       cnt.HasOptedOutOfEmail = true;
       cnt.IsActive__C = true;
       cnt.Salutation = 'Mr';

       insert cnt;
       
       Account_Relation__c actRel= new Account_Relation__c();
       
       actRel.Role__c = 'Attorney' ;
       actRel.Contact__c = cnt.Id ;
       actRel.Account__c = act.Id ;
       actRel.KeyMedsID__c = '1111';
       actRel.AtticusId__c = '111' ;
       actRel.GRSId__c = '2222';
       List<Account_Relation__c > actLst = new List<Account_Relation__c >();
       actLst.add(actRel);
       insert actLst;

       
       Non_Attorney_Contact__c nonAttorney = new Non_Attorney_Contact__c();
       nonAttorney.Role__c = 'Paralegal';
       //nonAttorney.Contact__c = cnt.Id;
       nonAttorney.Firm_Name__c = act.Id;
       nonAttorney.KeyMedsID__c = 111;
       nonAttorney.GRSId__c = 11;
       nonAttorney.AtticusId__c = 'eee';
       nonAttorney.Role__c = 'Paralegal';
              
       insert nonAttorney;
       Test.startTest();       
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       MedlienSalesforceToSystemsController.UpdateContactML(cnt.Id);
       Test.stopTest();
 }
 
 testMethod static void testUpdateFirmML(){
   Account act = new Account();
       //act.ParentId = '00300000003T2PGAA0';
       act.HeadQuarter__c = true;
       act.GRSId__c = 123456;
       act.KeyMedsID__c = 44444444 ;
       act.AtticusId__c = 'wewewe4444';
       act.Name = 'ssfdf';
       act.Street2__c = 'erer4545';
       act.BillingStreet = 'erer4545';
       act.BillingCity = 'CA';
       act.BillingState = 'TX';
       act.BillingPostalCode = '123ER';
       act.BillingCountry = 'United States';
       act.Phone = '9560682173';
       act.Fax = '9560682173';
       act.Website = 'https://www.google.com';
       act.type = 'Payor';
       insert act;
       
       Contact cnt = new Contact();
       cnt.firstname = 'first1';
       cnt.lastname = 'last';
       cnt.AccountId = act.Id ;
       cnt.Role__c ='Paralegal';
       cnt.Email = 'hitmprashant1@gmail.com';
       cnt.Phone = '9560682173';
       cnt.Fax = '9560682173';
       cnt.BirthDate = Date.newInstance(2000, 09, 09);
       cnt.ContactInstructions__c = 'fff';
       cnt.Preferred_Contact_Phone__c = true;
       cnt.Preferred_Contact_Fax__c = true;
       cnt.Preferred_Contact_Email__c = true;
       cnt.DoNotCall = true;
       cnt.HasOptedOutOfFax = true;
       cnt.HasOptedOutOfEmail = true;
       cnt.IsActive__C = true;
       cnt.Salutation = 'Mr';

       insert cnt;
       
       Account_Relation__c actRel= new Account_Relation__c();
       
       actRel.Role__c = 'Attorney' ;
       actRel.Contact__c = cnt.Id ;
       actRel.Account__c = act.Id ;
       actRel.KeyMedsID__c = '1111';
       actRel.AtticusId__c = '111' ;
       actRel.GRSId__c = '2222';
       List<Account_Relation__c > actLst = new List<Account_Relation__c >();
       actLst.add(actRel);
       insert actLst;

       
       Non_Attorney_Contact__c nonAttorney = new Non_Attorney_Contact__c();
       nonAttorney.Role__c = 'Paralegal';
       //nonAttorney.Contact__c = cnt.Id;
       nonAttorney.Firm_Name__c = act.Id;
       nonAttorney.KeyMedsID__c = 111;
       nonAttorney.GRSId__c = 11;
       nonAttorney.AtticusId__c = 'eee';
       nonAttorney.Role__c = 'Paralegal';
              
       insert nonAttorney;
       Test.startTest();       
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       MedlienSalesforceToSystemsController.UpdateFirmML(act.Id,true);
       Test.stopTest();
 }
 
 testMethod static void testCreateContactAssttML(){
   Account act = new Account();
       //act.ParentId = '00300000003T2PGAA0';
       act.HeadQuarter__c = true;
       act.GRSId__c = 123456;
       act.KeyMedsID__c = 44444444 ;
       act.AtticusId__c = 'wewewe4444';
       act.Name = 'ssfdf';
       act.Street2__c = 'erer4545';
       act.BillingStreet = 'erer4545';
       act.BillingCity = 'CA';
       act.BillingState = 'TX';
       act.BillingPostalCode = '123ER';
       act.BillingCountry = 'United States';
       act.Phone = '9560682173';
       act.Fax = '9560682173';
       act.Website = 'https://www.google.com';
       act.type = 'Payor';
       insert act;
       
       Contact cnt = new Contact();
       cnt.firstname = 'first1';
       cnt.lastname = 'last';
       cnt.AccountId = act.Id ;
       cnt.Role__c ='Paralegal';
       cnt.Email = 'hitmprashant1@gmail.com';
       cnt.Phone = '9560682173';
       cnt.Fax = '9560682173';
       cnt.BirthDate = Date.newInstance(2000, 09, 09);
       cnt.ContactInstructions__c = 'fff';
       cnt.Preferred_Contact_Phone__c = true;
       cnt.Preferred_Contact_Fax__c = true;
       cnt.Preferred_Contact_Email__c = true;
       cnt.DoNotCall = true;
       cnt.HasOptedOutOfFax = true;
       cnt.HasOptedOutOfEmail = true;
       cnt.IsActive__C = true;
       cnt.Salutation = 'Mr';

       insert cnt;
       
       Account_Relation__c actRel= new Account_Relation__c();
       
       actRel.Role__c = 'Attorney' ;
       actRel.Contact__c = cnt.Id ;
       actRel.Account__c = act.Id ;
       actRel.KeyMedsID__c = '1111';
       actRel.AtticusId__c = '111' ;
       actRel.GRSId__c = '2222';
       List<Account_Relation__c > actLst = new List<Account_Relation__c >();
       actLst.add(actRel);
       insert actLst;

       
       Non_Attorney_Contact__c nonAttorney = new Non_Attorney_Contact__c();
       nonAttorney.Role__c = 'Paralegal';
       //nonAttorney.Contact__c = cnt.Id;
       nonAttorney.Firm_Name__c = act.Id;
       nonAttorney.KeyMedsID__c = 111;
       nonAttorney.GRSId__c = 11;
       nonAttorney.AtticusId__c = 'eee';
       nonAttorney.Role__c = 'Paralegal';
              
       insert nonAttorney;
       Test.startTest();       
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       MedlienSalesforceToSystemsController.CreateContactAssttML(nonAttorney , 'LawFirm', '1111', 'test2', '77773');
       Test.stopTest();
 }
 
 testMethod static void testCreateContactML(){
   Account act = new Account();
       //act.ParentId = '00300000003T2PGAA0';
       act.HeadQuarter__c = true;
       act.GRSId__c = 123456;
       act.KeyMedsID__c = 44444444 ;
       act.AtticusId__c = 'wewewe4444';
       act.Name = 'ssfdf';
       act.Street2__c = 'erer4545';
       act.BillingStreet = 'erer4545';
       act.BillingCity = 'CA';
       act.BillingState = 'TX';
       act.BillingPostalCode = '123ER';
       act.BillingCountry = 'United States';
       act.Phone = '9560682173';
       act.Fax = '9560682173';
       act.Website = 'https://www.google.com';
       act.type = 'Payor';
       insert act;
       
       Contact cnt = new Contact();
       cnt.firstname = 'first1';
       cnt.lastname = 'last';
       cnt.AccountId = act.Id ;
       cnt.Role__c ='Paralegal';
       cnt.Email = 'hitmprashant1@gmail.com';
       cnt.Phone = '9560682173';
       cnt.Fax = '9560682173';
       cnt.BirthDate = Date.newInstance(2000, 09, 09);
       cnt.ContactInstructions__c = 'fff';
       cnt.Preferred_Contact_Phone__c = true;
       cnt.Preferred_Contact_Fax__c = true;
       cnt.Preferred_Contact_Email__c = true;
       cnt.DoNotCall = true;
       cnt.HasOptedOutOfFax = true;
       cnt.HasOptedOutOfEmail = true;
       cnt.IsActive__C = true;
       cnt.Salutation = 'Mr';

       insert cnt;
       
       Account_Relation__c actRel= new Account_Relation__c();
       
       actRel.Role__c = 'Attorney' ;
       actRel.Contact__c = cnt.Id ;
       actRel.Account__c = act.Id ;
       actRel.KeyMedsID__c = '1111';
       actRel.AtticusId__c = '111' ;
       actRel.GRSId__c = '2222';
       List<Account_Relation__c > actLst = new List<Account_Relation__c >();
       actLst.add(actRel);
       insert actLst;

       
       Non_Attorney_Contact__c nonAttorney = new Non_Attorney_Contact__c();
       nonAttorney.Role__c = 'Paralegal';
       //nonAttorney.Contact__c = cnt.Id;
       nonAttorney.Firm_Name__c = act.Id;
       nonAttorney.KeyMedsID__c = 111;
       nonAttorney.GRSId__c = 11;
       nonAttorney.AtticusId__c = 'eee';
       nonAttorney.Role__c = 'Paralegal';
              
       insert nonAttorney;
       Test.startTest();       
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       MedlienSalesforceToSystemsController.CreateContactML(actRel, 'LawFirm', '1111', 'test2', '77773');
       Test.stopTest();
 }
 
 testMethod static void testCreateFirmLocationML(){
   Account act = new Account();
       //act.ParentId = '00300000003T2PGAA0';
       act.HeadQuarter__c = true;
       act.GRSId__c = 123456;
       act.KeyMedsID__c = 44444444 ;
       act.AtticusId__c = 'wewewe4444';
       act.Name = 'ssfdf';
       act.Street2__c = 'erer4545';
       act.BillingStreet = 'erer4545';
       act.BillingCity = 'CA';
       act.BillingState = 'TX';
       act.BillingPostalCode = '123ER';
       act.BillingCountry = 'United States';
       act.Phone = '9560682173';
       act.Fax = '9560682173';
       act.Website = 'https://www.google.com';
       act.type = 'Payor';
       insert act;
       
       Contact cnt = new Contact();
       cnt.firstname = 'first1';
       cnt.lastname = 'last';
       cnt.AccountId = act.Id ;
       cnt.Role__c ='Paralegal';
       cnt.Email = 'hitmprashant1@gmail.com';
       cnt.Phone = '9560682173';
       cnt.Fax = '9560682173';
       cnt.BirthDate = Date.newInstance(2000, 09, 09);
       cnt.ContactInstructions__c = 'fff';
       cnt.Preferred_Contact_Phone__c = true;
       cnt.Preferred_Contact_Fax__c = true;
       cnt.Preferred_Contact_Email__c = true;
       cnt.DoNotCall = true;
       cnt.HasOptedOutOfFax = true;
       cnt.HasOptedOutOfEmail = true;
       cnt.IsActive__C = true;
       cnt.Salutation = 'Mr';

       insert cnt;
       
       Account_Relation__c actRel= new Account_Relation__c();
       
       actRel.Role__c = 'Attorney' ;
       actRel.Contact__c = cnt.Id ;
       actRel.Account__c = act.Id ;
       actRel.KeyMedsID__c = '1111';
       actRel.AtticusId__c = '111' ;
       actRel.GRSId__c = '2222';
       List<Account_Relation__c > actLst = new List<Account_Relation__c >();
       actLst.add(actRel);
       insert actLst;

       
       Non_Attorney_Contact__c nonAttorney = new Non_Attorney_Contact__c();
       nonAttorney.Role__c = 'Paralegal';
       //nonAttorney.Contact__c = cnt.Id;
       nonAttorney.Firm_Name__c = act.Id;
       nonAttorney.KeyMedsID__c = 111;
       nonAttorney.GRSId__c = 11;
       nonAttorney.AtticusId__c = 'eee';
       nonAttorney.Role__c = 'Paralegal';
              
       insert nonAttorney;
       Test.startTest();       
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       MedlienSalesforceToSystemsController.CreateFirmLocationML(act, '1111', 'test2', '77773');
       Test.stopTest();
 }
 
 
 
 testMethod static void testCreateFirmML(){
   Account act = new Account();
       //act.ParentId = '00300000003T2PGAA0';
       act.HeadQuarter__c = true;
       act.GRSId__c = 123456;
       act.KeyMedsID__c = 44444444 ;
       act.AtticusId__c = 'wewewe4444';
       act.Name = 'ssfdf';
       act.Street2__c = 'erer4545';
       act.BillingStreet = 'erer4545';
       act.BillingCity = 'CA';
       act.BillingState = 'TX';
       act.BillingPostalCode = '123ER';
       act.BillingCountry = 'United States';
       act.Phone = '9560682173';
       act.Fax = '9560682173';
       act.Website = 'https://www.google.com';
       act.type = 'Payor';
       insert act;
       
       Contact cnt = new Contact();
       cnt.firstname = 'first1';
       cnt.lastname = 'last';
       cnt.AccountId = act.Id ;
       cnt.Role__c ='Paralegal';
       cnt.Email = 'hitmprashant1@gmail.com';
       cnt.Phone = '9560682173';
       cnt.Fax = '9560682173';
       cnt.BirthDate = Date.newInstance(2000, 09, 09);
       cnt.ContactInstructions__c = 'fff';
       cnt.Preferred_Contact_Phone__c = true;
       cnt.Preferred_Contact_Fax__c = true;
       cnt.Preferred_Contact_Email__c = true;
       cnt.DoNotCall = true;
       cnt.HasOptedOutOfFax = true;
       cnt.HasOptedOutOfEmail = true;
       cnt.IsActive__C = true;
       cnt.Salutation = 'Mr';

       insert cnt;
       
       Account_Relation__c actRel= new Account_Relation__c();
       
       actRel.Role__c = 'Attorney' ;
       actRel.Contact__c = cnt.Id ;
       actRel.Account__c = act.Id ;
       actRel.KeyMedsID__c = '1111';
       actRel.AtticusId__c = '111' ;
       actRel.GRSId__c = '2222';
       List<Account_Relation__c > actLst = new List<Account_Relation__c >();
       actLst.add(actRel);
       insert actLst;

       
       Non_Attorney_Contact__c nonAttorney = new Non_Attorney_Contact__c();
       nonAttorney.Role__c = 'Paralegal';
       //nonAttorney.Contact__c = cnt.Id;
       nonAttorney.Firm_Name__c = act.Id;
       nonAttorney.KeyMedsID__c = 111;
       nonAttorney.GRSId__c = 11;
       nonAttorney.AtticusId__c = 'eee';
       nonAttorney.Role__c = 'Paralegal';
              
       insert nonAttorney;
       Test.startTest();       
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       //MedlienSalesforceToSystemsController.CreateFirmML(act);
       Test.stopTest();
 }
 
 testMethod static void testPushToMedlien(){
   Account act = new Account();
       //act.ParentId = '00300000003T2PGAA0';
       act.HeadQuarter__c = true;
       act.GRSId__c = 123456;
       act.KeyMedsID__c = 44444444 ;
       act.AtticusId__c = 'wewewe4444';
       act.Name = 'ssfdf';
       act.Street2__c = 'erer4545';
       act.BillingStreet = 'erer4545';
       act.BillingCity = 'CA';
       act.BillingState = 'TX';
       act.BillingPostalCode = '123ER';
       act.BillingCountry = 'United States';
       act.Phone = '9560682173';
       act.Fax = '9560682173';
       act.Website = 'https://www.google.com';
       act.type = 'Payor';
       insert act;
       
       Contact cnt = new Contact();
       cnt.firstname = 'first1';
       cnt.lastname = 'last';
       cnt.AccountId = act.Id ;
       cnt.Role__c ='Paralegal';
       cnt.Email = 'hitmprashant1@gmail.com';
       cnt.Phone = '9560682173';
       cnt.Fax = '9560682173';
       cnt.BirthDate = Date.newInstance(2000, 09, 09);
       cnt.ContactInstructions__c = 'fff';
       cnt.Preferred_Contact_Phone__c = true;
       cnt.Preferred_Contact_Fax__c = true;
       cnt.Preferred_Contact_Email__c = true;
       cnt.DoNotCall = true;
       cnt.HasOptedOutOfFax = true;
       cnt.HasOptedOutOfEmail = true;
       cnt.IsActive__C = true;
       cnt.Salutation = 'Mr';

       insert cnt;
       
       Account_Relation__c actRel= new Account_Relation__c();
       
       actRel.Role__c = 'Attorney' ;
       actRel.Contact__c = cnt.Id ;
       actRel.Account__c = act.Id ;
       actRel.KeyMedsID__c = '1111';
       actRel.AtticusId__c = '111' ;
       actRel.GRSId__c = '2222';
       List<Account_Relation__c > actLst = new List<Account_Relation__c >();
       actLst.add(actRel);
       insert actLst;

       
       Non_Attorney_Contact__c nonAttorney = new Non_Attorney_Contact__c();
       nonAttorney.Role__c = 'Paralegal';
       //nonAttorney.Contact__c = cnt.Id;
       nonAttorney.Firm_Name__c = act.Id;
       nonAttorney.KeyMedsID__c = 111;
       nonAttorney.GRSId__c = 11;
       nonAttorney.AtticusId__c = 'eee';
       nonAttorney.Role__c = 'Paralegal';
              
       insert nonAttorney;
       Test.startTest();       
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       MedlienSalesforceToSystemsController.PushToMedlien(actRel.Id);
       Test.stopTest();
 }
 
 
 
 
 testMethod static void testbuildCache(){
       String action = 'CreateFirmLocation';
       String inputPayload = '{"ZipCode":"78730-2315","State":"TX","FirmLocationName":"*The Christensen Law Firm","FirmLocationID":65572,"FirmID":61514,"CRM_FirmLocationID":"0014B00000ezBrBQAU","CRM_FirmID":"0014B00000ez0ToQAI","City":"Austin","Address2":"Ste 102","Address1":"6615 Vaught Ranch Rd"}';
       Id objectId = '001D000000IRt53';
       String lob = '{"Status":"Success"}';
       Test.startTest();       
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       MedlienSalesforceToSystemsController.buildCache(action,inputPayload , objectId, lob );
       Test.stopTest();
 }
}