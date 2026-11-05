/*
    Name           :    MedlienUpdateFirmLocationQueuebleJob
    Date           :    24 Dec 2019
    Author         :    OasisFinancial
    Description    :    
    TestClass      :    MedlienUpdateFirmLocationQueuebleJobTest
*/


public class MedlienUpdateFirmLocationQueuebleJob implements Queueable, Database.AllowsCallouts {

    public String reqBody;
    public MedlienUpdateFirmLocationQueuebleJob (List<String> lstOfAccounts){
        this.reqBody= lstOfAccounts[0];
    }
    public void execute(QueueableContext context) {
        ModelFirmLocations mdMer=(ModelFirmLocations.parseFirmLocations(reqBody));
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
        mdMer.IsParent=false;
        mdMer.Type='PayerLocation';
        
        Preset_Medlien_Configuration__c  objReq =Preset_Medlien_Configuration__c.getAll().get('MedlienUpdateFirmLocatons');
      
        HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request(JSON.serialize(mdMer),'MedlienUpdateFirmLocatons','');
            PSCommunicationCache__c objpsc=new PSCommunicationCache__c();
            objpsc.InputPayload__c=this.reqBody;
            objpsc.Operation__c=objReq.End_Point__c;   
            objpsc.ObjectId__c=mdMer.SFParentFirmld;
            objpsc.GenericName__c='MedlienUpdateFirmLocatons';
            objpsc.IsError__c=true;
            objpsc.ResponsePayload__c=resfrmLoc.getBody();
            objpsc.ResponseStatus__c=resfrmLoc.getStatusCode()+'';
            objpsc.LOB__c='ML';
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
    public class ModelFirmLocations{
        public String Type;  //PAYERLOCATION
        public boolean atticus;
        public String AtticusFirmID;    //536ee349-a47b-4bef-5432-08d7681ee36b
        public String AtticusParentFirmID;   //02c4cc63-da4b-4271-5433-08d7681ee36b
        public boolean core;
        public boolean grs;
        public String GRSFirmID;    //33018380
        public String GRSParentFirmID   ;   //33018381
        public String KeyMedsFirmID;    //1058551
        public String KeyMedsParentFirmID;   //1058552
        public String SFParentFirmld;   //0014B00000igG9A
        public boolean IsParent; //false
   }     
    public static ModelFirmLocations parseFirmLocations(String json){
        return (ModelFirmLocations) System.JSON.deserialize(json, ModelFirmLocations.class);
    }
}