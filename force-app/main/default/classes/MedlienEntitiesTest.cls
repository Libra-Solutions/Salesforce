@isTest
public class MedlienEntitiesTest{

 testMethod static void testFirm(){
   MedlienEntities.Firm sfEnt = new MedlienEntities.Firm();
   sfEnt.CRM_FirmID = '1234ert';
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
   
   
   System.assertNotEquals(null, sfEnt.CRM_FirmID);
   System.assertNotEquals(0, sfEnt.FirmID_KM);
   System.assertNotEquals(null, sfEnt.FirmID_AT);
   System.assertNotEquals(0, sfEnt.FirmID_GL);
   System.assertEquals(true, sfEnt.HeadQuarter);
   System.assertNotEquals(null, sfEnt.FirmName);
   System.assertNotEquals(null, sfEnt.Address1);
   System.assertNotEquals(null, sfEnt.Address2);
   System.assertNotEquals(null, sfEnt.City);
   System.assertNotEquals(null, sfEnt.State);
   System.assertNotEquals(null, sfEnt.ZipCode);
   System.assertNotEquals(null, sfEnt.PhoneNumber);
   System.assertNotEquals(null, sfEnt.Fax);
   System.assertNotEquals(null, sfEnt.Website);
   System.assertNotEquals(null, sfEnt.type);
 
 }
 
 testMethod static void testFirmLocation(){
   MedlienEntities.FirmLocation sfEnt = new MedlienEntities.FirmLocation();
   sfEnt.CRM_ParentFirmID = '1234ert';
   sfEnt.FirmID_KM = 12;
   sfEnt.CRM_FirmID = '123456';
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
   
   
   System.assertNotEquals(null, sfEnt.CRM_ParentFirmID);
   System.assertNotEquals(0, sfEnt.FirmID_KM);
   System.assertNotEquals(null, sfEnt.CRM_FirmID);
   System.assertNotEquals(0, sfEnt.FirmID_GL);
   System.assertEquals(true, sfEnt.HeadQuarter);
   System.assertNotEquals(null, sfEnt.FirmName);
   System.assertNotEquals(null, sfEnt.Address1);
   System.assertNotEquals(null, sfEnt.Address2);
   System.assertNotEquals(null, sfEnt.City);
   System.assertNotEquals(null, sfEnt.State);
   System.assertNotEquals(null, sfEnt.ZipCode);
   System.assertNotEquals(null, sfEnt.PhoneNumber);
   System.assertNotEquals(null, sfEnt.Fax);
   System.assertNotEquals(null, sfEnt.Address1);
   System.assertNotEquals(null, sfEnt.Address2);
   System.assertNotEquals(null, sfEnt.City);
   System.assertNotEquals(null, sfEnt.State);
   System.assertNotEquals(null, sfEnt.type);
 
 }
 
 testMethod static void testCRMContact(){
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
   
   
   System.assertNotEquals(null, sfEnt.CRM_FirmLocationID);
   System.assertNotEquals(0, sfEnt.ContactID_KM);
   System.assertNotEquals(null, sfEnt.CRM_ContactID);
   System.assertNotEquals(0, sfEnt.ContactID_GL);
   System.assertEquals(DateTime.newInstance(2000, 09, 09), sfEnt.Birthday);
   System.assertEquals(true, sfEnt.PreferredContactPhone);
   System.assertEquals(true, sfEnt.PreferredContactFax);
   System.assertEquals(true, sfEnt.DoNotContactPhone);
   System.assertEquals(true, sfEnt.DoNotContactFax);
   System.assertEquals(true, sfEnt.DoNotContactEmail);
   System.assertEquals(true, sfEnt.IsActive);
   
   
   System.assertNotEquals(null, sfEnt.FirstName);
   System.assertNotEquals(null, sfEnt.LastName);
   System.assertNotEquals(null, sfEnt.MiddleName);
   System.assertNotEquals(null, sfEnt.email);
   System.assertNotEquals(null, sfEnt.ContactInformation);
   System.assertNotEquals(null, sfEnt.Suffix);
   System.assertNotEquals(null, sfEnt.PhoneNumber);
   System.assertNotEquals(null, sfEnt.Fax);
   System.assertNotEquals(null, sfEnt.type);
   System.assertNotEquals(null, sfEnt.suffix);
 
 }
 
