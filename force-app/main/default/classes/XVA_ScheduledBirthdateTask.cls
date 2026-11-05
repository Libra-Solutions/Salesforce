global with sharing class XVA_ScheduledBirthdateTask implements Schedulable{
    global void execute(SchedulableContext sc) {
        List<Contact> contactsB = [SELECT Id, FirstName, LastName, Birthdate, OwnerId FROM Contact WHERE month_before_birthdate__c =:Date.Today()];
        List<Contact> contactsA = [SELECT Id, FirstName, LastName, AnniversaryofaFirm__c, OwnerId FROM Contact WHERE month_before_anniversary__c =:Date.Today()];

        List<Task> tasksToInsert = new List<Task>();

        for (Contact c : contactsB) {
            if (c.Birthdate != NULL) {
                Date birthdateThisYear = Date.newInstance(Date.today().year(), c.Birthdate.month(), c.Birthdate.day());
                Date oneMonthBefore = birthdateThisYear.addMonths((-1));

                if (Date.Today() == oneMonthBefore) {
                    Task newTask = new Task(
                        Subject = 'Send Birthday Card',
                        WhoId = c.Id,
                        ActivityDate = Date.Today(),
                        Status = 'New',
                        oasis_type__c = 'Task',
                        oasis_sub_type__c = 'Retention Call',
                        ownerId = c.OwnerId,
                        Priority = 'Normal',
                        Description = 'They have a birthday this month, send them a card.'
                    );

                    tasksToInsert.add(newTask);
                }
            }
        }

        for (Contact c : contactsA) {
            if (c.AnniversaryofaFirm__c != NULL) {
                Date anniversaryDateThisYear = Date.newInstance(Date.today().year(), c.AnniversaryofaFirm__c.month(), c.AnniversaryofaFirm__c.day());
                Date oneMonthBefore = anniversaryDateThisYear.addMonths((-1));

                if (Date.Today() == oneMonthBefore) {
                    Task newTask = new Task(
                        Subject = 'Send Anniversary Card',
                        WhoId = c.Id,
                        ActivityDate = Date.Today(),
                        Status = 'New',
                        oasis_type__c = 'Task',
                        oasis_sub_type__c = 'Retention Call',
                        ownerId = c.OwnerId,
                        Priority = 'Normal',
                        Description = 'They have an anniversary this month, send them a card.'
                    );

                    tasksToInsert.add(newTask);
                }
            }
        }

        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    }
}