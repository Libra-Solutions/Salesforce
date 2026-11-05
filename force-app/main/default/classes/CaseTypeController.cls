/**
  * @Created Date 04/24/2019
  * @author    OASISFINANCIAL GROUP
  * @copyright Copyright (c) 2019-2020 
  * @license   
  * @Modified Date
  * @Description 
*/
public class CaseTypeController {
    /**
     * This method is fetching the opportunity record type.
     * @param List<Account>, Map<Id, Account>
     * @return Id.
     * @exception Exception On input error.
     * @see 
    */
    @AuraEnabled        
    //Get Record Type ID
    public static Id getOpptyRecordTypeID(string selectedValue) {
        
        string recordTypeName = '';
        if(selectedValue.contains('Auto')) {
            recordTypeName = 'PS-QuickAdd-Auto' ;
        } else if(selectedValue.contains('Other')) {
            system.debug('selectedValue---'+selectedValue);
            recordTypeName = 'PS-QuickAdd-Other';
        } else {
            recordTypeName = 'PS-QuickAdd-WC';
        }
        system.debug('recordTypeName ---'+recordTypeName);
        Id opptyRTID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('PS-QuickAdd-Other').getRecordTypeId();
        system.debug('opptyRTID --'+opptyRTID );
        return opptyRTID ;
    } 
}