@isTest
public class BatchContactsWithEventsCSVTest {
	 static testMethod void testMethod1() 
        {
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
             
            Test.startTest();
                BatchContactsWithEventsCSV obj = new BatchContactsWithEventsCSV();
                DataBase.executeBatch(obj); 
            Test.stopTest();
     }
}