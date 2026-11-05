@isTest
public class Xva_BatchTaskOppCleanupTest {
    
    @TestSetup
    static void setupData() {
        Account acc = UtiityHelperClass.createAccount();
        acc.headquarter__c = false; 
        insert acc;
        Contact con = UtiityHelperClass.createContact(acc.Id);  
        insert con;
        
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.newInstance(2020, 1, 1),
            AccountId = acc.Id
        );
        insert opp;

        Task task = new Task(
            Subject = 'Test Task',
            ActivityDate = Date.newInstance(2020, 1, 1),
            WhoId = con.Id,
            Oasis_Type__c = 'Email',
            Oasis_Sub_Type__c = 'Accounts Receivable'
        );
        insert task;
        Test.setCreatedDate(opp.id, Date.Today().addYears(-2));
        Test.setCreatedDate(task.id, Date.Today().addYears(-2));
    }

    @isTest 
    static void testTaskCleanup() {
        Test.startTest();
        Xva_BatchTaskCleanup taskCleanup = new Xva_BatchTaskCleanup();
        Id batchProcessId = Database.executeBatch(taskCleanup);
        Test.stopTest();

    }

    @isTest
    static void testOpportunityCleanup() {
        Test.startTest();
        Xva_BatchOpportunityCleanup opportunityCleanup = new Xva_BatchOpportunityCleanup();
        Id batchProcessId = Database.executeBatch(opportunityCleanup);
        Test.stopTest();

    }

    @isTest 
    static void testSchedulableTaskOppCleanup() {
        Test.startTest();
        Xva_SchedulableTaskOppCleanup schedulableTaskCleanup = new Xva_SchedulableTaskOppCleanup();
        schedulableTaskCleanup.execute(null);
        Test.stopTest();
    }
}