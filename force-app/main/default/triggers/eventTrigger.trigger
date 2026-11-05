trigger eventTrigger on Event (before insert,after insert,before update,after update) {
    if((Trigger_Denied_Users__c.getAll().get('User_'+UserInfo.getUserId()))==null ){
    
    // Activitys preset callout   
        if(Trigger.isafter && Trigger.isInsert){
            if(EventTriggerHandler.isEventPresetCalloutDone){
                EventTriggerHandler.isEventPresetCalloutDone = false;
                EventTriggerHandler.crmActivitysPreset(Trigger.newMap);
            }
            // EventTriggerHandler.SendEmailWhenEventCreationOrUpdation(Trigger.New, 'Created');
        }
        
        if(Trigger.isafter && Trigger.isUpdate){
            if(EventTriggerHandler.isEventPresetCalloutDone){
                EventTriggerHandler.isEventPresetCalloutDone = false;
                EventTriggerHandler.crmActivitysPreset(Trigger.newMap);
            }
            //EventTriggerHandler.SendEmailWhenEventCreationOrUpdation(Trigger.New, 'Updated');
        }
        //End callout Activitys preset callout 
        
        if(Trigger.isBefore && Trigger.isInsert){
            eventTriggerHandler.beforeinsert(Trigger.new);
            eventTriggerHandler.updateRelatedContactNames(Trigger.new);
        }
        
        // if(Trigger.isAfter && Trigger.isInsert && RecursiveTriggerHandler.linkContact){
        if(Trigger.isAfter && Trigger.isInsert){ 
            set<string> evtIds = new set<string>();
            set<string> huntIds = new set<string>();
            eventTriggerHandler.updateContactBDRFields(Trigger.new);
            for(event evt : trigger.new){
                if(evt.WhatId !=Null){
                    if(evt.WhatId.getSObjectType().getDescribe().getName()=='Hunt_List__c')
                    {
                        
                        evtIds.add(evt.Id);
                        huntIds.add(evt.whatId);    
                    }
                }
            }
            
            if(evtIds.size() > 0){
                eventTriggerHandler.linkContactFutureMethod(evtIds,huntIds);
            }
            
        }
        if(Trigger.isBefore && Trigger.isUpdate){
            // EventTriggerHandler.checkEventUpdationAfter30Days(Trigger.new);
            eventTriggerHandler.updateRelatedContactNames(Trigger.new);

        }
    }
}