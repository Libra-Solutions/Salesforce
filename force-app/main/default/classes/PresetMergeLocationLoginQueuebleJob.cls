public class PresetMergeLocationLoginQueuebleJob implements Queueable, Database.AllowsCallouts {

    public String FromFirmID;
    public String toFirmId;
    public String toAccountId;
    public String tofirmLocationId;
    public String tofirmLocationsSfId;
    public PresetMergeLocationLoginQueuebleJob (String toFirmId, String toAccountId,String tofirmLocationId,String tofirmLocationsSfId){
        this.FromFirmID=FromFirmID;
        this.toFirmId=toFirmId;
        this.toAccountId=toAccountId;
        this.tofirmLocationId=tofirmLocationId;
        this.tofirmLocationsSfId=tofirmLocationsSfId;
    }
    public void execute(QueueableContext context) {
        HTTPResponse res = PresetMedlienHttpRequestController.request('','LoginPreset','');
        
        if(res.getStatusCode()==200){
           
           List<Preset_Medlien_Configuration__c> lstOfPreMesItems=new List<Preset_Medlien_Configuration__c>();
            
            lstOfPreMesItems=[select id,Token__c from Preset_Medlien_Configuration__c where Server_Type__c='Preset' and name!='LoginPreset'];
            
            for(Preset_Medlien_Configuration__c pre:lstOfPreMesItems){
                 PresetModel preMdl=PresetModel.parse(res.getBody()+'');
                 pre.Token__c=preMdl.SessionID;
            }
            
           
            if(lstOfPreMesItems.size()>0){
            
                update lstOfPreMesItems;
                
                if(!Test.isRunningTest()){
                 System.enqueueJob(new PresetUpdateFirmLocationQueuableJob(toFirmId, toAccountId, tofirmLocationId,tofirmLocationsSfId));
               }
            
            }
        }   
    }
     public class PresetModel {
        public String Status;
        public String SessionID;
    }
    public static PresetModel parse(String json) {
        return (PresetModel ) System.JSON.deserialize(json, PresetModel .class);
    }   
}