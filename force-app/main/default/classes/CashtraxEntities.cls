/**
  * @Created Date 04/24/2019
  * @author    OASISFINANCIAL GROUP
  * @copyright Copyright (c) 2019-2020 
  * @license   
  * @Modified Date
  * @Description 
*/
public class CashtraxEntities
{

public static boolean UpdatedByCashtrax = false; 
public static boolean ParentLOBChanged = false; 
public static boolean UpdateComingFromLeadConversion = false; 

public class Firm {
 
      public String CRM_FirmID{set;get;}  //This is reqd for FirmLocation
      
      public String FirmID{set;get;} //CTX ID
      public string FirmName {get; set;}
      public Boolean HeadQuarter {get; set;}
 /*
    public string Address1 { get; set; }
    public string Address2 { get; set; }
    public string City { get; set; }
    public string State { get; set; }
    public string ZipCode { get; set; }
  */
    public string PhoneNumber { get; set; }
    public string Website { get; set; }
    public string Fax { get; set; }
    
    public String Type {get;set;}
}

public class FirmLocation {
 
      public String CRM_FirmID{set;get;}  //This is reqd for FirmLocation
      public String CRM_FirmLocationID{set;get;} 

      public String FirmLocationID  {set;get;} //CTX ID
      public String FirmID{set;get;} 
      public string FirmLocationName {get; set;}
      public Boolean HeadQuarter {get; set;}
 
    public string Address1 { get; set; }
    public string Address2 { get; set; }
    public string City { get; set; }
    public string State { get; set; }
    public string ZipCode { get; set; }
    
    public string AssignedACEmail { get; set; }
  
    //public string PhoneNumber { get; set; }
   // public string Website { get; set; }
   // public string Fax { get; set; }
    
    public String Type {get;set;}
}


  public class  Attorney{

   
  public String CRM_FirmID{set;get;}
   // public integer CTX_FirmID {get; set;}
    public String CRM_FirmLocationID{set;get;} 
   
   
    public String CRM_AttorneyID { get; set; }   //Needed For Update
    public integer AttorneyID { get; set; }  //CTX ID
    public string FirstName { get; set; }
    public string LastName { get; set; }
    //public string MiddleName { get; set; }
 
    public string Email { get; set; }
    public string PhoneNumber { get; set; }
    public string Fax { get; set; }
    public DateTime Birthday { get; set; }
    public string ContactInformation { get; set; }
    
   // public string Type {get; set;}
    public DateTime BarVerificationDate {get;set;}
    public DateTime BarVerificationExpirationDate {get;set;}
    public Boolean Portal {get;set; }

    // added 7/27/2020 DW to support providing an owner from CashTrax  
    public string OwnerEmail { get; set; }
   }
   

    public class AttorneyAssistant{

        public String CRM_FirmID{set;get;}
         public String CRM_FirmLocationID{set;get;}
        public String CRM_AttorneyID { get; set; }
        public String CRM_AttorneyAssistantID { get; set; }    //Needed for Update - CRM ID
        public integer AttorneyAssistantID { get; set; }        //CashTrax ID
        public string AttorneyAssistantType { get; set; }
        
        public string Name { get; set; }

        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string PhoneNumber { get; set; }
        public string fax {get; set;}

    }
    
    public class UpdateActivity{
        public String Type{get;set;} 
        public String TaskSubtype {get;set;} 
        public String Description {get;set;}
        public String CRM_AttorneyID {get;set;}
        public String CreatedBy {get;set;}
        public String Subject {get;set;}
        public Datetime CreatedDate {get;set;}
        public String AttorneyNoteID {get;set;}
        public String AssignedTo {get;set;}
        public String ActivityDate {get;set;}
        public String Status {get; set;}
                public String CaseNumber {get; set;}
    }
    
    public class DeleteAccount{
        public String primaryFirmID{get;set;} 
        public String secondaryFirmID{get;set;} 
    }
    
    public class DeleteContact{
        public String primaryConID{get;set;} 
        public String secondaryConID{get;set;} 
    }
    
    public class moveContact{
        public String accID{get;set;} 
        public String conID{get;set;} 
    }
    
    public class Activity{

