@isTest
public class BatchGetDuplicateDataCSVNewTest {
	static testMethod void testMethod1() 
        {
            Account acc = new Account();
            acc.name = 'Goldblatt & Singer, University Ave';
            acc.BillingState ='CA';
            //acc.Phone = '0412345678';
            acc.Type = 'Law Firm';
            acc.isVisit__c = false;
            acc.BillingPostalCode = '09876';
           // acc.Fax = '(202) 225-7564'
            insert acc;
            
            Account acc1 = new Account();
            acc1.name = 'Goldblatt & Singer, University Ave';
            acc1.BillingState ='CA';
            //acc1.Phone = '0412345678';
            acc1.Type = 'Law Firm';
            acc1.isVisit__c = false;
            acc1.BillingPostalCode = '09876';
          //  acc1.Fax = '(202) 225-7564'
            insert acc1;
            
            Account acc2 = new Account();
            acc2.name = 'Goldblatt test & Singer, University Ave';
            acc2.BillingState ='CA';
             acc2.Type = 'Law Firm';
          //  acc2.Fax = '(202) 225-7564'
            insert acc2;
            
            Account acc3 = new Account();
            acc3.name = 'Goldblatt test & Singer, University Ave';
            acc3.BillingState ='CA';
             acc3.Type = 'Law Firm';
           // acc3.Fax = '(202) 225-7564'
            insert acc3;
            
             Task t = new Task(WhatId = acc.Id,Status = 'Completed',Priority = 'Normal',Subject = 'Dummy subject' ,ActivityDate = system.today());
            insert t;
            
            Task t3 = new Task(WhatId = acc2.Id,Status = 'Completed',Priority = 'Normal',Subject = 'Dummy subject' ,ActivityDate = system.today());
            insert t3;
             
            Test.startTest();
                BatchGetDuplicateDataCSVNew obj = new BatchGetDuplicateDataCSVNew('Law Firm',100,'','',4);
                DataBase.executeBatch(obj); 
            Test.stopTest();
     }
}