/*
    Name           :    MedlienMergeParentAccountQueuebleJob 
    Date           :    11 Nov 2019
    Author         :    Himanshu Tak
    Description    :    
    TestClass      :    MedlienMergeParentAccountQueuebleJobTest
*/


public class MedlienMergeParentAccountQueuebleJob implements Queueable, Database.AllowsCallouts {

    public String reqBody;
    public MedlienMergeParentAccountQueuebleJob (List<String> lstOfContacts){
        this.reqBody= lstOfContacts[0];
    }
    public void execute(QueueableContext context) {
        
        Preset_Medlien_Configuration__c  objReq =Preset_Medlien_Configuration__c.getAll().get('MergeParentAccounts');
        
        ModelMergeParentAcc mdMer=ModelMergeParentAcc.parseParentAcc(reqBody);
        mdMer.accountType='Payer';
        
        
        mdMer.core=false;
        mdMer.atticus=false;
        mdMer.grs=false;
        
        
        if(mdMer.keyMedsSourceAccountId!=null && mdMer.keyMedsSourceAccountId.trim()!='' &&
           mdMer.keyMedsMergeAccountId!=null && mdMer.keyMedsMergeAccountId.trim()!=''){
             mdMer.core=true;
        }
        
        if(mdMer.atticusSourceAccountId!=null && mdMer.atticusSourceAccountId.trim()!='' &&
           mdMer.atticusMergeAccountId!=null && mdMer.atticusMergeAccountId.trim()!=''){
             mdMer.atticus=true;
        }
        
        if(mdMer.grsSourceAccountId!=null && mdMer.grsSourceAccountId.trim()!='' &&
           mdMer.grsMergeAccountId!=null && mdMer.grsMergeAccountId.trim()!=''){
             mdMer.grs=true;
        }
        
        System.debug('###mdMer'+mdMer);
        System.debug('###reqBody'+reqBody);
        HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request(JSON.serialize(mdMer),'MergeParentAccounts','');
            PSCommunicationCache__c objpsc=new PSCommunicationCache__c();
            objpsc.InputPayload__c=JSON.serialize(mdMer);
            objpsc.Operation__c=objReq.End_Point__c;   
            objpsc.ObjectId__c=(ModelMergeParentAcc.parseParentAcc(JSON.serialize(mdMer))).sfid;
            objpsc.GenericName__c='MergeParentAccounts';
            objpsc.IsError__c=true;
            objpsc.ResponsePayload__c=resfrmLoc.getBody();
              objpsc.LOB__c='ML';
            objpsc.ResponseStatus__c=resfrmLoc.getStatusCode()+'';
        
            if(resfrmLoc.getStatusCode()==200 && StatusModel.parse(resfrmLoc.getBody()+'').Status=='OK'){
                 objpsc.IsError__c=false;
                
            }
         insert objpsc;
    }
    public class StatusModel {
        public String Status;
        public String Message;
    }
    public static StatusModel parse(String json) {
        return (StatusModel ) System.JSON.deserialize(json, StatusModel.class);
    }
    public class ModelMergeParentAcc{
        public String keyMedsSourceAccountId;
        public String keyMedsMergeAccountId;
        public String grsSourceAccountId;
        public String grsMergeAccountId;
        public String atticusSourceAccountId;
        public String atticusMergeAccountId;
        public String sfid;
        public String accountType;
        public Boolean core;
        public Boolean grs;
        public Boolean atticus;
        
    }
     public static ModelMergeParentAcc parseParentAcc(String json) {
        return (ModelMergeParentAcc ) System.JSON.deserialize(json, ModelMergeParentAcc.class);
    }
}