@isTest
public class UserTriggerHandlerTest {

    @isTest static void UserCreate() { 
        
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        List<User> uuList = new List<User>();
        User uu=new User(firstname = 'ABCSSSSS', 
        lastName = 'XYZzzzzz', 
        email = 'testdataagainzzz@gmail.com', 
        Username = 'testAgainData@gmail.com', 
        EmailEncodingKey = 'ISO-8859-1', 
        Alias = 'testAzz', 
        TimeZoneSidKey = 'America/Los_Angeles', 
        LocaleSidKey = 'en_US', 
        LanguageLocaleKey = 'en_US', 
        ProfileId = pf.Id); 
        uuList.add(uu);
        
        
        Test.startTest();
        	UserTriggerHandler.sendEmail(uuList);
        	insert uu;
        Test.stopTest();
    
    } 
}