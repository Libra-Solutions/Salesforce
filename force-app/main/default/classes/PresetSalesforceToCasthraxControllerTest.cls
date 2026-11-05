@isTest
public class PresetSalesforceToCasthraxControllerTest{

  @testSetup static void dataSetup(){
  
    PSCommunicationCache__c cache = new PSCommunicationCache__c();
    cache.GenericName__c = 'UpdateFirmLocation';
    cache.Operation__c = '/api/AttorneyFirm/UpdateFirmLocationToCTXUndo';
    cache.InputPayload__c = '{"ZipCode":"78730-2315","State":"TX","FirmLocationName":"*The Christensen Law Firm","FirmLocationID":65572,"FirmID":61514,"CRM_FirmLocationID":"0014B00000ezBrBQAU","CRM_FirmID":"0014B00000ez0ToQAI","City":"Austin","Address2":"Ste 102","Address1":"6615 Vaught Ranch Rd"}';
    cache.ResponseStatus__c = '200:Success';
    cache.ResponsePayload__c = '{"Status":"Success"}';
    insert cache;
    
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
       act.BillingState = 'AR';
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
       
       Opportunity op = new Opportunity();
       op.Attorney__c = cnt.Id;
       op.Name = 'test';
       op.StageName = 'Proposal';
       op.CloseDate = Date.newInstance(2000, 02,02);
       insert op;
       
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
  
  testMethod static void testPresetSync1(){
   Account parentAcct = new Account();
       parentAcct.HeadQuarter__c = true;
       parentAcct.GRSId__c = 123456;
       parentAcct.KeyMedsID__c = 44444444 ;
       parentAcct.AtticusId__c = 'wewewe4444';
       parentAcct.Name = 'ssfdf';
       parentAcct.Street2__c = 'erer4545';
       //act.BillingStreet = 'erer4545';
       //act.BillingCity = 'CA';
       //act.BillingState = 'AR';
       parentAcct.BillingPostalCode = '123ER';
       parentAcct.BillingCountry = 'United States';
       parentAcct.Phone = '9560682173';
       parentAcct.Fax = '9560682173';
       parentAcct.Website = 'https://www.google.com';
       parentAcct.type = 'LawFirm';
       insert parentAcct;
  
   Account act = new Account();
       act.HeadQuarter__c = true;
       act.GRSId__c = 123456;
       act.KeyMedsID__c = 44444444 ;
       act.AtticusId__c = 'wewewe4444';
       act.Name = 'ssfdf';
       act.Street2__c = 'erer4545';
       //act.BillingStreet = 'erer4545';
       //act.BillingCity = 'CA';
       //act.BillingState = 'AR';
       act.BillingPostalCode = '123ER';
       act.BillingCountry = 'United States';
       act.Phone = '9560682173';
       act.Fax = '9560682173';
       act.Website = 'https://www.google.com';
       act.type = 'LawFirm';
       act.ParentId = parentAcct.id;
       //act.CTXFirmId__c = '54321';
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
       PresetSalesforceToCasthraxController.PresetSyncSystems(act.id);
       
       act.CTXFirmId__c = '54321';
       PresetSalesforceToCasthraxController.PresetSyncSystems(act.id);
       update act;
       Test.stopTest();
 }
 testMethod static void testPresetSync4(){
   Account parentAcct = new Account();
       parentAcct.HeadQuarter__c = true;
       parentAcct.GRSId__c = 123456;
       parentAcct.KeyMedsID__c = 44444444 ;
       parentAcct.AtticusId__c = 'wewewe4444';
       parentAcct.Name = 'ssfdf';
       parentAcct.Street2__c = 'erer4545';
       //act.BillingStreet = 'erer4545';
       //act.BillingCity = 'CA';
       //act.BillingState = 'AR';
       parentAcct.BillingPostalCode = '123ER';
       parentAcct.BillingCountry = 'United States';
       parentAcct.Phone = '9560682173';
       parentAcct.Fax = '9560682173';
       parentAcct.Website = 'https://www.google.com';
       parentAcct.type = 'LawFirm';
       insert parentAcct;
  
   Account act = new Account();
       act.HeadQuarter__c = true;
       act.GRSId__c = 123456;
       act.KeyMedsID__c = 44444444 ;
       act.AtticusId__c = 'wewewe4444';
       act.Name = 'ssfdf';
       act.Street2__c = 'erer4545';
       //act.BillingStreet = 'erer4545';
       //act.BillingCity = 'CA';
       //act.BillingState = 'AR';
       act.BillingPostalCode = '123ER';
       act.BillingCountry = 'United States';
       act.Phone = '9560682173';
       act.Fax = '9560682173';
       act.Website = 'https://www.google.com';
       act.type = 'LawFirm';
       act.ParentId = parentAcct.id;
       act.CTXFirmId__c = '54321';
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
       PresetSalesforceToCasthraxController.updateFirmCTX(act.id);
       Test.stopTest();
 }
 testMethod static void testPresetSync2(){
   Account parentAcct = new Account();
       parentAcct.HeadQuarter__c = true;
       parentAcct.GRSId__c = 123456;
       parentAcct.KeyMedsID__c = 44444444 ;
       parentAcct.AtticusId__c = 'wewewe4444';
       parentAcct.Name = 'test Parent';
       parentAcct.Street2__c = 'erer4545';
       //act.BillingStreet = 'erer4545';
       //act.BillingCity = 'CA';
       //act.BillingState = 'AR';
       parentAcct.BillingPostalCode = '123ER';
       parentAcct.BillingCountry = 'United States';
       parentAcct.Phone = '9560682173';
       parentAcct.Fax = '9560682173';
       parentAcct.Website = 'https://www.google.com';
       parentAcct.type = 'LawFirm';
       parentAcct.CTXFirmId__c = '12345';
       insert parentAcct;
  
   Account act = new Account();
       act.GRSId__c = 123456;
       act.KeyMedsID__c = 44444444 ;
       act.AtticusId__c = 'wewewe4444';
       act.Name = 'Test Child';
       act.Street2__c = 'erer4545';
       act.BillingStreet = 'erer4545';
       act.BillingCity = 'CA';
       act.BillingState = 'AR';
       act.BillingPostalCode = '123ER';
       act.BillingCountry = 'United States';
       act.Phone = '9560682173';
       act.Fax = '9560682173';
       act.Website = 'https://www.google.com';
       act.type = 'LawFirm';
       act.ParentId = parentAcct.id;
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
       //actRel.Attorney__c = cnt.id;
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
       PresetSalesforceToCasthraxController.PresetSyncSystems(act.id);
       
       act.CTXFirmId__c = '54321';
       //act = [Select id,GRSId__c ,KeyMedsID__c, AtticusId__c, Name, BillingPostalCode, BillingCountry,
         //              Phone, Fax, Website, type, ParentId]
       PresetSalesforceToCasthraxController.PresetSyncSystems(act.id);
       update act;
       Test.stopTest();
 }
  
  testMethod static void testMedlienSyncSystems(){
    Account act = [Select Id from Account where Name = 'ssfdf'];
    PresetSalesforceToCasthraxController.SyncSystems(act.id);
  }
  
  testMethod static void testMedlienSyncSystems1(){
    Account act = [Select Id from Account where Name = 'titu'];
    PresetSalesforceToCasthraxController.SyncSystemsMedlien(act.id);
  }

   testMethod static void testAttorneyAssistantData (){
   PresetSalesforceToCasthraxController.AttorneyAssistantData sfEnt = new PresetSalesforceToCasthraxController.AttorneyAssistantData();
   sfEnt.CTX_AttorneyAssistantID= '1234ert';
   sfEnt.relation = new Non_Attorney_Contact__c();
   sfEnt.cache = new PSCommunicationCache__c();
   sfEnt.resp = new Map<String,Object>();
   
   System.assertNotEquals(null, sfEnt.CTX_AttorneyAssistantID);
   System.assertEquals(new Non_Attorney_Contact__c (), sfEnt.relation );
   System.assertEquals(new PSCommunicationCache__c(), sfEnt.cache);
   System.assertEquals(new Map<String,Object>(), sfEnt.resp);
   
 
 }
 
 testMethod static void testAttorneyData (){
   PresetSalesforceToCasthraxController.AttorneyData  sfEnt = new PresetSalesforceToCasthraxController.AttorneyData ();
   sfEnt.CTX_AttorneyID= '1234ert';
   sfEnt.relation = new Account_Relation__c ();
   sfEnt.cache = new PSCommunicationCache__c();
   sfEnt.resp = new Map<String,Object>();
   
   System.assertNotEquals(null, sfEnt.CTX_AttorneyID);
   System.assertEquals(new Account_Relation__c (), sfEnt.relation );
   System.assertEquals(new PSCommunicationCache__c(), sfEnt.cache);
   System.assertEquals(new Map<String,Object>(), sfEnt.resp);
    
 }
 
 
 testMethod static void testFirmData(){
   PresetSalesforceToCasthraxController.FirmData  sfEnt = new PresetSalesforceToCasthraxController.FirmData ();
   sfEnt.CTX_FirmId = '1234ert';
   sfEnt.acc = new Account();
   sfEnt.cache = new PSCommunicationCache__c();
   sfEnt.resp = new Map<String,Object>();
   sfEnt.HQ = true ;
   
   System.assertNotEquals(null, sfEnt.CTX_FirmId );
   System.assertEquals(new Account(), sfEnt.acc );
   System.assertEquals(new PSCommunicationCache__c(), sfEnt.cache);
   System.assertEquals(new Map<String,Object>(), sfEnt.resp);
   System.assertEquals(true , sfEnt.HQ);
   
 
 }
 
 testMethod static void testRemoveNull(){
   List<String> lst = new List<String>{'test', '', null};
   for(String val : lst) {
    PresetSalesforceToCasthraxController.removeNull(val);
   }
 }
 
 testMethod static void testPushToCashtrax(){
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
       act.BillingState = 'AR';
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
       
       Account_Relation__c actRel = new Account_Relation__c();
       
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
       PresetSalesforceToCasthraxController.PushToCashtrax(cnt.Id);
       Test.stopTest();
 }
 
 testMethod static void testCreateAttorneyCTX(){
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
       act.BillingState = 'AR';
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
       PresetSalesforceToCasthraxController.CreateAttorneyCTX(actRel, '1111', '222');
       Test.stopTest();
 }
 
 testMethod static void testUpdateContactCTX1(){
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
       act.BillingState = 'AR';
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
       PresetSalesforceToCasthraxController.UpdateContactCTX(cnt.Id);
       Test.stopTest();
 }
 
 testMethod static void testUpdateContactCTX(){
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
       act.BillingState = 'AR';
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
       //PresetSalesforceToCasthraxController.UpdateContactCTX(cnt.Id, nonAttorney.Id);
       Test.stopTest();
 }
 
 testMethod static void testUpdateAttorneyAssistantCTX(){
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
       act.BillingState = 'AR';
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
       nonAttorney.Contact__c = cnt.Id;
       nonAttorney.PresetID__c = 123456789;
       nonAttorney.Firm_Name__c = act.Id;
       nonAttorney.KeyMedsID__c = 111;
       nonAttorney.GRSId__c = 11;
       nonAttorney.AtticusId__c = 'eee';
       nonAttorney.Role__c = 'Paralegal';
              
       insert nonAttorney;
       Test.startTest();       
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       PresetSalesforceToCasthraxController.UpdateAttorneyAssistantCTX(cnt, nonAttorney );
       Test.stopTest();
 }
 
 testMethod static void testUpdateAttorneyCTX(){
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
       act.BillingState = 'AR';
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
       actRel.PresetID__c = '1111111';
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
       //PresetSalesforceToCasthraxController.UpdateAttorneyCTX(cnt, actRel, '1111');
       Test.stopTest();
 }
 
 
 
 testMethod static void testwolfPackAttorney(){
       Contact cnt = new Contact();
       cnt.firstname = 'testww';
       cnt.lastname = 'tegggg';
       insert cnt;
       Opportunity op = [Select Id, amount from Opportunity Where Name = 'test'];
              
       Test.startTest();       
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       PresetSalesforceToCasthraxController.wolfPackAttorney(op.Id, cnt.Id );
       Test.stopTest();
 }
 
  
 
 testMethod static void testsendToCache(){
       String action = 'CreateFirmLocation';
       String inputPayload = '{"ZipCode":"78730-2315","State":"VA","FirmLocationName":"*The Christensen Law Firm","FirmLocationID":65572,"FirmID":61514,"CRM_FirmLocationID":"0014B00000ezBrBQAU","CRM_FirmID":"0014B00000ez0ToQAI","City":"Austin","Address2":"Ste 102","Address1":"6615 Vaught Ranch Rd"}';
       Id objectId = '001D000000IRt53';
       String lob = 'PS';
       String sessionId = UserInfo.getSessionId();
       Test.startTest();       
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       //PresetSalesforceToCasthraxController.sendToCache(action,inputPayload , sessionId, objectId, lob );
       Test.stopTest();
 }
 
 testMethod static void testcreatequickadd(){
       Opportunity op = [Select Id from Opportunity Where Name = 'test'];
       Test.startTest();       
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       PresetSalesforceToCasthraxController.createQuickAdd('we234567', op.Id );
       Test.stopTest();
 }
 
 
 testMethod static void testUpdateAttorneyCTXO(){
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
       act.BillingState = 'AR';
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
       actRel.PresetID__c = '1111111';
       actRel.KeyMedsID__c = '1111';
       actRel.AtticusId__c = '111' ;
       actRel.GRSId__c = '2222';
       List<Account_Relation__c > actLst = new List<Account_Relation__c >();
       actLst.add(actRel);
       insert actLst;
       Test.startTest();       
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       PresetSalesforceToCasthraxController.UpdateAttorneyCTX(cnt, actRel, '12345' );
       Test.stopTest();
 }
 
}