        public String FirmName {set;get;}
        public String Attorney { get; set; }
        public String Subject {get;set;} 
        public String Type{get;set;} 
        public String Comments {get;set;} 
        public String AssignedTo {get;set;} 
        public Date DueDate {get;set;} 
        public String CreatedBy {get;set;}
        public Datetime CreatedDate {get;set;}  
        public String SubType {get;set;}
    }
 
    public class Event{

        public String FirmName {set;get;}
        public String CRM_FirmId {set;get;}
        public String Attorney { get; set; }
        public String AttorneyId { get; set; }
        public String Subject {get;set;} 
        public String EventType{get;set;} 
        public String ResultOfEvent{get;set;} 
        public Datetime StartDateTime {get;set;}
        public String CreatedByName {get;set;}
        public String Description{get;set;} 
        public String OwnerName {get;set;} 
        public Date DueDate {get;set;} 
        public String Location {get;set;}
        public Datetime CreatedDate {get;set;}  
    }
 
    
    public class  SFNote{

        public String CRMNoteID { get;set; }
        public String Attorney { get; set; }
        public String Title {get;set;} 
        public String NoteText {get;set;} 
        public String OwnerName {get;set;} 
       
        public String CreatedBy {get;set;}
        public Datetime CreatedDate {get;set;}  
    }
    
     public class ActivityRequest{

        public String CRM_FirmLocationID{set;get;}
        public String CRM_AttorneyID { get; set; }
        public integer count {get;set;} 
        
    }
    
    
    public class NewCase

    {

        // NEW Case
        public String CRM_ID { get;set; }
        public integer AttorneyID { get; set; }

        public integer CaseID { get; set; }
        
 

        // Plaintiff Information

        public string PlaintiffFirstName { get; set; }

        public string PlaintiffLastName { get; set; }

        public string Address1 { get; set; }

        public string Address2 { get; set; }

        public string City { get; set; }

        public string State { get; set; }

        public string ZipCode { get; set; }

        public string Email { get; set; }

        public string Phone { get; set; }

        public date DOB { get; set; }

 

        // Case Information

        public decimal AmountRequested { get; set; }

        public string StateOfCourt { get; set; }

        public string CaseType { get; set; }

        public date IncidentDate { get; set; }

 

        // AUTO - Accident Information

        public string PlaintiffInvolvement { get; set; }

        public string AccidentType { get; set; }        //

 

        //public List<string> Injuries { get; set; }

        public string Injuries { get; set; }

        //public List<string> Treatments { get; set; }

        public string Treatments { get; set; }

 

        public string TreatmentsDescription { get; set; }

 

        // WORKER'S COMPENSATION - Case Details

        public string AdditionalInformation { get; set; }

        public string MoreThan1000Damage { get; set; }

        public string WhosInsurancePaid { get; set; }

        public decimal OfferAmount { get; set; }
        public decimal amountOfCoverage { get; set; }
        public decimal probability { get; set; }
        
        public string descriptionOfAccident {get;set;}
        public string descriptionOfIncident {get;set;}
        public string closedDescription {get;set;}
        public string uimum {get;set;}
        public string propertyDamageAmount { get; set; }
        public string plaintiffWas { get; set; }
        public string plaintiffInjury { get; set; }
        public string ifYesHowMuch {get;set;}
        
        public string facilityType {get;set;}
        //public string dbCompetetor {get;set;}
        public string averageWeeklyWage {get;set;}
        public string isSuitFiled {get;set;}
        public string isthereaSettlementOffer {get;set;}
        public string isthereathirdPartyAction {get;set;}
        public string liensAgainstCase {get;set;}
        public string liability {get;set;}
        public string isCaseAccepted {get;set;}
        public string hasPlaintiffReceivedAnyOffers {get;set;}
        public date accidentDate { get; set; }
        public date openDate { get; set; }
        public string otherReason {get;set;}
        public date closeDate { get; set; }
        public string claimNumber {get;set;}
        public string additionalCaseDetails {get;set;}
    }
/*
    public class FundedCase{
        
        public string plaintiffName { get; set; }
        public Integer caseNumber { get; set; }
        public Decimal amount { get; set; }
        public string CRM_FirmID { get; set; }
        public string CRM_FirmLocationID { get; set; }
        public string CRM_AttorneyID { get; set; }
    }
*/

}