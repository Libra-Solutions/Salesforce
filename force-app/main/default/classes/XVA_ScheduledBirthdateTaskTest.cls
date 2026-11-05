@isTest
public class XVA_ScheduledBirthdateTaskTest {
    
    @testSetup
    static void setup() {
        // Create test Contacts with a birthdate and anniversary date one month from today.
        List<Contact> testContacts = new List<Contact>();

        // Contact with Birthdate 1 month from today
        testContacts.add(new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Birthdate = Date.today().addMonths(1),
            OwnerId = UserInfo.getUserId()
        ));

        // Contact with Anniversary one month from today
        testContacts.add(new Contact(
            FirstName = 'Jane',
            LastName = 'Smith',
            AnniversaryofaFirm__c = Date.today().addMonths(1),
            OwnerId = UserInfo.getUserId()
        ));

        // Insert test contacts
        insert testContacts;
    }
    
    @isTest
    static void testScheduledBirthdateAndAnniversaryTasks() {
        // Set up the test context for scheduling
        Test.startTest();
        
        // Create an instance of the schedulable class
        XVA_ScheduledBirthdateTask scheduledTask = new XVA_ScheduledBirthdateTask();
        
        // Simulate the scheduled job
        String jobId = System.schedule('Test Scheduled Job', '0 0 10 * * ?', scheduledTask);
        
        // Execute the job by calling the execute method directly
        scheduledTask.execute(null);
        
        Test.stopTest();
        
        // Query for tasks created by the scheduled job
        List<Task> tasks = [SELECT Id, Subject, WhoId, Description, Status, Priority, oasis_type__c, oasis_sub_type__c FROM Task WHERE subject IN ('Send Birthday Card', 'Send Anniversary Card')];

        // Validate that tasks were created for both birthday and anniversary
        System.assertEquals(4, tasks.size(), 'Four tasks should be created, two for birthday and two for anniversary, one of each card for each contact.');

        // Validate the task for the contact with a birthday
        Task birthdayTask = [SELECT Id, Subject, WhoId, Description FROM Task WHERE Subject = 'Send Birthday Card' LIMIT 1];
        System.assertEquals('Send Birthday Card', birthdayTask.Subject);
        System.assertEquals('They have a birthday this month, send them a card.', birthdayTask.Description);

        // Validate the task for the contact with an anniversary
        Task anniversaryTask = [SELECT Id, Subject, WhoId, Description FROM Task WHERE Subject = 'Send Anniversary Card' LIMIT 1];
        System.assertEquals('Send Anniversary Card', anniversaryTask.Subject);
        System.assertEquals('They have an anniversary this month, send them a card.', anniversaryTask.Description);
    }
}