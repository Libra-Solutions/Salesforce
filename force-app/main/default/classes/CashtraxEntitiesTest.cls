@isTest
public class CashtraxEntitiesTest{

 testMethod static void testFirm(){
   CashtraxEntities.Firm cashtrxEnt = new CashtraxEntities.Firm();
   cashtrxEnt.CRM_FirmID = '123ertt';
   cashtrxEnt.FirmID = '1234ert';
   cashtrxEnt.HeadQuarter = true;
   cashtrxEnt.Website = 'https://www.google.com';
   cashtrxEnt.fax = '9560682173';
   cashtrxEnt.type = 'new';
   cashtrxEnt.PhoneNumber = '9560682173';
    
   
   
   System.assertNotEquals(null, cashtrxEnt.CRM_FirmID);
   System.assertNotEquals(null, cashtrxEnt.FirmID);
   System.assertEquals(true, cashtrxEnt.HeadQuarter);
   System.assertNotEquals(null, cashtrxEnt.Website);
   System.assertNotEquals(null, cashtrxEnt.fax);
   System.assertNotEquals(null, cashtrxEnt.type);
   System.assertNotEquals(null, cashtrxEnt.PhoneNumber);
   
 }
 
 testMethod static void testFirmLocation(){
   CashtraxEntities.FirmLocation cashtrxEnt = new CashtraxEntities.FirmLocation();
   cashtrxEnt.CRM_FirmID = '123ertt';
   cashtrxEnt.CRM_FirmLocationID = '1234ert';
   cashtrxEnt.FirmLocationID = '1234ert';
   cashtrxEnt.FirmID = '1234ert';
   cashtrxEnt.FirmLocationName = 'test';
   cashtrxEnt.HeadQuarter = true;
   cashtrxEnt.Address1 = 'adr 1';
   cashtrxEnt.Address2 = 'adr 2';
   cashtrxEnt.City = 'Connecticut';
   cashtrxEnt.State = 'Colorado';
   cashtrxEnt.ZipCode = '1234ER';
   cashtrxEnt.type = 'new';
   
   
   System.assertNotEquals(null, cashtrxEnt.CRM_FirmID);
   System.assertNotEquals(null, cashtrxEnt.CRM_FirmLocationID);
   System.assertNotEquals(null, cashtrxEnt.FirmLocationID);
   System.assertNotEquals(null, cashtrxEnt.FirmID);
   System.assertNotEquals(null, cashtrxEnt.FirmLocationName);
   System.assertEquals(true, cashtrxEnt.HeadQuarter);
   System.assertNotEquals(null, cashtrxEnt.Address1);
   System.assertNotEquals(null, cashtrxEnt.Address1);
   System.assertNotEquals(null, cashtrxEnt.City);
   System.assertNotEquals(null, cashtrxEnt.State);
   System.assertNotEquals(null, cashtrxEnt.type);
   System.assertNotEquals(null, cashtrxEnt.ZipCode);
   
 }
 
 testMethod static void testAttorney(){
   CashtraxEntities.Attorney cashtrxEnt = new CashtraxEntities.Attorney();
   cashtrxEnt.CRM_FirmLocationID = '123ertt';
   cashtrxEnt.CRM_AttorneyID = '1234ert';
   cashtrxEnt.AttorneyID = 1234;
   cashtrxEnt.FirstName = 'test 1';
   cashtrxEnt.LastName = 'test';
   cashtrxEnt.Email = 'hitmprashant@gmail.com';
   cashtrxEnt.Portal = true;
   cashtrxEnt.PhoneNumber = '9560682173';
   cashtrxEnt.Fax = '9560682173';
   cashtrxEnt.Birthday = datetime.newInstance(2014, 9, 15, 12, 30, 0);
   cashtrxEnt.ContactInformation = 'Colorado';
   cashtrxEnt.BarVerificationDate = datetime.newInstance(2014, 9, 15, 12, 30, 0);
   cashtrxEnt.BarVerificationExpirationDate = datetime.newInstance(2014, 9, 15, 12, 30, 0);
   
   System.assertNotEquals(null, cashtrxEnt.CRM_FirmLocationID);
   System.assertNotEquals(null, cashtrxEnt.CRM_AttorneyID);
   System.assertNotEquals(0, cashtrxEnt.AttorneyID);
   System.assertNotEquals(null, cashtrxEnt.FirstName);
   System.assertNotEquals(null, cashtrxEnt.LastName);
   System.assertNotEquals(null, cashtrxEnt.Email);
   System.assertEquals(true, cashtrxEnt.Portal);
   System.assertNotEquals(null, cashtrxEnt.PhoneNumber);
   System.assertNotEquals(null, cashtrxEnt.Fax);
   System.assertEquals(datetime.newInstance(2014, 9, 15, 12, 30, 0), cashtrxEnt.Birthday);
   System.assertNotEquals(null, cashtrxEnt.ContactInformation);
   System.assertEquals(datetime.newInstance(2014, 9, 15, 12, 30, 0), cashtrxEnt.BarVerificationDate);
   System.assertEquals(datetime.newInstance(2014, 9, 15, 12, 30, 0), cashtrxEnt.BarVerificationExpirationDate);
   
 }
 
