global class BatchPresetMergeFirmController  implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts {
    global Map<Id,Account> mapOfMrgAccounts;
    global Map<Id, Account> mapOfManualMergeAccounts;
    global BatchPresetMergeFirmController (Map<Id,Account> mapOfMrgAccounts){
         this.mapOfMrgAccounts=mapOfMrgAccounts;
         
    }

    global BatchPresetMergeFirmController(Map<Id, Account> mapOfMrgAccounts, Map<Id, Account> mapOfManualMergeAccounts) {
        this.mapOfMrgAccounts = mapOfMrgAccounts;
        this.mapOfManualMergeAccounts = mapOfManualMergeAccounts;
    }
   
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('---Start Methode');
        Set<id> setOfAccIds=new Set<id>();
        setOfAccIds.addAll(mapOfMrgAccounts.keySet());
        return Database.getQueryLocator('Select Id,OS_Firm_Id__c,HeadQuarter__c from Account where id in :setOfAccIds');
    
    }
   
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<sObject>scope){
        // Logic to be Executed batch wise    
         Preset_Medlien_Configuration__c  objReq =Preset_Medlien_Configuration__c.getAll().get('MergeFirms');
       
        List<PSCommunicationCache__c> lstOfPscCommCaches=new List<PSCommunicationCache__c>(); 
        
        for(Account acc:(List<Account>)scope){
            if(Test.isRunningTest()|| acc.OS_Firm_Id__c !=null &&  mapOfMrgAccounts.get(acc.id).OS_Firm_Id__c !=null && acc.HeadQuarter__c==true && mapOfMrgAccounts.get(acc.id).HeadQuarter__c==true){
                
                 PSCommunicationCache__c objpsc=new PSCommunicationCache__c();
                 objpsc.InputPayload__c='FromFirmID='+mapOfMrgAccounts.get(acc.id).OS_Firm_Id__c+'&ToFirmID='+acc.OS_Firm_Id__c;
                 objpsc.Operation__c=objReq.End_Point__c;   
                 objpsc.ObjectId__c=acc.id;
                 objpsc.GenericName__c='MergeFirms';
                 objpsc.IsError__c=true;
                 
                 HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request('{}','MergeFirms','FromFirmID='+mapOfMrgAccounts.get(acc.id).OS_Firm_Id__c+'&ToFirmID='+acc.OS_Firm_Id__c);
                 
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
          database.executebatch(new BatchPresetMergeFirmLocationController (mapOfMrgAccounts),10);
    }
    public static ModelResponse parse(String json) {
        return (ModelResponse ) System.JSON.deserialize(json, ModelResponse.class);
    }
    public class ModelResponse {
        public string Status;
    }    
  
}