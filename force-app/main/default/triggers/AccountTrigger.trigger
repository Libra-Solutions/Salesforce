trigger AccountTrigger on Account(before insert, before update, before delete, after insert, after update, after delete, after undelete) {
       
      if((Trigger_Denied_Users__c.getAll().get('User_'+UserInfo.getUserId()))==null ){
            Trigger_Settings__mdt TriggerFlag = [SELECT 
                                                 Label, isActive__c 
                                                 FROM Trigger_Settings__mdt 
                                                 where Label = 'AccountTrigger' limit 1];
            
            if(Trigger.isDelete && Trigger.isafter){
                //2024-04-04 
                //This code has been removed to be handled by the ParentLawFirm Merging Flow, calling the MergeParentAccountController actions
                //AccountTriggerEventHandler.mergeAccount(Trigger.old,trigger.oldMap);
            }   
                                                    
            if(TriggerFlag.isActive__c) {  
                // Before Insert Event
                if(Trigger.isBefore && Trigger.isInsert){
                    AccountTriggerEventHandler.beforeInsert(Trigger.new);
                }
                // After Insert Event
                if(Trigger.isAfter && Trigger.isInsert){
                    AccountTriggerEventHandler.afterInsert(Trigger.new, Trigger.oldMap);
                }
                // Before update Event
                if(Trigger.isBefore && Trigger.isUpdate){
                    AccountTriggerEventHandler.beforeUpdate(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
                }
                // After Update Event
                if(Trigger.isAfter && Trigger.isUpdate){
                    AccountTriggerEventHandler.afterUpdate(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
                }
                /*   
                // Before Delete Event
                if(Trigger.isBefore && Trigger.isDelete){
                    AccountTriggerEventHandler.beforeDelete(Trigger.old, Trigger.oldMap);
                }
                // After Delete Event
                if(Trigger.isAfter && Trigger.isDelete){
                    AccountTriggerEventHandler.afterDelete(Trigger.old, Trigger.oldMap);
                }
            */
            
        }
    }
       
}