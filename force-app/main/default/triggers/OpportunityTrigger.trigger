/**
  * @Created Date 04/24/2019
  * @author    OASISFINANCIAL GROUP
  * @copyright Copyright (c) 2019-2020 
  * @license   
  * @Modified Date
  * @Description 
*/
trigger OpportunityTrigger on Opportunity(before insert, before update, before delete, after insert, after update, after delete, after undelete) {
      
    Trigger_Settings__mdt TriggerFlag = [SELECT 
                                         Label, isActive__c 
                                         FROM Trigger_Settings__mdt 
                                         where Label = 'OpportunityTrigger' limit 1];
                                            
    if(TriggerFlag.isActive__c) {  
        // Before Insert Event
        if(Trigger.isBefore && Trigger.isInsert){
            OpportunityTriggerEventHandler.beforeInsert(Trigger.new);
        }  
        // After Insert Event
        if(Trigger.isAfter && Trigger.isInsert){
            OpportunityTriggerEventHandler.afterInsert(Trigger.new, Trigger.oldMap);
        }
        // Before update Event
        if(Trigger.isBefore && Trigger.isUpdate){
            OpportunityTriggerEventHandler.beforeUpdate(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
        }
        // After Update Event
        if(Trigger.isAfter && Trigger.isUpdate){
            OpportunityTriggerEventHandler.afterUpdate(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
        }
        
    }    
}