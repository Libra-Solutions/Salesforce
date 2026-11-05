@isTest
public class NonAttorneyTriggerUtilityHandlerTest{
    
    static testMethod void testNonAttData(){   
    
        Account acc = UtiityHelperClass.createAccount();
        
        Contact con = UtiityHelperClass.createContact(acc.Id);
        
        Non_Attorney_Contact__c nonAtt = new Non_Attorney_Contact__c(Firm_Name__c = acc.Id, Attorney__c = con.Id,GRSId__c = 1234);
       
        insert nonAtt;
        try{
            update nonAtt;

        }
        catch(Exception e){
        
            Boolean expectedExceptionThrown =  e.getMessage().contains('The selected Attorney/Provider Contact is') ? true : false;
            
            System.AssertEquals(expectedExceptionThrown, true);
        
        } 
    }
    
    static testMethod void testNonAttDataDelete(){   
    
        Account acc = UtiityHelperClass.createAccount();
        
        Contact con = UtiityHelperClass.createContact(acc.Id);
        
        Non_Attorney_Contact__c nonAtt = new Non_Attorney_Contact__c(Firm_Name__c = acc.Id, Attorney__c = con.Id,GRSId__c = 1234);
         
        insert nonAtt;
        try{
            delete nonAtt;

        }
        catch(Exception e){
        
            Boolean expectedExceptionThrown =  e.getMessage().contains('You are not allowed to delete the record after it was submitted to backend systems. Please contact your system administrator') ? true : false;
            
            System.AssertEquals(expectedExceptionThrown, true);
        
        } 
    }
    
    static testMethod void testNonAttUpdateRole(){   
    
        Account acc = UtiityHelperClass.createAccount();
        
        Contact con = UtiityHelperClass.createContact(acc.Id);
        List<Non_Attorney_Contact__c> cntLst = new List<Non_Attorney_Contact__c>();
        
        Non_Attorney_Contact__c nonAtt = new Non_Attorney_Contact__c(Firm_Name__c = acc.Id, Attorney__c = con.Id,GRSId__c = 1234);
        cntLst.add(nonAtt);
        insert cntLst;
        try{
            NonAttorneyTriggerUtilityHandler.UpdateRole(cntLst);

        }
        catch(Exception e){
        
            Boolean expectedExceptionThrown =  e.getMessage().contains('You are not allowed to delete the record after it was submitted to backend systems. Please contact your system administrator') ? true : false;
            
            System.AssertEquals(expectedExceptionThrown, true);
        
        } 
    }
    
}