@isTest
public class XVA_EmailToTaskTest {

    @testSetup
    static void setupTestData() {
        // Create users to be owners of the tasks
        List<User> users = new List<User>();

        users.add(new User(
            LastName = 'Iglinski',
            Email = 'miglinski@movedocs.com.invalid',
            Username = 'miglinski@movedocs.com.testuser',
            Alias = 'migli',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US',
            IsActive = true
        ));

        users.add(new User(
            LastName = 'Jason',
            Email = 'jason@movedocs.com',
            Username = 'jason@movedocs.com.testuser',
            Alias = 'jjason',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US',
            IsActive = true
        ));

        // Insert users
        insert users;

        List<Contact> contacts = new List<Contact>();

        Contact contact = new Contact(
            FirstName = 'Website Request',
            LastName = 'Contact'
        );

        contacts.add(contact);
        
        Contact contactCMS = new Contact(
            FirstName = 'CMS Request',
            LastName = 'Contact'
        );

        contacts.add(contactCMS);

        insert contacts;
    }

    private static Messaging.InboundEmailResult callHandleCASEPeerForm(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        String businesstype = XVA_EmailToTask.GetLineStartingWith(email, new List<String>{ 'Business Type:', 'Select your business type::' })
            ?? XVA_EmailToTask.GetParsedValue(email, 'Select your business type::', 'Additional Info:')
            ?? XVA_EmailToTask.GetParsedValue(email, 'Select your business type::', 'Source:')
            ?? XVA_EmailToTask.GetParsedValue(email, 'Select your business type::', 'How did you hear about MoveDocs?:')
            ?? XVA_EmailToTask.GetParsedValue(email, 'Business Type:', 'Address:')
            ?? '';
        String name = XVA_EmailToTask.GetLineStartingWith(email, 'Name:')
            ?? XVA_EmailToTask.GetParsedValue(email, 'Name:', 'Email:')
            ?? '';
        String formEmail = XVA_EmailToTask.GetLineStartingWith(email, 'Email:')
            ?? XVA_EmailToTask.GetParsedValue(email, 'Email:', 'Phone:')
            ?? XVA_EmailToTask.GetParsedValue(email, 'Email:', 'Address:')
            ?? XVA_EmailToTask.GetParsedValue(email, 'Email:', 'Company:')
            ?? XVA_EmailToTask.GetParsedValue(email, 'Email:', 'Select your business type::')
            ?? XVA_EmailToTask.GetParsedValue(email, 'Email:', 'Additional Info:')
            ?? XVA_EmailToTask.GetParsedValue(email, 'Email:', 'Source:')
            ?? '';
        String phone = XVA_EmailToTask.GetLineStartingWith(email, 'Phone:')
            ?? XVA_EmailToTask.GetParsedValue(email, 'Phone:', 'Address:')
            ?? XVA_EmailToTask.GetParsedValue(email, 'Phone:', 'State:')
            ?? XVA_EmailToTask.GetParsedValue(email, 'Phone:', 'Company:')
            ?? XVA_EmailToTask.GetParsedValue(email, 'Phone:', 'Select your business type::')
            ?? XVA_EmailToTask.GetParsedValue(email, 'Phone:', 'Additional Info:')
            ?? XVA_EmailToTask.GetParsedValue(email, 'Phone:', 'Source:')
            ?? '';
        String address = XVA_EmailToTask.GetLineStartingWith(email, 'Address:')
            ?? XVA_EmailToTask.GetParsedValue(email, 'Address:', 'Company:')
            ?? XVA_EmailToTask.GetParsedValue(email, 'Address:', 'Select your business type::')
            ?? XVA_EmailToTask.GetParsedValue(email, 'Address:', 'Additional Info:')
            ?? XVA_EmailToTask.GetParsedValue(email, 'Address:', 'Source:');
        String state = XVA_EmailToTask.GetLineStartingWith(email, 'State:')
            ?? XVA_EmailToTask.GetParsedValue(email, 'State:', 'Company:');
        String company = XVA_EmailToTask.GetLineStartingWith(email, 'Company:')
            ?? XVA_EmailToTask.GetParsedValue(email, 'Company:', 'Select your business type::')
            ?? XVA_EmailToTask.GetParsedValue(email, 'Company:', 'Additional Info:')
            ?? XVA_EmailToTask.GetParsedValue(email, 'Company:', 'Source:')
            ?? '';
        String comments = XVA_EmailToTask.GetParsedValue(email, 'Additional Info:', 'Source:') ?? '';
        String source = XVA_EmailToTask.GetLineStartingWith(email, 'Source:')
            ?? email.plainTextBody.normalizeSpace().substringAfter('Source:');
        return XVA_EmailToTask.handleCASEPeerForm(email, envelope, businesstype, name, formEmail, phone, address, state, company, comments, source);
    }

