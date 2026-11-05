@isTest
public class SFEntitiesTest{

 testMethod static void testCRMFirm(){
   SFEntities.Firm sfEnt = new SFEntities.Firm();
   sfEnt.CRM_FirmID = '1234ert';
   sfEnt.FirmID = 123456;
   sfEnt.PhoneNumber = '9560682173';
   sfEnt.Fax = '9560682173';
   sfEnt.Website = 'https:\\www.google.com';
   sfEnt.FirmName = 'test';
   
   System.assertNotEquals(null, sfEnt.CRM_FirmID);
   System.assertNotEquals(0, sfEnt.FirmID);
   System.assertNotEquals(null, sfEnt.PhoneNumber);
   System.assertNotEquals(null, sfEnt.Fax);
   System.assertNotEquals(null, sfEnt.Website);
   System.assertNotEquals(null, sfEnt.FirmName);
 
 }
 
 testMethod static void testFirmLocation(){
   SFEntities.FirmLocation sfEnt = new SFEntities.FirmLocation();
   sfEnt.CRM_FirmID = '1234ert';
   sfEnt.CRM_FirmLocationID = '123ertt';
   sfEnt.FirmID = 123456;
   sfEnt.FirmLocationID = 123456;
   sfEnt.FirmLocationName = 'Cal';
   sfEnt.Address1 = 'adr 1';
   sfEnt.Address2 = 'adr 2';
   sfEnt.City = 'Albama';
   sfEnt.State = 'California';
   sfEnt.ZipCode = '1234ER';
   
   System.assertNotEquals(null, sfEnt.CRM_FirmID);
   System.assertNotEquals(null, sfEnt.CRM_FirmLocationID);
   System.assertNotEquals(0, sfEnt.FirmID);
   System.assertNotEquals(0, sfEnt.FirmLocationID);
   System.assertNotEquals(null, sfEnt.FirmLocationName);
   System.assertNotEquals(null, sfEnt.Address1);
   System.assertNotEquals(null, sfEnt.Address2);
   System.assertNotEquals(null, sfEnt.City);
   System.assertNotEquals(null, sfEnt.State);
   System.assertNotEquals(null, sfEnt.ZipCode);
 
 }
 
 testMethod static void testAttorney(){
   SFEntities.Attorney sfEnt = new SFEntities.Attorney();
   sfEnt.CRM_FirmLocationID = '123ertt';
   sfEnt.CRM_AttorneyID = '1234ert';
   sfEnt.FirmID = 123456;
   sfEnt.FirmLocationID = 123456;
   sfEnt.AttorneyID = 123456;
   sfEnt.FirstName = 'Cal';
   sfEnt.LastName = 'Tat';
   sfEnt.Email = 'hitmprashant@gmail.com';
   sfEnt.PhoneNumber = '9560682173';
   sfEnt.Fax = '9560682173';
   sfEnt.Birthday = Date.newinstance(2000, 09,09);
   sfEnt.ContactInformation = 'test ';
   
   System.assertNotEquals(null, sfEnt.CRM_FirmLocationID);
   System.assertNotEquals(null, sfEnt.CRM_AttorneyID);
   System.assertNotEquals(0, sfEnt.FirmID);
   System.assertNotEquals(0, sfEnt.FirmLocationID);
   System.assertNotEquals(0, sfEnt.AttorneyID);
   System.assertNotEquals(null, sfEnt.FirstName);
   System.assertNotEquals(null, sfEnt.LastName);
   System.assertNotEquals(null, sfEnt.Email);
   System.assertNotEquals(null, sfEnt.PhoneNumber);
   System.assertNotEquals(null, sfEnt.Fax);
   System.assertNotEquals(null, sfEnt.Birthday);
   System.assertNotEquals(null, sfEnt.ContactInformation);
 
 }
 
 testMethod static void testAttorneyAssistant(){
   SFEntities.AttorneyAssistant sfEnt = new SFEntities.AttorneyAssistant();
   sfEnt.CRM_FirmID = '123ertt';
   sfEnt.CRM_FirmLocationID = '1234ert';
   sfEnt.CRM_AttorneyAssistantID = '1234ert';
   sfEnt.AttorneyAssistantID = 123456;
   sfEnt.AttorneyID = 123456;
   sfEnt.AttorneyAssistantType = 'new';
   sfEnt.Name = 'test';
   sfEnt.Email = 'hitmprashant@gmail.com';
   sfEnt.PhoneNumber = '9560682173';
   
   
   
   System.assertNotEquals(null, sfEnt.CRM_FirmID);
   System.assertNotEquals(null, sfEnt.CRM_FirmLocationID);
   System.assertNotEquals(0, sfEnt.AttorneyAssistantID);
   System.assertNotEquals(0, sfEnt.AttorneyID);
   System.assertNotEquals(null, sfEnt.CRM_AttorneyAssistantID);
   System.assertNotEquals(null, sfEnt.AttorneyAssistantType);
   System.assertNotEquals(null, sfEnt.Name);
   System.assertNotEquals(null, sfEnt.Email);
   System.assertNotEquals(null, sfEnt.PhoneNumber);
 
 }
 
 




}