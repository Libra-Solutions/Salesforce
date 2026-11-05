public class PresetUpdateParentFirmQueuableJob implements Queueable, Database.AllowsCallouts {

    public String fromFirmId;
    public String toAccountId;
    public String reqBody;
  
    public PresetUpdateParentFirmqueuableJob (String fromFirmId,String toAccountId){
        this.fromFirmId=fromFirmId;
        this.toAccountId=toAccountId;

        Account accRecords=[Select Id,Website,Phone,Fax,name  from Account where Id=:toAccountId];
        
        PresetRequestModel  pr=new PresetRequestModel ();
        
        pr.Website=(accRecords.Website==null?'':accRecords.Website);
        pr.PhoneNumber=(accRecords.phone==null?'':accRecords.phone);  
        pr.Fax=(accRecords.Fax==null?'':accRecords.Fax);  
        pr.FirmName=accRecords.name;
        pr.FirmID=integer.ValueOf(fromFirmId);
        
        pr.CRM_FirmID=toAccountId;
        
        
        reqBody=JSON.serialize(pr);
    }
    public void execute(QueueableContext context) {
        
        
         Preset_Medlien_Configuration__c  objReq =Preset_Medlien_Configuration__c.getAll().get('PresetUpdateFirm');
        
         PSCommunicationCache__c objpsc=new PSCommunicationCache__c();
         
         objpsc.InputPayload__c=reqBody;
         objpsc.Operation__c=objReq.End_Point__c;   
         objpsc.ObjectId__c=toAccountId;
         objpsc.GenericName__c='PresetUpdateFirm';
         objpsc.IsError__c=true;
       
         HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request(reqBody,'PresetUpdateFirm','');
         
         objpsc.ResponsePayload__c=resfrmLoc.getBody();
         objpsc.LOB__c='PS';
         objpsc.ResponseStatus__c=resfrmLoc.getStatusCode()+'';
        
         if(resfrmLoc.getStatusCode()==200 && parse(resfrmLoc.getBody()).Status=='OK'){
             
              objpsc.IsError__c=false;
         }
         insert objpsc;
         
    }   
     public class PresetRequestModel {
       
        public String Website;
        public String PhoneNumber;
        public String FirmName;
        public Integer FirmID;
        public String Fax;
        public String CRM_FirmID;

    }
     public class PresetModel {
        public String Status;
        public String SessionID;
    }
    public static PresetModel parse(String json) {
        return (PresetModel) System.JSON.deserialize(json, PresetModel.class);
    }
}