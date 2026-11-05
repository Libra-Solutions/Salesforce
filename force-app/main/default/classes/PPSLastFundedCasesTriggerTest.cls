@isTest
public class PPSLastFundedCasesTriggerTest{
    
    static testMethod void testMethod2(){
    
        Account acc = UtiityHelperClass.createAccount();
        insert acc;
        Contact con = UtiityHelperClass.createContact(acc.Id);
        insert con;
        
        PSLastFundedCases__c pv = new PSLastFundedCases__c();
        pv.Attorney__c = con.id;
        pv.PSDateFunded__c = system.Today();
        insert pv;
        update pv;

    }
}