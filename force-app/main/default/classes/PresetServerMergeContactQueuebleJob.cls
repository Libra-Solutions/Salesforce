/*
    Name           :    PresetServerMergeContactQueuebleJob 
    Date           :    9 Oct 2019
    Author         :    OasisFinancial
    Description    :    Preset Session id Request 
    TestClass      :    PresetServerMergeContactQueuebleJobTest
*/


public class PresetServerMergeContactQueuebleJob implements Queueable, Database.AllowsCallouts {

    public List<String> lstOfContacts;
    
    public PresetServerMergeContactQueuebleJob (List<String> lstOfContacts){
        this.lstOfContacts= lstOfContacts;
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
            
            if(lstOfPreMesItems.size()>0 ){
                
                update lstOfPreMesItems;
              system.debug('##Lst of contacts'+lstOfContacts);
               /*if((lstOfContacts.size()==3 || lstOfContacts.size()==4) && lstOfContacts[0]=='MoveAttorney' && !test.isrunningtest()){
                    System.enqueueJob(new PresetServerMoveAttorneyQueuebleJob (lstOfContacts));
                }else if(lstOfContacts.size()==4 && lstOfContacts[0]=='MergeAttorneys' && !test.isrunningtest()){
                    System.enqueueJob(new PresetServerMergeAttContactQueuebleJob (lstOfContacts));
                }*/
                
               if((lstOfContacts.size()==3 || lstOfContacts.size()==4) && lstOfContacts[1]=='UpdateAttorney' && !test.isrunningtest()){
                    System.enqueueJob(new PresetMergeUpdateAttorneyContactJob (lstOfContacts[3],lstOfContacts[2]));
               }else if(lstOfContacts.size()==4 && lstOfContacts[0]=='MergeAttorneys' && !test.isrunningtest()){
                    System.enqueueJob(new PresetServerMergeAttContactQueuebleJob (lstOfContacts));
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