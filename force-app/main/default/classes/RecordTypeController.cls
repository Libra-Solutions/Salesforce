/**
  * @Created Date 04/24/2019
  * @author    OASISFINANCIAL GROUP
  * @copyright Copyright (c) 2019-2020 
  * @license   
  * @Modified Date  
  * @Description 
*/
public class RecordTypeController {
   public static Map<Id, String> recordtypemap {get;set;}
     
    /**
      * Fetch record type label.
      * @param string selectedValue
      * @return String.
      * @exception Exception On input error.
      * @see 
     */ 
    @AuraEnabled        
    public static String fetchRecordTypeLabel(string selectedValue){
        system.debug('====selectedValue==>'+selectedValue);   
        string recordTypeName = '';  
        
        if(selectedValue == 'Auto') {
            recordTypeName = 'PS-QuickAdd-Auto' ;
        }else if(selectedValue == 'Other') {            
            recordTypeName =  'PS-QuickAdd-Other';  
        }else if(selectedValue == '--Select--') {            
            recordTypeName =  'blank';  
        }else{ 
            recordTypeName = 'PS-QuickAdd-WC';
        }         
        return recordTypeName ;
    } 
    
    /**
      * Get the contact details.
      * @param Id conIds
      * @return Contact.
      * @exception Exception On input error.
      * @see 
     */
    @AuraEnabled
    public static Contact getContactdetails(Id conIds){  
        system.debug('===conIds==>'+conIds);  
        List<Contact> contactRecList = [Select id, FirstName, Lastname, accountid from Contact where Id = :conIds];        
        if(contactRecList!=null && contactRecList.size()>0)
        {
            return contactRecList[0];
        }
        return null;
    }
    
    @AuraEnabled
    public static boolean doDisableNextButton(Id conIds){  
              System.debug('1111111 ' + conIds);
        List<Account_Relation__c> accRelationList = [Select id from Account_Relation__c where Role__c='Attorney' and  PresetID__c != null and Contact__c = :conIds] ;
        system.debug('----------------accrel-----------'+accRelationList);
        if(accRelationList!=null && accRelationList.size()>0)
         {
                return false;
        } else 
        {
            return true;
        }
        //return contactRec;
    }
    
    /**
      * Get the record type Id.
      * @param String recordTypeLabel
      * @return Id.   
      * @exception Exception On input error.
      * @see 
     */      
    @AuraEnabled
    public static String getRecTypeId(String recordTypeLabel){
       system.debug('==recordTypeLabel==>'+recordTypeLabel);
       if(recordTypeLabel == 'blank'){    
           return 'Please select any value';       
       }else if(recordTypeLabel!=null){
       		Id recid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
       		return recid;   
       }
       return 'Please select any value';       
       
    }      
}