    @isTest
    static void testBrokenEmail() {
        //you can use this test to determine what might be the problem with emails that are coming in mamually. 

    }


    @isTest
    static void testHandleInboundEmail_DemoRequest() {
        // Create the mock email
        Messaging.InboundEmail email = new Messaging.InboundEmail();
         //email.subject = 'New submission from Schedule Demo on MoveDocs website';
         email.subject = 'New submission from Trio - Firms - Demo Form on MoveDocs website';
        email.plainTextBody = '*Select your business type:*Provider Name:John Doe Email:john.doe@example.com Phone: 555-1234 Address: 123 Main St, California Company:TestCo Additional Info: Testing submission Source: Website';
        email.htmlBody = '<html><body>' +
                 '<p><strong>Select your business type:</strong> Provider</p>' +
                 '<p><strong>Name:</strong> John Doe</p>' +
                 '<p><strong>Email:</strong> john.doe@example.com</p>' +
                 '<p><strong>Phone:</strong> 555-1234</p>' +
                 '<p><strong>Address:</strong> 123 Main St, California</p>' +
                 '<p><strong>Company:</strong> TestCo</p>' +
                 '<p><strong>Additional Info:</strong> Testing submission</p>' +
                 '<p><strong>Source:</strong> Website</p>' +
                 '</body></html>';

        Messaging.InboundEmail email1 = new Messaging.InboundEmail();
        email1.subject = 'New submission from Schedule Demo on MoveDocs website';
        email1.plainTextBody = 'Name:John Doe Email:john.doe@example.com Phone: 555-1234 Address: 123 Main St, Louisiana Company:TestCo Additional Info: Testing submission Source: Website';
        email1.htmlBody = '<html><body>' +
                  '<p><strong>Name:</strong> John Doe</p>' +
                  '<p><strong>Email:</strong> john.doe@example.com</p>' +
                  '<p><strong>Phone:</strong> 555-1234</p>' +
                  '<p><strong>Address:</strong> 123 Main St, Vermont</p>' +
                  '<p><strong>Company:</strong> TestCo</p>' +
                  '<p><strong>Additional Info:</strong> Testing submission</p>' +
                  '<p><strong>Source:</strong> Website</p>' +
                  '</body></html>';

        Messaging.InboundEmail email2 = new Messaging.InboundEmail();
        email2.subject = 'New submission from Schedule Demo on MoveDocs website';
        email2.plainTextBody = 'Name:John Doe Email:john.doe@example.com Phone: 555-1234 Address: 123 Main St, Tennessee Company:TestCo Additional Info: Testing submission Source: Website';
        email2.htmlBody = '<html><body>' +
                  '<p><strong>Name:</strong> John Doe</p>' +
                  '<p><strong>Email:</strong> john.doe@example.com</p>' +
                  '<p><strong>Phone:</strong> 555-1234</p>' +
                  '<p><strong>Address:</strong> 123 Main St, Oregon</p>' +
                  '<p><strong>Company:</strong> TestCo</p>' +
                  '<p><strong>Additional Info:</strong> Testing submission</p>' +
                  '<p><strong>Source:</strong> Website</p>' +
                  '</body></html>';

        Messaging.InboundEmail email3 = new Messaging.InboundEmail();
        email3.subject = 'New submission from Schedule Demo on MoveDocs website';
        email3.plainTextBody = 'Name:John Doe Email:john.doe@example.com Phone: 555-1234 Address: 123 Main St, Colorado Company:TestCo Additional Info: Testing submission Source: Website';
        email3.htmlBody = '<html><body>' +
                  '<p><strong>Name:</strong> John Doe</p>' +
                  '<p><strong>Email:</strong> john.doe@example.com</p>' +
                  '<p><strong>Phone:</strong> 555-1234</p>' +
                  '<p><strong>Address:</strong> 123 Main St, Oregon</p>' +
                  '<p><strong>Company:</strong> TestCo</p>' +
                  '<p><strong>Additional Info:</strong> Testing submission</p>' +
                  '<p><strong>Source:</strong> Website</p>' +
                  '</body></html>';

        Messaging.InboundEmail email4 = new Messaging.InboundEmail();
        email4.subject = 'New submission from Schedule Demo on MoveDocs website';
        email4.plainTextBody = 'Name:John Doe Email:john.doe@example.com Phone: 555-1234 Address: 123 Main St, Ohio Company:TestCo Additional Info: Testing submission Source: Website';
        email4.htmlBody = '<html><body>' +
                  '<p><strong>Name:</strong> John Doe</p>' +
                  '<p><strong>Email:</strong> john.doe@example.com</p>' +
                  '<p><strong>Phone:</strong> 555-1234</p>' +
                  '<p><strong>Address:</strong> 123 Main St, Ohio</p>' +
                  '<p><strong>Company:</strong> TestCo</p>' +
                  '<p><strong>Additional Info:</strong> Testing submission</p>' +
                  '<p><strong>Source:</strong> Website</p>' +
                  '</body></html>';

        Messaging.InboundEmail email5 = new Messaging.InboundEmail();
        email5.subject = 'New submission from Schedule Demo on MoveDocs website';
        email5.plainTextBody = 'Name:John Doe Email:john.doe@example.com Phone: 555-1234 Address: 123 Main St, Florida Company:TestCo Additional Info: Testing submission Source: Website';
        email5.htmlBody = '<html><body>' +
                '<p><strong>Name:</strong> John Doe</p>' +
                '<p><strong>Email:</strong> john.doe@example.com</p>' +
                '<p><strong>Phone:</strong> 555-1234</p>' +
                '<p><strong>Address:</strong> 123 Main St, Ohio</p>' +
                '<p><strong>Company:</strong> TestCo</p>' +
                '<p><strong>Additional Info:</strong> Testing submission</p>' +
                '<p><strong>Source:</strong> Website</p>' +
                '</body></html>';
                
        Messaging.InboundEmail email6 = new Messaging.InboundEmail();
        email6.subject = 'New submission from Request Oasis Access on MoveDocs';
        email6.plainTextBody = 'Name:Jane Doe Email: jane.doe@example.com Phone: 555-5678 Address: 456 Elm St, Oregon Company: LawCo Select your business type:: Provider Additional Info: Looking for demo Source: Referral';
        email6.htmlBody = '<html><body>' +
                '<p><strong>Select your business type:</strong> Attorney</p>' +
                '<p><strong>Name:</strong> Jane Doe</p>' +
                '<p><strong>Email:</strong> jane.doe@example.com</p>' +
                '<p><strong>Phone:</strong> 555-5678</p>' +
                '<p><strong>Address:</strong> 456 Elm St, Arizona</p>' +
                '<p><strong>Company:</strong> LawCo</p>' +
                '<p><strong>Additional Info:</strong> Looking for demo</p>' +
                '<p><strong>Source:</strong> Referral</p>' +
                '</body></html>';

        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = 'noreply@example.com';

        // Create an instance of the email handler
        XVA_EmailToTask emailHandler = new XVA_EmailToTask();

        // Simulate handling the email
        Test.startTest();
        Messaging.InboundEmailResult result = emailHandler.handleInboundEmail(email, envelope);
        Messaging.InboundEmailResult result1 = emailHandler.handleInboundEmail(email1, envelope);
        Messaging.InboundEmailResult result2 = emailHandler.handleInboundEmail(email2, envelope);
        Messaging.InboundEmailResult result3 = emailHandler.handleInboundEmail(email3, envelope);
        Messaging.InboundEmailResult result4 = emailHandler.handleInboundEmail(email4, envelope);
        Messaging.InboundEmailResult result5 = emailHandler.handleInboundEmail(email5, envelope);
        Messaging.InboundEmailResult result6 = emailHandler.handleInboundEmail(email6, envelope);
        Test.stopTest();

        // Verify the task was created
        List<Task> tasks = [SELECT Id, Subject, Description, Owner.Email, Oasis_Type__c, Oasis_Sub_Type__c, ActivityDate, ReminderDateTime FROM Task];
        //System.assertEquals(7, tasks.size(), '7 tasks should have been created');
        
    }

