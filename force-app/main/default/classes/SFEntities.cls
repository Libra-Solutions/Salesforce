/**
  * @Created Date 04/24/2019
  * @author    OASISFINANCIAL GROUP
  * @copyright Copyright (c) 2019-2020 
  * @license   
  * @Modified Date
  * @Description 
*/
public class SFEntities {
    
    public class Firm {
    
     public String CRM_FirmID{set;get;}
     public  integer FirmID{set;get;}
    
    //public integer HeadQuarter{set;get;}
    

    public string FirmName {get; set;}
  /*  public string Address1 { get; set; }
    public string Address2 { get; set; }
    public string City { get; set; }
    public string State { get; set; }
    public string ZipCode { get; set; }
   
    */
    public string PhoneNumber { get; set; }
    public string Fax { get; set; }
    public string Website {get;set;}

}


public class FirmLocation {
    
     public String CRM_FirmID{set;get;}
     public String CRM_FirmLocationID{set;get;}
     public integer FirmID{set;get;}
     
     public integer FirmLocationID { get; set; }
    // public integer HeadQuarter{set;get;}
    

    public string FirmLocationName {get; set;}
    public string Address1 { get; set; }
    public string Address2 { get; set; }
    public string City { get; set; }
    public string State { get; set; }
    public string ZipCode { get; set; }
  //  public string PhoneNumber { get; set; }
   // public string Website {get;set;}

}

  public class  Attorney{

 public String CRM_FirmLocationID{set;get;} 
    public String CRM_AttorneyID { get; set; }
   
    public integer FirmID {get; set;}
   public integer FirmLocationID {get; set;}
    public integer AttorneyID { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
   // public string MiddleName { get; set; }
   /* public string Address1 { get; set; }
    public string Address2 { get; set; }
    public string City { get; set; }
    public string State { get; set; }
    public string ZipCode { get; set; }
    */
    public string Email { get; set; }
    public string PhoneNumber { get; set; }
    public string Fax { get; set; }
    public DateTime Birthday { get; set; }
    public string ContactInformation { get; set; }
  //  public string Type {get; set;}
   
   }
   

    public class AttorneyAssistant{
        
        public String CRM_FirmID{set;get;}
        public String CRM_FirmLocationID { get; set; }    //CRM ID
        public String CRM_AttorneyAssistantID { get; set; }    //CRM ID
        public integer AttorneyAssistantID { get; set; }        //CashTrax ID
        public integer AttorneyID { get; set; }
         
        public string AttorneyAssistantType { get; set; }
        
        public string Name { get; set; }
    //    public string LastName { get; set; }
        public string Email { get; set; }
        public string PhoneNumber { get; set; }

    }
    
    
}