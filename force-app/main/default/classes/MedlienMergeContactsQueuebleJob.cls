/*
    Name           :    MedlienMergeContactsQueuebleJob
    Date           :    11 Nov 2019
    Author         :    Himanshu Tak
    Description    :    
    TestClass      :    MedlienMergeContactsQueuebleJobTest
*/


public class MedlienMergeContactsQueuebleJob implements Queueable, Database.AllowsCallouts {

    public String reqBody;
    public MedlienMergeContactsQueuebleJob (List<String> lstOfContacts){
        this.reqBody= lstOfContacts[0];
    }
    public void execute(QueueableContext context) {
        System.debug('##reqBody'+reqBody);
        ModelMedlienMergeContacts md=ModelMedlienMergeContacts.parseMergeContacts(reqBody);
        md.ContactType='PAYERLOCATION';
        
        md.core=false;
        md.atticus=false;
        md.grs=false;
            
        if(md.keyMedsSourceContactId!=null && md.keyMedsSourceContactId.trim()!='' &&
            md.keyMedsMergeContactId!=null && md.keyMedsMergeContactId.trim()!=''){
            md.core=true;
        }
        
        if(md.atticusSourceContactId!=null && md.atticusSourceContactId.trim()!='' &&
            md.atticusMergeContactId!=null && md.atticusMergeContactId.trim()!=''){
            md.atticus=true;
        }
        
        if(md.grsSourceContactId!=null && md.grsSourceContactId.trim()!='' &&
            md.grsMergeContactId!=null && md.grsMergeContactId.trim()!=''){
            md.grs=true;
        }
        
        
        
         Preset_Medlien_Configuration__c  objReq =Preset_Medlien_Configuration__c.getAll().get('MergeContacts');
              
            reqBody=JSON.serialize(md);  

            System.debug('###reqBody'+reqBody);
            
            HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request(reqBody,'MergeContacts','');
            PSCommunicationCache__c objpsc=new PSCommunicationCache__c();
            objpsc.InputPayload__c=reqBody;
            objpsc.Operation__c=objReq.End_Point__c;   
            objpsc.ObjectId__c=md.sfid;
            objpsc.GenericName__c='MergeContacts';
            objpsc.IsError__c=true;
            objpsc.ResponsePayload__c=resfrmLoc.getBody();
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
    public class ModelMedlienMergeContacts{
       public String keyMedsSourceContactId;    //1052117
        public String keyMedsMergeContactId;    //49737
        public String grsSourceContactId;   //33006264
        public String grsMergeContactId;    //33010595
        public String atticusSourceContactId;   //518dee48-d19a-48b0-836e-08d7684aa8e6
        public String atticusMergeContactId;    //9fe3404d-ebc0-4f8d-8116-08d76ab97447
        public String ContactType;  //PAYERLOCATION
        public boolean core;
        public boolean grs;
        public boolean atticus;
        public String sfid; //0034B00000coA3g
   }     
    public static ModelMedlienMergeContacts parseMergeContacts(String json){
        return (ModelMedlienMergeContacts) System.JSON.deserialize(json, ModelMedlienMergeContacts.class);
    }
}