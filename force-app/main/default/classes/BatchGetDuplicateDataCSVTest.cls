@isTest 
public class BatchGetDuplicateDataCSVTest {
	static testMethod void testMethod1() 
        {
            Account acc = new Account();
            acc.name = 'Goldblatt & Singer, University Ave';
            acc.BillingState ='CA';
            acc.Phone = '0412345678';
            insert acc;
            
            Account acc1 = new Account();
            acc1.name = 'Goldblatt & Singer, University Ave';
            acc1.BillingState ='CA';
            acc1.Phone = '0412345678';
            insert acc1;
            
            Account acc2 = new Account();
            acc2.name = 'Goldblatt test & Singer, University Ave';
            acc2.BillingState ='CA';
            insert acc2;
            
            Account acc3 = new Account();
            acc3.name = 'Goldblatt test & Singer, University Ave';
            acc3.BillingState ='CA';
            insert acc3;
            
            Task t = new Task(WhatId = acc.Id,Status = 'Completed',Priority = 'Normal',Subject = 'Dummy subject' ,ActivityDate = system.today());
            insert t;
            
            Task t3 = new Task(WhatId = acc2.Id,Status = 'Completed',Priority = 'Normal',Subject = 'Dummy subject' ,ActivityDate = system.today());
            insert t3;
            
            Task t4 = new Task(WhatId = acc3.Id,Status = 'Completed',Priority = 'Normal',Subject = 'Dummy subject' ,ActivityDate = system.today()-1);
            insert t4;
            
             Task t5 = new Task(WhatId = acc2.Id,Status = 'Completed',Priority = 'Normal',Subject = 'Dummy subject' ,ActivityDate = system.today()-1);
            insert t5;
             
            Test.startTest();
                BatchGetDuplicateDataCSV obj = new BatchGetDuplicateDataCSV('CA');
                DataBase.executeBatch(obj); 
            Test.stopTest();
     }
}