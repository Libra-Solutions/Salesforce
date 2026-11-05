public class PresetMergeUpdateAttorneyContactJob implements Queueable, Database.AllowsCallouts {

    public String conId;
    public String attorneyID;
    public String reqBody;
  
    public PresetMergeUpdateAttorneyContactJob (String conId,String attorneyID){
        this.conId=conId;
        this.attorneyID=attorneyID;

        contact conRec=[select id,lastname,firstname,Fax,Email,phone,accountid,birthdate,account.OS_Firm_Location_Id__c,account.OS_Firm_Id__c from contact where id=:conId];
       
        PresetRequestModel  pr=new PresetRequestModel ();
        
        pr.PhoneNumber=conRec.phone;
        pr.LastName=conRec.LastName;
        pr.FirstName=conRec.FirstName;
        pr.Birthday=conRec.birthdate;
        pr.fax=conRec.fax;
        pr.email=conRec.email;
        pr.CRM_FirmLocationID=conRec.Accountid;
        pr.CRM_AttorneyID=conId;
        pr.AttorneyID=Integer.valueOf(attorneyID);
        
        pr.ContactInformation='';
        
        if(conRec.account.OS_Firm_Location_Id__c!=null){
            pr.FirmLocationID=Integer.valueOf(conRec.account.OS_Firm_Location_Id__c);
        }
         if(conRec.account.OS_Firm_Id__c !=null){
            pr.FirmID=Integer.valueOf(conRec.account.OS_Firm_Id__c );
        }

        reqBody=JSON.serialize(pr);
    }
    public void execute(QueueableContext context) {
        
        
         Preset_Medlien_Configuration__c  objReq =Preset_Medlien_Configuration__c.getAll().get('PresetUpdateAttorneyContact');
        
         PSCommunicationCache__c objpsc=new PSCommunicationCache__c();
         
         objpsc.InputPayload__c=reqBody;
         objpsc.Operation__c=objReq.End_Point__c;   
         objpsc.ObjectId__c=conId;
         objpsc.GenericName__c='PresetUpdateAttorneyContact';
         objpsc.IsError__c=true;
       
         HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request(reqBody,'PresetUpdateAttorneyContact','');
         
         objpsc.ResponsePayload__c=resfrmLoc.getBody();
         objpsc.LOB__c='PS';
         objpsc.ResponseStatus__c=resfrmLoc.getStatusCode()+'';
        
         if(resfrmLoc.getStatusCode()==200 && parse(resfrmLoc.getBody()).Status=='Success'){
             
              objpsc.IsError__c=false;
         }
         insert objpsc;
         
    }   
     public class PresetRequestModel {
       
        public String PhoneNumber;
        public String LastName;
        public String FirstName;
        public Integer FirmLocationID;
        public Integer FirmID;
        public String Fax;
        public String Email;
        public String CRM_FirmLocationID;
        public String CRM_AttorneyID;
        public String ContactInformation;
        public Object Birthday;
        public Integer AttorneyID;
    }
     public class PresetModel {
        public String Status;
    }
    public static PresetModel parse(String json) {
        return (PresetModel) System.JSON.deserialize(json, PresetModel.class);
    }
}