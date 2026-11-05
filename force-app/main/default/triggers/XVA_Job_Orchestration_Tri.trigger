trigger XVA_Job_Orchestration_Tri on Job_Orchestration__c (before insert, before update) 
{
    if(Trigger.isBefore)
    {
        system.debug('Job Orchestration: Before');
        if(Trigger.isInsert)
        {
            system.debug('Job Orchestration: Insert');
            XVA_Job_Orchestration.onBeforeInsert(Trigger.new);
        }
        if(Trigger.isUpdate)
        {
            system.debug('Job Orchestration: Update');
            XVA_Job_Orchestration.onBeforeUpdate(Trigger.oldMap, Trigger.newMap);
        }
    }
}