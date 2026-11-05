public class NonAttorneyController{
     
    /**
     * Get pick values
     * @param String objectName, String fieldName
     * @return Map<String, List<String>>
     * @exception Exception On input error.
     * @see 
    */ 
    @AuraEnabled
    public static Map<String, List<String>> getPickValues(String objectName, String fieldName) {      
        List<String> fieldNames = fieldName.split(',');
        
        Map<String, List<String>> nameToValueMap = new Map<String, List<String>>();
        for(String s : fieldNames){
            Schema.sObjectType sobject_type = Schema.getGlobalDescribe().get(objectName); //grab the sobject that was passed
            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
            List<Schema.PicklistEntry> pick_list_values = field_map.get(s).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
            List<String> options = new List<String>(); //new list for holding all of the picklist options
            for(Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list       
                options.add(a.getValue()); //add the value and label to our final list
            }
            nameToValueMap.put(s, options);
        }
            return nameToValueMap; //return the List
    }  
    
    /**
     * Save records
     * @param String contactRecord,String recordId
     * @return Boolean 
     * @exception Exception On input error.
     * @see 
    */
    @AuraEnabled
    public static Boolean saveReocrds(String contactRecord,String recordId){
          Boolean isEmail=false;
          contact con=(Contact)JSON.deserialize(contactRecord, Contact.class);
          System.debug('EMail ====== ' + con.email);
          if(con.email!=null){
              List<Contact> lstOfCon=[select id from contact where email=:con.email];
              
              if(lstOfCon.size()>0){
                  isEmail=true;
              }
          }
          
          if(isEmail==false){
              insert con;
               contact conParent=[select id,accountid from contact where id =:recordId];
               Non_Attorney_Contact__c na = new Non_Attorney_Contact__c();  
               na.Contact__c = con.Id;
               na.Attorney__c = recordId;
               na.Firm_Name__c = conParent.accountid;                   
               na.Role__c = con.Role__c;
               insert na;
               
             
          }
         return isEmail;
    } 
}