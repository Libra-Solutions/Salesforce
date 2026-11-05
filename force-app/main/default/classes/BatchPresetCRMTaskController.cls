global class BatchPresetCRMTaskController  implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts {
    global Set<id> setOfActivityIds;
    global BatchPresetCRMTaskController (Set<id> setOfActivityIds){
         this.setOfActivityIds=setOfActivityIds;
         
    }
   
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('---Start Methode');
        return Database.getQueryLocator('select id,CaseNumber__c,Oasis_Type__c,Date__c,AttorneyNoteID__c, createdBy.Name,Whatid,Status,Subject,Whoid,ActivityDate,Oasis_Sub_Type__c,CreatedDate,LastModifiedDate,Owner.Name,Description from task  where id in :setOfActivityIds');
    
    }
   
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<sObject>scope){
        // Logic to be Executed batch wise    
         Preset_Medlien_Configuration__c  objReq =Preset_Medlien_Configuration__c.getAll().get('PresetaddCrmActivity');
       
        List<PSCommunicationCache__c> lstOfPscCommCaches=new List<PSCommunicationCache__c>(); 
        system.debug('new task controller');
        
        for(Task  tsk:(List<Task>)scope){
            ModelActivity md=new ModelActivity();
            md.CaseNumber =tsk.CaseNumber__c+'';
            md.Type=tsk.Oasis_Type__c+'';
            md.TaskStatus=tsk.status+'';
            md.Subject=tsk.Subject;
            md.CRM_ID=tsk.id+'';
            if(tsk.Whoid!=null){
                md.CRM_AttorneyID=tsk.Whoid+'';
            }else{
                md.CRM_AttorneyID=tsk.Whatid+'';
            }
            md.Description = String.isBlank(tsk.Description) ? '':tsk.Description;
           // md.CreatedBy=tsk.CreatedByid+'';
            //md.ResultOfEvent='false';
           // md.CreatedDate=tsk.CreatedDate+'';
            md.AssignedTo=tsk.Owner.Name+'';//UserInfo.getUserName()+'';
            md.ActivityDate=string.valueOf(tsk.ActivityDate);
           
             
               //md.ActivityDate=tsk.Date__c+'';
            md.SubType=tsk.Oasis_Sub_Type__c+'';
			md.CreatedDate=(tsk.CreatedDate- (1/4.0))+'';
            md.LastModifiedDate = (tsk.LastModifiedDate - (1/4.0))+'';
            md.AttorneyNoteID = String.isBlank(tsk.AttorneyNoteID__c) ? '':tsk.AttorneyNoteID__c;
            md.createdById = tsk.CreatedByid;
            md.createdByUserName = tsk.CreatedBy.Name;
            String body=System.JSON.serialize(md);
            System.debug('###@@ body '+body);
            PSCommunicationCache__c objpsc=new PSCommunicationCache__c();
            objpsc.InputPayload__c=body;
            objpsc.Operation__c=objReq.End_Point__c;   
            objpsc.ObjectId__c=tsk.id;
            objpsc.GenericName__c='PresetaddCrmActivity';
            objpsc.IsError__c=true;

            system.debug('task json body');
            system.debug(body);

            HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request(body,'PresetaddCrmActivity','');

            objpsc.ResponsePayload__c=resfrmLoc.getBody();
            objpsc.ResponseStatus__c=resfrmLoc.getStatusCode()+'';
            
            System.debug('###@@'+resfrmLoc.getBody());
            
            if(resfrmLoc.getStatusCode()==200 && parse(resfrmLoc.getBody()).Status=='Success'){
                objpsc.IsError__c=false;
            }
            lstOfPscCommCaches.add(objpsc); 
        }     
            
        if(lstOfPscCommCaches.size()>0){
             insert lstOfPscCommCaches;
        }
    }
 
    global void finish(Database.BatchableContext BC){
        // Logic to be Executed at finish
    }
    public static ModelResponse parse(String json) {
        return (ModelResponse ) System.JSON.deserialize(json, ModelResponse.class);
    }
    public class ModelResponse {
        public string Status;
    }    
    public class ModelActivity{
        public String CaseNumber;
        public String Type;
        public String TaskStatus;
        public String Subject;
        public String CRM_AttorneyID;
       // public String ResultOfEvent;
        public String CRM_ID;
       // public String CreatedDate;
       // public String CreatedBy;
        public String AssignedTo;
        public String ActivityDate;
        public String SubType;
        public String CreatedDate;
        public String LastModifiedDate;
        public String AttorneyNoteID;
        public String Description;
        public String createdByUserName;
        public String createdById;
    }
  
}