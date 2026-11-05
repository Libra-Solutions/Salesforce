@isTest
public class UpdateAccountRelationBatchTest{
    
    static testMethod void testMethod1(){
        Test.StartTest();  
          Account acc = UtiityHelperClass.createAccount();
          insert acc;
          Contact con = UtiityHelperClass.createContact(acc.Id);
          insert con;
          
          Account_Relation__c actRel= new Account_Relation__c();
       
          actRel.Role__c = 'Attorney' ;
          actRel.Contact__c = con.Id ;
          actRel.Account__c = acc.Id ;
          insert actRel;
          
          PS_View360__c psView= new PS_View360__c(Account__c = acc.Id);
          insert psView;
          
          Database.executeBatch(new UpdateAccountRelationBatch());
        Test.StopTest();
        
    }
    

   
  }