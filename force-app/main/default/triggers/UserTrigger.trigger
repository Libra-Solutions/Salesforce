trigger UserTrigger on User (before insert) {
	 if(Trigger.isbefore && Trigger.isInsert){
         UserTriggerHandler.sendEmail(Trigger.new);
     }
}