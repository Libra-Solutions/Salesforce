@isTest
public class CaseTypeControllerTest{
    
    
    
    static testMethod void testMethod1(){
       String selectedValue = 'Auto';
       CaseTypeController.getOpptyRecordTypeID(selectedValue);
       
    }
    
    static testMethod void testMethod2(){
       String selectedValue = 'Other';
       CaseTypeController.getOpptyRecordTypeID(selectedValue);
       
    }
    
    static testMethod void testMethod3(){
       String selectedValue = 'test';
       CaseTypeController.getOpptyRecordTypeID(selectedValue);
       
    }
    

   
  }