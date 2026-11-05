/**********************************************************
*@author             : 
*@Description        : All Account Trigger event will be managed here. 
*                      Code should be written in the respective handlers and call method from required event method.
**********************************************************/
public class AccountTriggerEventHandler {
   
    // All before insert event logic should be called from beforeInsert method
    public static void beforeInsert(List<Account> triggerNew) {
        // If we update the BillingStreet, update the Address_Line_1__C for searches
		for(Account acct: triggerNew)
        {	acct.Address_Line_1__c = acct.BillingStreet; }

        // 08/23/2024 remove updateRegion call 
        // AccountTriggerUtilityHandler.updateRegion(triggerNew);  
     }  
    
    // All after insert Event logic should be called from afterInsert method
    public static void afterInsert(List<Account> triggerNew, Map<Id, Account> newMap) {
    }
    
    // All after insert Event logic should be called from beforeUpdate method
    public static void beforeUpdate(List<Account> triggerNew, List<Account> triggerOld, Map<Id, Account> newMap, Map<Id, Account> oldMap) {
        // If we update the BillingStreet, update the Address_Line_1__C for searches
        for(Account acct: triggerNew)
        {	acct.Address_Line_1__c = acct.BillingStreet; }
        
        // 08/23/2024 remove updateRegion call 
        //AccountTriggerUtilityHandler.updateRegion(triggerNew, oldMap);  
        //AccountTriggerUtilityHandler.updateAccountName(triggerNew);
    }
    
    // All after insert Event logic should be called from afterUpdate method
    public static void afterUpdate(List<Account> triggerNew, List<Account> triggerOld, Map<Id, Account> newMap, Map<Id, Account> oldMap) {

          if(CashTraxEntities.UpdateComingFromLeadConversion==false){
         
            //If HQ, fire it 
            for(Account acc : triggerNew ){
                //AccountTriggerUtilityHandler.sendToBackEndSystems(acc, oldMap);
            }
       }
    }
    
    //merge  Account
    /*
    public static void mergeAccount(List<Account> lstOfOldAccounts,Map<id,Account> mapOfOldAccounts){
    Map<id,Account> mapOfnewAccounts=new Map<id,Account>();
    System.debug('##mapOfOldAccounts'+mapOfOldAccounts);
    
    System.debug('##lstOfOldAccounts'+lstOfOldAccounts);
    System.debug('##lstOfOldAccounts'+lstOfOldAccounts);
        Map<id,Account> mapOfMrgAccounts=new Map<Id,Account>();
        Map<id,Account> mapOfAllAccounts=new Map<Id,Account>();
        
        Id accId;
        id masterRecordId;
        for(Account acct : lstOfOldAccounts) {
            if(String.isNotBlank(acct.MasterRecordId) ) { 
               mapOfMrgAccounts.put(acct.MasterRecordId,acct);
               masterRecordId=acct.MasterRecordId;
               accId=acct.id;
            }         
        }
        
      
        
        for(Account acc:[select id,CTXFirmId__c,OS_Firm_Location_Id__c  from Account where id =:masterRecordId]){
            mapOfnewAccounts.put(acc.id,acc);
        }
        System.debug('###mapOfMrgAccounts'+mapOfMrgAccounts);
        System.debug('##accId'+accId);
        System.debug('##masterRecordId'+masterRecordId);
        System.debug('##mapOfnewAccounts'+mapOfnewAccounts);
        
        if(mapOfMrgAccounts.size()>0 && !test.isrunningtest() ){
             System.debug('mapOfOldAccounts.get(accId).CTXFirmId__c'+mapOfOldAccounts.get(accId).CTXFirmId__c);
             System.debug('mapOfnewAccounts.get(masterRecordId).CTXFirmId__c'+mapOfnewAccounts.get(masterRecordId).CTXFirmId__c);
             
             
           if(mapOfOldAccounts.get(accId).CTXFirmId__c!=null && mapOfnewAccounts.get(masterRecordId).CTXFirmId__c!=null){
               
               System.enqueueJob(new PresetServerMergeQueuebleJob (mapOfMrgAccounts));
           }else if(mapOfOldAccounts.get(accId).CTXFirmId__c!=null ){
                System.enqueueJob(new PresetMergeLocationLoginQueuebleJob( mapOfOldAccounts.get(accId).OS_Firm_Id__c,masterRecordId,mapOfOldAccounts.get(accId).CTXFirmId__c,accId));
           }
           
            
            
        } */
        
    //}
}