 testMethod static void testAttorneyAssistant(){
   CashtraxEntities.AttorneyAssistant cashtrxEnt = new CashtraxEntities.AttorneyAssistant();
   cashtrxEnt.CRM_FirmID = '123ertt';
   cashtrxEnt.CRM_FirmLocationID = '1234ert';
   cashtrxEnt.CRM_AttorneyID = '1234ert';
   cashtrxEnt.CRM_AttorneyAssistantID = '1234ert';
   cashtrxEnt.AttorneyAssistantID = 1234;
   cashtrxEnt.AttorneyAssistantType = 'test';
   cashtrxEnt.Name = 'test 1';
   cashtrxEnt.FirstName = 'test';
   cashtrxEnt.LastName = 'test';
   cashtrxEnt.Email = 'hitmprashant@gmail.com';
   cashtrxEnt.PhoneNumber = '9560682173';
   cashtrxEnt.Fax = '9560682173';
      
   System.assertNotEquals(null, cashtrxEnt.CRM_FirmID);
   System.assertNotEquals(null, cashtrxEnt.CRM_FirmLocationID);
   System.assertNotEquals(null, cashtrxEnt.CRM_AttorneyID);
   System.assertNotEquals(null, cashtrxEnt.CRM_AttorneyAssistantID);
   System.assertNotEquals(0, cashtrxEnt.AttorneyAssistantID);
   System.assertNotEquals(null, cashtrxEnt.AttorneyAssistantType);
   System.assertNotEquals(null, cashtrxEnt.Name);
   System.assertNotEquals(null, cashtrxEnt.FirstName);
   System.assertNotEquals(null, cashtrxEnt.LastName);
   System.assertNotEquals(null, cashtrxEnt.Email);
   System.assertNotEquals(null, cashtrxEnt.PhoneNumber);
   System.assertNotEquals(null, cashtrxEnt.Fax);
   
 }
 
 testMethod static void testActivity(){
   CashtraxEntities.Activity cashtrxEnt = new CashtraxEntities.Activity();
   cashtrxEnt.FirmName = '123ertt';
   cashtrxEnt.Attorney = '1234ert';
   cashtrxEnt.Subject = '1234ert';
   cashtrxEnt.Type = '1234ert';
   cashtrxEnt.Comments = 'test';
   cashtrxEnt.AssignedTo = 'test 1';
   cashtrxEnt.DueDate = Date.newInstance(2000,09,09);
   cashtrxEnt.CreatedBy = 'test';
   cashtrxEnt.CreatedDate = datetime.newInstance(2014, 9, 15, 12, 30, 0);
   cashtrxEnt.SubType = 'Atty no longer in Firm	';
      
   System.assertNotEquals(null, cashtrxEnt.FirmName);
   System.assertNotEquals(null, cashtrxEnt.Attorney);
   System.assertNotEquals(null, cashtrxEnt.Subject);
   System.assertNotEquals(null, cashtrxEnt.Type);
   System.assertNotEquals(null, cashtrxEnt.Comments);
   System.assertNotEquals(null, cashtrxEnt.AssignedTo);
   System.assertEquals(Date.newInstance(2000,09,09), cashtrxEnt.DueDate);
   System.assertNotEquals(null, cashtrxEnt.CreatedBy);
   System.assertEquals(datetime.newInstance(2014, 9, 15, 12, 30, 0), cashtrxEnt.CreatedDate);
   System.assertNotEquals(null, cashtrxEnt.SubType);
 }
 
