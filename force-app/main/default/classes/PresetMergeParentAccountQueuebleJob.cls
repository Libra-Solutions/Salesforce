public class PresetMergeParentAccountQueuebleJob implements Queueable, Database.AllowsCallouts {

    public String fromFirmId;
    public String toFirmId;
    public PresetMergeParentAccountQueuebleJob (String fromFirmId,String toFirmId){
        this.fromFirmId=fromFirmId;
        this.toFirmId=toFirmId;
    }
    public void execute(QueueableContext context) {
        Preset_Medlien_Configuration__c  objReq =Preset_Medlien_Configuration__c.getAll().get('MergeFirms');
        
        PSCommunicationCache__c objpsc=new PSCommunicationCache__c();
         objpsc.InputPayload__c='FromFirmID='+fromFirmId+'&ToFirmID='+toFirmId;
         objpsc.Operation__c=objReq.End_Point__c;   
         objpsc.ObjectId__c=ToFirmID;
         objpsc.GenericName__c='MergeFirms';
         objpsc.IsError__c=true;
         
         HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request('{}','MergeFirms','FromFirmID='+fromFirmId+'&ToFirmID='+toFirmId);
         
         objpsc.ResponsePayload__c=resfrmLoc.getBody();
         objpsc.ResponseStatus__c=resfrmLoc.getStatusCode()+'';
         if(resfrmLoc.getStatusCode()==200 && parse(resfrmLoc.getBody()).Status=='Success'){
             
              objpsc.IsError__c=false;
         }
           
         insert objpsc;
    }   
     public class PresetModel {
        public String Status;
        public String SessionID;
    }
    public static PresetModel parse(String json) {
        return (PresetModel ) System.JSON.deserialize(json, PresetModel .class);
    }
}