@isTest 
public class BatchContactsWithTasksCSVTest {
	 static testMethod void testMethod1() 
        {
             Account acc = UtiityHelperClass.createAccount();
            insert acc;
            Contact con = UtiityHelperClass.createContact(acc.Id);
            insert con;
            
            task tsk = new task();
            tsk.Subject = 'test';
            tsk.Oasis_Type__c = 'Email';
            tsk.Oasis_Sub_Type__c = 'Email';
            tsk.Priority = 'Normal';
            tsk.Status = 'Open';
            tsk.whoId = con.Id;
            insert tsk;
            datetime startD = 
            datetime.newInstance
              (2021, 1, 1);
        
        
            datetime lastD = 
            datetime.newInstance
              (2021, 4, 1);
            Test.startTest();
                BatchContactsWithTasksCSV obj = new BatchContactsWithTasksCSV(startD, lastD);
                DataBase.executeBatch(obj); 
            Test.stopTest();
     }
}