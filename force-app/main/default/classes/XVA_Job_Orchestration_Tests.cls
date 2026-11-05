@isTest
public with sharing class XVA_Job_Orchestration_Tests {
    
    static testMethod void TestBadBatchInsert() {
        Job_Orchestration__c jobOrchestration = new Job_Orchestration__c(Apex_Job_Name__c = 'XVA_ClearAccountCimiCashTraxLinksTest');
        try {
            insert jobOrchestration;
        } catch(Exception e) {
            //we expect an exception here
        }
    }

    static testMethod void TestGoodBatchInsert() {
        Job_Orchestration__c jobOrchestration = new Job_Orchestration__c(Apex_Job_Name__c = 'XVA_ClearAccountCimiCashTraxLinks');
        insert jobOrchestration;
    }

    static testMethod void TestQueueJob() 
    {
        Job_Orchestration__c jobOrchestration = new Job_Orchestration__c(Apex_Job_Name__c = 'XVA_ClearAccountCimiCashTraxLinks');
        insert jobOrchestration;

        test.StartTest();
        jobOrchestration.Trigger_Job__c = true;
        update jobOrchestration;

        test.stopTest();
    }

    static testMethod void TestStartJobOrchestration() 
    {
        Job_Orchestration__c jobOrchestration = new Job_Orchestration__c(Apex_Job_Name__c = 'XVA_ClearAccountCimiCashTraxLinks');
        insert jobOrchestration;
        XVA_Job_Orchestration.StartJobOrchestration(new List<string>{'XVA_ClearAccountCimiCashTraxLinks'});
    }

    static testMethod void TestEndJobOrchestration() 
    {
        Job_Orchestration__c jobOrchestration = new Job_Orchestration__c(Apex_Job_Name__c = 'XVA_ClearAccountCimiCashTraxLinks');
        insert jobOrchestration;
        XVA_Job_Orchestration.StartJobOrchestration(new List<string>{'XVA_ClearAccountCimiCashTraxLinks'});
        XVA_Job_Orchestration.EndJobOrchestration(new Map<string, string>{'XVA_ClearAccountCimiCashTraxLinks' => 'XVA_ClearAccountCimiCashTraxLinks has completed successfully.'});
    }
}