/*
    Name           :    PresetServerMoveAttorneyQueuebleJob
    Date           :    9 Oct 2019
    Author         :    Himanshu Tak
    Description    :    Preset Session id Request 
    TestClass      :    PresetServerMoveAttorneyQueuebleJob
*/
public class PresetServerMoveAttorneyQueuebleJob implements Queueable, Database.AllowsCallouts {
       
    public  List<String> lstOfAttorneyIds;   
    public PresetServerMoveAttorneyQueuebleJob (List<String> lstOfAttorneyIds){
        this.lstOfAttorneyIds=lstOfAttorneyIds;
    }
    public void execute(QueueableContext context) {
     
         Preset_Medlien_Configuration__c  objReq =Preset_Medlien_Configuration__c.getAll().get('MoveAttorney');
         
         
         HTTPResponse resfrmLoc;
         
         PSCommunicationCache__c objpsc=new PSCommunicationCache__c();
         
         /* http://sfapiprod.oasislegal.com/api/AttorneyFirm/MoveAttorney?AttorneyID=1252592&ToFirmLocationID=146049
          * The list provides,   [0]='MoveAttorney', [1]=attorneyId, [2]=firmLocationId, [3]=firmLocationid (repeated)
		  */
         if(lstOfAttorneyIds.size()==4){
             resfrmLoc=PresetMedlienHttpRequestController.request('{}','MoveAttorney','AttorneyID='+lstOfAttorneyIds[1]+'&ToFirmLocationID='+lstOfAttorneyIds[2]);
             objpsc.ObjectId__c=lstOfAttorneyIds[2];
              objpsc.InputPayload__c='AttorneyID='+lstOfAttorneyIds[1]+'&ToFirmLocationID=='+lstOfAttorneyIds[2];
        
         }else  if(lstOfAttorneyIds.size()==3){
             resfrmLoc=PresetMedlienHttpRequestController.request('{}','MoveAttorney','AttorneyID='+lstOfAttorneyIds[1]+'&ToFirmLocationID='+lstOfAttorneyIds[2]);
            objpsc.ObjectId__c=lstOfAttorneyIds[2];
             objpsc.InputPayload__c='AttorneyID='+lstOfAttorneyIds[1]+'&ToFirmLocationID='+lstOfAttorneyIds[2];
        
         }
         objpsc.Operation__c=objReq.End_Point__c;   
         
         objpsc.GenericName__c='MoveAttorney';
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