@isTest 
public class BatchUpdateContactTypeFieldTest {
	static testMethod void testMethod1() 
        {
            Account acc = new Account();
            acc.name = 'test';
            acc.BillingState ='CA';
            acc.Type = 'Law Firm';
            insert acc;
            
            
            
            Test.startTest();
    
                BatchUpdateContactTypeField obj = new BatchUpdateContactTypeField();
                DataBase.executeBatch(obj); 
                
            Test.stopTest();
     }
}