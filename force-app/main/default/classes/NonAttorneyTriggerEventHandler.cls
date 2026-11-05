/**********************************************************
*@author             : 
*@Description        : All Non_Attorney_Contact__c Trigger event will be managed here. 
*                      Code should be written in the respective handlers and call method from required event method.
**********************************************************/
public with sharing class NonAttorneyTriggerEventHandler 
{
    
    
    // All after insert Event logic should be called from afterUpdate method
    public static void afterUpdate(List<Non_Attorney_Contact__c> triggerNew, List<Non_Attorney_Contact__c> triggerOld, Map<Id, Non_Attorney_Contact__c> newMap, Map<Id, Non_Attorney_Contact__c> oldMap) {
        NonAttorneyTriggerUtilityHandler.UpdateRole(triggerNew);  
    }
    
    
    
}