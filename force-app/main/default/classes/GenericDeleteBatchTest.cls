@isTest
public class GenericDeleteBatchTest{
       
    static testMethod void testMethod1(){
        Test.StartTest();  
          
          Account acc = UtiityHelperClass.createAccount();
          insert acc;
          
          String query = 'Select id from Account limit 1';
          
          GenericDeleteBatch batch = new GenericDeleteBatch(query);
          Database.executeBatch(batch);
        Test.StopTest();
        
    }
    

   
  }