global class MergeContactsController {
   @InvocableMethod
   public static void Contacts(List<Inputs> request) {
       // Master Contact Id
     Id masterId = request[0].MasterContactId;
       // Merge Contact
       Id mergeId = request[0].MergeContactId;
      
       //Get Master Contact details
       Contact masterCont = [SELECT Id, Core__c, GRS__c, Atticus__c, PreSet__c FROM Contact WHERE Id = :masterId LIMIT 1];
       system.debug('**********'+ masterCont);
       // Get Merge Contact details
       Contact mergeCont = [SELECT Id, Core__c, GRS__c, Atticus__c, PreSet__c FROM Contact WHERE Id = :mergeId LIMIT 1];
       system.debug('**********'+ mergeCont);
       
         // Check for core checkbox in from Contact
       If (mergeCont.Core__c == true){
           //Check for core checkbox in to Contact
           If (masterCont.Core__c == false){  masterCont.Core__c = true; }
                     
       }
       // Check for GRS checkbox in from contact
       If (mergeCont.GRS__c == true){
           //Check for GRS checkbox in to contact
           If (masterCont.GRS__c == false){ masterCont.GRS__c = true; }
               
       }
       
       // Check for Atticus checkbox in from contact
       If (mergeCont.Atticus__c == true){
           //Check for Atticus checkbox in to contact
           If (masterCont.Atticus__c == false){ masterCont.Atticus__c = true; }
                
       }
       
       // Check for Preset checkbox in from contact
       If (mergeCont.PreSet__c == true){
           //Check for Preset checkbox in to contact
           If (masterCont.PreSet__c == false){ masterCont.PreSet__c = true; }
                
       }
       
        //Get Master Attorney/Provider details
       Account_Relation__c MasterAtr = [SELECT Id, KeyMedsID__c, GRSId__c, AtticusId__c, PresetID__c FROM Account_Relation__c WHERE Contact__c = :masterId LIMIT 1];
      
       // Get Merge Attorney/Provider details
       Account_Relation__c mergeAtr = [SELECT Id, KeyMedsID__c, GRSId__c, AtticusId__c, PresetID__c FROM Account_Relation__c WHERE Contact__c = :mergeId LIMIT 1];
      
       // Check for Core Id in from Attorney
       If (mergeAtr.KeyMedsID__c != Null){
           // Check for Core Id in to Attorney
           If (MasterAtr.KeyMedsID__c == Null){ MasterAtr.KeyMedsID__c = mergeAtr.KeyMedsID__c; }
               
       }
       
       // Check for GRS Id in from location
       If (mergeAtr.GRSId__c != Null){
           // Check for GRS Id in to location
           If (MasterAtr.GRSId__c == Null){ MasterAtr.GRSId__c = mergeAtr.GRSId__c; }
            
       }
       
       // Check for Atticus Id in from location
       If (mergeAtr.AtticusId__c != Null){
           // Check for Atticus Id in to location
           If (MasterAtr.AtticusId__c == Null){ MasterAtr.AtticusId__c = mergeAtr.AtticusId__c; }
               
       }
       // Check for CashTrax Id in from location
           If (mergeAtr.PresetID__c != Null){
               // Check for Atticus Id in to location
               If (MasterAtr.PresetID__c == Null){  MasterAtr.PresetID__c = mergeAtr.PresetID__c; }
                  
           }
         // Merge Contacts
        if(!Test.isRunningTest()){ merge masterCont mergeCont; Update masterCont; Update MasterAtr; }
            
        /* Remove calls to Medlien API
        List<String> lstOfReqBody=new List<String>();
        
        if((request[0].atticusMergeContactId!=null && request[0].atticusMergeContactId.trim()!='' &&
            request[0].atticusSourceContactId!=null && request[0].atticusSourceContactId.trim()!='') ||
          (request[0].keyMedsMergeContactId!=null && request[0].keyMedsMergeContactId.trim()!='' &&
           request[0].keyMedsSourceContactId!=null && request[0].keyMedsSourceContactId.trim()!='') ||
            (request[0].grsMergeContactId!=null && request[0].grsMergeContactId.trim()!='' &&
           request[0].grsSourceContactId!=null && request[0].grsSourceContactId.trim()!='')){
          
            lstOfReqBody.add(JSON.serialize(request[0]));
        }*/
        
        List<String> lstOfPresetMergeContacts=new List<String>();
        
        contact conDetails=[select id,Account.OS_Firm_Location_Id__c from contact where id =:request[0].sfid and Account.OS_Firm_Location_Id__c!=null limit 1 ];
        
        
       if(request[0].cashTraxSourceContactId!=null && request[0].cashTraxSourceContactId.trim()!='' &&
            request[0].cashTraxMergeContactId!=null && request[0].cashTraxMergeContactId.trim()!=''){
            
            lstOfPresetMergeContacts.add('MergeAttorneys');
        }else if(request[0].cashTraxSourceContactId!=null && request[0].cashTraxSourceContactId.trim()!=''){
                lstOfPresetMergeContacts.add('MoveAttorney'); 
                lstOfPresetMergeContacts.add('UpdateAttorney');
        } 
        
        
        if(request[0].cashTraxSourceContactId!=null && request[0].cashTraxSourceContactId.trim()!=''){
            lstOfPresetMergeContacts.add(request[0].cashTraxSourceContactId);
        }
        if(request[0].cashTraxMergeContactId!=null && request[0].cashTraxMergeContactId.trim()!=''){
            lstOfPresetMergeContacts.add(request[0].cashTraxMergeContactId);
        }
        
        if(request[0].sfid!=null && request[0].sfid.trim()!=''){
            lstOfPresetMergeContacts.add(request[0].sfid);
        }
        
       System.debug('###lstOfPresetMergeContacts'+lstOfPresetMergeContacts);
        
      // System.debug('###lstOfReqBody'+lstOfReqBody);
        
       MedlienMergeContactServerController.mergeContact(lstOfPresetMergeContacts);
      
   }
    
    //input details that comes to apex from flow
    public class Inputs{
        @InvocableVariable public Id MasterContactId;      
        @InvocableVariable public Id MergeContactId;
        @InvocableVariable public String keyMedsSourceContactId;      
        @InvocableVariable public String keyMedsMergeContactId;
        @InvocableVariable public String grsSourceContactId;      
        @InvocableVariable public String grsMergeContactId;
        @InvocableVariable public String atticusSourceContactId;      
        @InvocableVariable public String atticusMergeContactId;
        @InvocableVariable public String cashTraxSourceContactId;      
        @InvocableVariable public String cashTraxMergeContactId;
        @InvocableVariable public String sfid;
                
    }
}