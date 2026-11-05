global with sharing class XVA_BatchUpdateAccountOwner implements Database.Batchable<Account>
{
    public XVA_BatchUpdateAccountOwner() {

    }

    global List<Account> start(Database.BatchableContext bc) 
    {
        XVA_Job_Orchestration.StartJobOrchestration(new List<string>{'XVA_BatchUpdateAccountOwner'});
        return [Select Id, OwnerId, API_Owner_Reassign__c from Account where API_Owner_Reassign__c != null LIMIT 25000];
    }

    global void execute(Database.BatchableContext bc, List<Account> scope) 
    {
        List<Account> accountsToUpdate = new List<Account>();
        for (Account acc : scope) {
            if (acc.API_Owner_Reassign__c != null) {
                acc.OwnerId = acc.API_Owner_Reassign__c;
                acc.API_Owner_Reassign__c = null; // Clear the field after processing
                accountsToUpdate.add(acc);
            }
        }
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }

    global void finish(Database.BatchableContext bc) 
    {
        integer totalRemainingOwnerUpdates = [Select Count() from Account where API_Owner_Reassign__c != null];
        if (totalRemainingOwnerUpdates > 0)
        {
            Job_Orchestration__c jo = [Select id, Batch_Size__C from Job_Orchestration__c where Apex_Job_Name__c = 'XVA_BatchUpdateAccountOwner' LIMIT 1];
            Database.executeBatch(new XVA_BatchUpdateAccountOwner(), jo.Batch_Size__c.intValue());
        }            
        else {
            XVA_Job_Orchestration.EndJobOrchestration(new Map<string, string> {'XVA_BatchUpdateAccountOwner' => 'XVA_BatchUpdateAccount Owner has completed successfully.'});        
        }
        
    }



}