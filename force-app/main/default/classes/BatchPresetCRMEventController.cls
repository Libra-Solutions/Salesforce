global class BatchPresetCRMEventController  implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts {
    global Set<id> setOfActivityIds;
    global BatchPresetCRMEventController (Set<id> setOfActivityIds){
         this.setOfActivityIds=setOfActivityIds;
         
    }
   
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('---Start Method');
        return Database.getQueryLocator('select id,createdBy.Name,Oasis_Type__c,AttorneyNoteID__c,Oasis_Event_Purpose__c,Oasis_Event_Result__c, Whatid,Subject,Whoid,ActivityDate,Owner.Name,CreatedDate,LastModifiedDate  from Event  where id in :setOfActivityIds');
    
    }
   
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<sObject>scope){
        // Logic to be Executed batch wise    
         Map<Id,String> mapOfEventVsEventRelation = new Map<Id,String>(); 
        Set<Id> setEvtId = new Set<Id>();
         for(Event  evnt:(List<Event>)scope){
             setEvtId.add(evnt.Id);
         }

        for(Event evtObj : [select id, (select id,relationId from Eventrelations) from Event where Id In:setEvtId]){
            String relationId  = '';
            for(Eventrelation evt : evtObj.Eventrelations){
                relationId += evt.relationId+',' ;
            }
       		mapOfEventVsEventRelation.put(evtObj.Id,relationId);
        }
            
         Preset_Medlien_Configuration__c  objReq =Preset_Medlien_Configuration__c.getAll().get('PresetaddCrmActivity');
       
        List<PSCommunicationCache__c> lstOfPscCommCaches=new List<PSCommunicationCache__c>(); 
        
        for(Event  evnt:(List<Event>)scope){
            ModelActivity md=new ModelActivity();
           // md.Type=evnt.Oasis_Type__c+'';
           md.Type='Event';
            //md.EventStatus='';
            md.Subject=evnt.Subject;
            md.CRM_ID=evnt.id+'';
            md.SubType = 'Meeting';
            if(evnt.Whoid!=null){
                md.CRM_AttorneyID=evnt.Whoid+'';
            }else{
                md.CRM_AttorneyID=evnt.Whatid+'';
            }
            md.MultipleAttendeeIDs = mapOfEventVsEventRelation.get(evnt.Id) != null ? mapOfEventVsEventRelation.get(evnt.Id) : '';
            md.MultipleAttendeeIDs = md.MultipleAttendeeIDs.removeEnd(',');
            md.TypeOfEvent=evnt.Oasis_Event_Purpose__c+'';
           // md.CreatedBy=evnt.CreatedByid+'';
            md.ResultOfEvent=evnt.Oasis_Event_Result__c;
            md.CreatedDate=(evnt.CreatedDate- (1/4.0))+'';
            md.AssignedTo=evnt.Owner.Name+'';

            //  DW 08/02/2022 - Modify for sending activity date to cashtrax
            //  If the activity date is populated, send to cashtrax
            //  otherwise, send the startdate.
			if(evnt.ActivityDate != null){md.ActivityDate=evnt.ActivityDate.format();} 
            else {md.ActivityDate= evnt.StartDateTime.format();}
 			md.LastModifiedDate = (evnt.LastModifiedDate - (1/4.0))+'';
            md.createdById = evnt.CreatedByid;
            md.createdByUserName = evnt.CreatedBy.Name;
            
            String body=System.JSON.serialize(md);
            system.debug('body:::'+body);
            PSCommunicationCache__c objpsc=new PSCommunicationCache__c();
            objpsc.InputPayload__c=body;
            objpsc.Operation__c=objReq.End_Point__c;   
            objpsc.ObjectId__c=evnt.id;
            objpsc.GenericName__c='PresetaddCrmActivity';
            objpsc.IsError__c=true;

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
        public String Type;
        //public String EventStatus;
        public String Subject;
        public String CRM_AttorneyID;
        public String MultipleAttendeeIDs;
        public String ResultOfEvent;
        public String CRM_ID;
        public String SubType;
        public String CreatedDate;
       // public String CreatedBy;
        public String AssignedTo;
        public String ActivityDate;
        public String TypeOfEvent;
        public String LastModifiedDate;
        public String createdByUserName;
        public String createdById;
    }
  
}