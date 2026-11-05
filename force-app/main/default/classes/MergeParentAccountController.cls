global class MergeParentAccountController {
    @InvocableMethod
    public static void Parent_LawFirms(List<Modelparentacc> request){
        
         // New Location
       Id masterId = request[0].sfid;
       // Current Location
       Id mergeId = request[0].fromsfid;
        System.debug('#masterId'+masterId);
        System.debug('#mergeId'+mergeId);
       Account FromLoc = [SELECT Id, KeyMedsID__c, Core__c, GRS__c, GRSId__c, Atticus__c, AtticusId__c, PreSet__c, CTXFirmId__c, Type, OwnerId, Created_from_backend__c FROM Account WHERE Id = :mergeId LIMIT 1];
       Account ToLoc = [SELECT Id, KeyMedsID__c, Core__c, GRS__c, GRSId__c, Atticus__c, AtticusId__c, PreSet__c, CTXFirmId__c, OwnerId, Created_from_backend__c FROM Account WHERE Id = :masterId LIMIT 1];
        
        system.debug('##ToLoc.OwnerId'+ToLoc.OwnerId);
       // Check for Owner API Only User in to location
        if(ToLoc.OwnerId == '0054M000003ia3m'){
            ToLoc.OwnerId = FromLoc.OwnerId;
        } 
        
        //Check for Created from backend checkbox in to location
        if (FromLoc.Created_from_backend__c == true){
            
           If (ToLoc.Created_from_backend__c == false){
               ToLoc.Created_from_backend__c = true;
           } 
        }
       // Check for core checkbox in from location
       if(FromLoc.Core__c == true){
           //Check for core checkbox in to location
           if(ToLoc.Core__c == false){
               ToLoc.Core__c = true;
           }          
       }
       // Check for Core Id in from location
       if(FromLoc.KeyMedsID__c != Null){
           // Check for Core Id in to location
           if(ToLoc.KeyMedsID__c == Null){
               ToLoc.KeyMedsID__c = FromLoc.KeyMedsID__c;
           }
       }
       // Check for GRS checkbox in from location
       if(FromLoc.GRS__c == true){
           //Check for GRS checkbox in to location
           if(ToLoc.GRS__c == false){
               ToLoc.GRS__c = true;
           }          
       }
       // Check for GRS Id in from location
       if(FromLoc.GRSId__c != Null){
           // Check for GRS Id in to location
           if(ToLoc.GRSId__c == Null){
               ToLoc.GRSId__c = FromLoc.GRSId__c;
           }
       }
       // Check for Atticus checkbox in from location
       if(FromLoc.Atticus__c == true){
           //Check for Atticus checkbox in to location
           if(ToLoc.Atticus__c == false){
               ToLoc.Atticus__c = true;
           }          
       }
       // Check for Atticus Id in from location
       if(FromLoc.AtticusId__c != Null){
           // Check for Atticus Id in to location
           if(ToLoc.AtticusId__c == Null){
               ToLoc.AtticusId__c = FromLoc.AtticusId__c;
           }
       }
       
       // From location type is LawFirm
       if(FromLoc.Type == 'LawFirm'){
           // Check for Preset checkbox in from location
           if(FromLoc.PreSet__c == true){
               //Check for Preset checkbox in to location
               if(ToLoc.PreSet__c == false){
                   ToLoc.PreSet__c = true;
               }          
           }
           // Check for CashTrax Id in from location
           if(FromLoc.CTXFirmId__c != Null){
               // Check for Atticus Id in to location
               if(ToLoc.CTXFirmId__c == Null){
                   ToLoc.CTXFirmId__c = FromLoc.CTXFirmId__c;
               }
           }
       } 

        
        System.debug('#####'+request[0].keyMedsSourceAccountId);
        System.debug('#####'+request[0].keyMedsMergeAccountId);
        System.debug('#####'+request[0].grsSourceAccountId);
        System.debug('#####'+request[0].grsMergeAccountId);
        System.debug('#####'+request[0].atticusSourceAccountId);
        System.debug('#####'+request[0].atticusMergeAccountId);
        System.debug('#####'+request[0].cashTraxSourceAccountId);
        System.debug('#####'+request[0].cashTraxMergeAccountId);
        System.debug('#####'+request[0].sfid);
        /*Remove calls to Medlien API lines 99 - 123
        List<String> lstOfReqBody=new List<String>();
        lstOfReqBody.add(JSON.serialize(request[0]));
        if((request[0].atticusMergeAccountId!=null && request[0].atticusMergeAccountId.trim()!='' &&
            request[0].atticusSourceAccountId!=null && request[0].atticusSourceAccountId.trim()!='') ||
          (request[0].keyMedsMergeAccountId!=null && request[0].keyMedsMergeAccountId.trim()!='' &&
           request[0].keyMedsSourceAccountId!=null && request[0].keyMedsSourceAccountId.trim()!='') ||
            (request[0].grsMergeAccountId!=null && request[0].grsMergeAccountId.trim()!='' &&
           request[0].grsSourceAccountId!=null && request[0].grsSourceAccountId.trim()!='')){
           System.enqueueJob(new MedlienMergeParentAccountQueuebleJob(lstOfReqBody)); 
        }
        if(request[0].atticusSourceAccountId!=null && request[0].atticusSourceAccountId.trim()!='' && String.isBlank(request[0].atticusMergeAccountId)){
            lstOfReqBody.add(JSON.serialize(request[0].atticusSourceAccountId));
        }
        if(request[0].keyMedsSourceAccountId!=null && request[0].keyMedsSourceAccountId.trim()!='' && String.isBlank(request[0].keyMedsMergeAccountId)){
            lstOfReqBody.add(JSON.serialize(request[0].keyMedsSourceAccountId));
        }
        if(request[0].grsSourceAccountId!=null && request[0].grsSourceAccountId.trim()!='' && String.isBlank(request[0].grsMergeAccountId)){
            lstOfReqBody.add(JSON.serialize(request[0].grsSourceAccountId));
        }
        system.debug('lstOfReqBody.size()'+lstOfReqBody.size());
        system.debug('lstOfReqBody'+lstOfReqBody);
        if(lstOfReqBody.size()>0 && !Test.isRunningTest()){
            system.debug('Second condition');
            System.enqueueJob(new MedlienUpdateParentFirmQueuebleJob(lstOfReqBody));
        }    */
        
         if((request[0].cashTraxSourceAccountId!=null && request[0].cashTraxSourceAccountId.trim()!='' &&
            request[0].cashTraxMergeAccountId!=null && request[0].cashTraxMergeAccountId.trim()!='')||
            (request[0].cashTraxSourceAccountId!=null && request[0].cashTraxSourceAccountId.trim()!='' &&
            String.isBlank(request[0].cashTraxMergeAccountId))){
           
           if(!test.isrunningtest()){ 
               System.debug('Third COndition');
               String cashTraxSourceAccountId=null;
               String cashTraxMergeAccountId=null;
               String sfid=null;
               if(request[0].cashTraxSourceAccountId!=null){
                   cashTraxSourceAccountId=request[0].cashTraxSourceAccountId;
               }
               if(request[0].cashTraxMergeAccountId!=null){
                   cashTraxMergeAccountId=request[0].cashTraxMergeAccountId;
               }
               if(request[0].sfid!=null){
                    sfid=request[0].sfid;
               }
              System.enqueueJob(new PresetMergeParentAccountLoginQueuebleJob(cashTraxSourceAccountId,cashTraxMergeAccountId, sfid));
           }
        }    
         
           
        if(!test.isrunningtest()){    
            // Update Servival Parent Firm
            Update ToLoc;
        }    
    }
    
    public class Modelparentacc{
        @InvocableVariable
        public String keyMedsSourceAccountId;
        @InvocableVariable
        public String keyMedsMergeAccountId;
       
        @InvocableVariable
        public String grsSourceAccountId;
        @InvocableVariable
        public String grsMergeAccountId;
       
        @InvocableVariable
        public String atticusSourceAccountId;
        @InvocableVariable
        public String atticusMergeAccountId;
        
        @InvocableVariable
        public String cashTraxSourceAccountId;
        @InvocableVariable
        public String cashTraxMergeAccountId;
        
        @InvocableVariable
        public String sfid;
        @InvocableVariable
        public String fromsfid;
     }
}