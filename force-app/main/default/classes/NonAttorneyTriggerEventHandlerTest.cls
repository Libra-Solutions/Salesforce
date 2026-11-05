@isTest
public class NonAttorneyTriggerEventHandlerTest{
 /*
 @testsetup static void Setup(){
   Account acc = UtiityHelperClass.createAccount();
        
   Contact con = UtiityHelperClass.createContact(acc.Id);
   Non_Attorney_Contact__c nonAtt = new Non_Attorney_Contact__c(Firm_Name__c = acc.Id, Attorney__c = con.Id,GRSId__c = 7890);
       
        insert nonAtt;
 }
 *

    
    static testMethod void testNonAttData(){   
    
        Account acc = UtiityHelperClass.createAccount();
        
        Contact con = UtiityHelperClass.createContact(acc.Id);
        
        List<Non_Attorney_Contact__c> oldlst = [Select Firm_Name__c,Attorney__c, GRSId__c from  Non_Attorney_Contact__c];
        Map<Id, Non_Attorney_Contact__c> olMp;
        for(Non_Attorney_Contact__c nonAttr :oldlst){
          olMp = new Map<Id, Non_Attorney_Contact__c>();
         olMp.put(nonAttr.Id, nonAttr);
        }
        Non_Attorney_Contact__c nonAtt = new Non_Attorney_Contact__c(Firm_Name__c = acc.Id, Attorney__c = con.Id,GRSId__c = 1234);
        List<Non_Attorney_Contact__c> newlst = new List<Non_Attorney_Contact__c>();
        newlst.add(nonAtt);
        insert newlst;
        Map<Id, Non_Attorney_Contact__c> nwMp;
        for(Non_Attorney_Contact__c nonAttr1 :newlst){
         nwMp = new Map<Id, Non_Attorney_Contact__c>();
         nwMp.put(nonAttr1.Id, nonAttr1);
        }
        
        try{
            NonAttorneyTriggerEventHandler.afterUpdate(newlst,oldlst,nwMp,olMp );

        }
        catch(Exception e){
        
            Boolean expectedExceptionThrown =  e.getMessage().contains('The selected Attorney/Provider Contact is') ? true : false;
            
            System.AssertEquals(expectedExceptionThrown, true);
        
        } 
    }
    
    
    */
    

}