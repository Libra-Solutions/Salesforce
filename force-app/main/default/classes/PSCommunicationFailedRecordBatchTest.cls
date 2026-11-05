@isTest
public class PSCommunicationFailedRecordBatchTest{
    
    @testsetup static  void testPSCommunicationFailedRecordBatchSetup() {
        PSCommunicationCache__c psCache= new PSCommunicationCache__c (
        FailedRetries__c= 2, GenericName__c='CreateCase', 
        InputPayload__c ='{"ZipCode":"201301","WhosInsurancePaid":""}',
        Operation__c = '/api/Case/CreateCase',
        ResponseStatus__c = '200:Fail');
        
        PSCommunicationCache__c psCache1 = new PSCommunicationCache__c (
        FailedRetries__c= 1, GenericName__c='CreateCase', 
        InputPayload__c ='{"ZipCode":"201301","WhosInsurancePaid":""}',
        Operation__c = '/api/Case/CreateCase',
        ResponseStatus__c = '200:Success');

        
        List<PSCommunicationCache__c> psLst= new List<PSCommunicationCache__c>();
        psLst.add(psCache);
        psLst.add(psCache1);
        insert psLst;        
        
    }
    
    static testMethod void testMethod1(){
        Test.StartTest();  
          Database.executeBatch(new PSCommunicationFailedRecordBatch());
        Test.StopTest();
        
    }
    

   
  }