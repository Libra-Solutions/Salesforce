/**********************************************************
*@author             : 
*@Description        : All Account Contact Trigger event will be managed here. 
*                      Code should be written in the respective handlers and call method from required event method.
**********************************************************/
public class AccountRelationTriggerEventHandler{
    
    public static void beforeInsert(List<Account_Relation__c> triggerNew) {
        AccountContactTriggerUtilityHandler.showConRoleError(triggerNew);
    }  
    
    
    // All after insert Event logic should be called from beforeDelete method
    public static void beforeDelete(List<Account_Relation__c> triggerOld, Map<Id, Account_Relation__c> oldMap) {
        AccountContactTriggerUtilityHandler.deleteAccountRelation(triggerOld);
    }
    
}