 testMethod static void testSFNote(){
   CashtraxEntities.SFNote cashtrxEnt = new CashtraxEntities.SFNote();
   cashtrxEnt.CRMNoteID = '123ertt';
   cashtrxEnt.Attorney = '1234ert';
   cashtrxEnt.Title = '1234ert';
   cashtrxEnt.NoteText = '1234ert';
   cashtrxEnt.OwnerName = 'test';
   cashtrxEnt.CreatedBy = 'test';
   cashtrxEnt.CreatedDate = datetime.newInstance(2014, 9, 15, 12, 30, 0);
      
   System.assertNotEquals(null, cashtrxEnt.CRMNoteID);
   System.assertNotEquals(null, cashtrxEnt.Attorney);
   System.assertNotEquals(null, cashtrxEnt.Title);
   System.assertNotEquals(null, cashtrxEnt.NoteText);
   System.assertNotEquals(null, cashtrxEnt.OwnerName);
   System.assertNotEquals(null, cashtrxEnt.CreatedBy);
   System.assertEquals(datetime.newInstance(2014, 9, 15, 12, 30, 0), cashtrxEnt.CreatedDate);
 }
 
 testMethod static void testActivityRequest(){
   CashtraxEntities.ActivityRequest cashtrxEnt = new CashtraxEntities.ActivityRequest();
   cashtrxEnt.CRM_FirmLocationID = '123ertt';
   cashtrxEnt.CRM_AttorneyID = '1234ert';
   cashtrxEnt.count = 1;
  
      
   System.assertNotEquals(null, cashtrxEnt.CRM_FirmLocationID);
   System.assertNotEquals(null, cashtrxEnt.CRM_AttorneyID);
   System.assertNotEquals(0, cashtrxEnt.count);
   
 }
 
 testMethod static void testNewCase(){
   CashtraxEntities.NewCase cashtrxEnt = new CashtraxEntities.NewCase();
   cashtrxEnt.CRM_ID = '123ertt';
   cashtrxEnt.AttorneyID = 1;
   cashtrxEnt.CaseID = 1;
   cashtrxEnt.PlaintiffFirstName = '123ertt';
   cashtrxEnt.PlaintiffLastName = '123ertt';
   cashtrxEnt.Address1 = '123ertt';
   cashtrxEnt.Address2 = '123ertt';
   cashtrxEnt.City = '123ertt';
   cashtrxEnt.State = '123ertt';
   cashtrxEnt.ZipCode = '123ertt';
   cashtrxEnt.Email = 'hitmprashant@gmail.com';
   cashtrxEnt.Phone = '9560682173';
   cashtrxEnt.DOB = Date.newInstance(2000, 09,09);
   cashtrxEnt.AmountRequested = 20.00;
   cashtrxEnt.StateOfCourt = 'San Diego';
   cashtrxEnt.CaseType = 'New';
   cashtrxEnt.IncidentDate = Date.newInstance(2000, 09,09);
   cashtrxEnt.PlaintiffInvolvement = 'Yes';
   cashtrxEnt.AccidentType = 'Wound';
   //cashtrxEnt.Injuries = new List<String> {'H', 'J'};
   //cashtrxEnt.OtherInjuries =  'J';
   //cashtrxEnt.Treatments = new List<String> {'H', 'J'};
   //cashtrxEnt.OtherTreatments = 'K';
   cashtrxEnt.TreatmentsDescription = 'Test' ;
   cashtrxEnt.AdditionalInformation = 'Additonal Comments';
   cashtrxEnt.MoreThan1000Damage = 'er';
   cashtrxEnt.WhosInsurancePaid = 'er';
   cashtrxEnt.OfferAmount = 10.00;
   cashtrxEnt.descriptionOfAccident = 'er';
   cashtrxEnt.descriptionOfIncident = 'er';
   cashtrxEnt.closedDescription = 'er';
   cashtrxEnt.uimum = 'er';
   cashtrxEnt.propertyDamageAmount = 'er';
   cashtrxEnt.plaintiffWas = 'er';
   cashtrxEnt.plaintiffInjury = 'er';
   cashtrxEnt.ifYesHowMuch = 'er';
      
   System.assertNotEquals(null, cashtrxEnt.AmountRequested);
   System.assertNotEquals(0, cashtrxEnt.AttorneyID);
   System.assertNotEquals(0, cashtrxEnt.CaseID);
   System.assertNotEquals(null, cashtrxEnt.PlaintiffFirstName);
   System.assertNotEquals(null, cashtrxEnt.PlaintiffLastName);
   System.assertNotEquals(null, cashtrxEnt.Address1);
   System.assertNotEquals(null, cashtrxEnt.Address2);
   System.assertNotEquals(null, cashtrxEnt.City);
   System.assertNotEquals(null, cashtrxEnt.State);
   System.assertNotEquals(null, cashtrxEnt.ZipCode);
   System.assertNotEquals(null, cashtrxEnt.Email);
   System.assertNotEquals(null, cashtrxEnt.Phone);
   System.assertEquals(Date.newInstance(2000, 09,09), cashtrxEnt.DOB);
   
   System.assertNotEquals(0.0, cashtrxEnt.AmountRequested);
   System.assertNotEquals(null, cashtrxEnt.StateOfCourt);
   System.assertNotEquals(null, cashtrxEnt.CaseType);
   System.assertEquals(Date.newInstance(2000, 09,09), cashtrxEnt.IncidentDate);
   System.assertNotEquals(null, cashtrxEnt.PlaintiffInvolvement);
   System.assertNotEquals(null, cashtrxEnt.AccidentType);
   //System.assertNotEquals(null, cashtrxEnt.Injuries);
   //System.assertNotEquals(null, cashtrxEnt.OtherInjuries);
   //System.assertNotEquals(null, cashtrxEnt.Treatments);
   //System.assertNotEquals(null, cashtrxEnt.OtherTreatments);
   System.assertNotEquals(null, cashtrxEnt.TreatmentsDescription);
   System.assertNotEquals(null, cashtrxEnt.AdditionalInformation);
   System.assertNotEquals(null, cashtrxEnt.MoreThan1000Damage);
   System.assertNotEquals(null, cashtrxEnt.WhosInsurancePaid);
   System.assertNotEquals(0.0, cashtrxEnt.OfferAmount);
   System.assertNotEquals(null, cashtrxEnt.descriptionOfAccident);
   System.assertNotEquals(null, cashtrxEnt.descriptionOfIncident);
   System.assertNotEquals(null, cashtrxEnt.closedDescription);
   System.assertNotEquals(null, cashtrxEnt.uimum);
   System.assertNotEquals(null, cashtrxEnt.propertyDamageAmount);
   System.assertNotEquals(null, cashtrxEnt.plaintiffWas);
   System.assertNotEquals(null, cashtrxEnt.plaintiffInjury);
   System.assertNotEquals(null, cashtrxEnt.ifYesHowMuch);
   
   
 }
 testMethod static void testupdateActivity(){
   CashtraxEntities.UpdateActivity cashtrxEnt = new CashtraxEntities.UpdateActivity();
   cashtrxEnt.Type = '1234ert';
   cashtrxEnt.TaskSubtype = '1234ert';
   cashtrxEnt.Description = '1234ert';

   System.assertNotEquals(null, cashtrxEnt.TaskSubtype);
   System.assertNotEquals(null, cashtrxEnt.Description);
   System.assertNotEquals(null, cashtrxEnt.Type);
 }
    