    /*
    @isTest
    static void testHandleCASEPeerForm() {
        // Create the mock email for CASEPeer demo
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'New CASEpeer + MDs Demo Request for Oasis Attorney';
        email.plainTextBody = 'Select your business type:Attorney\r\nName:Jane Doe\r\nEmail: jane.doe@example.com\r\nPhone: 555-5678\r\nAddress: 456 Elm St, Texas\r\nState:Texas\r\nCompany: LawCo\r\nAdditional Info: Looking for demo\r\nSource: Referral';
        email.htmlBody = '<html><body>' +
                 '<p><strong>Select your business type:</strong> Attorney</p>' +
                 '<p><strong>Name:</strong> Jane Doe</p>' +
                 '<p><strong>Email:</strong> jane.doe@example.com</p>' +
                 '<p><strong>Phone:</strong> 555-5678</p>' +
                 '<p><strong>Address:</strong> 456 Elm St, Texas</p>' +
                 '<p><strong>State:</strong>Texas</p>' +
                 '<p><strong>Company:</strong> LawCo</p>' +
                 '<p><strong>Additional Info:</strong> Looking for demo</p>' +
                 '<p><strong>Source:</strong> Referral</p>' +
                 '</body></html>';

        Messaging.InboundEmail email1 = new Messaging.InboundEmail();
        email1.subject = 'New CASEpeer + MDs Demo Request for Oasis Attorney';
        email1.plainTextBody = 'Select your business type:Attorney\r\nName:Jane Doe\r\nEmail: jane.doe@example.com\r\nPhone: 555-5678\r\nAddress: 456 Elm St, North Carolina\r\nState:North Carolina\r\nCompany: LawCo\r\nAdditional Info: Looking for demo\r\nSource: Referral';
        email1.htmlBody = '<html><body>' +
                  '<p><strong>Select your business type:</strong> Attorney</p>' +
                  '<p><strong>Name:</strong> Jane Doe</p>' +
                  '<p><strong>Email:</strong> jane.doe@example.com</p>' +
                  '<p><strong>Phone:</strong> 555-5678</p>' +
                  '<p><strong>Address:</strong> 456 Elm St, North Carolina</p>' +
                  '<p><strong>State:</strong>North Carolina</p>' +
                  '<p><strong>Additional Info:</strong> Looking for demo</p>' +
                  '<p><strong>Source:</strong> Referral</p>' +
                  '</body></html>';

        Messaging.InboundEmail email2 = new Messaging.InboundEmail();
        email2.subject = 'New CASEpeer + MDs Demo Request for Oasis Attorney';
        email2.plainTextBody = 'Select your business type:*Attorney*\r\nName:Jane Doe\r\nEmail: jane.doe@example.com\r\nPhone: 555-5678\r\nAddress: 456 Elm St, Florida\r\nState:Florida\r\nCompany: LawCo\r\nAdditional Info: Looking for demo\r\nSource: Referral';
        email2.htmlBody = '<html><body>' +
                  '<p><strong>Select your business type:</strong> Attorney</p>' +
                  '<p><strong>Name:</strong> Jane Doe</p>' +
                  '<p><strong>Email:</strong> jane.doe@example.com</p>' +
                  '<p><strong>Phone:</strong> 555-5678</p>' +
                  '<p><strong>Address:</strong> 456 Elm St, Florida</p>' +
                  '<p><strong>Company:</strong> LawCo</p>' +
                  '<p><strong>Additional Info:</strong> Looking for demo</p>' +
                  '<p><strong>Source:</strong> Referral</p>' +
                  '</body></html>';

        Messaging.InboundEmail email3 = new Messaging.InboundEmail();
        email3.subject = 'New CASEpeer + MDs Demo Request for Oasis Attorney';
        email3.plainTextBody = 'Select your business type:*Attorney*\r\nName:Jane Doe\r\nEmail: jane.doe@example.com\r\nPhone: 555-5678\r\nAddress: 456 Elm St, Illinois\r\nState:Illinois\r\nCompany: LawCo\r\nAdditional Info: Looking for demo\r\nSource: Referral';
        email3.htmlBody = '<html><body>' +
                  '<p><strong>Select your business type:</strong> Attorney</p>' +
                  '<p><strong>Name:</strong> Jane Doe</p>' +
                  '<p><strong>Email:</strong> jane.doe@example.com</p>' +
                  '<p><strong>Phone:</strong> 555-5678</p>' +
                  '<p><strong>Address:</strong> 456 Elm St, Illinois</p>' +
                  '<p><strong>State:</strong>Illinois</p>' +
                  '<p><strong>Company:</strong> LawCo</p>' +
                  '<p><strong>Additional Info:</strong> Looking for demo</p>' +
                  '<p><strong>Source:</strong> Referral</p>' +
                  '</body></html>';

        Messaging.InboundEmail email4 = new Messaging.InboundEmail();
        email4.subject = 'New CASEpeer + MDs Demo Request for Oasis Attorney';
        email4.plainTextBody = '*Select your business type:*Attorney*\r\nName:Jane Doe\r\nEmail: jane.doe@example.com\r\nPhone: 555-5678\r\nAddress: 456 Elm St, Arizona\r\nState:Arizona\r\nCompany: LawCo\r\nAdditional Info: Looking for demo\r\nSource: Referral';
        email4.htmlBody = '<html><body>' +
                  '<p><strong>Select your business type:</strong> Attorney</p>' +
                  '<p><strong>Name:</strong> Jane Doe</p>' +
                  '<p><strong>Email:</strong> jane.doe@example.com</p>' +
                  '<p><strong>Phone:</strong> 555-5678</p>' +
                  '<p><strong>Address:</strong> 456 Elm St, Arizona</p>' +
                  '<p><strong>State:</strong>Arizona</p>' +
                  '<p><strong>Company:</strong> LawCo</p>' +
                  '<p><strong>Additional Info:</strong> Looking for demo</p>' +
                  '<p><strong>Source:</strong> Referral</p>' +
                  '</body></html>';

        Messaging.InboundEmail email5 = new Messaging.InboundEmail();
        email5.subject = 'New CASEpeer + MDs Demo Request for Oasis Attorney';
        email5.plainTextBody = '*Select your business type:*Attorney*\r\nName:Jane Doe\r\nEmail: jane.doe@example.com\r\nPhone: 555-5678\r\nAddress: 456 Elm St, Oregon\r\nState:Oregon\r\nCompany: LawCo\r\nAdditional Info: Looking for demo\r\nSource: Referral';
        email5.htmlBody = '<html><body>' +
                '<p><strong>Select your business type:</strong> Attorney</p>' +
                '<p><strong>Name:</strong> Jane Doe</p>' +
                '<p><strong>Email:</strong> jane.doe@example.com</p>' +
                '<p><strong>Phone:</strong> 555-5678</p>' +
                '<p><strong>Address:</strong> 456 Elm St, Arizona</p>' +
                '<p><strong>State:</strong>Oregon</p>' +
                '<p><strong>Company:</strong> LawCo</p>' +
                '<p><strong>Additional Info:</strong> Looking for demo</p>' +
                '<p><strong>Source:</strong> Referral</p>' +
                '</body></html>';

        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = 'noreply@example.com';

        // Create an instance of the email handler
        XVA_EmailToTask emailHandler = new XVA_EmailToTask();

        // Simulate handling the email
        Test.startTest();
        Messaging.InboundEmailResult result = callHandleCASEPeerForm(email, envelope);
        Messaging.InboundEmailResult result1 = callHandleCASEPeerForm(email1, envelope);
        Messaging.InboundEmailResult result2 = callHandleCASEPeerForm(email2, envelope);
        Messaging.InboundEmailResult result3 = callHandleCASEPeerForm(email3, envelope);
        Messaging.InboundEmailResult result4 = callHandleCASEPeerForm(email4, envelope);
        Messaging.InboundEmailResult result5 = callHandleCASEPeerForm(email5, envelope);
        Test.stopTest();

        // Verify the tasks were created
        List<Task> tasks = [SELECT Id, Subject, Description, Owner.Email, Oasis_Type__c, Oasis_Sub_Type__c, ActivityDate, ReminderDateTime FROM Task];
        System.assertEquals(6, tasks.size(), '6 tasks should have been created');

    }
        */

