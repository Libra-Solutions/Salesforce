/**********************************************************
*@author             : 
*@Description        : All Contact Trigger event will be managed here. 
*                      Code should be written in the respective handlers and call method from required event method.
**********************************************************/
public class ContactTriggerEventHandler {
      
    
    
    /**
     * All after insert Event logic should be called from beforeUpdate method
     * @param List<Contact>, List<Contact>, Map<Id, Contact>, Map<Id, Contact>
     * @return Nothing.
     * @exception Exception On input error.
     * @see 
    */
    public static void beforeUpdate(List<Contact> triggerNew, List<Contact> triggerOld, Map<Id, Contact> newMap, Map<Id, Contact> oldMap) {
        ContactTriggerUtilityHandler.restictAddress(triggerNew, oldMap);  
    }
    
    
    /**
     * All after insert Event logic should be called from afterUpdate method
     * @param List<Contact>, List<Contact>, Map<Id, Contact>, Map<Id, Contact>
     * @return Nothing.
     * @exception Exception On input error.
     * @see 
    */
    public static void afterUpdate(List<Contact> triggerNew, List<Contact> triggerOld, Map<Id, Contact> newMap, Map<Id, Contact> oldMap) {
        
        /* if(CashTraxEntities.UpdateComingFromLeadConversion==false && CashtraxEntities.UpdatedByCashtrax == false){
                ContactTriggerUtilityHandler.sendToBackEndSystems(triggerNew, oldMap);
         } */
         
         ContactTriggerUtilityHandler.UpdateAccountrealatection(triggerNew, oldMap);
 
    }
    
    
}