  testMethod static void testSFContact(){
   MedlienEntities.SFContact sfEnt = new MedlienEntities.SFContact();
   sfEnt.CRM_FirmLocationID = '1234ert';
   sfEnt.CRM_ContactID = '1234ert';
   sfEnt.ContactID_KM = 12;
   sfEnt.ContactID_AT = 'test';
   sfEnt.FirmLocationID_KM = 12;
   sfEnt.FirmLocationID_GL = 12;
   sfEnt.FirmLocationID_AT = '333ddddd';
   
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
   sfEnt.CRM_FirmType = 'Payer' ;
   
   
   System.assertNotEquals(null, sfEnt.CRM_FirmLocationID);
   System.assertNotEquals(null, sfEnt.CRM_ContactID);
   System.assertNotEquals(null, sfEnt.FirmLocationID_AT);
   System.assertNotEquals(null, sfEnt.ContactID_AT);
   System.assertNotEquals(0, sfEnt.ContactID_KM);
   System.assertNotEquals(0, sfEnt.FirmLocationID_KM);
   System.assertNotEquals(0, sfEnt.FirmLocationID_GL);
   System.assertNotEquals(null, sfEnt.CRM_ContactID);
   System.assertNotEquals(0, sfEnt.ContactID_GL);
   System.assertEquals(DateTime.newInstance(2000, 09, 09), sfEnt.Birthday);
   System.assertEquals(true, sfEnt.PreferredContactPhone);
   System.assertEquals(true, sfEnt.PreferredContactFax);
   System.assertEquals(true, sfEnt.DoNotContactPhone);
   System.assertEquals(true, sfEnt.DoNotContactFax);
   System.assertEquals(true, sfEnt.DoNotContactEmail);
   System.assertEquals(true, sfEnt.IsActive);
   
   
   System.assertNotEquals(null, sfEnt.FirstName);
   System.assertNotEquals(null, sfEnt.LastName);
   System.assertNotEquals(null, sfEnt.MiddleName);
   System.assertNotEquals(null, sfEnt.email);
   System.assertNotEquals(null, sfEnt.ContactInformation);
   System.assertNotEquals(null, sfEnt.Suffix);
   System.assertNotEquals(null, sfEnt.PhoneNumber);
   System.assertNotEquals(null, sfEnt.Fax);
   System.assertNotEquals(null, sfEnt.type);
   System.assertNotEquals(null, sfEnt.suffix);
   System.assertNotEquals(null, sfEnt.CRM_FirmType);
 
 }

 
 testMethod static void testSFFirm(){
   MedlienEntities.SFFirm sfEnt = new MedlienEntities.SFFirm();
   sfEnt.CRM_FirmID = '1234ert';
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
   
   
   System.assertNotEquals(null, sfEnt.CRM_FirmID);
   System.assertNotEquals(0, sfEnt.FirmID_KM);
   System.assertNotEquals(null, sfEnt.FirmID_AT);
   System.assertNotEquals(0, sfEnt.FirmID_GL);
   System.assertEquals(true, sfEnt.HeadQuarter);
   System.assertNotEquals(null, sfEnt.FirmName);
   System.assertNotEquals(null, sfEnt.Address1);
   System.assertNotEquals(null, sfEnt.Address2);
   System.assertNotEquals(null, sfEnt.City);
   System.assertNotEquals(null, sfEnt.State);
   System.assertNotEquals(null, sfEnt.ZipCode);
   System.assertNotEquals(null, sfEnt.PhoneNumber);
   System.assertNotEquals(null, sfEnt.Fax);
   System.assertNotEquals(null, sfEnt.Website);
   System.assertNotEquals(null, sfEnt.type);
 
 }
 
 testMethod static void testSFFirmLocation(){
   MedlienEntities.SFFirmLocation sfEnt = new MedlienEntities.SFFirmLocation();
   sfEnt.CRM_ParentFirmID = '1234ert';
   sfEnt.FirmID_AT = '1234ert';
   sfEnt.FirmID_KM = 12;
   sfEnt.CRM_FirmID = '123456';
   sfEnt.FirmID_GL = 12345;
   
   sfEnt.ParentFirmID_KM = 12345;
   sfEnt.ParentFirmID_GL = 12345;
   sfEnt.ParentFirmID_AT = 'dddd';
   
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
   
   
   System.assertNotEquals(null, sfEnt.CRM_ParentFirmID);
   System.assertNotEquals(null, sfEnt.ParentFirmID_AT);
   System.assertNotEquals(0, sfEnt.ParentFirmID_KM);
   System.assertNotEquals(0, sfEnt.ParentFirmID_GL);
   System.assertNotEquals(null, sfEnt.FirmID_AT);
   System.assertNotEquals(0, sfEnt.FirmID_KM);
   System.assertNotEquals(null, sfEnt.CRM_FirmID);
   System.assertNotEquals(0, sfEnt.FirmID_GL);
   System.assertEquals(true, sfEnt.HeadQuarter);
   System.assertNotEquals(null, sfEnt.FirmName);
   System.assertNotEquals(null, sfEnt.Address1);
   System.assertNotEquals(null, sfEnt.Address2);
   System.assertNotEquals(null, sfEnt.City);
   System.assertNotEquals(null, sfEnt.State);
   System.assertNotEquals(null, sfEnt.ZipCode);
   System.assertNotEquals(null, sfEnt.PhoneNumber);
   System.assertNotEquals(null, sfEnt.Fax);
   System.assertNotEquals(null, sfEnt.Address1);
   System.assertNotEquals(null, sfEnt.Address2);
   System.assertNotEquals(null, sfEnt.City);
   System.assertNotEquals(null, sfEnt.State);
   System.assertNotEquals(null, sfEnt.type);
 
 }
 


}