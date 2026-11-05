global class UpdateRecordsBatch implements Database.Batchable<sObject> {
   
   String query1 = null;
   
   public UpdateRecordsBatch(String s)
   {
      this.query1 = s;
   }
   
    global Database.QueryLocator start(Database.BatchableContext BC){
    
        String query = 'select id ,name,Region__c,GMSA__c,billingstate,BillingPostalCode,OwnerId, Type,'+
                        ' Atticus__c,Core__c,GRS__c,PreSet__c'+
                        ' from Account where HeadQuarter__c=false';
        if(query1!=null) query= this.query1;
       
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Account> accList){
    
        Set<String> stateString = new Set<String>();
        Set<String> zipCodeString = new Set<String>();
        
        Map<String, Region_Territory__c> mapOfStateAndRegion = new Map<String, Region_Territory__c>();
        Map<String, Region_Territory__c> mapOfZipCodeAndRegion = new Map<String, Region_Territory__c>();

              for(Region_Territory__c region : [Select id, GMSA__c, Region__c, State__c, Territory__c, Zip_Code__c,GMSA_Name__c ,MLRep_UserID__c 
                                               from Region_Territory__c ])
               {
                                               
                    mapOfStateAndRegion.put(region.State__c, region);
                    mapOfZipCodeAndRegion.put(region.Zip_Code__c, region);
                }
                
                

   for(Account acc : accList){
                    if(mapOfStateAndRegion.containskey(acc.billingstate)){
                    
                      
                        acc.Region__c = mapOfStateAndRegion.get(acc.billingstate).Region__c;
                        
                    
                        
                    }
                    String zip = acc.billingpostalcode;
                    if(String.IsNotBlank(zip))
                    {
                       zip = (zip.length()>5 )? zip.left(5) : zip;
                    }
                    if(mapOfZipCodeAndRegion.containskey(zip)){
                        acc.GMSA__c = mapOfZipCodeAndRegion.get(zip).GMSA_Name__c;
                    
                        if( mapOfZipCodeAndRegion.get(zip).MLRep_UserID__c!=null){
                        
                        //Assignment Criteria: Only Vendor/Vendor Location, 
                        //2. For LawFirm. If ML flags are up, assign it
                        
                        if(acc.Type.contains('Vendor') || (acc.Type.contains('LawFirm') && (acc.Atticus__c==true || acc.Core__c==true || acc.GRS__c==true))){ 
                            acc.OwnerId = mapOfZipCodeAndRegion.get(zip).MLRep_UserID__c;
                        }
                            
                            
                            
                        }
                    }
                }
                

Database.saveResult[] rslt=Database.update(accList, false);
     for(Database.saveResult r: rslt){
       if(r.isSuccess()){
             System.debug(r.getId());
       }
       else{
             for(Database.Error err : r.getErrors()){
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Contact fields that affected this error: ' + err.getFields());
                    }
           }
    
    }
    
    

 }
   
    global void finish(Database.BatchableContext BC){
        
        
    }
}