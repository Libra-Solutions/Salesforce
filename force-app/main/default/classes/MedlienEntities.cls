/**
  * @Created Date 04/24/2019
  * @author    OASISFINANCIAL GROUP
  * @copyright Copyright (c) 2019-2020 
  * @license   
  * @Modified Date
  * @Description 
*/
public class MedlienEntities
{

public class Firm {
 
      public String CRM_FirmID{set;get;}   
        
      public integer FirmID_KM {set;get;} 
      public String FirmID_AT {set;get;} 
      public integer FirmID_GL {set;get;} 
        
     
      public string FirmName {get; set;}
      public Boolean HeadQuarter {get; set;}
 
      public string Address1 { get; set; }
      public string Address2 { get; set; }
      public string City { get; set; }
      public string State { get; set; }
      public string ZipCode { get; set; }
      public string PhoneNumber { get; set; }
      public string Website { get; set; }
      public string Fax { get; set; }
        
      public String Type {get;set;}    //“Payer Only”  
      
   
}


public class FirmLocation {
 
      public String CRM_ParentFirmID{set;get;}  //Parent Firm Id This is reqd for FirmLocation
       
      public String CRM_FirmID{set;get;}   //CRM Firm Location ID : Needed for update
            
      public integer FirmID_KM {set;get;} 
      public String FirmID_AT {set;get;} 
      public integer FirmID_GL {set;get;} 
        
     
      public string FirmName {get; set;}
      public Boolean HeadQuarter {get; set;}
 
      public string Address1 { get; set; }
      public string Address2 { get; set; }
      public string City { get; set; }
      public string State { get; set; }
      public string ZipCode { get; set; }
      public string PhoneNumber { get; set; }
     // public string Website { get; set; }
      public string Fax { get; set; }
        
      public String Type {get;set;}    //“Payer Location”   
   
}

  public class  CRMContact{

   
    public String CRM_FirmLocationID{set;get;}   
    public String CRM_ContactID{set;get;}   
    
    public integer ContactID_KM {set;get;} 
    public String ContactID_AT {set;get;} 
    public integer ContactID_GL {set;get;} 
        
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string MiddleName { get; set; }
    public string Email { get; set; }
    public string PhoneNumber { get; set; }
    public string Fax { get; set; }
    public DateTime Birthday { get; set; }
    public string ContactInformation { get; set; }
    public string Type {get; set;}
    
     public Boolean PreferredContactPhone { get; set; } // if they prefer phone say it as 1 or else 0
     public Boolean PreferredContactFax { get; set; } //
     public Boolean PreferredContactEmail { get; set; }   //

     public Boolean DoNotContactPhone { get; set; } // few attorny’s never wanted us to contact them via phone. So donot contact will ‘1’
     public Boolean DoNotContactFax { get; set; }
     public Boolean DoNotContactEmail { get; set; }
     public Boolean IsActive {get;set;}
     
     public string Suffix {get;set;}
     

    
   }

//========================Used for SF to ML Integration==========================================

public class SFFirm {
 
      public String CRM_FirmID{set;get;}   
        
      public integer FirmID_KM {set;get;} 
      public String FirmID_AT {set;get;} 
      public integer FirmID_GL {set;get;} 
        
     
      public string FirmName {get; set;}
      public Boolean HeadQuarter {get; set;}
 
      public string Address1 { get; set; }
      public string Address2 { get; set; }
      public string City { get; set; }
      public string State { get; set; }
      public string ZipCode { get; set; }
      public string PhoneNumber { get; set; }
      public string Website { get; set; }
      public string Fax { get; set; }
        
      public String Type {get;set;}    //“Payer”  
      
         
      public Boolean Preset {get;set;}
      public Boolean Core {get;set;}
      public Boolean Atticus {get;set;}
      public Boolean AccidentMeds {get;set;}
      public Boolean GRS {get;set;}


}


public class SFFirmLocation {
 
      public String CRM_ParentFirmID{set;get;}  //Parent Firm Id This is reqd for FirmLocation
       
      public String CRM_FirmID{set;get;}   //CRM Firm Location ID : Needed for update
            
      public integer FirmID_KM {set;get;} 
      public String FirmID_AT {set;get;} 
      public integer FirmID_GL {set;get;} 
        
      public integer ParentFirmID_KM {set;get;} 
      public String ParentFirmID_AT {set;get;} 
      public integer ParentFirmID_GL {set;get;} 
     
      public string FirmName {get; set;}
      public Boolean HeadQuarter {get; set;}
 
      public string Address1 { get; set; }
      public string Address2 { get; set; }
      public string City { get; set; }
      public string State { get; set; }
      public string ZipCode { get; set; }
      public string PhoneNumber { get; set; }
     // public string Website { get; set; }
      public string Fax { get; set; }
        
      public String Type {get;set;}    //“Payer Location”   
      
      
         
      public Boolean Preset {get;set;}
      public Boolean Core {get;set;}
      public Boolean Atticus {get;set;}
      public Boolean AccidentMeds {get;set;}
      public Boolean GRS {get;set;}

}

  public class  SFContact{

   
    public String CRM_FirmLocationID{set;get;}   
    public String CRM_ContactID{set;get;}   
    
    public integer FirmLocationID_KM  {set;get;} 
    public String FirmLocationID_AT {set;get;} 
    public integer FirmLocationID_GL {set;get;} 
        
     public integer ContactID_KM {get;set;}
     public String ContactID_AT {get;set;}
      public integer ContactID_GL { get;set;}
        
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string MiddleName { get; set; }
    public string Email { get; set; }
    public string PhoneNumber { get; set; }
    public string Fax { get; set; }
    public DateTime Birthday { get; set; }
    public string ContactInformation { get; set; }
    public string Type {get; set;}
    
     public Boolean PreferredContactPhone { get; set; } // if they prefer phone say it as 1 or else 0
     public Boolean PreferredContactFax { get; set; } //
     public Boolean PreferredContactEmail { get; set; }   //

     public Boolean DoNotContactPhone { get; set; } // few attorny’s never wanted us to contact them via phone. So donot contact will ‘1’
     public Boolean DoNotContactFax { get; set; }
     public Boolean DoNotContactEmail { get; set; }
     public Boolean IsActive {get;set;}
     
     public string CRM_FirmType { get;set;}
     public string Suffix {get;set;}
     
     
        
      public Boolean Preset {get;set;}
      public Boolean Core {get;set;}
      public Boolean Atticus {get;set;}
      public Boolean AccidentMeds {get;set;}
      public Boolean GRS {get;set;}
  }

      
}