@isTest
public class RecordTypeControllerTest{


 @testSetup static void data(){
  Account act = new Account();
       act.name = 'test';
       act.CTXFirmId__c = '123dfg';
       act.AtticusId__c = '123fghd';
       act.GRSId__c = 1234.99;
       act.KeyMedsID__c = 123456;
       act.BillingStreet = 'Street';
       act.BillingCity = 'city';
       act.BillingState = 'LA';
       act.BillingPostalCode = '12345';
       insert act;
       
       Contact cnt = new Contact();
       cnt.firstname = 'first';
       cnt.lastname = 'last';
       cnt.AccountId = act.Id ;
       cnt.Role__c ='Paralegal';
       insert cnt;
       
       Account_Relation__c actRel= new Account_Relation__c();
       
       actRel.Role__c = 'Attorney' ;
       actRel.Contact__c = cnt.Id ;
       actRel.Account__c = act.Id ;
       List<Account_Relation__c > actLst = new List<Account_Relation__c >();
       actLst.add(actRel);
       insert actLst;
 }

  testMethod static void testMethod1(){
    List<String> lst = new List<String>{'Auto', 'Others'};
    for(String selectedValue : lst) {
      RecordTypeController.fetchRecordTypeLabel(selectedValue );
    }
  }
  
  testMethod static void testgetContactdetails(){
      Contact cnt = [Select id, FirstName, Lastname, accountid from Contact where FirstName= 'first'];
      RecordTypeController.getContactdetails(cnt.Id);
    
  }
  
  testMethod static void testdoDisableNextButton(){
      Contact cnt = [Select id, FirstName, Lastname, accountid from Contact where FirstName= 'first'];
      RecordTypeController.doDisableNextButton(cnt.Id);
    
  }
  
  testMethod static void testgetRecTypeId(){
      
      RecordTypeController.getRecTypeId('Provider');
    
  }
  
  

}