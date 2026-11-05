trigger ContactTrigger on Contact(before insert, before update, before delete, after insert, after update, after delete, after undelete) 
{
    //query once for profile name string
     boolean DisableContactTrigger = [select id, Disable_Contact_Trigger__c from User where id = :Userinfo.getUserId()].Disable_Contact_Trigger__c;

     // remove this - once we disable them at the user level
     if(UserInfo.getUserEmail() != 'b2bmaintegration@00d610000007e9qeau.ext')
     {
       // Trigger_Denied_Users__c object does not exist - remove code once validated
       //if((Trigger_Denied_Users__c.getAll().get('User_'+UserInfo.getUserId()))==null )
       //{
       
        // Get the settings for the contact trigger - if it is active -> fire the code below
                Trigger_Settings__mdt TriggerFlag = [SELECT 
                                             Label, isActive__c 
                                             FROM Trigger_Settings__mdt 
                                             where Label = 'ContactTrigger_Trigger' limit 1];
        
        // If the trigger is active and the user is NOT to fire off the contact trigger
        if(TriggerFlag.isActive__c && !DisableContactTrigger) {
             //system.debug('<< IS DisableContactTrigger? >>> '+DisableContactTrigger);
             //system.debug('<< User Email >>> '+UserInfo.getUserEmail());       
             //system.debug('<< Is Trigger Active? >>> '+TriggerFlag.isActive__c);       
             
            // Before update Event
            if(Trigger.isBefore && Trigger.isUpdate){
                ContactTriggerEventHandler.beforeUpdate(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
            }
            // After Update Event
            if(Trigger.isAfter && Trigger.isUpdate){
                ContactTriggerEventHandler.afterUpdate(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
            }
            
        }
        }// End b2bma user
       //}   // End Trigger Denied object
}