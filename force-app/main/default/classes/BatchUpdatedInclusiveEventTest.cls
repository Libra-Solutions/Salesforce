@isTest
public class BatchUpdatedInclusiveEventTest {
	static testMethod void testMethod1(){
    
        Account acc = UtiityHelperClass.createAccount();
        insert acc;
        Contact con = UtiityHelperClass.createContact(acc.Id);
        insert con;
        
        event evt = new event();
        evt.Subject = 'test';
        evt.Oasis_Event_Purpose__c = 'Meeting - Attorney';
        evt.Oasis_Event_Result__c = 'Level 1';
        evt.StartDateTime = system.now();
        evt.EndDateTime = system.now().addHours(5);
        evt.whoId = con.Id;
        insert evt;
        
        
        evt.Created_By_Inclusive__c = evt.createdBy.Name;
        update evt;
        
        Test.startTest();
            BatchUpdatedInclusiveEvent obj = new BatchUpdatedInclusiveEvent();
            DataBase.executeBatch(obj); 
        Test.stopTest();
        
    }
}