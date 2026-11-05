Trigger LeadTrigger on Lead(before insert, before update, after insert, after update) {
    
    Trigger_Settings__mdt TriggerFlag = [SELECT 
                                         Label, isActive__c 
                                         FROM Trigger_Settings__mdt 
                                         where Label = 'LeadTrigger' limit 1];
                                         
    if(TriggerFlag.isActive__c) {  
        // Before Insert Event
        if(Trigger.isBefore && Trigger.isInsert){
            LeadTriggerEventHandler.beforeInsert(Trigger.new);
        }
        // After Insert Event
        if(Trigger.isAfter && Trigger.isInsert){
            LeadTriggerEventHandler.afterInsert(Trigger.new, Trigger.oldMap);
        }
        // Before update Event
        if(Trigger.isBefore && Trigger.isUpdate){
            LeadTriggerEventHandler.beforeUpdate(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
        }
        // After Update Event
        if(Trigger.isAfter && Trigger.isUpdate){
            LeadTriggerEventHandler.afterUpdate(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
        }
        
    }    
}