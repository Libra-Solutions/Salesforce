public class PresetMergeParentAccountLoginQueuebleJob implements Queueable, Database.AllowsCallouts {

    public String FromFirmID;
    public String toFirmId;
    public String toAccountId;
   public PresetMergeParentAccountLoginQueuebleJob (String FromFirmID,String toFirmId){} 
   
    public PresetMergeParentAccountLoginQueuebleJob (String FromFirmID,String toFirmId, String toAccountId){
        this.FromFirmID=FromFirmID;
        this.toFirmId=toFirmId;
        this.toAccountId=toAccountId;
    }
    public void execute(QueueableContext context) {
        HTTPResponse res = PresetMedlienHttpRequestController.request('','LoginPreset','');
        
        if(res.getStatusCode()==200){
           
            PSCommunicationCache__c connectionErrorLog = new PSCommunicationCache__c();
            connectionErrorLog.Direction__c = 'Outgoing';
            connectionErrorLog.GenericName__c = 'LoginPreset';
            connectionErrorLog.IsError__c = false;
            connectionErrorLog.ResponsePayload__c = res.getBody();
            connectionErrorLog.Operation__c = Preset_Medlien_Configuration__c.getAll().get('LoginPreset').End_Point__c;
            insert connectionErrorLog;

           List<Preset_Medlien_Configuration__c> lstOfPreMesItems=new List<Preset_Medlien_Configuration__c>();
            
            lstOfPreMesItems=[select id,Token__c from Preset_Medlien_Configuration__c where Server_Type__c='Preset' and name!='LoginPreset'];
            
            for(Preset_Medlien_Configuration__c pre:lstOfPreMesItems){
                 PresetModel preMdl=PresetModel.parse(res.getBody()+'');
                 pre.Token__c=preMdl.SessionID;
            }
            
           
            if(lstOfPreMesItems.size()>0){
            
                update lstOfPreMesItems;
                
                if(!Test.isRunningTest()){
                    if(FromFirmID!=null && FromFirmID.trim()!='' && toFirmId!=null && toFirmId.trim()!='' ){
                        System.enqueueJob(new PresetMergeParentAccountQueuebleJob(FromFirmID,toFirmId));
                    }else if(FromFirmID!=null && FromFirmID.trim()!=''){
                        System.debug('#you can move preset Id to serviving record');
                        System.enqueueJob(new PresetUpdateParentFirmQueuableJob(FromFirmID, toAccountId));
                    }
                }
            
            }
        }
        else {
            PSCommunicationCache__c connectionErrorLog = new PSCommunicationCache__c();
            connectionErrorLog.Direction__c = 'Outgoing';
            connectionErrorLog.GenericName__c = 'LoginPreset';
            connectionErrorLog.IsError__c = true;
            connectionErrorLog.ResponsePayload__c = res.getBody();
            connectionErrorLog.Operation__c = Preset_Medlien_Configuration__c.getAll().get('LoginPreset').End_Point__c;
            insert connectionErrorLog;


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

/*

PresetMergeParentAccountLoginQueuebleJob job = new PresetMergeParentAccountLoginQueuebleJob('70373','70377', '001Rl000000PzMwIAK');
system.enqueueJob(job, 0);

*/