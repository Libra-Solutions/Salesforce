@isTest
public class AccountContactTriggerUtilityHandlerTest{
    
    static testMethod void testMethod2(){
        
        Account acc = UtiityHelperClass.createAccount();
        insert acc;
        Contact con = UtiityHelperClass.createContact(acc.Id);
        insert con;
        
        
        Account_Relation__c actRel= UtiityHelperClass.createAccountRealtion(acc.id,con.id);
        
        insert actRel;
        
        delete actRel;        
    }
    
    static testMethod void testMethod1(){
        
        Account acc = new Account(Name = 'TestAccount2', HeadQuarter__c = false, Type = 'LawFirm', Core__c = true,BillingStreet = 'Street',BillingCity = 'city',BillingState = 'LA',BillingPostalCode = '12345',Phone = '1234567890',Fax = '123456789');
        insert acc;
        Account acc2 = new Account(Name = 'TestAccount3', HeadQuarter__c = false, Type = 'LawFirm', Core__c = true,BillingStreet = 'Street',BillingCity = 'city',BillingState = 'LA',BillingPostalCode = '12345',Phone = '1234567890',Fax = '123456789');
        insert acc2;
        Contact con = UtiityHelperClass.createContact(acc.Id);
        con.LastName = 'TestCon2';
        insert con;
        
        Contact con2 = UtiityHelperClass.createContact(acc2.Id);
        con2.LastName = 'TestCon2';
        insert con2;
    
        
        Account_Relation__c actRel= UtiityHelperClass.createAccountRealtion(acc.id,con.id);
        
        insert actRel;
        
        // added below uml operation to cover deleteAccountRelation method 
        delete actRel;
        
        Non_Attorney_Contact__c nonAtt = UtiityHelperClass.createNonAttorneyContact(acc2.id,con2.id);
        //nonAtt.Contact__c = con.id;
        insert nonAtt;
        
        /*
        catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Please select a Contact in Support role') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        
        } */
                
    }
    
    
   
}