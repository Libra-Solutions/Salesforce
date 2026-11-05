@isTest 
public class BatchUpdatedInclusiveTaskTest {
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
            
            tsk.Created_By_Inclusive__c = tsk.createdBy.Name;
            update tsk;

            Test.startTest();
                BatchUpdatedInclusiveTask obj = new BatchUpdatedInclusiveTask();
                DataBase.executeBatch(obj); 
            Test.stopTest();
     }
}