global class MergeLawFirmLocationController {
    @InvocableMethod
    public static void LawFirm_Locations(List<ModelLocAcc> request){
    
        // New Location
       Id masterId = request[0].Firmlocationsfid;
       // Current Location
       Id mergeId = request[0].CurrentFirmlocationsfid;
       
       Account FromLoc = [SELECT Id,  KeyMedsID__c, Core__c, GRS__c, GRSId__c, Atticus__c, AtticusId__c, PreSet__c, CTXFirmId__c, Type, Phone, Fax, OwnerId, Created_from_backend__c FROM Account WHERE Id = :mergeId LIMIT 1];
       Account ToLoc = [SELECT Id, KeyMedsID__c, Core__c, GRS__c, GRSId__c, Atticus__c, AtticusId__c, PreSet__c, CTXFirmId__c, Phone, Fax, OwnerId, Created_from_backend__c FROM Account WHERE Id = :masterId LIMIT 1];

       Account fromLocOSFirmID = [Select Id,CTXFirmId__c from Account WHERE Id = :mergeId LIMIT 1];
       Account toLocOSFirmID = [Select Id,CTXFirmId__c from Account WHERE Id = :masterId LIMIT 1];


       system.debug('Merge Call Accounts');
        system.debug(fromLocOSFirmID);
        system.debug(toLocOSFirmID);

        string fromLocationId = fromLocOSFirmID.CTXFirmId__c;
        string toLocationId = toLocOSFirmID.CTXFirmId__c;

        
    
        System.debug('#####'+request[0].atticusMergeAccountId);
        System.debug('#####'+request[0].atticusMergeParentAccountId);
        System.debug('#####'+request[0].atticusSourceAccountId);
        System.debug('#####'+request[0].atticusSourceParentAccountId);
        System.debug('#####'+request[0].Firmlocationsfid);
        System.debug('#####'+request[0].CurrentFirmlocationsfid);
        System.debug('#####'+request[0].grsMergeAccountId);
        System.debug('#####'+request[0].grsMergeParentAccountId);
        System.debug('#####'+request[0].grsSourceAccountId);
        System.debug('#####'+request[0].grsSourceParentAccountId);
        System.debug('#####'+request[0].keyMedsMergeAccountId);
        System.debug('#####'+request[0].keyMedsMergeParentAccountId);
        System.debug('#####'+request[0].keyMedsSourceAccountId);
        System.debug('#####'+request[0].keyMedsSourceParentAccountId);
        System.debug('#####'+request[0].cashTraxSourceAccountId);
        System.debug('#####'+request[0].cashTraxSourceParentAccountId);
        System.debug('#####'+request[0].cashTraxMergeAccountId);
        System.debug('#####'+request[0].cashTraxMergeParentAccountId);
        
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
       If (FromLoc.Core__c == true){
           //Check for core checkbox in to location
           If (ToLoc.Core__c == false){
               ToLoc.Core__c = true;
           }          
       }
       // Check for Phone in from location
       If (FromLoc.Phone != Null){
           // Check for Phone in to location
           If (ToLoc.Phone == Null){
               ToLoc.Phone = FromLoc.Phone;
           }
       }
       // Check for Fax in from location
       If (FromLoc.Fax != Null){
           // Check for Fax in to location
           If (ToLoc.Fax == Null){
               ToLoc.Fax = FromLoc.Fax;
           }
       }
       // Check for Core Id in from location
       If (FromLoc.KeyMedsID__c != Null){
           // Check for Core Id in to location
           If (ToLoc.KeyMedsID__c == Null){
               ToLoc.KeyMedsID__c = FromLoc.KeyMedsID__c;
           }
       }
       // Check for GRS checkbox in from location
       If (FromLoc.GRS__c == true){
           //Check for GRS checkbox in to location
           If (ToLoc.GRS__c == false){
               ToLoc.GRS__c = true;
           }          
       }
       // Check for GRS Id in from location
       If (FromLoc.GRSId__c != Null){
           // Check for GRS Id in to location
           If (ToLoc.GRSId__c == Null){
               ToLoc.GRSId__c = FromLoc.GRSId__c;
           }
       }
       // Check for Atticus checkbox in from location
       If (FromLoc.Atticus__c == true){
           //Check for Atticus checkbox in to location
           If (ToLoc.Atticus__c == false){
               ToLoc.Atticus__c = true;
           }          
       }
       // Check for Atticus Id in from location
       If (FromLoc.AtticusId__c != Null){
           // Check for Atticus Id in to location
           If (ToLoc.AtticusId__c == Null){
               ToLoc.AtticusId__c = FromLoc.AtticusId__c;
           }
       }
       
       // From location type is LawFirm
       If(FromLoc.Type == 'LawFirm'){
           // Check for Preset checkbox in from location
           If (FromLoc.PreSet__c == true){
               //Check for Preset checkbox in to location
               If (ToLoc.PreSet__c == false){
                   ToLoc.PreSet__c = true;
               }          
           }
           // Check for CashTrax Id in from location
           If (FromLoc.CTXFirmId__c != Null){
               // Check for Atticus Id in to location
               If (ToLoc.CTXFirmId__c == Null){
                   ToLoc.CTXFirmId__c = FromLoc.CTXFirmId__c;
               }
           }
       } 

       //System.enqueueJob(new PresetServerMergeQueuebleJob (mapOfMrgAccounts));
       
        if (ToLoc.CTXFirmId__c != null && FromLoc.CTXFirmId__c != null)
       		System.enqueueJob(new MergeFirmLocationLoginQueueable(fromLocationId, toLocationId, FromLoc.Id));

        if(!test.isrunningtest()){ 
            // Merge Locations
            merge ToLoc FromLoc;
            // Update Servival location
            Update ToLoc;
        }

        
        
        /* 
        if(FromLoc.CTXFirmId__c!=null ){
            //String toFirmId, String toAccountId,String tofirmLocationId,String tofirmLocationsSfId
            //OS_Firm_Id__c (old record), masterRecordId (new AccountId), old CTXID, oldSFID)
            system.debug('Running Merge Queueable Job.');
            system.debug('FromLoc.OS_Firm_Id__c: '+fromLocOSFirmID.OS_Firm_Id__c);
            system.debug('ToLoc.Id: '+ToLoc.Id);
            system.debug('FromLoc.CTXFrimID__c: '+FromLoc.CTXFirmId__c);
            system.debug('FromLoc.accId: '+FromLoc.Id);

            System.enqueueJob(new PresetMergeLocationLoginQueuebleJob( fromLocOSFirmID.OS_Firm_Id__c,ToLoc.Id,FromLoc.CTXFirmId__c, FromLoc.Id));
        
        } *

       

        /* Remove Medlien API Calls lines 126 - 143
        List<String> lstOfReqBody=new List<String>();
        lstOfReqBody.add(JSON.serialize(request[0]));
        
       if((request[0].atticusMergeAccountId!=null && request[0].atticusMergeAccountId.trim()!='' &&
            request[0].atticusSourceAccountId!=null && request[0].atticusSourceAccountId.trim()!='') ||
            (request[0].keyMedsMergeAccountId!=null && request[0].keyMedsMergeAccountId.trim()!='' &&
            request[0].keyMedsSourceAccountId!=null && request[0].keyMedsSourceAccountId.trim()!='') ||
            (request[0].grsMergeAccountId!=null && request[0].grsMergeAccountId.trim()!='' &&
            request[0].grsSourceAccountId!=null && request[0].grsSourceAccountId.trim()!='')){
                system.debug('Hitting the MedlienFirmLocationQueuebleJob Queueable Job');
           System.enqueueJob(new MedlienFirmLocationQueuebleJob(lstOfReqBody));    
       }
       if((request[0].atticusSourceAccountId!=null && request[0].atticusSourceAccountId.trim()!='' && String.isBlank(request[0].atticusMergeAccountId)) ||
               (request[0].keyMedsSourceAccountId!=null && request[0].keyMedsSourceAccountId.trim()!='' && String.isBlank(request[0].keyMedsMergeAccountId)) ||
               (request[0].grsSourceAccountId!=null && request[0].grsSourceAccountId.trim()!='' && String.isBlank(request[0].grsMergeAccountId)) ){

             system.debug('Hitting the Medlien Update Firm Location Queueable Job');
              System.enqueueJob(new MedlienUpdateFirmLocationQueuebleJob(lstOfReqBody));     
            
        } 
        */
        
             
        }
    
    public class ModelLocAcc{
        @InvocableVariable
        public String atticusMergeAccountId;
        @InvocableVariable
        public String atticusMergeParentAccountId;
       
        @InvocableVariable
        public String atticusSourceAccountId;
        @InvocableVariable
        public String atticusSourceParentAccountId;
       
        @InvocableVariable
        public String Firmlocationsfid;
        @InvocableVariable
        public String CurrentFirmlocationsfid;
        @InvocableVariable
        public String grsMergeAccountId;
        @InvocableVariable
        public String grsMergeParentAccountId;
        
        @InvocableVariable
        public String grsSourceAccountId;
        @InvocableVariable
        public String grsSourceParentAccountId;
        @InvocableVariable
        public String keyMedsMergeAccountId;
        @InvocableVariable
        public String keyMedsMergeParentAccountId;
        @InvocableVariable
        public String keyMedsSourceAccountId;
        @InvocableVariable
        public String keyMedsSourceParentAccountId;
        
        @InvocableVariable
        public String cashTraxSourceAccountId;
        @InvocableVariable
        public String cashTraxSourceParentAccountId;
        @InvocableVariable
        public String cashTraxMergeAccountId;
        @InvocableVariable
        public String cashTraxMergeParentAccountId;
     }
}