public without sharing class XVA_NonSearchableRedirectController {
    

    @AuraEnabled(cacheable=true)
    public static RedirectResult getCashtraxRedirectAccountId(Id recordId) 
    {

        RedirectResult result = new RedirectResult();

        User currentUser = [Select Id, Profile.Name from User where Id = :UserInfo.getUserId()];
        result.shouldRedirect = !(currentUser.Profile.Name == 'System Administrator' 
        || currentUser.Profile.Name == 'API Only User'
        || currentUser.Profile.Name == 'Marketing User - Custom');
        
        system.debug(result.ShouldRedirect);
        try {

            Account acc = [Select Id, Non_Searchable_Account__c, CashTrax_Account__c, Cashtrax_Account__r.Name from Account where Id = :recordId];
            
        
            if (acc.Non_Searchable_Account__c == true && acc.CashTrax_Account__c != null) {
                result.redirectName = acc.Cashtrax_Account__r.Name;
                result.redirectId = acc.CashTrax_Account__c;
            }
        

        }
        catch(Exception ex) {
            result.errorMessage = 'An error occurred while processing the redirect: ' + ex.getMessage();
        }       

        return result;
    }

    public class RedirectResult {
        @AuraEnabled public String redirectId {get;set;}
        @AuraEnabled public String redirectName {get; set;}
        @AuraEnabled public boolean shouldRedirect {get; set;}
        @AuraEnabled public String errorMessage {get; set;}

        public RedirectResult() {
            redirectId = null;
            redirectName = null;
            shouldRedirect = false;
            errorMessage = null;
        }

    }


}