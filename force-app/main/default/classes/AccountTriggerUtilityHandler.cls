/**********************************************************
    *@author             :
    *@Version            : V 1.0
    *@Description        : 
    *@Test class         :
    **********************************************************/
Public class AccountTriggerUtilityHandler {
    
     /**
     * This method is updating the region.
     * @param List<Account>, Map<Id, Account>
     * @return Nothing.
     * @exception Exception On input error.
     * @see 
    */
    public static void updateRegion(List<Account> accList) {
        Set<String> stateString = new Set<String>();
        Set<String> zipCodeString = new Set<String>();
        
        Map<String, Region_Territory__c> mapOfStateAndRegion = new Map<String, Region_Territory__c>();
        Map<String, Region_Territory__c> mapOfZipCodeAndRegion = new Map<String, Region_Territory__c>();
        
        for(Account acc: accList){
        
        if(acc.HeadQuarter__c ==false){
            if(acc.billingstate != null){
                stateString.add(acc.billingstate);
            }
            if(acc.billingpostalcode != null){
                zipCodeString.add(acc.billingpostalcode);
            }
          }
            system.debug('===stateString===>'+stateString);
            system.debug('===zipCodeString===>'+zipCodeString);
        }
          
        if(stateString.size()>0 || zipCodeString.size()>0)
        {
     
            //list<Region_Territory__c> region2 = [Select id, GMSA__c, Region__c, State__c, Territory__c, Zip_Code__c,GMSA_Name__c,MLRep_UserID__c from Region_Territory__c];
            //system.debug('==region2===>'+region2);    
     
                for(Region_Territory__c region : [Select id, GMSA__c, Region__c, State__c, Territory__c, Zip_Code__c,GMSA_Name__c,MLRep_UserID__c from Region_Territory__c where State__c IN :stateString OR Zip_Code__c IN :zipCodeString]){
                    mapOfStateAndRegion.put(region.State__c, region);
                    mapOfZipCodeAndRegion.put(region.Zip_Code__c, region);
                    system.debug('===mapOfStateAndRegion===>'+mapOfStateAndRegion);
                    system.debug('===mapOfZipCodeAndRegion===>'+mapOfZipCodeAndRegion);
                }
                
                
                for(Account acc : accList){
                    if(mapOfStateAndRegion.containskey(acc.billingstate)){
                        acc.Region__c = mapOfStateAndRegion.get(acc.billingstate).Region__c;
                        acc.Territory__c = mapOfStateAndRegion.get(acc.billingstate).Territory__c;
                        
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
                        if(acc.Type!=null){
                        if(acc.Type.contains('Vendor') || (acc.Type.contains('LawFirm') && (acc.Atticus__c==true || acc.Core__c==true || acc.GRS__c==true))){ 
                            acc.OwnerId = mapOfZipCodeAndRegion.get(zip).MLRep_UserID__c;
                        }
                        }
                      }
                    }
                }
      }
    
    }
    
    /**
     * This method is updating the region.
     * @param List<Account>, Map<Id, Account>
     * @return Nothing.
     * @exception Exception On input error.
     * @see 
    */
    public static void updateRegion(List<Account> accList,  Map<Id, Account> oldMap) {
        System.debug('MAP VALUES ===== '+oldMap.keySet());
        Set<String> stateString = new Set<String>();
        Set<String> zipCodeString = new Set<String>();
        
        Map<String, Region_Territory__c> mapOfStateAndRegion = new Map<String, Region_Territory__c>();
        Map<String, Region_Territory__c> mapOfZipCodeAndRegion = new Map<String, Region_Territory__c>();
        
        for(Account acc: accList){
        
        if(acc.HeadQuarter__c ==false){
            if(acc.billingstate != oldMap.get(acc.id).billingstate){
                stateString.add(acc.billingstate);
            }
            if(acc.billingpostalcode != oldMap.get(acc.id).billingpostalcode){
                zipCodeString.add(acc.billingpostalcode);
            }
          }
            system.debug('===stateString===>'+stateString);
            system.debug('===zipCodeString===>'+zipCodeString);
        }
        if(stateString.size()>0 || zipCodeString.size()>0)
        {
      
        //list<Region_Territory__c> region1 = [Select id, GMSA__c, Region__c, State__c,MLRep_UserID__c, Territory__c, Zip_Code__c,GMSA_Name__c from Region_Territory__c];
        //system.debug('==region1===>'+region1);      
      
      
                for(Region_Territory__c region : [Select id, GMSA__c, Region__c,MLRep_UserID__c, State__c, Territory__c, Zip_Code__c,GMSA_Name__c from Region_Territory__c where State__c IN :stateString OR Zip_Code__c IN :zipCodeString]){
                    mapOfStateAndRegion.put(region.State__c, region);
                    mapOfZipCodeAndRegion.put(region.Zip_Code__c, region);
                    system.debug('===mapOfStateAndRegion===>'+mapOfStateAndRegion);
                    system.debug('===mapOfZipCodeAndRegion===>'+mapOfZipCodeAndRegion);
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
                

      }
    
    }
    /*
    public static void updateAccountName(List<Account> accList) {
        
       
        for(Account acc : accList){
            system.debug('======>'+acc.name.contains('HQ'));
            if(acc.HeadQuarter__c == true && acc.name.contains('HQ')){
               
                    acc.name = acc.name;
            }else{
                
                acc.name = acc.name+'-'+'HQ';
            }
        }
    }*/
    
    /**
     * This method is sending the list of account to cashtrax/ML from salesforce.
     * @param List<Account>.
     * @return Nothing.
     * @exception Exception On input error.
     * @see 
    */
    public static void sendToBackEndSystems(Account acc, Map<Id, Account> oldMap) {
        
       
        
        system.debug('-------------trigger CashtraxEntities.UpdatedByCashtrax -----------------'+CashtraxEntities.UpdatedByCashtrax);
        system.debug('-------------trigger MedlienSalesforceService.OpportunityContractedFlag--------'+MedlienSalesforceService.OpportunityContractedFlag);
        system.debug('-------------trigger CashTraxEntities.UpdateComingFromLeadConversion--------'+CashTraxEntities.UpdateComingFromLeadConversion);
       
            
            //If external Ids changing, dont fire update
            if(!(acc.AtticusID__c != oldMap.get(acc.id).AtticusID__c ||  acc.GRSId__c != oldMap.get(acc.id).GRSId__c || acc.CTXFirmId__c!= oldMap.get(acc.id).CTXFirmId__c|| 
                            acc.KeyMedsId__c != oldMap.get(acc.id).KeyMedsId__c || (CashTraxEntities.UpdateComingFromLeadConversion==true) ))
            {
            /* Removing calls to the Medlien API lines 194 - 262    
            //fire only for HQ update or Opp contracted scenario 
               if(acc.HeadQuarter__c==true){ 
                 if((Utility.IsNonZero(String.valueOf(acc.GRSId__c)) ||  Utility.IsNonZero(String.valueOf(acc.KeyMedsID__c)) ||  Utility.IsNonZero(acc.AtticusId__c)) 
                    )// || MedlienSalesforceService.OpportunityContractedFlag ==true
                     {
                        
                        //if flags changing, we need to update firm location too, to handle seq issue
                        if(acc.Atticus__c != oldMap.get(acc.id).Atticus__c ||  acc.GRS__c != oldMap.get(acc.id).GRS__c ||  
                            acc.Core__c != oldMap.get(acc.id).Core__c || acc.Accident_Meds__c != oldMap.get(acc.id).Accident_Meds__c )  
                        {
                           system.debug('----------HQ update with Flag chaging as true --------------');
                           CashtraxEntities.ParentLOBChanged = true;
                           MedlienSalesforceToSystemsController.UpdateFirmML(acc.Id, true);
                        }
                        else
                        {
                              //if specific fields changed , then fire
                           if(acc.name != oldMap.get(acc.id).name || acc.billingstreet != oldMap.get(acc.id).billingstreet || acc.billingcity != oldMap.get(acc.id).billingcity || acc.Street2__c != oldMap.get(acc.id).Street2__c ||
                            acc.billingstate != oldMap.get(acc.id).billingstate || acc.billingpostalcode != oldMap.get(acc.id).billingpostalcode || acc.Phone != oldMap.get(acc.id).Phone || 
                            acc.fax != oldMap.get(acc.id).fax )
                            {
                         
                              system.debug('----------HQ update with Flag chaging as false --------------');
                              MedlienSalesforceToSystemsController.UpdateFirmML(acc.Id,false);
                            }
                        }
                       
                    
                     }
               }
               else //Location
               {    
                
                    if((Utility.IsNonZero(String.valueOf(acc.GRSId__c)) ||  Utility.IsNonZero(String.valueOf(acc.KeyMedsID__c)) ||  Utility.IsNonZero(acc.AtticusId__c))
                    )// || MedlienSalesforceService.OpportunityContractedFlag ==true
                    {
                    
                    
                         //if loc flags changing and parent is also new
                        if((acc.Atticus__c != oldMap.get(acc.id).Atticus__c ||  acc.GRS__c != oldMap.get(acc.id).GRS__c || acc.PreSet__c != oldMap.get(acc.id).Preset__c || 
                            acc.Core__c != oldMap.get(acc.id).Core__c || acc.Accident_Meds__c != oldMap.get(acc.id).Accident_Meds__c )
                            )
                        {
                          
                           if(CashtraxEntities.ParentLOBChanged == false)   { 
                               system.debug('----------loc update with Flag chaging as false--------------');
                               MedlienSalesforceToSystemsController.UpdateFirmML(acc.Id, false);
                            }
                                   
                                   
                                   
                        }
                        else
                        {
            
                            //if specific fields changed , then fire
                           if(acc.name != oldMap.get(acc.id).name || acc.billingstreet != oldMap.get(acc.id).billingstreet || acc.billingcity != oldMap.get(acc.id).billingcity || acc.Street2__c != oldMap.get(acc.id).Street2__c ||
                            acc.billingstate != oldMap.get(acc.id).billingstate || acc.billingpostalcode != oldMap.get(acc.id).billingpostalcode || acc.Phone != oldMap.get(acc.id).Phone || 
                            acc.fax != oldMap.get(acc.id).fax )
                            {
                         
                                system.debug('----------loc general --------------');
                                MedlienSalesforceToSystemsController.UpdateFirmML(acc.Id, false);
                            }
                        }
                        
                    
                    } 
               } */
               
        
                //Do not call if updated by CTX itself  ; 
                if(Utility.IsNonZero(acc.CTXFirmId__c) && CashtraxEntities.UpdatedByCashtrax == false && acc.Type=='LawFirm' && !Test.isRunningTest()){
                    PresetSalesforceToCasthraxController.UpdateFirmCTX(acc.Id);
                }
          }

    }
    
    
}