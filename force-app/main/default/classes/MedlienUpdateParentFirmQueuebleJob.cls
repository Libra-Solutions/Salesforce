/*
    Name           :    MedlienUpdateParentFirmQueuebleJob 
    Date           :    12 Dec 2019
    Author         :    OasisFinancial
    Description    :    
    TestClass      :    MedlienUpdateParentFirmQueuebleJobTest
*/
public class MedlienUpdateParentFirmQueuebleJob implements Queueable, Database.AllowsCallouts{
    public String reqBody;
    public MedlienUpdateParentFirmQueuebleJob (List<String> lstOfAccounts){
    
        System.debug('####lstOfAccounts[0]'+lstOfAccounts[0]);
        
        this.reqBody= lstOfAccounts[0];
    }
    public void execute(QueueableContext context) {
        
        Preset_Medlien_Configuration__c  objReq =Preset_Medlien_Configuration__c.getAll().get('MedlienUpdateFirm');
        
        ModelMergeParentAcc mdMer=ModelMergeParentAcc.parseParentAcc(reqBody);
        mdMer.Type='Payer';

        mdMer.core=false;
        mdMer.atticus=false;
        mdMer.grs=false;
        
        
        if(mdMer.KeyMedsParentFirmID!=null && mdMer.KeyMedsParentFirmID.trim()!='' &&
           String.isBlank(mdMer.KeyMedsFirmID)){
             mdMer.core=true;
        }
        
        if(mdMer.AtticusParentFirmID!=null && mdMer.AtticusParentFirmID.trim()!='' &&
           String.isBlank(mdMer.AtticusFirmID)){
             mdMer.atticus=true;
        }
        
        if(mdMer.GRSParentFirmID!=null && mdMer.GRSParentFirmID.trim()!='' &&
           String.isBlank(mdMer.GRSFirmID)){
             mdMer.grs=true;
        }
        mdMer.IsParent=true;
        mdMer.Type='Payer';
        
        System.debug('###mdMer'+mdMer);
        System.debug('###reqBody'+reqBody);
        HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request(JSON.serialize(mdMer),'MedlienUpdateFirm','');
           
            PSCommunicationCache__c objpsc=new PSCommunicationCache__c();
            objpsc.InputPayload__c=this.reqBody;
            objpsc.Operation__c=objReq.End_Point__c;   
            objpsc.ObjectId__c=(ModelMergeParentAcc.parseParentAcc(JSON.serialize(mdMer))).SFParentFirmld;
            objpsc.GenericName__c='MedlienUpdateFirm';
            objpsc.IsError__c=true;
            objpsc.ResponsePayload__c=resfrmLoc.getBody();
            objpsc.LOB__c='ML';
            objpsc.ResponseStatus__c=resfrmLoc.getStatusCode()+'';
        
            if(!Test.isRunningTest() && resfrmLoc.getStatusCode()==200 && StatusModel.parse(resfrmLoc.getBody()+'').Status=='OK'){
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
        public String KeyMedsParentFirmID;
        public String KeyMedsFirmID;
        public String GRSParentFirmID;
        public String GRSFirmID;
        public String AtticusParentFirmID;
        public String AtticusFirmID;
        public String SFParentFirmld;
        public String Type;
        public Boolean core;
        public Boolean grs;
        public Boolean atticus;
        public Boolean IsParent;
        
    }
     public static ModelMergeParentAcc parseParentAcc(String json) {
        return (ModelMergeParentAcc ) System.JSON.deserialize(json, ModelMergeParentAcc.class);
    }
}