 testMethod static void testEvent(){
   CashtraxEntities.Event cashtrxEnt = new CashtraxEntities.Event();
   cashtrxEnt.FirmName = '123ertt';
   cashtrxEnt.Attorney = '1234ert';
   cashtrxEnt.Subject = '1234ert';
   cashtrxEnt.CRM_FirmID = '123ertt';
   cashtrxEnt.AttorneyId = '1234ert';
   cashtrxEnt.EventType = 'test';
   cashtrxEnt.ResultOfEvent = 'test 1';
   cashtrxEnt.StartDateTime = datetime.newInstance(2014, 9, 15, 12, 30, 0);
   cashtrxEnt.DueDate = Date.newInstance(2014, 9,9);
   cashtrxEnt.CreatedByName = 'test';
   cashtrxEnt.Description = 'test';
   cashtrxEnt.OwnerName = 'test';
   cashtrxEnt.Location = 'test';
   cashtrxEnt.CreatedDate = datetime.newInstance(2014, 9, 15, 12, 30, 0);
      
   System.assertNotEquals(null, cashtrxEnt.FirmName);
   System.assertNotEquals(null, cashtrxEnt.Attorney);
   System.assertNotEquals(null, cashtrxEnt.Subject);
   System.assertNotEquals(null, cashtrxEnt.CRM_FirmID);
   System.assertNotEquals(null, cashtrxEnt.ResultOfEvent);
   System.assertNotEquals(null, cashtrxEnt.CreatedByName);
   System.assertEquals(Date.newInstance(2014, 9,9), cashtrxEnt.DueDate);
   System.assertNotEquals(null, cashtrxEnt.Description);
   System.assertNotEquals(null, cashtrxEnt.OwnerName);
   System.assertNotEquals(null, cashtrxEnt.Location);
   System.assertEquals(datetime.newInstance(2014, 9, 15, 12, 30, 0), cashtrxEnt.CreatedDate);
   System.assertEquals(datetime.newInstance(2014, 9, 15, 12, 30, 0), cashtrxEnt.StartDateTime);
 }

 
 
}