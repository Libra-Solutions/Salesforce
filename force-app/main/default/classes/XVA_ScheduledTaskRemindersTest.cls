@isTest
public class XVA_ScheduledTaskRemindersTest {
    
    @testSetup
    static void setupTestData() {
        User testUser = [SELECT Id, Email FROM User WHERE IsActive = true LIMIT 1];

        // Create tasks that are 3 days, 1 day before, and 1 day past due
        List<Task> tasks = new List<Task>();
        tasks.add(new Task(
            Subject = 'Website Request Reachout - Demo',
            OwnerId = UserInfo.getUserId(),
            ActivityDate = Date.today().addDays(3), // Task due in 3 days
            Status = 'New'
        ));
        tasks.add(new Task(
            Subject = 'CMS Demo Follow Up',
            OwnerId = UserInfo.getUserId(),
            ActivityDate = Date.today().addDays(1), // Task due tomorrow
            Status = 'New'
        ));
        tasks.add(new Task(
            Subject = 'Website Request Reachout - Demo',
            OwnerId = UserInfo.getUserId(),
            ActivityDate = Date.today().addDays(-1), // Task was due yesterday
            Status = 'New',
            rvp__c = UserInfo.getUserId()
        ));

        insert tasks;
    }
    
    @isTest
    static void testExecuteScheduledJob() {

        String jobId = System.schedule('Test Scheduled Task Reminders', '0 0 10 * * ?', new XVA_ScheduledTaskReminders());
        
        
    }
}