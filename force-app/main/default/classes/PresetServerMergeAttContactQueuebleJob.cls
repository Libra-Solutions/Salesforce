/*
    Name           :    PresetServerMergeAttContactQueuebleJob
    Date           :    9 Oct 2019
    Author         :    Himanshu Tak
    Description    :    Preset Session id Request 
    TestClass      :    PresetServerMergeAttContactQueuebleJobTest
*/
public class PresetServerMergeAttContactQueuebleJob implements Queueable, Database.AllowsCallouts {
       
    public  List<String> lstOfAttorneyIds;   
    public PresetServerMergeAttContactQueuebleJob (List<String> lstOfAttorneyIds){
        this.lstOfAttorneyIds=lstOfAttorneyIds;
    }
    public void execute(QueueableContext context) {
     
         Preset_Medlien_Configuration__c  objReq =Preset_Medlien_Configuration__c.getAll().get('MergeAttorneys');
         HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request('{}','MergeAttorneys','FromAttorneyID='+lstOfAttorneyIds[1]+'&ToAttorneyID='+lstOfAttorneyIds[2]);
         
         PSCommunicationCache__c objpsc=new PSCommunicationCache__c();
         objpsc.InputPayload__c='FromAttorneyID='+lstOfAttorneyIds[1]+'&ToAttorneyID='+lstOfAttorneyIds[2];
         objpsc.Operation__c=objReq.End_Point__c;   
         objpsc.ObjectId__c=lstOfAttorneyIds[3];
         objpsc.GenericName__c='MergeAttorneys';
         objpsc.IsError__c=true;
          objpsc.LOB__c='PS';
         objpsc.ResponsePayload__c=resfrmLoc.getBody();
         objpsc.ResponseStatus__c=resfrmLoc.getStatusCode()+'';
         if(resfrmLoc.getStatusCode()==200 && parse(resfrmLoc.getBody()).Status=='Success'){
             
              objpsc.IsError__c=false;
         }
         
         insert objpsc;
       
        
    }
    public class PresetModel {
        public String Status;
        public String SessionID;
    }
    public static PresetModel parse(String json) {
        return (PresetModel ) System.JSON.deserialize(json, PresetModel .class);
    }
}