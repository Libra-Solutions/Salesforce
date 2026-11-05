@isTest
private class AutocreatedRegHandler1555013408562Test {
    static testMethod void testCreateAndUpdateUser() {
        
        Profile pf= [Select Id from profile where Name='Standard User']; 
        User uu=new User(firstname = 'testFirstone', 
                         lastName = 'testLastone', 
                         email = 'testuse8881r@example.org', 
                         Username = 'testuse8881r@example.org', 
                        
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'tester11', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        
        // create user
        insert uu;
        
        
        AutocreatedRegHandler1555013408562 handler = new AutocreatedRegHandler1555013408562();
        Auth.UserData sampleData = new Auth.UserData('testId2', 'testFirstTwo', 'testLastTwo',
                                                     'testFirstTwo testLastTwo', 'testuse8888rtwo@example.org', null, 'testuse8888rtwo@example.org', 'en_US', 'facebook',
                                                     null, new Map<String, String>{'language' => 'en_US'});
        
        try{
            User u = handler.createUser(null, sampleData);
            
            sampleData = new Auth.UserData('testId2', 'testNewFirstThree', 'testNewLastThree',
                                           'testNewFirstThree testNewLastThree', 'testnewuser3Three@example.org', null, 'testnewuserThree', 'en_US', 'facebook',
                                           null, new Map<String, String>{});
            handler.updateUser(null, null, sampleData);
        }
        
        catch(Exception e){
            
        }      
    }
}