/*
    Name           :    PresetServerMergeQueuebleJob 
    Date           :    9 Oct 2019
    Author         :    Himanshu Tak
    Description    :    Preset Session id Request 
    TestClass      :    PresetServerMergeQueuebleJobTest
*/


public class PresetServerMergeQueuebleJob implements Queueable, Database.AllowsCallouts {

    public Map<Id,Account> mapOfMrgAccounts;
    
    public PresetServerMergeQueuebleJob (Map<Id,Account> mapOfMrgAccounts){
        this.mapOfMrgAccounts= mapOfMrgAccounts;
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
                
                if(!test.isrunningtest()){database.executebatch(new BatchPresetMergeFirmController(mapOfMrgAccounts),10);}
                
               
               
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