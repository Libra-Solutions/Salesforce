public class PresetUpdateFirmLocationQueuableJob implements Queueable, Database.AllowsCallouts {

    public String fromFirmId;
    public String toAccountId;
    public String reqBody;
  
    public PresetUpdateFirmLocationQueuableJob (String fromFirmId,String toAccountId,String fromfirmLocationId,String fromfirmLocationsSfId){
        this.fromFirmId=fromFirmId;
        this.toAccountId=toAccountId;

        Account accRecords=[Select name,BillingStreet,parentid,parent.OS_Firm_Id__c,OS_Firm_Id__c,OS_Firm_Location_Id__c, BillingCity,Street2__c, BillingState, BillingPostalCode, BillingCountry, BillingStateCode, BillingCountryCode  from Account where Id=:toAccountId];
        
        PresetRequestModel  pr=new PresetRequestModel ();
        
        pr.ZipCode=(accRecords.BillingPostalCode==null?'':accRecords.BillingPostalCode);
        pr.State=(accRecords.BillingState==null?'':accRecords.BillingState);
        pr.City=(accRecords.BillingCity==null?'':accRecords.BillingCity);
        
        //pr.Address1=pr.ZipCode+' '+pr.State+' '+pr.City;
       // pr.Address2=pr.ZipCode+' '+pr.State+' '+pr.City;
       pr.Address1=(accRecords.BillingStreet==null?'':accRecords.BillingStreet);
       pr.Address2=(accRecords.Street2__c==null?'':accRecords.Street2__c);
         
        pr.FirmLocationName=accRecords.name;
        
        if(fromFirmId!=null && fromFirmId.trim()!=''){
            pr.FirmLocationID=Integer.valueOf(fromFirmId);
        }
        pr.CRM_FirmID=accRecords.parentid; // parentid
        pr.CRM_FirmLocationID=toAccountId; // to sf child id
        
        if(fromFirmId!=null && fromFirmId.trim()!=''){
             pr.FirmID =Integer.valueOf(fromFirmId);
        }
        //pr.FirmID=1284;
         
         if(fromfirmLocationId!=null && fromfirmLocationId.trim()!=''){
             pr.FirmLocationID=Integer.valueOf(fromfirmLocationId);
         }
       
        
        reqBody=JSON.serialize(pr);
    }
    public void execute(QueueableContext context) {
        
        
         Preset_Medlien_Configuration__c  objReq =Preset_Medlien_Configuration__c.getAll().get('PresetUpdateFirmLocation');
        
         PSCommunicationCache__c objpsc=new PSCommunicationCache__c();
         
         objpsc.InputPayload__c=reqBody;
         objpsc.Operation__c=objReq.End_Point__c;   
         objpsc.ObjectId__c=toAccountId;
         objpsc.GenericName__c='PresetUpdateFirmLocation';
         objpsc.IsError__c=true;
       
         HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request(reqBody,'PresetUpdateFirmLocation','');
         
         objpsc.ResponsePayload__c=resfrmLoc.getBody();
         objpsc.LOB__c='PS';
         objpsc.ResponseStatus__c=resfrmLoc.getStatusCode()+'';
        
         if(resfrmLoc.getStatusCode()==200 && parse(resfrmLoc.getBody()).Status=='OK'){
             
              objpsc.IsError__c=false;
         }
         insert objpsc;
         
    }   
     public class PresetRequestModel {
       
        public String ZipCode;
        public String State;
        public String FirmLocationName;
        public Integer FirmLocationID;
        public Integer FirmID;
        public String CRM_FirmLocationID;
        public String CRM_FirmID;
        public String City;
        public String Address2;
        public String Address1;
    }
     public class PresetModel {
        public String Status;
    }
    public static PresetModel parse(String json) {
        return (PresetModel) System.JSON.deserialize(json, PresetModel.class);
    }
}