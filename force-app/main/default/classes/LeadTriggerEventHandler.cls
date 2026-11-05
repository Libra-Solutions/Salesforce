/**********************************************************
*@author             : 
*@Description        : All Lead Trigger event will be managed here. 
*                      Code should be written in the respective handlers and call method from required event method.
**********************************************************/
public class LeadTriggerEventHandler {
    
    
     /**
     * All before insert event logic should be called from beforeInsert method
     * @param List<Lead> triggerNew
     * @return 
     * @exception Exception On input error.
     * @see 
    */
    public static void beforeInsert(List<Lead> triggerNew) {
        //LeadTriggerUtilityHandler.checkDuplicateLead(triggerNew);  
    }  
    
    
    /**
     * All after insert Event logic should be called from afterInsert method
     * @param List<Lead> triggerNew, Map<Id, Lead> newMap
     * @return 
     * @exception Exception On input error.
     * @see 
    */
    public static void afterInsert(List<Lead> triggerNew, Map<Id, Lead> newMap) {
        
    }
    
    
    /**
     * All after insert Event logic should be called from beforeupdatemethod
     * @param List<Lead> triggerNew, List<Lead> triggerOld, Map<Id, Lead> newMap, Map<Id, Lead> oldMa
     * @return 
     * @exception Exception On input error.
     * @see 
    */
    public static void beforeUpdate(List<Lead> triggerNew, List<Lead> triggerOld, Map<Id, Lead> newMap, Map<Id, Lead> oldMap) {
        //LeadTriggerUtilityHandler.checkDuplicateLead(triggerNew);  
    }
    
    
    /**
     * All after insert Event logic should be called from afterupdate method
     * @param List<Lead> triggerNew, List<Lead> triggerOld, Map<Id, Lead> newMap, Map<Id, Lead> oldMap
     * @return 
     * @exception Exception On input error.
     * @see 
    */
    public static void afterUpdate(List<Lead> triggerNew, List<Lead> triggerOld, Map<Id, Lead> newMap, Map<Id, Lead> oldMap) {
        LeadTriggerUtilityHandler.ConvertLead(triggerNew, oldMap);  
    }
    
    
}