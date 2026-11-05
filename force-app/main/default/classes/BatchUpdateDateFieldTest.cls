@isTest 
public class BatchUpdateDateFieldTest {
    static testMethod void testMethod1() 
        {
            Account acc = new Account();
            acc.name = 'test';
            acc.BillingState ='CA';
            acc.Type = 'Law Firm';
            insert acc;
            
            Task t = new Task(WhatId = acc.Id,Status = 'Completed',Priority = 'Normal',Subject = 'Dummy subject' ,ActivityDate = system.today());
            insert t;
            
            
            Test.startTest();
    
                BatchUpdateDateField obj = new BatchUpdateDateField('Law Firm');
                DataBase.executeBatch(obj); 
                
            Test.stopTest();
     }
 }