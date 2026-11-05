public with sharing class MergeFirmLocationLoginQueueable implements Queueable, Database.AllowsCallouts 
{
    string toLocationId;
    string fromLocationId;
    Id accountId;

    public MergeFirmLocationLoginQueueable(string fromLocationId, string toLocationId, Id accountId) {
        this.fromLocationId = fromLocationId;
        this.toLocationId = toLocationId;
        this.accountId = accountId;
    }

    public void execute(QueueableContext context) 
    {
        HTTPResponse res;
        
        res =  (!Test.isRunningTest() ?  PresetMedlienHttpRequestController.request('','LoginPreset','') : new HTTPResponse());

         if(Test.isRunningTest() || res.getStatusCode()==200){
            
            List<Preset_Medlien_Configuration__c> lstOfPreMesItems=new List<Preset_Medlien_Configuration__c>();
            
            lstOfPreMesItems=[select id,Token__c from Preset_Medlien_Configuration__c where Server_Type__c='Preset' and name!='LoginPreset'];
            
            for(Preset_Medlien_Configuration__c pre:lstOfPreMesItems){
                 PresetModel preMdl=PresetModel.parse(res.getBody()+'');
                 pre.Token__c=preMdl.SessionID;
            }
            
            if(lstOfPreMesItems.size()>0){
                
                update lstOfPreMesItems;
                if (!Test.isRunningTest()) system.enqueueJob(new MergeFirmLocationQueueable(fromLocationId, toLocationId, accountId));
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