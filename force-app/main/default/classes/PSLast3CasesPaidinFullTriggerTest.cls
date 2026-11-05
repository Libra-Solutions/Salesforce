@isTest
public class PSLast3CasesPaidinFullTriggerTest{
    
    static testMethod void testMethod3(){
    
        Account acc = UtiityHelperClass.createAccount();
        insert acc;
        Contact con = UtiityHelperClass.createContact(acc.Id);
        insert con;
        
        PS_Last3Cases_Paid_In_Full__c pv = new PS_Last3Cases_Paid_In_Full__c();
        pv.Attorney__c = con.id;
        pv.Last_Payment_Date__c = system.today();
        pv.CTX_FirmId__c=2;
        pv.Amount_Paid__c=100;
        insert pv;
        update pv;

    }
}