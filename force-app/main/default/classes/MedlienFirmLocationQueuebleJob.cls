/*
    Name           :    MedlienFirmLocationQueuebleJob
    Date           :    11 Nov 2019
    Author         :    Himanshu Tak
    Description    :    
    TestClass      :    MedlienFirmLocationQueuebleJobTest
*/


public class MedlienFirmLocationQueuebleJob implements Queueable, Database.AllowsCallouts {

    public String reqBody;
    public MedlienFirmLocationQueuebleJob (List<String> lstOfContacts){
        this.reqBody= lstOfContacts[0];
    }
    public void execute(QueueableContext context) {
        ModelFirmLocations mdMer=(ModelFirmLocations.parseFirmLocations(reqBody));
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
        
        Preset_Medlien_Configuration__c  objReq =Preset_Medlien_Configuration__c.getAll().get('MergeFirmLocations');
      
        HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request(JSON.serialize(mdMer),'MergeFirmLocations','');
            PSCommunicationCache__c objpsc=new PSCommunicationCache__c();
            objpsc.InputPayload__c=JSON.serialize(mdMer);
            objpsc.Operation__c=objReq.End_Point__c;   
            objpsc.ObjectId__c=mdMer.Parentsfid;
            objpsc.GenericName__c='MergeFirmLocations';
            objpsc.IsError__c=true;
            objpsc.ResponsePayload__c=resfrmLoc.getBody();
            objpsc.ResponseStatus__c=resfrmLoc.getStatusCode()+'';
            objpsc.LOB__c='ML';
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
    public class ModelFirmLocations{
        public String accountType;  //PAYERLOCATION
        public boolean atticus;
        public String atticusMergeAccountId;    //536ee349-a47b-4bef-5432-08d7681ee36b
        public String atticusMergeParentAccountId;  //177ad237-8244-47f8-2811-08d7681ee21b
        public String atticusSourceAccountId;   //02c4cc63-da4b-4271-5433-08d7681ee36b
        public String atticusSourceParentAccountId; //61e50386-94cd-4b03-2812-08d7681ee21b
        public boolean core;
        public String Firmlocationsfid; //0014B00000igG99
        public boolean grs;
        public String grsMergeAccountId;    //33018380
        public String grsMergeParentAccountId;  //33006262
        public String grsSourceAccountId;   //33018381
        public String grsSourceParentAccountId; //33006263
        public String keyMedsMergeAccountId;    //1058551
        public String keyMedsMergeParentAccountId;  //1052115
        public String keyMedsSourceAccountId;   //1058552
        public String keyMedsSourceParentAccountId; //1052116
        public String Parentsfid;   //0014B00000igG9A
   }     
    public static ModelFirmLocations parseFirmLocations(String json){
        return (ModelFirmLocations) System.JSON.deserialize(json, ModelFirmLocations.class);
    }
}