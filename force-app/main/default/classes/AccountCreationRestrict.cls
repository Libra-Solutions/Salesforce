public class AccountCreationRestrict {
	
    @AuraEnabled
    public static List<ListView> getListViews() {
        List<ListView> listviews =
            [SELECT Id, Name FROM ListView WHERE SobjectType = 'Account'];
    
        // Perform isAccessible() check here
        return listviews;
    }
}