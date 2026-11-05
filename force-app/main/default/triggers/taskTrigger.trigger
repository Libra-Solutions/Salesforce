trigger taskTrigger on Task (After Insert,After Update) {
    if((Trigger_Denied_Users__c.getAll().get('User_'+UserInfo.getUserId()))==null ){
        //Activitys preset callout
        if(Trigger.isafter && (Trigger.isInsert)){
            TaskTriggerHandler.crmActivitysPreset(Trigger.newMap);
        }
        if(Trigger.isafter && Trigger.isUpdate){
            TaskTriggerHandler.crmActivitysPreset(Trigger.newMap);
            //TaskTriggerHandler.sendEmailWhenStatusClosed(Trigger.oldMap,Trigger.new);
        // TaskTriggerHandler.updateDueDateWithCreatedDate(Trigger.new);
        }
        if(Trigger.isAfter && Trigger.isInsert){ 
            set<string> huntIds = new set<string>();
            set<string> tskIds = new set<string>();
            //TaskTriggerHandler.updateContactBDRFields(Trigger.new);
            for(task tsk : trigger.new){
                if(tsk.WhatId !=Null){
                    if(tsk.WhatId.getSObjectType().getDescribe().getName()=='Hunt_List__c')
                    {
                        tskIds.add(tsk.id);
                        huntIds.add(tsk.whatId);    
                    }
                }
            }
            
            if(tskIds.size() > 0){
            
                TaskTriggerHandler.linkContactFutureMethod(tskIds,huntIds);
            }       
        // activityTriggerHandler.taskApi(trigger.new);    
            
            
            
        }
    }

}