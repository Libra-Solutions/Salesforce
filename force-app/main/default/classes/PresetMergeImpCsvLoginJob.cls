public class PresetMergeImpCsvLoginJob implements Queueable, Database.AllowsCallouts {

    Set<id> setOfpsCmmIds;
    public PresetMergeImpCsvLoginJob (Set<id> setOfpsCmmIds){
        this.setOfpsCmmIds=setOfpsCmmIds;
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
                
               if(!Test.isRunningTest() && setOfpsCmmIds.size()>0){
                    List<Preset_Medlien_Communication__c> lstOfcomms=new List<Preset_Medlien_Communication__c>();
                    
                    for(id ids:setOfpsCmmIds){
                        lstOfcomms.add(new Preset_Medlien_Communication__c(id=ids,Status__c='In progress'));
                    } 
                    
                    if(lstOfcomms.size()>0){
                        update lstOfcomms;
                    }
                    database.executebatch(new BatchPresetMergeImportCsvController (setOfpsCmmIds),1);
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