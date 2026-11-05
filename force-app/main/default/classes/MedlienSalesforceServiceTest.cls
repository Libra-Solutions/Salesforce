@isTest
public class MedlienSalesforceServiceTest {

  @testSetup static void dataSetup() {
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
       act.BillingPostalCode = '1234ER';
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
       cnt.firstname = 'dddd';
       cnt.lastname = 'dddd';
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
  
   testMethod static void testWrapper(){
   MedlienSalesforceService.CTXResponse sfEnt = new MedlienSalesforceService.CTXResponse();
   sfEnt.CRM_FirmID = '1234ert';
   sfEnt.statusCode = '123456';
   sfEnt.status = '123456';
   sfEnt.message = '123456';
   sfEnt.CRM_AttorneyId = '123456';
   
   System.assertNotEquals(null, sfEnt.CRM_FirmID);
   System.assertNotEquals(null, sfEnt.statusCode );
   System.assertNotEquals(null, sfEnt.status );
   System.assertNotEquals(null, sfEnt.message );
   System.assertNotEquals(null, sfEnt.CRM_AttorneyId );
   
   MedlienSalesforceService.CTXNonAttorneyUpdatResponse sfEnt1 = new MedlienSalesforceService.CTXNonAttorneyUpdatResponse();
   sfEnt1.statusCode = '123456';
   sfEnt1.status = '123456';
   sfEnt1.message = '123456';
   sfEnt1.CRM_ContactId= '123456';
   
   System.assertNotEquals(null, sfEnt1.statusCode );
   System.assertNotEquals(null, sfEnt1.status );
   System.assertNotEquals(null, sfEnt1.message );
   System.assertNotEquals(null, sfEnt1.CRM_ContactId);
   
   MedlienSalesforceService.CTXUpdateResponse sfEnt2 = new MedlienSalesforceService.CTXUpdateResponse();
   sfEnt2.status = '123456';
   sfEnt2.message = '123456';
   
   System.assertNotEquals(null, sfEnt2.status );
   System.assertNotEquals(null, sfEnt2.message );
   
   MedlienSalesforceService.ContactResponse sfEnt3 = new MedlienSalesforceService.ContactResponse();
   sfEnt3.status = '123456';
   sfEnt3.message = '123456';
   sfEnt3.statusCode ='ddd';
   sfEnt3.CRM_ContactID = 'ddd';
   
   System.assertNotEquals(null, sfEnt3.status );
   System.assertNotEquals(null, sfEnt3.message );
   System.assertNotEquals(null, sfEnt3.statusCode );
   System.assertNotEquals(null, sfEnt3.CRM_ContactID );
   
   MedlienSalesforceService.FirmResponse sfEnt4 = new MedlienSalesforceService.FirmResponse();
   sfEnt4.status = '123456';
   sfEnt4.message = '123456';
   sfEnt4.statusCode ='ddd';
   sfEnt4.CRM_FirmID= 'ddd';
   
   System.assertNotEquals(null, sfEnt4.status );
   System.assertNotEquals(null, sfEnt4.message );
   System.assertNotEquals(null, sfEnt4.statusCode );
   System.assertNotEquals(null, sfEnt4.CRM_FirmID);
   
   
  
 }
 
 testmethod static void testgetContactRecordType() {
    MedlienSalesforceService.getContactRecordType('Vendor');
 }
 
 testmethod static void testcheckDuplicateAccount() {
   MedlienEntities.FirmLocation sfEnt = new MedlienEntities.FirmLocation();
   sfEnt.CRM_ParentFirmID = '1234ert';
   sfEnt.FirmID_KM = 12;
   sfEnt.CRM_FirmID = '123456';
   sfEnt.FirmID_GL = 12345;
   sfEnt.FirmName = 'ssfdf';
   sfEnt.HeadQuarter = true;
   sfEnt.Address1 = 'erer4545';
   sfEnt.Address2 = 'test333';
   sfEnt.City = 'CA';
   sfEnt.State = 'AR';
   sfEnt.ZipCode = '1234ER';
   sfEnt.PhoneNumber = '9560682173';
   sfEnt.Fax = '9560682173';
   sfEnt.type = 'Payer' ;
   new MedlienSalesforceService().checkDuplicateAccount(sfEnt , true);
 }
 
 testmethod static void testcheckDuplicateContact() {
   MedlienEntities.CRMContact sfEnt = new MedlienEntities.CRMContact();
   sfEnt.CRM_FirmLocationID = '1234ert';
   sfEnt.ContactID_KM = 12;
   sfEnt.CRM_ContactID = '123456';
   sfEnt.ContactID_GL = 12345;
   sfEnt.FirstName = 'dddd';
   sfEnt.LastName = 'dddd';
   sfEnt.MiddleName = 'dddd';
   sfEnt.Email = 'hitmprashant@gmail.com';
   sfEnt.PhoneNumber = '9560682173';
   sfEnt.Birthday = DateTime.newInstance(2000, 09, 09);
   sfEnt.Fax = '9560682173';
   sfEnt.ContactInformation = 'Payer' ;
   sfEnt.PreferredContactPhone = true ;
   sfEnt.PreferredContactFax = true ;
   sfEnt.PreferredContactEmail = true ;
   sfEnt.DoNotContactPhone = true ;
   sfEnt.DoNotContactFax = true ;
   sfEnt.DoNotContactEmail = true ;
   sfEnt.IsActive = true ;
   sfEnt.Suffix = 'Payer' ;
   sfEnt.type = 'Payer' ;
   new MedlienSalesforceService().checkDuplicateContact(sfEnt);
 }
  
  
 testmethod static void testcreateConta() {
   MedlienEntities.CRMContact sfEnt = new MedlienEntities.CRMContact();
   sfEnt.CRM_FirmLocationID = '1234ert';
   sfEnt.ContactID_KM = 12;
   sfEnt.CRM_ContactID = '123456';
   sfEnt.ContactID_GL = 12345;
   sfEnt.FirstName = 'dddd';
   sfEnt.LastName = 'dddd';
   sfEnt.MiddleName = 'dddd';
   sfEnt.Email = 'hitmprashant@gmail.com';
   sfEnt.PhoneNumber = '9560682173';
   sfEnt.Birthday = DateTime.newInstance(2000, 09, 09);
   sfEnt.Fax = '9560682173';
   sfEnt.ContactInformation = 'Payer' ;
   sfEnt.PreferredContactPhone = true ;
   sfEnt.PreferredContactFax = true ;
   sfEnt.PreferredContactEmail = true ;
   sfEnt.DoNotContactPhone = true ;
   sfEnt.DoNotContactFax = true ;
   sfEnt.DoNotContactEmail = true ;
   sfEnt.IsActive = true ;
   sfEnt.Suffix = 'Payer' ;
   sfEnt.type = 'Payer' ;
   new MedlienSalesforceService().createContact(sfEnt);
 }

 testmethod static void testupdateContact() {
   Contact cnt = [Select Id from Contact where email = 'hitmprashant@gmail.com'];
   Account act = [Select Id from Account where name = 'ssfdf'];
   MedlienEntities.CRMContact sfEnt = new MedlienEntities.CRMContact();
   sfEnt.CRM_FirmLocationID = act.Id;
   sfEnt.ContactID_KM = 12;
   sfEnt.CRM_ContactID= cnt.Id;
   sfEnt.ContactID_GL = 12345;
   sfEnt.FirstName = 'dddd';
   sfEnt.LastName = 'dddd';
   sfEnt.MiddleName = 'dddd';
   sfEnt.Email = 'hitmprashant@gmail.com';
   sfEnt.PhoneNumber = '9560682173';
   sfEnt.Birthday = DateTime.newInstance(2000, 09, 09);
   sfEnt.Fax = '9560682173';
   sfEnt.ContactInformation = 'Payer' ;
   sfEnt.PreferredContactPhone = true ;
   sfEnt.PreferredContactFax = true ;
   sfEnt.PreferredContactEmail = true ;
   sfEnt.DoNotContactPhone = true ;
   sfEnt.DoNotContactFax = true ;
   sfEnt.DoNotContactEmail = true ;
   sfEnt.IsActive = true ;
   sfEnt.Suffix = 'Payer' ;
   sfEnt.type = 'Payer' ;
  // new MedlienSalesforceService().updateContact(sfEnt);
 }
 
 testmethod static void testupdateContactNullCheck() {
   String s = null;
   new MedlienSalesforceService().updateContact(s);
 }

 testmethod static void testupdateFirmLocation() {
   Contact cnt = [Select Id from Contact where email = 'hitmprashant@gmail.com'];
   Account act = [Select Id from Account where name = 'ssfdf'];
    MedlienEntities.FirmLocation sfEnt = new MedlienEntities.FirmLocation();
   sfEnt.CRM_ParentFirmID = '1234ert';
   sfEnt.FirmID_KM = 12;
   sfEnt.CRM_FirmID = act.Id;
   sfEnt.FirmID_GL = 12345;
   sfEnt.FirmName = 'dddd';
   sfEnt.HeadQuarter = true;
   sfEnt.Address1 = 'ttttt';
   sfEnt.Address2 = 'test333';
   sfEnt.City = 'Albama';
   sfEnt.State = 'California';
   sfEnt.ZipCode = '1234ER';
   sfEnt.PhoneNumber = '9560682173';
   sfEnt.Fax = '9560682173';
   sfEnt.type = 'Payer' ;
   new MedlienSalesforceService().updateFirmLocation(sfEnt);
 }
 
 testmethod static void testupdateFirm() {
   Contact cnt = [Select Id from Contact where email = 'hitmprashant@gmail.com'];
   Account act = [Select Id from Account where name = 'ssfdf'];
   MedlienEntities.Firm sfEnt = new MedlienEntities.Firm();
   sfEnt.CRM_FirmID = act.Id;
   sfEnt.FirmID_KM = 12;
   sfEnt.FirmID_AT = '123456';
   sfEnt.FirmID_GL = 12345;
   sfEnt.FirmName = 'dddd';
   sfEnt.HeadQuarter = true;
   sfEnt.Address1 = 'ttttt';
   sfEnt.Address2 = 'test333';
   sfEnt.City = 'Albama';
   sfEnt.State = 'California';
   sfEnt.ZipCode = '1234ER';
   sfEnt.PhoneNumber = '9560682173';
   sfEnt.Website = 'https://www.sss.com' ;
   sfEnt.Fax = '9560682173';
   sfEnt.type = 'Payer' ;
   new MedlienSalesforceService().updateFirm(sfEnt);
 }
 
 testmethod static void testcreateFirmLocation() {
    MedlienEntities.FirmLocation sfEnt = new MedlienEntities.FirmLocation();
   sfEnt.CRM_ParentFirmID = '1234ert';
   sfEnt.FirmID_KM = 12;
   sfEnt.CRM_FirmID = '11111';
   sfEnt.FirmID_GL = 12345;
   sfEnt.FirmName = 'dddd';
   sfEnt.HeadQuarter = true;
   sfEnt.Address1 = 'ttttt';
   sfEnt.Address2 = 'test333';
   sfEnt.City = 'Albama';
   sfEnt.State = 'California';
   sfEnt.ZipCode = '1234ER';
   sfEnt.PhoneNumber = '9560682173';
   sfEnt.Fax = '9560682173';
   sfEnt.type = 'Payer' ;
   new MedlienSalesforceService().createFirmLocation(sfEnt);
 }
 
 testmethod static void testcreateFirm() {
   
   MedlienEntities.Firm sfEnt = new MedlienEntities.Firm();
   sfEnt.CRM_FirmID = '111';
   sfEnt.FirmID_KM = 12;
   sfEnt.FirmID_AT = '123456';
   sfEnt.FirmID_GL = 12345;
   sfEnt.FirmName = 'dddd';
   sfEnt.HeadQuarter = true;
   sfEnt.Address1 = 'ttttt';
   sfEnt.Address2 = 'test333';
   sfEnt.City = 'Albama';
   sfEnt.State = 'California';
   sfEnt.ZipCode = '1234ER';
   sfEnt.PhoneNumber = '9560682173';
   sfEnt.Website = 'https://www.sss.com' ;
   sfEnt.Fax = '9560682173';
   sfEnt.type = 'Payer' ;
   new MedlienSalesforceService().createFirm(sfEnt);
 }
 
 testmethod static void testUpdateContactJson() {
   
   Contact cnt = [Select Id from Contact where email = 'hitmprashant@gmail.com'];
   Account act = [Select Id from Account where name = 'ssfdf'];
   MedlienEntities.CRMContact sfEnt = new MedlienEntities.CRMContact();
   sfEnt.CRM_FirmLocationID = act.Id;
   sfEnt.ContactID_KM = 12;
   sfEnt.CRM_ContactID= cnt.Id;
   sfEnt.ContactID_GL = 12345;
   sfEnt.FirstName = 'dddd';
   sfEnt.LastName = 'dddd';
   sfEnt.MiddleName = 'dddd';
   sfEnt.Email = 'hitmprashant@gmail.com';
   sfEnt.PhoneNumber = '9560682173';
   sfEnt.Birthday = DateTime.newInstance(2000, 09, 09);
   sfEnt.Fax = '9560682173';
   sfEnt.ContactInformation = 'Payer' ;
   sfEnt.PreferredContactPhone = true ;
   sfEnt.PreferredContactFax = true ;
   sfEnt.PreferredContactEmail = true ;
   sfEnt.DoNotContactPhone = true ;
   sfEnt.DoNotContactFax = true ;
   sfEnt.DoNotContactEmail = true ;
   sfEnt.IsActive = true ;
   sfEnt.Suffix = 'Payer' ;
   sfEnt.type = 'Payer' ;
   String json = Json.Serialize(sfEnt);
  // new MedlienSalesforceService().updateContact(json);
 }
 
 testmethod static void testUpdateContactJsonNull() {
   
   String json = null;
   new MedlienSalesforceService().updateContact(json);
 }
 
 
 testmethod static void testCreateContactJson() {
    
   MedlienEntities.CRMContact sfEnt = new MedlienEntities.CRMContact();
   sfEnt.CRM_FirmLocationID = '333333';
   sfEnt.ContactID_KM = 12;
   sfEnt.CRM_ContactID= '111111';
   sfEnt.ContactID_GL = 12345;
   sfEnt.FirstName = 'dddd';
   sfEnt.LastName = 'dddd';
   sfEnt.MiddleName = 'dddd';
   sfEnt.Email = 'hitmprashant@gmail.com';
   sfEnt.PhoneNumber = '9560682173';
   sfEnt.Birthday = DateTime.newInstance(2000, 09, 09);
   sfEnt.Fax = '9560682173';
   sfEnt.ContactInformation = 'Payer' ;
   sfEnt.PreferredContactPhone = true ;
   sfEnt.PreferredContactFax = true ;
   sfEnt.PreferredContactEmail = true ;
   sfEnt.DoNotContactPhone = true ;
   sfEnt.DoNotContactFax = true ;
   sfEnt.DoNotContactEmail = true ;
   sfEnt.IsActive = true ;
   sfEnt.Suffix = 'Payer' ;
   sfEnt.type = 'Payer' ;
   String json = Json.Serialize(sfEnt);
   new MedlienSalesforceService().createContact(json);
 }
 
 testmethod static void testCreateContactJsonNull() {
  
   String json = null;
   new MedlienSalesforceService().createContact(json);
 }
 
 
 testmethod static void testupdateFirmLocationJson() {
   Contact cnt = [Select Id from Contact where email = 'hitmprashant@gmail.com'];
   Account act = [Select Id from Account where name = 'ssfdf'];
    MedlienEntities.FirmLocation sfEnt = new MedlienEntities.FirmLocation();
   sfEnt.CRM_ParentFirmID = '1234ert';
   sfEnt.FirmID_KM = 12;
   sfEnt.CRM_FirmID = act.Id;
   sfEnt.FirmID_GL = 12345;
   sfEnt.FirmName = 'dddd';
   sfEnt.HeadQuarter = true;
   sfEnt.Address1 = 'ttttt';
   sfEnt.Address2 = 'test333';
   sfEnt.City = 'Albama';
   sfEnt.State = 'California';
   sfEnt.ZipCode = '1234ER';
   sfEnt.PhoneNumber = '9560682173';
   sfEnt.Fax = '9560682173';
   sfEnt.type = 'Payer' ;
   String json = Json.Serialize(sfEnt);
   new MedlienSalesforceService().updateFirmLocation(json);
 }
 
 testmethod static void testcreateFirmLocationJson() {
   
   MedlienEntities.FirmLocation sfEnt = new MedlienEntities.FirmLocation();
   sfEnt.CRM_ParentFirmID = '1234ert';
   sfEnt.FirmID_KM = 12;
   sfEnt.CRM_FirmID = '11111';
   sfEnt.FirmID_GL = 12345;
   sfEnt.FirmName = 'dddd';
   sfEnt.HeadQuarter = true;
   sfEnt.Address1 = 'ttttt';
   sfEnt.Address2 = 'test333';
   sfEnt.City = 'Albama';
   sfEnt.State = 'California';
   sfEnt.ZipCode = '1234ER';
   sfEnt.PhoneNumber = '9560682173';
   sfEnt.Fax = '9560682173';
   sfEnt.type = 'Payer' ;
   String json = Json.Serialize(sfEnt);
   new MedlienSalesforceService().createFirmLocation(json);
 }
 
 testmethod static void testcreateFirmLocationJsonNull() {
   
   String json = null;
   new MedlienSalesforceService().createFirmLocation(json);
 }
 
 testmethod static void testupdateFirmJson() {
   
   MedlienEntities.Firm sfEnt = new MedlienEntities.Firm();
   sfEnt.CRM_FirmID = '111';
   sfEnt.FirmID_KM = 12;
   sfEnt.FirmID_AT = '123456';
   sfEnt.FirmID_GL = 12345;
   sfEnt.FirmName = 'dddd';
   sfEnt.HeadQuarter = true;
   sfEnt.Address1 = 'ttttt';
   sfEnt.Address2 = 'test333';
   sfEnt.City = 'Albama';
   sfEnt.State = 'California';
   sfEnt.ZipCode = '1234ER';
   sfEnt.PhoneNumber = '9560682173';
   sfEnt.Website = 'https://www.sss.com' ;
   sfEnt.Fax = '9560682173';
   sfEnt.type = 'Payer' ;
   String json = Json.Serialize(sfEnt);
   new MedlienSalesforceService().updateFirm(json);
 }
 
 testmethod static void testupdateFirmJsonNull() {
   String s = null;
   new MedlienSalesforceService().updateFirm(s);
 }
 
 testmethod static void testcreateFirmJson() {
   
   MedlienEntities.Firm sfEnt = new MedlienEntities.Firm();
   sfEnt.CRM_FirmID = '111';
   sfEnt.FirmID_KM = 12;
   sfEnt.FirmID_AT = '123456';
   sfEnt.FirmID_GL = 12345;
   sfEnt.FirmName = 'dddd';
   sfEnt.HeadQuarter = true;
   sfEnt.Address1 = 'ttttt';
   sfEnt.Address2 = 'test333';
   sfEnt.City = 'Albama';
   sfEnt.State = 'California';
   sfEnt.ZipCode = '1234ER';
   sfEnt.PhoneNumber = '9560682173';
   sfEnt.Website = 'https://www.sss.com' ;
   sfEnt.Fax = '9560682173';
   sfEnt.type = 'Payer' ;
   String json = Json.Serialize(sfEnt);
   new MedlienSalesforceService().createFirm(json);
 }
 
 testmethod static void testcreateFirmJsonNull() {
   
   MedlienEntities.Firm sfEnt = new MedlienEntities.Firm();
   sfEnt.CRM_FirmID = '111';
   sfEnt.FirmID_KM = 12;
   sfEnt.FirmID_AT = '123456';
   sfEnt.FirmID_GL = 12345;
   sfEnt.FirmName = 'dddd';
   sfEnt.HeadQuarter = true;
   sfEnt.Address1 = 'ttttt';
   sfEnt.Address2 = 'test333';
   sfEnt.City = 'Albama';
   sfEnt.State = 'California';
   sfEnt.ZipCode = '1234ER';
   sfEnt.PhoneNumber = '9560682173';
   sfEnt.Website = 'https://www.sss.com' ;
   sfEnt.Fax = '9560682173';
   sfEnt.type = 'Payer' ;
   String json = null;
   new MedlienSalesforceService().createFirm(json);
 }
  
}