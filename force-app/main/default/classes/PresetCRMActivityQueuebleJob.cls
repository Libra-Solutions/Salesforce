/*
    Name           :    PresetCRMActivityQueuebleJob 
    Date           :    19 april 2020
    Author         :    OasisFinancial 
    Description    :    Preset Activity Callout 
    TestClass      :    PresetCRMActivityQueuebleJobTest
*/
public class PresetCRMActivityQueuebleJob implements Queueable, Database.AllowsCallouts {
    //Ids of Activity records
    public Set<id> setOfActivityIds;
   
    public PresetCRMActivityQueuebleJob (Set<id> setOfActivityIds){
        this.setOfActivityIds=setOfActivityIds;
    }
    public void execute(QueueableContext context) {
        //Callout LoginPreset and get Token 
        HTTPResponse res = PresetMedlienHttpRequestController.request('','LoginPreset','');
        
        //if status 200 put token in  'Preset Medlien Configuration'
        if(res.getStatusCode()==200){
            
            //Get All 'Preset Medlien Configuration' Records for update Token
            List<Preset_Medlien_Configuration__c> lstOfPreMesItems=new List<Preset_Medlien_Configuration__c>();
            lstOfPreMesItems=[select id,Token__c from Preset_Medlien_Configuration__c where Server_Type__c='Preset' and name!='LoginPreset'];
            for(Preset_Medlien_Configuration__c pre:lstOfPreMesItems){
                 PresetModel preMdl=PresetModel.parse(res.getBody()+'');
                 pre.Token__c=preMdl.SessionID;
            }
           
           //Update 'Preset Medlien Configuration' Records
            if(lstOfPreMesItems.size()>0){
               update lstOfPreMesItems;
                if(setOfActivityIds.size()>0 && (new List<Id>(setOfActivityIds))[0].getSObjectType()+''=='Task'){
                    database.executebatch(new BatchPresetCRMTaskController(setOfActivityIds),50);
                }else if(setOfActivityIds.size()>0 && (new List<Id>(setOfActivityIds))[0].getSObjectType()+''=='Event'){
                    database.executebatch(new BatchPresetCRMEventController(setOfActivityIds),50);
                }
                
                
            }
        }   
    }
    
    //Model class for Login Preset json parse
     public class PresetModel {
        public String Status;
        public String SessionID;
    }
    
    //parse Josn 'Login Preset'
    public static PresetModel parse(String json) {
        return (PresetModel ) System.JSON.deserialize(json, PresetModel .class);
    }   
}