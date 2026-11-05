public with sharing class XVA_TestDataFactory {
    public Account TestAccount {get; set;}
    public Contact TestContact {get; set;}

    public XVA_TestDataFactory() {

        TestAccount = createTestAccountDefaults();
        insert TestAccount;

        TestContact = createTestContactDefaults(TestAccount.Id);
        insert TestContact;
    }

    public Account createTestAccountDefaults() {
        Account newTestAccount = new Account();
        newTestAccount.Name = 'Test Account';

        return newTestAccount;
    }

    public Contact createTestContactDefaults() 
    {
        Contact newTestContact = new Contact();
        newTestContact.FirstName = 'Test';
        newTestContact.LastName = 'Contact';
        return newTestContact;
    }

    public Contact createTestContactDefaults(Id accountId) 
    {
        Contact newTestContact = createTestContactDefaults();
        newTestContact.AccountId = accountId;
        return newTestContact;
    }

    public void createTestDocumentAndContentDocumentLink(Id relatedToId) 
    {
        ContentVersion cv = new ContentVersion(
            Title = 'Test Document',
            PathOnClient = 'test.txt',
            VersionData = Blob.valueOf('Test Content'), 
            IsMajorVersion = true
        );
        insert cv;
        cv = [SELECT Id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
        
        ContentDocumentLink cdl = new ContentDocumentLink(
            ContentDocumentId = cv.ContentDocumentId,
            LinkedEntityId = relatedToId,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );

        insert cdl;
    }

    public void createTestNoteAndContentDocumentLink(Id relatedToId) {
        ContentNote cn = new ContentNote();
            cn.Title = 'Test Note';
            String body =  'Test Note Body';
            cn.Content = Blob.valueOf(body.escapeHTML4());
            insert cn;
            
            
            ContentDocumentLink newCD = new ContentDocumentLink();
            newCD.ContentDocumentId = cn.id;
            newCD.LinkedEntityId = relatedToId;
            newCD.ShareType = 'V';
            newCD.Visibility = 'AllUsers';
            insert newCD;
    }
}