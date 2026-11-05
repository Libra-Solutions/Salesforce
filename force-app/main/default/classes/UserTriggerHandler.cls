public class UserTriggerHandler {
    public static void sendEmail(List<User> triggerNew){
 		AggregateResult res =
            [SELECT COUNT(Id) used, MAX(Profile.UserLicense.TotalLicenses) total
             FROM User 
             WHERE Profile.UserLicense.Name = 'Salesforce' AND 
                   IsActive = true GROUP BY Profile.UserLicense.Name];
        
        Integer total = (Integer) res.get('total');
        Integer used = (Integer) res.get('used');
        sendingEmail(total, used);
    }
    
    @future
    public static void sendingEmail(Integer total, Integer used) {
		Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
		String[] sendingTo = new String[]{'sbattu@oasisfinancial.com','apriyatmo@oasisfinancial.com'};
		semail.setToAddresses(sendingTo);
		semail.setSubject('Reminder: Salesforce User License count');
        String remaining = String.valueOf(total - used);
		semail.setPlainTextBody('Remaining Salesforce User License : '+remaining);
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
	}
}