public with sharing class XVA_Job_Orchestration {

    public static void OnBeforeInsert(List<Job_Orchestration__c> jobOrchestrations) 
    {
        for(Job_Orchestration__c jo : jobOrchestrations) 
        {
            string className = jo.Apex_Job_Name__c;
            try {
                Type t = Type.forName(className);
                Database.Batchable<SObject> b = (Database.Batchable<SObject>)t.newInstance();
                system.debug('able to create a new instance of the batchable class');
            } catch(Exception ex) {
                jo.addError('This is an invalid batchable class');
            }
            
        }
    }

    public static void OnBeforeUpdate(Map<Id, Job_Orchestration__c> oldJobOrchestrations, Map<Id,Job_Orchestration__c> newJobOrchestrations) 
    {
        Set<Id> jobOrchestrationsToQueueBatchJob = new Set<Id>();

        for(Id joId : newJobOrchestrations.keySet()) 
        {
            Job_Orchestration__c newJo = newJobOrchestrations.get(joId);
            Job_Orchestration__c oldJo = oldJobOrchestrations.get(joId);

            //if the job trigger has been ... triggered, add to the jobs that need their job triggered.
            if(oldJo.Trigger_Job__c != newJo.Trigger_Job__c && newJo.Trigger_Job__c && newJo.Job_Status__c != 'Running')
            {

                jobOrchestrationsToQueueBatchJob.add(joId);
            }
        }

        if (jobOrchestrationsToQueueBatchJob.size() > 0) 
            TriggerBatchJobs(jobOrchestrationsToQueueBatchJob, newJobOrchestrations);
    }

    public static void TriggerBatchJobs(Set<Id> jobOrchestrationIds, Map<Id, Job_Orchestration__c> jobOrchestrations) 
    {
        for(Id joId : jobOrchestrationIds) 
        {
            Job_Orchestration__c jo = jobOrchestrations.get(joId);
            string className = jo.Apex_Job_Name__c;
            Type t = Type.forName(className);
            Database.Batchable<SObject> b = (Database.Batchable<SObject>)t.newInstance();
            Database.executeBatch(b, jo.Batch_Size__c != null ? integer.valueOf(jo.Batch_Size__c) : 200);
        }
    }

    public static void StartJobOrchestration(List<string> jobNames) 
    {
        List<Job_Orchestration__c> jobOrchestrations = [Select Id, Job_Status__c, Job_Start_Date__c, Job_End_Date__c from Job_Orchestration__c where Apex_Job_Name__c in :jobNames];
        for(Job_Orchestration__c jo : jobOrchestrations) {
            jo.Job_Start_Date__c = System.now();
            jo.Job_End_Date__c = null;
            jo.Job_Status__c = 'Running';
        }

        update jobOrchestrations;
    }

    public static void EndJobOrchestration(Map<string, string> jobEnds) 
    {
        List<Job_Orchestration__c> jobOrchestrations = [Select Id, Name, Job_Start_Date__c, Job_End_Date__c, Trigger_Job__c, Job_Status__c from Job_Orchestration__c where Apex_Job_Name__c in :jobEnds.keySet()];
        for(Job_Orchestration__c jo : jobOrchestrations) {
            string jobEndMessage = jobEnds.get(jo.Name);
            jo.Job_End_Date__c = System.now();
            jo.Trigger_Job__c = false;
            jo.Job_Message__c = jobEndMessage;
            jo.Job_Status__c = 'Completed';
        }

        update jobOrchestrations;
    }
}

/*

Select FIELDS(ALL) from CronTrigger order by CreatedDate desc LIMIT 200
Select FIELDS(ALL) from AsyncApexJob order by CreatedDate desc LIMIT 200

string className = 'XVA_ClearAccountCimiCashTraxLinks';
Type t = Type.forName(className);
Database.Batchable<SObject> b = (Database.Batchable<SObject>)t.newInstance();

string className2 = 'XVA_ClearAccountCimiCashTraxLinksTest';
Type t2 = Type.forName(className2);
Database.Batchable<SObject> b2 = (Database.Batchable<SObject>)t2.newInstance();


*/