    @isTest
    static void testExceptionTrio() {
        // Create the mock email for CASEPeer demo
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'New CASEpeer + MDs Demo Request for Oasis Attorney';
        email.plainTextBody = '*Select your business type:*Attorney* Name:Jane Doe Email: jane.doe@example.com Phone: 555-5678 Address: 456 Elm St, Texas Company: LawCo Additional Info: Looking for demo Source: trio-providers Referral';
        email.htmlBody = '<html><body>' +
                 '<p><strong>Select your business type:</strong> Attorney</p>' +
                 '<p><strong>Name:</strong> Jane Doe</p>' +
                 '<p><strong>Email:</strong> jane.doe@example.com</p>' +
                 '<p><strong>Phone:</strong> 555-5678</p>' +
                 '<p><strong>Address:</strong> 456 Elm St, Texas</p>' +
                 '<p><strong>Company:</strong> LawCo</p>' +
                 '<p><strong>Additional Info:</strong> Looking for demo</p>' +
                 '<p><strong>Source:</strong> trio-providers Referral</p>' +
                 '</body></html>';

        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = 'noreply@example.com';

        // Create an instance of the email handler
        XVA_EmailToTask emailHandler = new XVA_EmailToTask();

        // Simulate handling the email
        Test.startTest();
        Messaging.InboundEmailResult result = callHandleCASEPeerForm(email, envelope);
        
        Test.stopTest();

        // Verify the tasks were created
        List<Task> tasks = [SELECT Id, Subject, Description, Owner.Email, Oasis_Type__c, Oasis_Sub_Type__c, ActivityDate, ReminderDateTime FROM Task];
        System.assertEquals(0, tasks.size(), '0 tasks should have been created');

    }

