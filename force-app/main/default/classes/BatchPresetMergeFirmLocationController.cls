global class BatchPresetMergeFirmLocationController implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts {
    global Map<Id,Account> mapOfMrgAccounts;
    global BatchPresetMergeFirmLocationController (Map<Id,Account> mapOfMrgAccounts){
         this.mapOfMrgAccounts=mapOfMrgAccounts;
         
    }
   
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('---Start Methode');
        Set<id> setOfAccIds=new Set<id>();
        setOfAccIds.addAll(mapOfMrgAccounts.keySet());
        return Database.getQueryLocator('Select Id,OS_Firm_Id__c,OS_Firm_Location_Id__c,HeadQuarter__c from Account where id in :setOfAccIds and OS_Firm_Id__c!=null and OS_Firm_Location_Id__c!=null and HeadQuarter__c=false');
    
    }
   
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<sObject>scope){
        // Logic to be Executed batch wise    
         Preset_Medlien_Configuration__c  objReq =Preset_Medlien_Configuration__c.getAll().get('PresetMergeFirmLocations');
       
        List<PSCommunicationCache__c> lstOfPscCommCaches=new List<PSCommunicationCache__c>(); 
        
        for(Account acc:(List<Account>)scope){
            if(Test.isRunningTest()||acc.OS_Firm_Location_Id__c!=null &&  mapOfMrgAccounts.get(acc.id).OS_Firm_Location_Id__c!=null && acc.HeadQuarter__c==false && mapOfMrgAccounts.get(acc.id).HeadQuarter__c==false){
                
                 PSCommunicationCache__c objpsc=new PSCommunicationCache__c();
                 objpsc.InputPayload__c='FromFirmLocationID='+mapOfMrgAccounts.get(acc.id).OS_Firm_Location_Id__c+'&ToFirmLocationID='+acc.OS_Firm_Location_Id__c;
                 objpsc.Operation__c=objReq.End_Point__c;   
                 objpsc.ObjectId__c=acc.id;
                 objpsc.GenericName__c='PresetMergeFirmLocations';
                 objpsc.IsError__c=true;
                  objpsc.LOB__c='PS';
                 HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request('{}','PresetMergeFirmLocations','FromFirmLocationID='+mapOfMrgAccounts.get(acc.id).OS_Firm_Location_Id__c+'&ToFirmLocationID='+acc.OS_Firm_Location_Id__c);
                 
                 objpsc.ResponsePayload__c=resfrmLoc.getBody();
                 objpsc.ResponseStatus__c=resfrmLoc.getStatusCode()+'';
                 if(resfrmLoc.getStatusCode()==200 && parse(resfrmLoc.getBody()).Status=='Success'){
                     
                      objpsc.IsError__c=false;
                 }
                lstOfPscCommCaches.add(objpsc); 
             }     
            
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
  
}