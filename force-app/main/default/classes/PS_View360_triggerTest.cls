@isTest
public class PS_View360_triggerTest{
    
    static testMethod void testMethod1(){
    
        Account acc = UtiityHelperClass.createAccount();
        insert acc;
        Contact con = UtiityHelperClass.createContact(acc.Id);
        insert con;
        
        PS_View360__c pv = new PS_View360__c();
        pv.Attorney__c = con.id;
        pv.No_of_Funded_Cases__c = 5;
        pv.Funded__c = 10;
        pv.No_of_Total_Cases__c = 15;
        insert pv;
        update pv;

    }
}