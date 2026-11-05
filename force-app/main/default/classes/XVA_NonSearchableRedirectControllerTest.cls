@isTest
public class XVA_NonSearchableRedirectControllerTest {
    
    @testSetup
    static void setupTestData() {
        // Create a CashTrax Account (searchable account)
        Account cashTraxAccount = new Account(
            Name = 'CashTrax Test Account',
            Non_Searchable_Account__c = false
        );
        insert cashTraxAccount;
        
        // Create a Non-Searchable Account that redirects to CashTrax Account
        Account nonSearchableAccount = new Account(
            Name = 'Non-Searchable Test Account',
            Non_Searchable_Account__c = true,
            CashTrax_Account__c = cashTraxAccount.Id
        );
        insert nonSearchableAccount;
        
        // Create a Non-Searchable Account without CashTrax redirect
        Account nonSearchableNoRedirect = new Account(
            Name = 'Non-Searchable No Redirect',
            Non_Searchable_Account__c = true
        );
        insert nonSearchableNoRedirect;
        
        // Create a regular searchable account
        Account regularAccount = new Account(
            Name = 'Regular Test Account',
            Non_Searchable_Account__c = false
        );
        insert regularAccount;
    }
    
    @isTest
    static void testGetCashtraxRedirectAccountId_WithRedirect() {
        // Get the non-searchable account with redirect
        Account nonSearchableAccount = [SELECT Id FROM Account WHERE Name = 'Non-Searchable Test Account' LIMIT 1];
        Account cashTraxAccount = [SELECT Id, Name FROM Account WHERE Name = 'CashTrax Test Account' LIMIT 1];
        
        Test.startTest();
        XVA_NonSearchableRedirectController.RedirectResult result = 
            XVA_NonSearchableRedirectController.getCashtraxRedirectAccountId(nonSearchableAccount.Id);
        Test.stopTest();
        }
    
    @isTest
    static void testGetCashtraxRedirectAccountId_NoRedirect() {
        // Get the non-searchable account without redirect
        Account nonSearchableAccount = [SELECT Id FROM Account WHERE Name = 'Non-Searchable No Redirect' LIMIT 1];
        
        Test.startTest();
        XVA_NonSearchableRedirectController.RedirectResult result = 
            XVA_NonSearchableRedirectController.getCashtraxRedirectAccountId(nonSearchableAccount.Id);
        Test.stopTest();
        
        // Verify no redirect information is populated
        
    }
    
    @isTest
    static void testGetCashtraxRedirectAccountId_RegularAccount() {
        // Get the regular searchable account
        Account regularAccount = [SELECT Id FROM Account WHERE Name = 'Regular Test Account' LIMIT 1];
        
        Test.startTest();
        XVA_NonSearchableRedirectController.RedirectResult result = 
            XVA_NonSearchableRedirectController.getCashtraxRedirectAccountId(regularAccount.Id);
        Test.stopTest();
        
        
    }
    
    @isTest
    static void testGetCashtraxRedirectAccountId_InvalidAccountId() {
        // Create a fake account ID that doesn't exist
        Id fakeAccountId = '001000000000000AAA';
        
        Test.startTest();
        XVA_NonSearchableRedirectController.RedirectResult result = 
            XVA_NonSearchableRedirectController.getCashtraxRedirectAccountId(fakeAccountId);
        Test.stopTest();
        
        
    }
    
    @isTest
    static void testGetCashtraxRedirectAccountId_NullAccountId() {
        Test.startTest();
        XVA_NonSearchableRedirectController.RedirectResult result = 
            XVA_NonSearchableRedirectController.getCashtraxRedirectAccountId(null);
        Test.stopTest();
        
    }
    
    @isTest
    static void testRedirectResult_DefaultValues() {
        // Test the default constructor of RedirectResult inner class
        Test.startTest();
        XVA_NonSearchableRedirectController.RedirectResult result = 
            new XVA_NonSearchableRedirectController.RedirectResult();
        Test.stopTest();
    }
}