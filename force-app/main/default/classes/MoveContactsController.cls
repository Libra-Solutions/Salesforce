global class MoveContactsController {  
   @InvocableMethod
   public static void Contacts(List<Inputs> request) {
             
       System.debug('From Contact Id'+request[0].FromContactsfid);
       System.debug('ToLocation Id'+request[0].ToLocationsfid);
       Account_Relation__c Attorney = [SELECT Id, PresetID__c from Account_Relation__c where Contact__c = :request[0].FromContactsfid LIMIT 1];
       Account Acc = [SELECT Id, OS_Firm_Location_Id__c from Account where Id = :request[0].ToLocationsfid];
       System.debug('From preset'+Attorney.PresetID__c);
       System.debug('To location' +Acc.OS_Firm_Location_Id__c);
       List<String> lstOfContacts=new List<String>();
       lstOfContacts.add('MoveAttorney');
       lstOfContacts.add(Attorney.PresetID__c+'');
       lstOfContacts.add(Acc.OS_Firm_Location_Id__c+'');
       lstOfContacts.add(Acc.OS_Firm_Location_Id__c+'');
       
       System.enqueueJob(new PresetServerMoveAttorneyQueuebleJob (lstOfContacts));
   }
       //input details that comes to apex from flow
    public class Inputs{
    
        @InvocableVariable
        public String ToLocationsfid;
        @InvocableVariable
        public String FromContactsfid;
    }

}