        @isTest
    static void testUpdateFormat() {
        // Create the mock email for CASEPeer demo
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'New submission from Schedule a Demo on MoveDocs website';
        email.plainTextBody = 'Name: Paige Burks Email: pburks@dh-law.com Phone: 816-891-9990 State: Missouri Company: Dougherty & Holloway, LLC Select your business type:: Law Firm How did you hear about MoveDocs?: Email from MoveDocs Source: Request a Demo HandL ( utm_source ): F-B_Moving to Existing MD Rep_Trio Oct Launch HandL ( utm_medium ): email HandL ( utm_campaign ): f17ba2bb69-EMAIL_CAMPAIGN_2025_08_12_03_31_COPY_01';       
        
        email.htmlBody = 'Name: Paige Burks' +
        'Email: pburks@dh-law.com' +
        'Phone: 816-891-9990' +
        'State: Missouri' +
        'Company: Dougherty & Holloway, LLC' +
        'Select your business type:: Law Firm' +
        'How did you hear about MoveDocs?: Email from MoveDocs' +
        'Source: Request a Demo' +
        'HandL ( utm_source ): F-B_Moving to Existing MD Rep_Trio Oct Launch' +
        'HandL ( utm_medium ): email' +
        'HandL ( utm_campaign ): f17ba2bb69-EMAIL_CAMPAIGN_2025_08_12_03_31_COPY_01;';

        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = 'noreply@example.com';

        // Create an instance of the email handler
        XVA_EmailToTask emailHandler = new XVA_EmailToTask();

        
        // Simulate handling the email
        Test.startTest();
        Messaging.InboundEmailResult result = emailHandler.handleInboundEmail(email, envelope);
        
        Test.stopTest();

        // Verify the tasks were created
        List<Task> tasks = [SELECT Id, Subject, Description, Owner.Email, Oasis_Type__c, Oasis_Sub_Type__c, ActivityDate, ReminderDateTime FROM Task];
        //System.assertEquals(0, tasks.size(), '0 tasks should have been created');

    }
}