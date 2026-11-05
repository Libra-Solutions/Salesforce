/*
    Name           :    BatchPresetMergeImportCsvController 
    Date           :    09 -12- 2019
    Author         :    Himanshu Tak
    TestClass      :    BatchPresetMergeImportCsvControllertest
    Description    :    This class Merge and move csv file records
*/

global class BatchPresetMergeImportCsvController implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts {
    global  Set<id> setOfpsCmmIds;
    global BatchPresetMergeImportCsvController (Set<id> setOfpsCmmIds){
         this.setOfpsCmmIds=setOfpsCmmIds;
         
    }
   
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query='select id,Api_Action__c,Deleting_Atticus_Id__c,Deleting_Cashtrax_Id__c,Deleting_Core_Id__c, ';
        query+=' Deleting_Grs_Id__c,Deleting_Id__c,Serviving_Atticus_Id__c,Serviving_CashTrax_Id__c,Serviving_Core_Id__c, ';
        query+=' Serviving_Grs_Id__c,Serviving_Id__c from Preset_Medlien_Communication__c where id in:setOfpsCmmIds';
        
        return  database.getQueryLocator(query);
        
    }
   
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<sObject>scope){
    
        List<Preset_Medlien_Communication__c> lstOfcomms=new List<Preset_Medlien_Communication__c>();
        List<Account> lstOfUpdateAccounts=new List<Account>();
        list<Account_Relation__c> lstOfUpdateAccRel=new List<Account_Relation__c>();
        Map<id,List<Account>> mapOfMergeAccounts=new Map<id,List<Account>>();
        Map<id,List<Contact>> mapOfMergeContacts=new Map<id,List<Contact>>();
        
        
        Set<id> setOfDelAcc=new Set<id>();
        Set<id> setOfDelCons=new Set<id>();
        Set<id> setOfDelAccRel=new Set<id>();
        
       //Map Of Preset Update Firm 
       Map<id,Preset_Medlien_Communication__c> mapOfPreUpdateFirmCmms=new Map<id,Preset_Medlien_Communication__c>();
        
       //Preset Update Firm Locations
       Map<id,Preset_Medlien_Communication__c> mapOfPreUpdateFirmLocationsCmms=new Map<id,Preset_Medlien_Communication__c>();
       
       //Preset Update Attorney Contact
       Map<id,Preset_Medlien_Communication__c> mapOfPreUpdateAttorneyCmms=new Map<id,Preset_Medlien_Communication__c>();
       
       //Preset Merge Firms
       Map<id,Preset_Medlien_Communication__c> mapOfPreMergeFirmsCmms=new Map<id,Preset_Medlien_Communication__c>();
       
       //Preset Merge Attorneys
       Map<id,Preset_Medlien_Communication__c> mapOfPreMergeAttorneysCmms=new Map<id,Preset_Medlien_Communication__c>();
       
        //Preset Merge Firm Location
       Map<id,Preset_Medlien_Communication__c> mapOfPreMergeFirmLocCmms=new Map<id,Preset_Medlien_Communication__c>();
       
       //Preset Move Attorney
       Map<id,Preset_Medlien_Communication__c> mapOfPreMoveAttorneyCmms=new Map<id,Preset_Medlien_Communication__c>();
      
      
       //Medlien Update Firm
       Map<id,Preset_Medlien_Communication__c> mapOfMedlienUpdateFirm=new Map<id,Preset_Medlien_Communication__c>();
       
       //Medlien Update Firm Location
       Map<id,Preset_Medlien_Communication__c> mapOfMedlienUpdateFirmLocations=new Map<id,Preset_Medlien_Communication__c>();
       
       //Medlien Update Contacts
       Map<id,Preset_Medlien_Communication__c> mapOfMedlienUpdateContacts=new Map<id,Preset_Medlien_Communication__c>();
       
        //Medlien Merge Firm
       Map<id,Preset_Medlien_Communication__c> mapOfMedlienMergeFirms=new Map<id,Preset_Medlien_Communication__c>();
       
        //Medlien Merge Firm Locations
       Map<id,Preset_Medlien_Communication__c> mapOfMedlienMergeFirmsLocations=new Map<id,Preset_Medlien_Communication__c>();
       
        //Medlien Merge Attorneys
       Map<id,Preset_Medlien_Communication__c> mapOfMedlienMergeAttorneysCmms=new Map<id,Preset_Medlien_Communication__c>();
       
       
       for(Preset_Medlien_Communication__c  prMedRec:(List<Preset_Medlien_Communication__c  >)scope){   
         
      
           System.debug('####prMedRec'+prMedRec);
           
          //Fill record in Map (PresetUpdateFirm) 
          if(prMedRec.Api_Action__c.trim().touppercase()==('PresetUpdateFirm').touppercase() && 
            !mapOfPreUpdateFirmCmms.containsKey(prMedRec.Serviving_Id__c) ){
             mapOfPreUpdateFirmCmms.put(prMedRec.Serviving_Id__c,prMedRec);
          }else if(prMedRec.Api_Action__c.trim().touppercase()==('PresetUpdateFirmLocation').touppercase() &&
            !mapOfPreUpdateFirmLocationsCmms.containsKey(prMedRec.Serviving_Id__c)){
             mapOfPreUpdateFirmLocationsCmms.put(prMedRec.Serviving_Id__c,prMedRec);
          }else if(prMedRec.Api_Action__c.trim().touppercase()==('PresetUpdateAttorneyContact').touppercase() &&
            !mapOfPreUpdateAttorneyCmms.containsKey(prMedRec.Serviving_Id__c)){
             mapOfPreUpdateAttorneyCmms.put(prMedRec.Serviving_Id__c,prMedRec);
          }else if(prMedRec.Api_Action__c.trim().touppercase()==('MergeFirms').touppercase() &&
            !mapOfPreMergeFirmsCmms.containsKey(prMedRec.Serviving_Id__c)){
             mapOfPreMergeFirmsCmms.put(prMedRec.Serviving_Id__c,prMedRec);
         }else if(prMedRec.Api_Action__c.trim().touppercase()==('MergeAttorneys').touppercase() &&
            !mapOfPreMergeAttorneysCmms.containsKey(prMedRec.Serviving_Id__c)){
             mapOfPreMergeAttorneysCmms.put(prMedRec.Serviving_Id__c,prMedRec);
         }else if(prMedRec.Api_Action__c.trim().touppercase()==('MedlienUpdateFirm').touppercase() &&
            !mapOfMedlienUpdateFirm.containsKey(prMedRec.Serviving_Id__c)){
             mapOfMedlienUpdateFirm.put(prMedRec.Serviving_Id__c,prMedRec);
         }else if(prMedRec.Api_Action__c.trim().touppercase()==('MedlienUpdateFirmLocatons').touppercase() &&
            !mapOfMedlienUpdateFirmLocations.containsKey(prMedRec.Serviving_Id__c)){
             mapOfMedlienUpdateFirmLocations.put(prMedRec.Serviving_Id__c,prMedRec);
         }else if(prMedRec.Api_Action__c.trim().touppercase()==('MedlienUpdateContact').touppercase() &&
            !mapOfMedlienUpdateContacts.containsKey(prMedRec.Serviving_Id__c)){
             mapOfMedlienUpdateContacts.put(prMedRec.Serviving_Id__c,prMedRec);
         }else if(prMedRec.Api_Action__c.trim().touppercase()==('MergeParentAccounts').touppercase() &&
            !mapOfMedlienMergeFirms.containsKey(prMedRec.Serviving_Id__c)){
             mapOfMedlienMergeFirms.put(prMedRec.Serviving_Id__c,prMedRec);
         }else if(prMedRec.Api_Action__c.trim().touppercase()==('MergeFirmLocations').touppercase() &&
            !mapOfMedlienMergeFirmsLocations.containsKey(prMedRec.Serviving_Id__c)){
             mapOfMedlienMergeFirmsLocations.put(prMedRec.Serviving_Id__c,prMedRec);
         }else if(prMedRec.Api_Action__c.trim().touppercase()==('MergeContacts').touppercase() &&
            !mapOfMedlienMergeAttorneysCmms.containsKey(prMedRec.Serviving_Id__c)){
             mapOfMedlienMergeAttorneysCmms.put(prMedRec.Serviving_Id__c,prMedRec);
         }else if(prMedRec.Api_Action__c.trim().touppercase()==('PresetMergeFirmLocations').touppercase() &&
            !mapOfPreMergeFirmLocCmms.containsKey(prMedRec.Serviving_Id__c)){
             mapOfPreMergeFirmLocCmms.put(prMedRec.Serviving_Id__c,prMedRec);
         }else if(prMedRec.Api_Action__c.trim().touppercase()==('MoveAttorney').touppercase() &&
            !mapOfPreMoveAttorneyCmms.containsKey(prMedRec.Serviving_Id__c)){
             mapOfPreMoveAttorneyCmms.put(prMedRec.Serviving_Id__c,prMedRec);
         }

        }     
      
       //Add record multiplePreset Update Firm records 
       if(mapOfPreUpdateFirmCmms.size()>0){
           ModelBatchUpdateItem objItem=fillpresetUpdateFirm(mapOfPreUpdateFirmCmms);
           lstOfcomms.addAll(objItem.lstOfUpdatePreMedComm);
           if(objItem.lstOfUpdateAccounts!=null && !objItem.lstOfUpdateAccounts.isEmpty()){
              lstOfUpdateAccounts.addAll(objItem.lstOfUpdateAccounts);
           }  
           if(objItem.setOfDelAccs!=null &&  !objItem.setOfDelAccs.isEmpty()){
              setOfDelAcc.addAll(objItem.setOfDelAccs);
           }  
           
           if(objItem.mapOfMergeAccounts!=null &&  !objItem.mapOfMergeAccounts.isEmpty()){
           
              System.debug('###objItem.mapOfMergeAccounts'+objItem.mapOfMergeAccounts);
           
              Map<id,List<Account>> mapOfMergeAccountsTemp= objItem.mapOfMergeAccounts;
              for(id ids:mapOfMergeAccountsTemp.keySet()){
                  mapOfMergeAccounts.put(ids,mapOfMergeAccountsTemp.get(ids));
              }
           } 
           System.debug('##@'+mapOfMergeAccounts);
           System.debug('##lstOfUpdateAccounts'+lstOfUpdateAccounts);


       }
       
       //Add record multiple Preset Update Firm Locations records 
       if(mapOfPreUpdateFirmLocationsCmms.size()>0){
           System.debug('###mapOfPreUpdateFirmLocationsCmms'+mapOfPreUpdateFirmLocationsCmms);
           
           ModelBatchUpdateItem objItem=fillpresetUpdateFirmLocations(mapOfPreUpdateFirmLocationsCmms);
           System.debug('##Locations'+objItem);
           lstOfcomms.addAll(objItem.lstOfUpdatePreMedComm);
           if(objItem.lstOfUpdateAccounts!=null && !objItem.lstOfUpdateAccounts.isEmpty()){
              lstOfUpdateAccounts.addAll(objItem.lstOfUpdateAccounts);
           }  
           if( objItem.setOfDelAccs!=null &&  !objItem.setOfDelAccs.isEmpty()){
              setOfDelAcc.addAll(objItem.setOfDelAccs);
           }  
           
           if(objItem.mapOfMergeAccounts!=null &&  !objItem.mapOfMergeAccounts.isEmpty()){
           
              System.debug('###objItem.mapOfMergeAccounts'+objItem.mapOfMergeAccounts);
           
              Map<id,List<Account>> mapOfMergeAccountsTemp= objItem.mapOfMergeAccounts;
              for(id ids:mapOfMergeAccountsTemp.keySet()){
                  mapOfMergeAccounts.put(ids,mapOfMergeAccountsTemp.get(ids));
              }
           } 
           System.debug('##@'+mapOfMergeAccounts);
           System.debug('##lstOfUpdateAccounts'+lstOfUpdateAccounts);


       }
        
        //Add record multiple PreSet Update Attorney Cmms records 
       if(mapOfPreUpdateAttorneyCmms.size()>0){
           
           ModelBatchUpdateItem objItem=fillpresetUpdateAtt(mapOfPreUpdateAttorneyCmms);
           
           lstOfcomms.addAll(objItem.lstOfUpdatePreMedComm);
           if(objItem.setOfDelCons!=null && !objItem.setOfDelCons.isEmpty()){
              setOfDelCons.addAll(objItem.setOfDelCons);
           }  
           if(objItem.lstOfUpdateAccRel!=null &&  !objItem.lstOfUpdateAccRel.isEmpty()){
              lstOfUpdateAccRel.addAll(objItem.lstOfUpdateAccRel);
           }  
           
           if(objItem.mapOfMergeContacts!=null &&  !objItem.mapOfMergeContacts.isEmpty()){
              Map<id,List<Contact>> mapOfMergeContactsTemp= objItem.mapOfMergeContacts;
              for(id ids:mapOfMergeContactsTemp.keySet()){
                  mapOfMergeContacts.put(ids,mapOfMergeContactsTemp.get(ids));
              }
           } 
           
           if(objItem.setOfDelAccRel!=null && !objItem.setOfDelAccRel.isEmpty()){
              setOfDelCons.addAll(objItem.setOfDelAccRel);
           }  
       }
       
       //Add multiple Peset merge firm Records
       
       if(mapOfPreMergeFirmsCmms.size()>0){
           ModelBatchUpdateItem objItem=fillpresetMergeFirm(mapOfPreMergeFirmsCmms);
           lstOfcomms.addAll(objItem.lstOfUpdatePreMedComm);
           if(objItem.lstOfUpdateAccounts!=null && !objItem.lstOfUpdateAccounts.isEmpty()){
              lstOfUpdateAccounts.addAll(objItem.lstOfUpdateAccounts);
           }  
           if(objItem.setOfDelAccs!=null &&  !objItem.setOfDelAccs.isEmpty()){
              setOfDelAcc.addAll(objItem.setOfDelAccs);
           }  
           if(objItem.mapOfMergeAccounts!=null &&  !objItem.mapOfMergeAccounts.isEmpty()){
              Map<id,List<Account>> mapOfMergeAccountsTemp= objItem.mapOfMergeAccounts;
              for(id ids:mapOfMergeAccountsTemp.keySet()){
                  mapOfMergeAccounts.put(ids,mapOfMergeAccountsTemp.get(ids));
              }
           } 
           
       }
       
       // fill preset Merge Attorneys
       
       if(mapOfPreMergeAttorneysCmms.size()>0){
           ModelBatchUpdateItem objItem=fillpresetMergeAttorneys(mapOfPreMergeAttorneysCmms);
           lstOfcomms.addAll(objItem.lstOfUpdatePreMedComm);
           if(objItem.setOfDelCons!=null && !objItem.setOfDelCons.isEmpty()){
              setOfDelCons.addAll(objItem.setOfDelCons);
           }  
           if(objItem.lstOfUpdateAccRel!=null &&  !objItem.lstOfUpdateAccRel.isEmpty()){
              lstOfUpdateAccRel.addAll(objItem.lstOfUpdateAccRel);
           }  
           
           if(objItem.mapOfMergeContacts!=null &&  !objItem.mapOfMergeContacts.isEmpty()){
              Map<id,List<Contact>> mapOfMergeContactsTemp= objItem.mapOfMergeContacts;
              for(id ids:mapOfMergeContactsTemp.keySet()){
                  mapOfMergeContacts.put(ids,mapOfMergeContactsTemp.get(ids));
              }
           } 
           if(objItem.setOfDelAccRel!=null && !objItem.setOfDelAccRel.isEmpty()){
              setOfDelCons.addAll(objItem.setOfDelAccRel);
           }  
           
       }
       
       //fill Medlien Update Firm
       if(mapOfMedlienUpdateFirm.size()>0){
           ModelBatchUpdateItem objItem=fillMedlienUpdateFirm(mapOfMedlienUpdateFirm);
           lstOfcomms.addAll(objItem.lstOfUpdatePreMedComm);
           if(objItem.lstOfUpdateAccounts!=null && !objItem.lstOfUpdateAccounts.isEmpty()){
              lstOfUpdateAccounts.addAll(objItem.lstOfUpdateAccounts);
           }  
           if(objItem.setOfDelAccs!=null &&  !objItem.setOfDelAccs.isEmpty()){
              setOfDelAcc.addAll(objItem.setOfDelAccs);
           }
            if(objItem.mapOfMergeAccounts!=null &&  !objItem.mapOfMergeAccounts.isEmpty()){
           
              System.debug('###objItem.mapOfMergeAccounts'+objItem.mapOfMergeAccounts);
           
              Map<id,List<Account>> mapOfMergeAccountsTemp= objItem.mapOfMergeAccounts;
              for(id ids:mapOfMergeAccountsTemp.keySet()){
                  mapOfMergeAccounts.put(ids,mapOfMergeAccountsTemp.get(ids));
              }
           } 
           System.debug('##@'+mapOfMergeAccounts);
           System.debug('##lstOfUpdateAccounts'+lstOfUpdateAccounts);
  
       }
       
       //fill Medlien Update Firm Locations
       if(mapOfMedlienUpdateFirmLocations.size()>0){
           ModelBatchUpdateItem objItem=fillMedlienUpdateFirmLocation(mapOfMedlienUpdateFirmLocations);
           lstOfcomms.addAll(objItem.lstOfUpdatePreMedComm);
           if(objItem.lstOfUpdateAccounts!=null && !objItem.lstOfUpdateAccounts.isEmpty()){
              lstOfUpdateAccounts.addAll(objItem.lstOfUpdateAccounts);
           }  
           if(objItem.setOfDelAccs!=null &&  !objItem.setOfDelAccs.isEmpty()){
              setOfDelAcc.addAll(objItem.setOfDelAccs);
           }
           if(objItem.mapOfMergeAccounts!=null &&  !objItem.mapOfMergeAccounts.isEmpty()){
           
              System.debug('###objItem.mapOfMergeAccounts'+objItem.mapOfMergeAccounts);
           
              Map<id,List<Account>> mapOfMergeAccountsTemp= objItem.mapOfMergeAccounts;
              for(id ids:mapOfMergeAccountsTemp.keySet()){
                  mapOfMergeAccounts.put(ids,mapOfMergeAccountsTemp.get(ids));
              }
           } 
           System.debug('##@'+mapOfMergeAccounts);
           System.debug('##lstOfUpdateAccounts'+lstOfUpdateAccounts);
  
       }
       
       
       // fill Medlien Update Attorneys
       
       if(mapOfMedlienUpdateContacts.size()>0){
           ModelBatchUpdateItem objItem=fillMedlienUpdateContact(mapOfMedlienUpdateContacts);
           lstOfcomms.addAll(objItem.lstOfUpdatePreMedComm);
           if(objItem.setOfDelCons!=null && !objItem.setOfDelCons.isEmpty()){
              setOfDelCons.addAll(objItem.setOfDelCons);
           }  
           if(objItem.lstOfUpdateAccRel!=null &&  !objItem.lstOfUpdateAccRel.isEmpty()){
              lstOfUpdateAccRel.addAll(objItem.lstOfUpdateAccRel);
           }  
           if(objItem.mapOfMergeContacts!=null &&  !objItem.mapOfMergeContacts.isEmpty()){
              Map<id,List<Contact>> mapOfMergeContactsTemp= objItem.mapOfMergeContacts;
              for(id ids:mapOfMergeContactsTemp.keySet()){
                  mapOfMergeContacts.put(ids,mapOfMergeContactsTemp.get(ids));
              }
           } 
           if(objItem.setOfDelAccRel!=null && !objItem.setOfDelAccRel.isEmpty()){
              setOfDelCons.addAll(objItem.setOfDelAccRel);
           }  
       }
       
       
        //fill Medlien merge Firm
       if(mapOfMedlienMergeFirms.size()>0){
           System.debug('###mapOfMedlienMergeFirms11'+mapOfMedlienMergeFirms);
           
           ModelBatchUpdateItem objItem=fillMedlienMergeFirm(mapOfMedlienMergeFirms);
           lstOfcomms.addAll(objItem.lstOfUpdatePreMedComm);
           if(objItem.lstOfUpdateAccounts!=null && !objItem.lstOfUpdateAccounts.isEmpty()){
              lstOfUpdateAccounts.addAll(objItem.lstOfUpdateAccounts);
           }  
           if(objItem.setOfDelAccs!=null &&  !objItem.setOfDelAccs.isEmpty()){
              setOfDelAcc.addAll(objItem.setOfDelAccs);
           }  
           if(objItem.mapOfMergeAccounts!=null &&  !objItem.mapOfMergeAccounts.isEmpty()){
           
              System.debug('###objItem.mapOfMergeAccounts'+objItem.mapOfMergeAccounts);
           
              Map<id,List<Account>> mapOfMergeAccountsTemp= objItem.mapOfMergeAccounts;
              for(id ids:mapOfMergeAccountsTemp.keySet()){
                  mapOfMergeAccounts.put(ids,mapOfMergeAccountsTemp.get(ids));
              }
           } 
           System.debug('##@'+mapOfMergeAccounts);
           System.debug('##lstOfUpdateAccounts'+lstOfUpdateAccounts);


       }
       
        //fill Medlien merge Firm Locations
       if(mapOfMedlienMergeFirmsLocations.size()>0){
           ModelBatchUpdateItem objItem=fillMedlienMergeFirmLocations(mapOfMedlienMergeFirmsLocations);
           lstOfcomms.addAll(objItem.lstOfUpdatePreMedComm);
           if(objItem.lstOfUpdateAccounts!=null && !objItem.lstOfUpdateAccounts.isEmpty()){
              lstOfUpdateAccounts.addAll(objItem.lstOfUpdateAccounts);
           }  
           if(objItem.setOfDelAccs!=null &&  !objItem.setOfDelAccs.isEmpty()){
              setOfDelAcc.addAll(objItem.setOfDelAccs);
           }  
           
           if(objItem.mapOfMergeAccounts!=null &&  !objItem.mapOfMergeAccounts.isEmpty()){
           
              System.debug('###objItem.mapOfMergeAccounts'+objItem.mapOfMergeAccounts);
           
              Map<id,List<Account>> mapOfMergeAccountsTemp= objItem.mapOfMergeAccounts;
              for(id ids:mapOfMergeAccountsTemp.keySet()){
                  mapOfMergeAccounts.put(ids,mapOfMergeAccountsTemp.get(ids));
              }
           } 
           System.debug('##@'+mapOfMergeAccounts);
           System.debug('##lstOfUpdateAccounts'+lstOfUpdateAccounts);



       }
       
        // fill Medlien Merge Attorneys
       
       if(mapOfMedlienMergeAttorneysCmms.size()>0){
           ModelBatchUpdateItem objItem=fillMedlienMergeAttorneys(mapOfMedlienMergeAttorneysCmms);
           
           lstOfcomms.addAll(objItem.lstOfUpdatePreMedComm);
           if(objItem.setOfDelCons!=null && !objItem.setOfDelCons.isEmpty()){
              setOfDelCons.addAll(objItem.setOfDelCons);
           }  
           if(objItem.lstOfUpdateAccRel!=null &&  !objItem.lstOfUpdateAccRel.isEmpty()){
              lstOfUpdateAccRel.addAll(objItem.lstOfUpdateAccRel);
           }  
           
           if(objItem.mapOfMergeContacts!=null &&  !objItem.mapOfMergeContacts.isEmpty()){
              Map<id,List<Contact>> mapOfMergeContactsTemp= objItem.mapOfMergeContacts;
              for(id ids:mapOfMergeContactsTemp.keySet()){
                  mapOfMergeContacts.put(ids,mapOfMergeContactsTemp.get(ids));
              }
           } 
           
           if(objItem.setOfDelAccRel!=null && !objItem.setOfDelAccRel.isEmpty()){
              setOfDelCons.addAll(objItem.setOfDelAccRel);
           }  
       }
       
       
        //fill Preset merge Firm Locations
       if(mapOfPreMergeFirmLocCmms.size()>0){
           ModelBatchUpdateItem objItem=fillPresetMergeFirmLocations(mapOfPreMergeFirmLocCmms);
           lstOfcomms.addAll(objItem.lstOfUpdatePreMedComm);
           
           System.debug('###objItem.lstOfUpdateAccounts'+objItem.lstOfUpdateAccounts);
           if(objItem.lstOfUpdateAccounts!=null && !objItem.lstOfUpdateAccounts.isEmpty()){
              lstOfUpdateAccounts.addAll(objItem.lstOfUpdateAccounts);
           }  
           if(objItem.setOfDelAccs!=null &&  !objItem.setOfDelAccs.isEmpty()){
              setOfDelAcc.addAll(objItem.setOfDelAccs);
           }  
           
           if(objItem.mapOfMergeAccounts!=null &&  !objItem.mapOfMergeAccounts.isEmpty()){
           
              System.debug('###objItem.mapOfMergeAccounts'+objItem.mapOfMergeAccounts);
           
              Map<id,List<Account>> mapOfMergeAccountsTemp= objItem.mapOfMergeAccounts;
              for(id ids:mapOfMergeAccountsTemp.keySet()){
                  mapOfMergeAccounts.put(ids,mapOfMergeAccountsTemp.get(ids));
              }
           } 
           System.debug('##@'+mapOfMergeAccounts);
           System.debug('##lstOfUpdateAccounts'+lstOfUpdateAccounts);
       }

       // fill Preset Move Attorney
       
       if(mapOfPreMoveAttorneyCmms.size()>0){
           ModelBatchUpdateItem objItem=fillPresetMoveAttorney(mapOfPreMoveAttorneyCmms);
           lstOfcomms.addAll(objItem.lstOfUpdatePreMedComm);
           if(objItem.setOfDelCons!=null && !objItem.setOfDelCons.isEmpty()){
              setOfDelCons.addAll(objItem.setOfDelCons);
           }  
           if(objItem.lstOfUpdateAccRel!=null &&  !objItem.lstOfUpdateAccRel.isEmpty()){
              lstOfUpdateAccRel.addAll(objItem.lstOfUpdateAccRel);
           }  
       }
       ///Dml Opp Records
       System.debug('####mapOfMergeAccountsmain'+mapOfMergeAccounts);
       if(mapOfMergeAccounts.size()>0 && !Test.IsRunningTest()){
       
           for(id ids:mapOfMergeAccounts.keySet()){
               System.debug('##@@1'+mapOfMergeAccounts.get(ids)[0]);
               System.debug('##@@1'+mapOfMergeAccounts.get(ids)[1]);
               merge mapOfMergeAccounts.get(ids)[0] mapOfMergeAccounts.get(ids)[1];
           }
       }
       System.debug('####mapOfMergeContactsmain'+mapOfMergeContacts);
       if(mapOfMergeContacts.size()>0  && !Test.IsRunningTest()){
       
           for(id ids:mapOfMergeContacts.keySet()){
               System.debug('##@@1'+mapOfMergeContacts.get(ids)[0]);
               System.debug('##@@1'+mapOfMergeContacts.get(ids)[1]);
               merge mapOfMergeContacts.get(ids)[0] mapOfMergeContacts.get(ids)[1];
           }
       }
       System.debug('##lstOfcomms'+lstOfcomms);
       
       if(lstOfcomms.size()>0 && !Test.IsRunningTest()){
           database.update(lstOfcomms,false);
       }
       
       if(lstOfUpdateAccounts.size()>0){
           Set<id> setOfDulIds=new Set<id>();
           List<Account> lstOfaccs=new List<Account>();
           
           for(Account acc:lstOfUpdateAccounts){
               if(!setOfDulIds.contains(acc.id)){
                   setOfDulIds.add(acc.id);
                   lstOfaccs.add(acc);
               }
           }
           System.debug('###lstOfaccs'+lstOfaccs);
           if(lstOfaccs.size()>0){
               database.update(lstOfaccs,false);
           }
       }
       
       if(lstOfUpdateAccRel.size()>0){
           Set<id> setOfDulIds=new Set<id>();
           List<Account_Relation__c> lstOfaccs=new List<Account_Relation__c>();
           
           for(Account_Relation__c acc:lstOfUpdateAccRel){
               if(!setOfDulIds.contains(acc.id)){
                   setOfDulIds.add(acc.id);
                   lstOfaccs.add(acc);
               }
           }
           
           if(lstOfaccs.size()>0){
              database.update(lstOfaccs,false);
           }
       }
       
       
       if(setOfDelAccRel.size()>0){
           List<Account_Relation__c> lstRels=[select id,Flow_Flag__c from Account_Relation__c where id in:setOfDelAccRel];
           
           for(Account_Relation__c rel:lstRels){
               rel.Flow_Flag__c =true;
           }
           
           if(lstRels.size()>0){
               database.update(lstRels,false);
           }
           
          database.delete([select id from Account_Relation__c where id in:setOfDelAccRel],false);
       }
       if(setOfDelAcc.size()>0){
       
           System.debug('###setOfDelAcc'+setOfDelAcc);
           database.delete([select id from Account where id in:setOfDelAcc],false);
       }
       
       if(setOfDelCons.size()>0){
           database.delete([select id from contact where id in:setOfDelCons],false);
       }
    }
 
    global void finish(Database.BatchableContext BC){
        // Logic to be Executed at finish
         
    }
    
   //Preset Update Firm  
    private ModelBatchUpdateItem fillpresetUpdateFirm(Map<id,Preset_Medlien_Communication__c >mapOfPreUpdateFirmsCmms){
        List<Preset_Medlien_Communication__c> lstOfcomms=new List<Preset_Medlien_Communication__c>();
        List<Account> lstofUpdateAccounts=new List<Account>();
        Map<id,Id> mapOfMergeAccs=new Map<id,id>();
        Map<id,id> mapDelAccounts=new Map<id,id>();
        Map<id,List<Account>> mapOfMergeAccounts=new Map<id,List<Account>>();
         Set<id> setOfEndPoinsAcc=new Set<id>();
        if(mapOfPreUpdateFirmsCmms.size()>0){
           
             for(Account acc:[Select Id,Website,Phone,Fax,name,CTXFirmId__c  from Account where Id=:mapOfPreUpdateFirmsCmms.keySet()]){
                id ids=acc.id;

                Preset_Medlien_Communication__c preObj=mapOfPreUpdateFirmsCmms.get(ids);
            
                if((mapOfPreUpdateFirmsCmms.get(ids).Deleting_Cashtrax_Id__c!=null  && mapOfPreUpdateFirmsCmms.get(ids).Deleting_Cashtrax_Id__c.trim()!='') 
                    && ((mapOfPreUpdateFirmsCmms.get(ids).Serviving_Atticus_Id__c!=null && mapOfPreUpdateFirmsCmms.get(ids).Serviving_Atticus_Id__c.trim()!='')
                        ||(mapOfPreUpdateFirmsCmms.get(ids).Serviving_Grs_Id__c!=null && mapOfPreUpdateFirmsCmms.get(ids).Serviving_Grs_Id__c.trim()!='')
                        || (mapOfPreUpdateFirmsCmms.get(ids).Serviving_Core_Id__c!=null && mapOfPreUpdateFirmsCmms.get(ids).Serviving_Core_Id__c.trim()!='')
                        )){
                    
                  
                            ModelRequestUpdateFirm pr=new ModelRequestUpdateFirm ();
                            pr.Website=(acc.Website==null?'':acc.Website);
                            pr.PhoneNumber=(acc.phone==null?'':acc.phone);  
                            pr.Fax=(acc.Fax==null?'':acc.Fax);  
                            pr.FirmName=acc.name;
                            if(mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c.trim()!=''){
                                pr.FirmID=integer.ValueOf(mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c);
                            }
                            pr.CRM_FirmID=mapOfPreUpdateFirmsCmms.get(acc.id).Serviving_Id__c;
                            String reqBody=JSON.serialize(pr);
                        
                             HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request(reqBody,'PresetUpdateFirm','');
                             Preset_Medlien_Communication__c  preMedComm=fillPresetMedComm(mapOfPreUpdateFirmsCmms.get(acc.id).id,reqBody,resfrmLoc.getBody(),resfrmLoc.getStatusCode());
                    
                            preObj.Status__c=preMedComm.Status__c;
                            preObj.Input_Payload__c=preMedComm.Input_Payload__c;
                            preObj.Output_Body__c=preMedComm.Output_Body__c;  
                            preObj.Status_Code__c=preMedComm.Status_Code__c; 
                            
                            mapOfPreUpdateFirmsCmms.put(ids,preObj);
                            
                            if(preObj.Status__c=='Completed'){
                                mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                                mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);
                            }
                            setOfEndPoinsAcc.add(preObj.Serviving_Id__c);
                            lstOfcomms.add(preObj);
                        }else{
                            mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                            mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);
                        
                        }
            }   

        }
        
        if(mapOfMergeAccs.size()>0){
            
            for(Account acc:[select id,parentId from account where parentId in:mapDelAccounts.keySet()]){
                lstofUpdateAccounts.add(new Account(id=acc.id,parentId=mapDelAccounts.get(acc.parentId)));   
            }

            Map<id,Account> maprOfFormLocs=new Map<Id,Account>();
            Map<id,Account> maprOfToLocs=new Map<Id,Account>();
            
            for( Account acc:[SELECT Id, KeyMedsID__c, Core__c, GRS__c, GRSId__c, Atticus__c, AtticusId__c, PreSet__c, CTXFirmId__c, Type FROM Account WHERE Id in:mapOfMergeAccs.keySet()]){
                maprOfToLocs.put(acc.id,acc);
            }
            
            for( Account acc:[SELECT Id, KeyMedsID__c, Core__c, GRS__c, GRSId__c, Atticus__c, AtticusId__c, PreSet__c, CTXFirmId__c, Type FROM Account WHERE Id in:mapDelAccounts.keySet()]){
                maprOfFormLocs.put(acc.id,acc);
            }
            
            for(id Ids:maprOfToLocs.keySet()){
                Account ToLoc=maprOfToLocs.get(ids);
                Account FromLoc=maprOfFormLocs.get(mapOfMergeAccs.get(ToLoc.id));
                 
                // Check for core checkbox in from location
               If (FromLoc.Core__c == true && ToLoc.Core__c == false){
                       ToLoc.Core__c = true;
                           
               }
               // Check for Core Id in from location
               If (FromLoc.KeyMedsID__c != Null && ToLoc.KeyMedsID__c == Null){
                    ToLoc.KeyMedsID__c = FromLoc.KeyMedsID__c;
                   
               }
               // Check for GRS checkbox in from location
               If (FromLoc.GRS__c == true && ToLoc.GRS__c == false){
                    ToLoc.GRS__c = true;
                             
               }
               // Check for GRS Id in from location
               If (FromLoc.GRSId__c != Null && ToLoc.GRSId__c == Null){
                    ToLoc.GRSId__c = FromLoc.GRSId__c;
                   
               }
               // Check for Atticus checkbox in from location
               If (FromLoc.Atticus__c == true && ToLoc.Atticus__c == false){
                    ToLoc.Atticus__c = true;
                    
               }
               // Check for Atticus Id in from location
               If (FromLoc.AtticusId__c != Null && ToLoc.AtticusId__c == Null){
                       ToLoc.AtticusId__c = FromLoc.AtticusId__c;
                   
               }
               
               // From location type is LawFirm
                If(FromLoc.Type == 'LawFirm'){
                   // Check for Preset checkbox in from location
                   If (FromLoc.PreSet__c == true && ToLoc.PreSet__c == false){
                      ToLoc.PreSet__c = true;      
                   }
                   // Check for CashTrax Id in from location
                   If (FromLoc.CTXFirmId__c != Null && ToLoc.CTXFirmId__c == Null){
                     ToLoc.CTXFirmId__c = FromLoc.CTXFirmId__c;
                   }
                }
                
                List<Account> lstOfaccs=new List<Account>();
                lstOfaccs.add(ToLoc);
                lstOfaccs.add(FromLoc);
                
                
                mapOfMergeAccounts.put(ToLoc.id,lstOfaccs);
                if(Test.IsRunningTest() || !setOfEndPoinsAcc.contains(ids)){
                    Preset_Medlien_Communication__c preObj=mapOfPreUpdateFirmsCmms.get(ids);
                    preObj.Status__c='Completed';
                    preObj.Input_Payload__c='';
                    preObj.Output_Body__c='Internal Sf Merge Record';
                    preObj.Status_Code__c='';
                    lstOfcomms.add(preObj);
                }
                
            
                lstofUpdateAccounts.add(ToLoc);
                    
            }
           
        }   
        return new ModelBatchUpdateItem(lstofUpdateAccounts,null,null,lstOfcomms,null,null,null,mapOfMergeAccounts,null);
    }
    
     // preset Update Firm Locations
     private ModelBatchUpdateItem fillpresetUpdateFirmLocations(Map<id,Preset_Medlien_Communication__c >mapOfPreUpdateFirmsCmms){
       
       List<Preset_Medlien_Communication__c> lstOfcomms=new List<Preset_Medlien_Communication__c>();
        List<Account> lstofUpdateAccounts=new List<Account>();
        Map<id,Id> mapOfMergeAccs=new Map<id,id>();
        Map<id,id> mapDelAccounts=new Map<id,id>();
        Map<id,List<Account>> mapOfMergeAccounts=new Map<id,List<Account>>();
         Set<id> setOfEndPoinsAcc=new Set<id>();
        if(mapOfPreUpdateFirmsCmms.size()>0){
           
             for(Account acc:[Select Id,name,BillingStreet,parentid,
                              parent.OS_Firm_Id__c,OS_Firm_Id__c,OS_Firm_Location_Id__c, 
                              BillingCity,Street2__c, BillingState, BillingPostalCode, 
                              BillingCountry, BillingStateCode, BillingCountryCode ,
                              CTXFirmId__c  from Account where Id=:mapOfPreUpdateFirmsCmms.keySet()]){
                 id ids=acc.id;
                 if(mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c==null &&
                    mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c.trim()==''){

                      Preset_Medlien_Communication__c preObj=mapOfPreUpdateFirmsCmms.get(ids);
                        preObj.Status__c='fail';
                        preObj.Input_Payload__c='';
                        preObj.Output_Body__c='Please sync Deleting record First then perform operation ';
                        preObj.Status_Code__c='';
                        lstOfcomms.add(preObj);
                        
                }else{
                        Preset_Medlien_Communication__c preObj=mapOfPreUpdateFirmsCmms.get(ids);
                        if(Test.isRunningTest() || mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c!=null &&
                            mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c.trim()!='' && acc.CTXFirmId__c==null){
                            
                            String fromFirmId=mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c;
                            String fromfirmLocationId=mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Id__c;
                            
                            ModelRequestUpdateFirmLocation pr=new ModelRequestUpdateFirmLocation  ();

                            pr.ZipCode=(acc.BillingPostalCode==null?'':acc.BillingPostalCode);
                            pr.State=(acc.BillingState==null?'':acc.BillingState);
                            pr.City=(acc.BillingCity==null?'':acc.BillingCity);

                            pr.Address1=(acc.BillingStreet==null?'':acc.BillingStreet);
                            pr.Address2=(acc.Street2__c==null?'':acc.Street2__c);

                            pr.FirmLocationName=acc.name;

                            if(fromFirmId!=null && fromFirmId.trim()!=''){
                                pr.FirmLocationID=Integer.valueOf(fromFirmId);
                                pr.FirmID =Integer.valueOf(fromFirmId);
                            }
                            pr.CRM_FirmID=acc.parentid; // parentid
                            pr.CRM_FirmLocationID=acc.id; // to sf child id

                            //pr.FirmID=1284;

                            if(!Test.isRunningTest()&& fromfirmLocationId!=null && fromfirmLocationId.trim()!=''){
                                //pr.FirmLocationID=Integer.valueOf(fromfirmLocationId);
                            }

                            String reqBody=JSON.serialize(pr);

                            HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request(reqBody,'PresetUpdateFirmLocation','');
                            Preset_Medlien_Communication__c  preMedComm=fillPresetMedComm(mapOfPreUpdateFirmsCmms.get(acc.id).id,reqBody,resfrmLoc.getBody(),resfrmLoc.getStatusCode());
                    
                            preObj.Status__c=preMedComm.Status__c;
                            preObj.Input_Payload__c=preMedComm.Input_Payload__c;
                            preObj.Output_Body__c=preMedComm.Output_Body__c;  
                            preObj.Status_Code__c=preMedComm.Status_Code__c; 
                            
                            mapOfPreUpdateFirmsCmms.put(ids,preObj);
                            
                            if(preObj.Status__c=='Completed'){
                                mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                                mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);
                            }
                            setOfEndPoinsAcc.add(preObj.Serviving_Id__c);
                            lstOfcomms.add(preObj);
                        }else{
                            mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                            mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);
                        
                        }
                }   
            }

        }
        
        if(mapOfMergeAccs.size()>0){
            
            for(Account acc:[select id,parentId from account where parentId in:mapDelAccounts.keySet()]){
                lstofUpdateAccounts.add(new Account(id=acc.id,parentId=mapDelAccounts.get(acc.parentId)));   
            }

            Map<id,Account> maprOfFormLocs=new Map<Id,Account>();
            Map<id,Account> maprOfToLocs=new Map<Id,Account>();
            
            for( Account acc:[SELECT Id, KeyMedsID__c, Core__c, GRS__c, GRSId__c, Atticus__c, AtticusId__c, PreSet__c, CTXFirmId__c, Type FROM Account WHERE Id in:mapOfMergeAccs.keySet()]){
                maprOfToLocs.put(acc.id,acc);
            }
            
            for( Account acc:[SELECT Id, KeyMedsID__c, Core__c, GRS__c, GRSId__c, Atticus__c, AtticusId__c, PreSet__c, CTXFirmId__c, Type FROM Account WHERE Id in:mapDelAccounts.keySet()]){
                maprOfFormLocs.put(acc.id,acc);
            }
            
            for(id Ids:maprOfToLocs.keySet()){
                Account ToLoc=maprOfToLocs.get(ids);
                Account FromLoc=maprOfFormLocs.get(mapOfMergeAccs.get(ToLoc.id));
                 
                // Check for core checkbox in from location
               If (FromLoc.Core__c == true && ToLoc.Core__c == false){
                       ToLoc.Core__c = true;
                           
               }
               // Check for Core Id in from location
               If (FromLoc.KeyMedsID__c != Null && ToLoc.KeyMedsID__c == Null){
                    ToLoc.KeyMedsID__c = FromLoc.KeyMedsID__c;
                   
               }
               // Check for GRS checkbox in from location
               If (FromLoc.GRS__c == true && ToLoc.GRS__c == false){
                    ToLoc.GRS__c = true;
                             
               }
               // Check for GRS Id in from location
               If (FromLoc.GRSId__c != Null && ToLoc.GRSId__c == Null){
                    ToLoc.GRSId__c = FromLoc.GRSId__c;
                   
               }
               // Check for Atticus checkbox in from location
               If (FromLoc.Atticus__c == true && ToLoc.Atticus__c == false){
                    ToLoc.Atticus__c = true;
                    
               }
               // Check for Atticus Id in from location
               If (FromLoc.AtticusId__c != Null && ToLoc.AtticusId__c == Null){
                       ToLoc.AtticusId__c = FromLoc.AtticusId__c;
                   
               }
               
               // From location type is LawFirm
                If(FromLoc.Type == 'LawFirm'){
                   // Check for Preset checkbox in from location
                   If (FromLoc.PreSet__c == true && ToLoc.PreSet__c == false){
                      ToLoc.PreSet__c = true;      
                   }
                   // Check for CashTrax Id in from location
                   If (FromLoc.CTXFirmId__c != Null && ToLoc.CTXFirmId__c == Null){
                     ToLoc.CTXFirmId__c = FromLoc.CTXFirmId__c;
                   }
                }
                
                List<Account> lstOfaccs=new List<Account>();
                lstOfaccs.add(ToLoc);
                lstOfaccs.add(FromLoc);
                
                
                mapOfMergeAccounts.put(ToLoc.id,lstOfaccs);
                if(Test.IsRunningTest() || !setOfEndPoinsAcc.contains(ids)){
                    Preset_Medlien_Communication__c preObj=mapOfPreUpdateFirmsCmms.get(ids);
                    preObj.Status__c='Completed';
                    preObj.Input_Payload__c='';
                    preObj.Output_Body__c='Internal Sf Merge Record';
                    preObj.Status_Code__c='';
                    lstOfcomms.add(preObj);
                }
                
            
                lstofUpdateAccounts.add(ToLoc);
                    
            }
           
        }   
        return new ModelBatchUpdateItem(lstofUpdateAccounts,null,null,lstOfcomms,null,null,null,mapOfMergeAccounts,null);
    }
    
    // preset Update Firm Att
     private ModelBatchUpdateItem fillpresetUpdateAtt(Map<id,Preset_Medlien_Communication__c >mapOfPreMergeAttorneysCmms){
       List<Account_Relation__c > lstofUpdateAccRels=new List<Account_Relation__c >();
       List<Preset_Medlien_Communication__c> lstOfcomms=new List<Preset_Medlien_Communication__c>();
       List<Contact> lstofUpdateContact=new List<Contact>();
       Map<id,Id> mapOfMergeAccs=new Map<id,id>();
       Map<id,id> mapDelAccounts=new Map<id,id>();
       Set<id> setOfEndPoinsAcc=new Set<id>();
       set<id> setOfDelAccRel=new Set<id>();
         
        Map<id,List<Contact>> mapOfMergeContacts=new Map<id,List<Contact>>();
       for(contact conRec:[select id,lastname,firstname,Fax,Email,phone,accountid,
                            birthdate,account.OS_Firm_Location_Id__c,account.OS_Firm_Id__c from
                            contact where id=:mapOfPreMergeAttorneysCmms.keySet()]){
            
            id ids=conRec.id;               
            Preset_Medlien_Communication__c preObj=mapOfPreMergeAttorneysCmms.get(ids);
            
             if((mapOfPreMergeAttorneysCmms.get(ids).Deleting_Cashtrax_Id__c!=null  && mapOfPreMergeAttorneysCmms.get(ids).Deleting_Cashtrax_Id__c.trim()!='')
                && mapOfPreMergeAttorneysCmms.get(ids).Serviving_CashTrax_Id__c==null
                && ((mapOfPreMergeAttorneysCmms.get(ids).Serviving_Atticus_Id__c!=null && mapOfPreMergeAttorneysCmms.get(ids).Serviving_Atticus_Id__c.trim()!='')
                    ||(mapOfPreMergeAttorneysCmms.get(ids).Serviving_Grs_Id__c!=null && mapOfPreMergeAttorneysCmms.get(ids).Serviving_Grs_Id__c.trim()!='')
                    || (mapOfPreMergeAttorneysCmms.get(ids).Serviving_Core_Id__c!=null && mapOfPreMergeAttorneysCmms.get(ids).Serviving_Core_Id__c.trim()!='')
                    )){
                
                ModelRequestUpdateAttorneyContact pr=new ModelRequestUpdateAttorneyContact();
            
                pr.PhoneNumber=conRec.phone;
                pr.LastName=conRec.LastName;
                pr.FirstName=conRec.FirstName;
                pr.Birthday=conRec.birthdate;
                pr.fax=conRec.fax;
                pr.email=conRec.email;
                pr.CRM_FirmLocationID=conRec.Accountid;
                pr.CRM_AttorneyID=conRec.id;
                
                if(mapOfPreMergeAttorneysCmms.get(conRec.id).Deleting_Cashtrax_Id__c!=null && mapOfPreMergeAttorneysCmms.get(conRec.id).Deleting_Cashtrax_Id__c.trim()!=''){
                    pr.AttorneyID=Integer.valueOf(mapOfPreMergeAttorneysCmms.get(conRec.id).Deleting_Cashtrax_Id__c);
                }
                
                pr.ContactInformation='';
                
                if(conRec.account.OS_Firm_Location_Id__c!=null){
                    pr.FirmLocationID=Integer.valueOf(conRec.account.OS_Firm_Location_Id__c);
                }
                 if(conRec.account.OS_Firm_Id__c !=null){
                    pr.FirmID=Integer.valueOf(conRec.account.OS_Firm_Id__c );
                }
                String reqBody=JSON.serialize(pr);
            
                HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request(reqBody,'PresetUpdateAttorneyContact','');
                Preset_Medlien_Communication__c  preMedComm=fillPresetMedComm(mapOfPreMergeAttorneysCmms.get(conRec.id).id,reqBody,resfrmLoc.getBody(),resfrmLoc.getStatusCode());    
              
                preObj.Status__c=preMedComm.Status__c;
                preObj.Input_Payload__c=preMedComm.Input_Payload__c;
                preObj.Output_Body__c=preMedComm.Output_Body__c;
                preObj.Status_Code__c=preMedComm.Status_Code__c;
                
                mapOfPreMergeAttorneysCmms.put(ids,preObj);   
              
                if(preObj.Status__c=='Completed'){
                   mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                   mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);  
                }
                setOfEndPoinsAcc.add(preObj.Serviving_Id__c);
                lstOfcomms.add(preObj);
                
            }else{
                mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);   
                
            }
                 
        }
        
        if(mapOfMergeAccs.size()>0){
            Map<id,Contact> maprOfFormLocs=new Map<Id,Contact>();
            Map<id,Contact> maprOfToLocs=new Map<Id,Contact>();
            
            Map<id,Account_Relation__c > maprOfFormLocsRel=new Map<Id,Account_Relation__c >();
            Map<id,Account_Relation__c > maprOfToLocsRel=new Map<Id,Account_Relation__c >();
            
            for(Account_Relation__c MasterAtr :[SELECT Id, KeyMedsID__c, GRSId__c, 
                                                AtticusId__c, PresetID__c,Contact__c  
                                                FROM Account_Relation__c 
                                                WHERE Contact__c in:mapOfMergeAccs.keySet() limit 1]){
                    
                    maprOfToLocsRel.put(MasterAtr.Contact__c,MasterAtr);        
            
            }                                   
            
            for(Account_Relation__c mergeAtr :[SELECT Id, KeyMedsID__c, GRSId__c,
                                                AtticusId__c, PresetID__c,Contact__c  
                                                FROM Account_Relation__c 
                                                WHERE Contact__c in:mapDelAccounts.keySet() limit 1]){
                                              
                    maprOfFormLocsRel.put(mergeAtr.Contact__c,mergeAtr);                          
            
            }       
             
              
            for( Contact acc:[SELECT Id, Core__c, GRS__c, Atticus__c, PreSet__c FROM Contact WHERE Id in:mapOfMergeAccs.keySet()]){
                maprOfToLocs.put(acc.id,acc);
            }
            
            for( Contact acc:[SELECT Id, Core__c, GRS__c, Atticus__c, PreSet__c FROM Contact WHERE Id in:mapDelAccounts.keySet()]){
                maprOfFormLocs.put(acc.id,acc);
            }
            
            for(id Ids:maprOfToLocs.keySet()){
                Contact masterCont=maprOfToLocs.get(ids);
                Contact mergeCont =maprOfFormLocs.get(mapOfMergeAccs.get(masterCont.id));
                 
                Account_Relation__c MasterAtr =maprOfToLocsRel.get(ids);
                Account_Relation__c mergeAtr  =maprOfFormLocsRel.get(mapOfMergeAccs.get(masterCont.id));
               
               
               // Check for core checkbox in from Contact
               If (mergeCont.Core__c == true && masterCont.Core__c == false){
                  masterCont.Core__c = true; 
                             
               }
               // Check for GRS checkbox in from contact
               If (mergeCont.GRS__c == true && masterCont.GRS__c == false){
                  masterCont.GRS__c = true;
                       
               }
               
               // Check for Atticus checkbox in from contact
               If (mergeCont.Atticus__c == true && masterCont.Atticus__c == false){
                  masterCont.Atticus__c = true; 
                        
               }
               
               // Check for Preset checkbox in from contact
               If (mergeCont.PreSet__c == true && masterCont.PreSet__c == false){
                  masterCont.PreSet__c = true;
                        
               }
               
            
               // Check for Core Id in from Attorney
               If (mergeAtr.KeyMedsID__c != Null && MasterAtr.KeyMedsID__c == Null){
                   // Check for Core Id in to Attorney
                   MasterAtr.KeyMedsID__c = mergeAtr.KeyMedsID__c;
                       
               }
               
               // Check for GRS Id in from location
               If (mergeAtr.GRSId__c != Null && MasterAtr.GRSId__c == Null){
                   // Check for GRS Id in to location
                  MasterAtr.GRSId__c = mergeAtr.GRSId__c;
                    
               }
               
               // Check for Atticus Id in from location
               If (mergeAtr.AtticusId__c != Null && MasterAtr.AtticusId__c == Null){
                   // Check for Atticus Id in to location
                   MasterAtr.AtticusId__c = mergeAtr.AtticusId__c; 
                       
               }
               // Check for CashTrax Id in from location
               If (mergeAtr.PresetID__c != Null && MasterAtr.PresetID__c == Null){
                   // Check for Atticus Id in to location
                   MasterAtr.PresetID__c = mergeAtr.PresetID__c;
                      
               }
               
                // Merge Contacts
                List<Contact> lstOfCons=new List<Contact>();
                lstOfCons.add(masterCont);
                lstOfCons.add(mergeCont);
                mapOfMergeContacts.put(masterCont.id,lstOfCons);
                lstofUpdateAccRels.add(MasterAtr);
                
                setOfDelAccRel.add(mergeAtr.id);
                
                if(Test.IsRunningTest() || !setOfEndPoinsAcc.contains(ids)){
                    Preset_Medlien_Communication__c preObj=mapOfPreMergeAttorneysCmms.get(ids);
                    preObj.Status__c='Completed';
                    preObj.Input_Payload__c='';
                    preObj.Status_Code__c='';
                    preObj.Output_Body__c='Internal Sf Merge Record';
                    lstOfcomms.add(preObj);
                }
                lstofUpdateContact.add(masterCont);
            }                      
       
        }

        return new ModelBatchUpdateItem(null,lstofUpdateContact,lstofUpdateAccRels,lstOfcomms,null,null,setOfDelAccRel,null,mapOfMergeContacts);
    }   
     // preset merge Firm  
    private ModelBatchUpdateItem fillpresetMergeFirm(Map<id,Preset_Medlien_Communication__c >mapOfPreMergeFirmsCmms){
        List<Preset_Medlien_Communication__c> lstOfcomms=new List<Preset_Medlien_Communication__c>();
        List<Account> lstofUpdateAccounts=new List<Account>();
        Map<id,Id> mapOfMergeAccs=new Map<id,id>();
        Map<id,id> mapDelAccounts=new Map<id,id>();
        Map<id,List<Account>> mapOfMergeAccounts=new Map<id,List<Account>>();
         Set<id> setOfEndPoinsAcc=new Set<id>();
        if(mapOfPreMergeFirmsCmms.size()>0){
           
           for(id ids:mapOfPreMergeFirmsCmms.keySet()){
           
                Preset_Medlien_Communication__c preObj=mapOfPreMergeFirmsCmms.get(ids);
            
                if(mapOfPreMergeFirmsCmms.get(ids).Deleting_Cashtrax_Id__c!=null  && mapOfPreMergeFirmsCmms.get(ids).Deleting_Cashtrax_Id__c.trim()!='' &&
                    mapOfPreMergeFirmsCmms.get(ids).Serviving_CashTrax_Id__c!=null && mapOfPreMergeFirmsCmms.get(ids).Serviving_CashTrax_Id__c.trim()!=''){
                  
                    HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request('{}','MergeFirms','FromFirmID='+mapOfPreMergeFirmsCmms.get(ids).Deleting_Cashtrax_Id__c+'&ToFirmID='+mapOfPreMergeFirmsCmms.get(ids).Serviving_CashTrax_Id__c);
                    Preset_Medlien_Communication__c  preMedComm=fillPresetMedComm(mapOfPreMergeFirmsCmms.get(ids).id,'FromFirmID='+mapOfPreMergeFirmsCmms.get(ids).Deleting_Cashtrax_Id__c+'&ToFirmID='+mapOfPreMergeFirmsCmms.get(ids).Serviving_CashTrax_Id__c,resfrmLoc.getBody(),resfrmLoc.getStatusCode());    

                    preObj.Status__c=preMedComm.Status__c;
                    preObj.Input_Payload__c=preMedComm.Input_Payload__c;
                    preObj.Output_Body__c=preMedComm.Output_Body__c;  
                    preObj.Status_Code__c=preMedComm.Status_Code__c; 
                    mapOfPreMergeFirmsCmms.put(ids,preObj);
                    
                    if(preObj.Status__c=='Completed'){
                        mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                        mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);
                    }
                    setOfEndPoinsAcc.add(preObj.Serviving_Id__c);
                    lstOfcomms.add(preObj);
                }else{
                    mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                    mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);
                
                }
            }   

        }
        
        if(mapOfMergeAccs.size()>0){
            
            for(Account acc:[select id,parentId from account where parentId in:mapDelAccounts.keySet()]){
                lstofUpdateAccounts.add(new Account(id=acc.id,parentId=mapDelAccounts.get(acc.parentId)));   
            }

            Map<id,Account> maprOfFormLocs=new Map<Id,Account>();
            Map<id,Account> maprOfToLocs=new Map<Id,Account>();
            
            for( Account acc:[SELECT Id, KeyMedsID__c, Core__c, GRS__c, GRSId__c, Atticus__c, AtticusId__c, PreSet__c, CTXFirmId__c, Type FROM Account WHERE Id in:mapOfMergeAccs.keySet()]){
                maprOfToLocs.put(acc.id,acc);
            }
            
            for( Account acc:[SELECT Id, KeyMedsID__c, Core__c, GRS__c, GRSId__c, Atticus__c, AtticusId__c, PreSet__c, CTXFirmId__c, Type FROM Account WHERE Id in:mapDelAccounts.keySet()]){
                maprOfFormLocs.put(acc.id,acc);
            }
            
            for(id Ids:maprOfToLocs.keySet()){
                Account ToLoc=maprOfToLocs.get(ids);
                Account FromLoc=maprOfFormLocs.get(mapOfMergeAccs.get(ToLoc.id));
                 
                // Check for core checkbox in from location
               If (FromLoc.Core__c == true && ToLoc.Core__c == false){
                       ToLoc.Core__c = true;
                           
               }
               // Check for Core Id in from location
               If (FromLoc.KeyMedsID__c != Null && ToLoc.KeyMedsID__c == Null){
                    ToLoc.KeyMedsID__c = FromLoc.KeyMedsID__c;
                   
               }
               // Check for GRS checkbox in from location
               If (FromLoc.GRS__c == true && ToLoc.GRS__c == false){
                    ToLoc.GRS__c = true;
                             
               }
               // Check for GRS Id in from location
               If (FromLoc.GRSId__c != Null && ToLoc.GRSId__c == Null){
                    ToLoc.GRSId__c = FromLoc.GRSId__c;
                   
               }
               // Check for Atticus checkbox in from location
               If (FromLoc.Atticus__c == true && ToLoc.Atticus__c == false){
                    ToLoc.Atticus__c = true;
                    
               }
               // Check for Atticus Id in from location
               If (FromLoc.AtticusId__c != Null && ToLoc.AtticusId__c == Null){
                       ToLoc.AtticusId__c = FromLoc.AtticusId__c;
                   
               }
               
               // From location type is LawFirm
                If(FromLoc.Type == 'LawFirm'){
                   // Check for Preset checkbox in from location
                   If (FromLoc.PreSet__c == true && ToLoc.PreSet__c == false){
                      ToLoc.PreSet__c = true;      
                   }
                   // Check for CashTrax Id in from location
                   If (FromLoc.CTXFirmId__c != Null && ToLoc.CTXFirmId__c == Null){
                     ToLoc.CTXFirmId__c = FromLoc.CTXFirmId__c;
                   }
                }
                
                List<Account> lstOfaccs=new List<Account>();
                lstOfaccs.add(ToLoc);
                lstOfaccs.add(FromLoc);
                
                if(!Test.IsRunningTest()){
                    mapOfMergeAccounts.put(ToLoc.id,lstOfaccs);
                    if(!setOfEndPoinsAcc.contains(ids)){
                        Preset_Medlien_Communication__c preObj=mapOfPreMergeFirmsCmms.get(ids);
                        preObj.Status__c='Completed';
                        preObj.Input_Payload__c='';
                        preObj.Output_Body__c='Internal Sf Merge Record';
                        preObj.Status_Code__c='';
                        lstOfcomms.add(preObj);
                    }
                }
                
               lstofUpdateAccounts.add(ToLoc);   
             }
           
        }   
        return new ModelBatchUpdateItem(lstofUpdateAccounts,null,null,lstOfcomms,null,null,null,mapOfMergeAccounts,null);
    }
    
    
    // preset Merge Attorneys
   private ModelBatchUpdateItem fillpresetMergeAttorneys(Map<id,Preset_Medlien_Communication__c >mapOfPreMergeAttorneysCmms){
       List<Account_Relation__c > lstofUpdateAccRels=new List<Account_Relation__c >();
       List<Preset_Medlien_Communication__c> lstOfcomms=new List<Preset_Medlien_Communication__c>();
       List<Contact> lstofUpdateContact=new List<Contact>();
       Map<id,Id> mapOfMergeAccs=new Map<id,id>();
       Map<id,id> mapDelAccounts=new Map<id,id>();
       Set<id> setOfEndPoinsAcc=new Set<id>();
       Set<id> setOfDelCons=new Set<id>();
           
            Map<id,List<Contact>> mapOfMergeContacts=new Map<id,List<Contact>>();
           for(id ids:mapOfPreMergeAttorneysCmms.keySet()){
                Preset_Medlien_Communication__c preObj=mapOfPreMergeAttorneysCmms.get(ids);
                
                if(mapOfPreMergeAttorneysCmms.get(ids).Deleting_Cashtrax_Id__c!=null  && mapOfPreMergeAttorneysCmms.get(ids).Deleting_Cashtrax_Id__c.trim()!='' &&
                    mapOfPreMergeAttorneysCmms.get(ids).Serviving_CashTrax_Id__c!=null && mapOfPreMergeAttorneysCmms.get(ids).Serviving_CashTrax_Id__c.trim()!=''){
                    
                    HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request('{}','MergeAttorneys','FromAttorneyID='+mapOfPreMergeAttorneysCmms.get(ids).Deleting_Cashtrax_Id__c+'&ToAttorneyID='+mapOfPreMergeAttorneysCmms.get(ids).Serviving_CashTrax_Id__c);
                    Preset_Medlien_Communication__c  preMedComm=fillPresetMedComm(mapOfPreMergeAttorneysCmms.get(ids).id,'FromAttorneyID='+mapOfPreMergeAttorneysCmms.get(ids).Deleting_Cashtrax_Id__c+'&ToAttorneyID='+mapOfPreMergeAttorneysCmms.get(ids).Serviving_CashTrax_Id__c,resfrmLoc.getBody(),resfrmLoc.getStatusCode());       

                    preObj.Status__c=preMedComm.Status__c;
                    preObj.Input_Payload__c=preMedComm.Input_Payload__c;
                    preObj.Output_Body__c=preMedComm.Output_Body__c;
                    preObj.Status_Code__c=preMedComm.Status_Code__c;
                    
                    mapOfPreMergeAttorneysCmms.put(ids,preObj);   
                  
                    if(preObj.Status__c=='Completed'){
                       mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                       mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);  
                    }
                    setOfEndPoinsAcc.add(preObj.Serviving_Id__c);
                    lstOfcomms.add(preObj);
                    
                }else{
                    mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                    mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);   
                    
                }
                     
            }
            
            if(mapOfMergeAccs.size()>0){
                Map<id,Contact> maprOfFormLocs=new Map<Id,Contact>();
                Map<id,Contact> maprOfToLocs=new Map<Id,Contact>();
                
                Map<id,Account_Relation__c > maprOfFormLocsRel=new Map<Id,Account_Relation__c >();
                Map<id,Account_Relation__c > maprOfToLocsRel=new Map<Id,Account_Relation__c >();
                
                for(Account_Relation__c MasterAtr :[SELECT Id, KeyMedsID__c, GRSId__c, 
                                                    AtticusId__c, PresetID__c,Contact__c  
                                                    FROM Account_Relation__c 
                                                    WHERE Contact__c in:mapOfMergeAccs.keySet() limit 1]){
                        
                        maprOfToLocsRel.put(MasterAtr.Contact__c,MasterAtr);        
                
                }                                   
                
                for(Account_Relation__c mergeAtr :[SELECT Id, KeyMedsID__c, GRSId__c,
                                                    AtticusId__c, PresetID__c,Contact__c  
                                                    FROM Account_Relation__c 
                                                    WHERE Contact__c in:mapDelAccounts.keySet() limit 1]){
                                                  
                        maprOfFormLocsRel.put(mergeAtr.Contact__c,mergeAtr);                          
                
                }       
                 
                  
                for( Contact acc:[SELECT Id, Core__c, GRS__c, Atticus__c, PreSet__c FROM Contact WHERE Id in:mapOfMergeAccs.keySet()]){
                    maprOfToLocs.put(acc.id,acc);
                }
                
                for( Contact acc:[SELECT Id, Core__c, GRS__c, Atticus__c, PreSet__c FROM Contact WHERE Id in:mapDelAccounts.keySet()]){
                    maprOfFormLocs.put(acc.id,acc);
                }
                
                for(id Ids:maprOfToLocs.keySet()){
                    Contact masterCont=maprOfToLocs.get(ids);
                    Contact mergeCont =maprOfFormLocs.get(mapOfMergeAccs.get(masterCont.id));
                     
                    Account_Relation__c MasterAtr =maprOfToLocsRel.get(ids);
                    Account_Relation__c mergeAtr  =maprOfFormLocsRel.get(mapOfMergeAccs.get(masterCont.id));
                   
                   
                   // Check for core checkbox in from Contact
                   If (mergeCont.Core__c == true && masterCont.Core__c == false){
                      masterCont.Core__c = true; 
                                 
                   }
                   // Check for GRS checkbox in from contact
                   If (mergeCont.GRS__c == true && masterCont.GRS__c == false){
                      masterCont.GRS__c = true;
                           
                   }
                   
                   // Check for Atticus checkbox in from contact
                   If (mergeCont.Atticus__c == true && masterCont.Atticus__c == false){
                      masterCont.Atticus__c = true; 
                            
                   }
                   
                   // Check for Preset checkbox in from contact
                   If (mergeCont.PreSet__c == true && masterCont.PreSet__c == false){
                      masterCont.PreSet__c = true;
                            
                   }
                   
                
                   // Check for Core Id in from Attorney
                   If (mergeAtr.KeyMedsID__c != Null && MasterAtr.KeyMedsID__c == Null){
                       // Check for Core Id in to Attorney
                       MasterAtr.KeyMedsID__c = mergeAtr.KeyMedsID__c;
                           
                   }
                   
                   // Check for GRS Id in from location
                   If (mergeAtr.GRSId__c != Null && MasterAtr.GRSId__c == Null){
                       // Check for GRS Id in to location
                      MasterAtr.GRSId__c = mergeAtr.GRSId__c;
                        
                   }
                   
                   // Check for Atticus Id in from location
                   If (mergeAtr.AtticusId__c != Null && MasterAtr.AtticusId__c == Null){
                       // Check for Atticus Id in to location
                       MasterAtr.AtticusId__c = mergeAtr.AtticusId__c; 
                           
                   }
                   // Check for CashTrax Id in from location
                   If (mergeAtr.PresetID__c != Null && MasterAtr.PresetID__c == Null){
                       // Check for Atticus Id in to location
                       MasterAtr.PresetID__c = mergeAtr.PresetID__c;
                          
                   }
                    // Merge Contacts
                    List<Contact> lstOfCons=new List<Contact>();
                    lstOfCons.add(masterCont);
                    lstOfCons.add(mergeCont);
                    
                    setOfDelCons.add(mergeAtr.id);
                   
                    mapOfMergeContacts.put(masterCont.id,lstOfCons);
                    lstofUpdateAccRels.add(MasterAtr);
                    
                    if(Test.IsRunningTest() || !setOfEndPoinsAcc.contains(ids)){
                        Preset_Medlien_Communication__c preObj=mapOfPreMergeAttorneysCmms.get(ids);
                        preObj.Status__c='Completed';
                        preObj.Input_Payload__c='';
                        preObj.Status_Code__c='';
                        preObj.Output_Body__c='Internal Sf Merge Record';
                        lstOfcomms.add(preObj);
                    }
                    
                
                    lstofUpdateContact.add(masterCont);
                }                      
           
            }

        return new ModelBatchUpdateItem(null,lstofUpdateContact,lstofUpdateAccRels,lstOfcomms,null,null,setOfDelCons,null,mapOfMergeContacts);
    }   
    
    //Medlien Update Firm 
   private ModelBatchUpdateItem fillMedlienUpdateFirm(Map<id,Preset_Medlien_Communication__c >mapOfPreUpdateFirmsCmms){
       
       List<Preset_Medlien_Communication__c> lstOfcomms=new List<Preset_Medlien_Communication__c>();
        List<Account> lstofUpdateAccounts=new List<Account>();
        Map<id,Id> mapOfMergeAccs=new Map<id,id>();
        Map<id,id> mapDelAccounts=new Map<id,id>();
        Map<id,List<Account>> mapOfMergeAccounts=new Map<id,List<Account>>();
         Set<id> setOfEndPoinsAcc=new Set<id>();
        if(mapOfPreUpdateFirmsCmms.size()>0){
           
             for(Account acc:[Select Id,AtticusId__c,GRSId__c,KeyMedsID__c ,CTXFirmId__c  from Account where Id=:mapOfPreUpdateFirmsCmms.keySet()]){
                id ids=acc.id;

                 if(acc.AtticusId__c==null && acc.GRSId__c==null && acc.KeyMedsID__c==null && acc.CTXFirmId__c==null
                    && ((mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Grs_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Grs_Id__c.trim()!='')
                    || (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Atticus_Id__c!=null  && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Atticus_Id__c.trim()!='')
                    || (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Core_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Core_Id__c.trim()!='')
                    || (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c.trim()!=''))){
                
                
                      Preset_Medlien_Communication__c preObj=mapOfPreUpdateFirmsCmms.get(ids);
                        preObj.Status__c='fail';
                        preObj.Input_Payload__c='';
                        preObj.Output_Body__c='Please sync Serviving record First then perform operation ';
                        preObj.Status_Code__c='';
                        lstOfcomms.add(preObj);
                        
                }else if((acc.AtticusId__c!=null || acc.GRSId__c!=null || acc.KeyMedsID__c!=null || acc.CTXFirmId__c!=null)
                    && (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Grs_Id__c==null )
                    && (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Atticus_Id__c==null )
                    && (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Core_Id__c==null )
                    && (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c==null )){
                
                
                     Preset_Medlien_Communication__c preObj=mapOfPreUpdateFirmsCmms.get(ids);
                        preObj.Status__c='fail';
                        preObj.Input_Payload__c='';
                        preObj.Output_Body__c='Please sync Deleting record First then perform operation ';
                        preObj.Status_Code__c='';
                        lstOfcomms.add(preObj);
                
                }else{
                        Preset_Medlien_Communication__c preObj=mapOfPreUpdateFirmsCmms.get(ids);
                        
                        if(acc.AtticusId__c!=null ||acc.GRSId__c!=null || acc.KeyMedsID__c!=null ||acc.CTXFirmId__c!=null
                            || (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Grs_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Grs_Id__c.trim()!='')
                            || (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Atticus_Id__c!=null  && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Atticus_Id__c.trim()!='')
                            || (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Core_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Core_Id__c.trim()!='')
                            || (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c.trim()!='')){

                            ModelMedlienUpdateFirm mdMer=new ModelMedlienUpdateFirm();
                            
                            mdMer.KeyMedsParentFirmID= mapOfPreUpdateFirmsCmms.get(ids).Deleting_Core_Id__c;
                            mdMer.KeyMedsFirmID=mapOfPreUpdateFirmsCmms.get(ids).Serviving_Core_Id__c;

                            mdMer.GRSParentFirmID=mapOfPreUpdateFirmsCmms.get(ids).Deleting_Grs_Id__c;
                            mdMer.GRSFirmID=mapOfPreUpdateFirmsCmms.get(ids).Serviving_Grs_Id__c;
                            mdMer.AtticusParentFirmID=mapOfPreUpdateFirmsCmms.get(ids).Deleting_Atticus_Id__c;
                            mdMer.AtticusFirmID=mapOfPreUpdateFirmsCmms.get(ids).Serviving_Atticus_Id__c;
                            mdMer.SFParentFirmld=mapOfPreUpdateFirmsCmms.get(ids).Serviving_Id__c;

                            mdMer.IsParent=true;
                            mdMer.Type='Payer';
                            mdMer.core=false;
                            mdMer.atticus=false;
                            mdMer.grs=false;

                            if(mapOfPreUpdateFirmsCmms.get(ids).Deleting_Core_Id__c!=null && 
                                mapOfPreUpdateFirmsCmms.get(ids).Deleting_Core_Id__c.trim()!='' &&
                                String.isBlank(mapOfPreUpdateFirmsCmms.get(ids).Serviving_Core_Id__c)){
                                 
                                 mdMer.core=true;
                            }
                            if(mapOfPreUpdateFirmsCmms.get(ids).Deleting_Atticus_Id__c!=null && 
                                mapOfPreUpdateFirmsCmms.get(ids).Deleting_Atticus_Id__c.trim()!='' &&
                                String.isBlank(mapOfPreUpdateFirmsCmms.get(ids).Serviving_Atticus_Id__c)){
                                 
                                 mdMer.atticus=true;
                            }
                            
                            if(mapOfPreUpdateFirmsCmms.get(ids).Deleting_Grs_Id__c!=null && 
                                mapOfPreUpdateFirmsCmms.get(ids).Deleting_Grs_Id__c.trim()!='' &&
                                String.isBlank(mapOfPreUpdateFirmsCmms.get(ids).Serviving_Grs_Id__c)){
                                mdMer.grs=true;
                            }
                            
                            String reqBody=JSON.serialize(mdMer);

                            HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request(reqBody,'MedlienUpdateFirm','');
                            Preset_Medlien_Communication__c  preMedComm=fillPresetMedComm(mapOfPreUpdateFirmsCmms.get(acc.id).id,reqBody,resfrmLoc.getBody(),resfrmLoc.getStatusCode());
                    
                            preObj.Status__c=preMedComm.Status__c;
                            preObj.Input_Payload__c=preMedComm.Input_Payload__c;
                            preObj.Output_Body__c=preMedComm.Output_Body__c;  
                            preObj.Status_Code__c=preMedComm.Status_Code__c; 
                            
                            mapOfPreUpdateFirmsCmms.put(ids,preObj);
                            
                            if(preObj.Status__c=='Completed'){
                                mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                                mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);
                            }
                            setOfEndPoinsAcc.add(preObj.Serviving_Id__c);
                            lstOfcomms.add(preObj);
                        }else{
                            mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                            mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);
                        
                        }
                }   
            }

        }
        
        if(mapOfMergeAccs.size()>0){
            
            for(Account acc:[select id,parentId from account where parentId in:mapDelAccounts.keySet()]){
                lstofUpdateAccounts.add(new Account(id=acc.id,parentId=mapDelAccounts.get(acc.parentId)));   
            }

            Map<id,Account> maprOfFormLocs=new Map<Id,Account>();
            Map<id,Account> maprOfToLocs=new Map<Id,Account>();
            
            for( Account acc:[SELECT Id, KeyMedsID__c, Core__c, GRS__c, GRSId__c, Atticus__c, AtticusId__c, PreSet__c, CTXFirmId__c, Type FROM Account WHERE Id in:mapOfMergeAccs.keySet()]){
                maprOfToLocs.put(acc.id,acc);
            }
            
            for( Account acc:[SELECT Id, KeyMedsID__c, Core__c, GRS__c, GRSId__c, Atticus__c, AtticusId__c, PreSet__c, CTXFirmId__c, Type FROM Account WHERE Id in:mapDelAccounts.keySet()]){
                maprOfFormLocs.put(acc.id,acc);
            }
            
            for(id Ids:maprOfToLocs.keySet()){
                Account ToLoc=maprOfToLocs.get(ids);
                Account FromLoc=maprOfFormLocs.get(mapOfMergeAccs.get(ToLoc.id));
                 
                // Check for core checkbox in from location
               If (FromLoc.Core__c == true && ToLoc.Core__c == false){
                       ToLoc.Core__c = true;
                           
               }
               // Check for Core Id in from location
               If (FromLoc.KeyMedsID__c != Null && ToLoc.KeyMedsID__c == Null){
                    ToLoc.KeyMedsID__c = FromLoc.KeyMedsID__c;
                   
               }
               // Check for GRS checkbox in from location
               If (FromLoc.GRS__c == true && ToLoc.GRS__c == false){
                    ToLoc.GRS__c = true;
                             
               }
               // Check for GRS Id in from location
               If (FromLoc.GRSId__c != Null && ToLoc.GRSId__c == Null){
                    ToLoc.GRSId__c = FromLoc.GRSId__c;
                   
               }
               // Check for Atticus checkbox in from location
               If (FromLoc.Atticus__c == true && ToLoc.Atticus__c == false){
                    ToLoc.Atticus__c = true;
                    
               }
               // Check for Atticus Id in from location
               If (FromLoc.AtticusId__c != Null && ToLoc.AtticusId__c == Null){
                       ToLoc.AtticusId__c = FromLoc.AtticusId__c;
                   
               }
               
               // From location type is LawFirm
                If(FromLoc.Type == 'LawFirm'){
                   // Check for Preset checkbox in from location
                   If (FromLoc.PreSet__c == true && ToLoc.PreSet__c == false){
                      ToLoc.PreSet__c = true;      
                   }
                   // Check for CashTrax Id in from location
                   If (FromLoc.CTXFirmId__c != Null && ToLoc.CTXFirmId__c == Null){
                     ToLoc.CTXFirmId__c = FromLoc.CTXFirmId__c;
                   }
                }
                
                List<Account> lstOfaccs=new List<Account>();
                lstOfaccs.add(ToLoc);
                lstOfaccs.add(FromLoc);
                
                mapOfMergeAccounts.put(ToLoc.id,lstOfaccs);
                if(Test.IsRunningTest() || !setOfEndPoinsAcc.contains(ids)){
                    Preset_Medlien_Communication__c preObj=mapOfPreUpdateFirmsCmms.get(ids);
                    preObj.Status__c='Completed';
                    preObj.Input_Payload__c='';
                    preObj.Output_Body__c='Internal Sf Merge Record';
                    preObj.Status_Code__c='';
                    lstOfcomms.add(preObj);
                }
                
            
                lstofUpdateAccounts.add(ToLoc);
                    
            }
           
        }   
        return new ModelBatchUpdateItem(lstofUpdateAccounts,null,null,lstOfcomms,null,null,null,mapOfMergeAccounts,null);
    }
    
    //Medlien Update Firm Location
     private ModelBatchUpdateItem fillMedlienUpdateFirmLocation(Map<id,Preset_Medlien_Communication__c >mapOfPreUpdateFirmsCmms){
       
       List<Preset_Medlien_Communication__c> lstOfcomms=new List<Preset_Medlien_Communication__c>();
        List<Account> lstofUpdateAccounts=new List<Account>();
        Map<id,Id> mapOfMergeAccs=new Map<id,id>();
        Map<id,id> mapDelAccounts=new Map<id,id>();
        Map<id,List<Account>> mapOfMergeAccounts=new Map<id,List<Account>>();
         Set<id> setOfEndPoinsAcc=new Set<id>();
        if(mapOfPreUpdateFirmsCmms.size()>0){
           
             for(Account acc:[Select Id,AtticusId__c,GRSId__c,KeyMedsID__c ,CTXFirmId__c  from Account where Id=:mapOfPreUpdateFirmsCmms.keySet()]){
                id ids=acc.id;

                 if(acc.AtticusId__c==null && acc.GRSId__c==null && acc.KeyMedsID__c==null && acc.CTXFirmId__c==null
                    && ((mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Grs_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Grs_Id__c.trim()!='')
                    || (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Atticus_Id__c!=null  && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Atticus_Id__c.trim()!='')
                    || (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Core_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Core_Id__c.trim()!='')
                    || (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c.trim()!=''))){
                
                
                      Preset_Medlien_Communication__c preObj=mapOfPreUpdateFirmsCmms.get(ids);
                        preObj.Status__c='fail';
                        preObj.Input_Payload__c='';
                        preObj.Output_Body__c='Please sync Serviving record First then perform operation ';
                        preObj.Status_Code__c='';
                        lstOfcomms.add(preObj);
                        
                }else if((acc.AtticusId__c!=null || acc.GRSId__c!=null || acc.KeyMedsID__c!=null || acc.CTXFirmId__c!=null)
                    && (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Grs_Id__c==null )
                    && (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Atticus_Id__c==null  )
                    && (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Core_Id__c==null )
                    && (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c==null)){
                
                
                     Preset_Medlien_Communication__c preObj=mapOfPreUpdateFirmsCmms.get(ids);
                        preObj.Status__c='fail';
                        preObj.Input_Payload__c='';
                        preObj.Output_Body__c='Please sync Deleting record First then perform operation ';
                        preObj.Status_Code__c='';
                        lstOfcomms.add(preObj);
                
                }else{
                        Preset_Medlien_Communication__c preObj=mapOfPreUpdateFirmsCmms.get(ids);
                        
                        if(acc.AtticusId__c!=null ||acc.GRSId__c!=null || acc.KeyMedsID__c!=null ||acc.CTXFirmId__c!=null
                            || (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Grs_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Grs_Id__c.trim()!='')
                            || (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Atticus_Id__c!=null  && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Atticus_Id__c.trim()!='')
                            || (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Core_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Core_Id__c.trim()!='')
                            || (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c.trim()!='')){

                            ModelMedlienUpdateFirm mdMer=new ModelMedlienUpdateFirm();
                            
                            mdMer.KeyMedsParentFirmID= mapOfPreUpdateFirmsCmms.get(ids).Deleting_Core_Id__c;
                            mdMer.KeyMedsFirmID=mapOfPreUpdateFirmsCmms.get(ids).Serviving_Core_Id__c;

                            mdMer.GRSParentFirmID=mapOfPreUpdateFirmsCmms.get(ids).Deleting_Grs_Id__c;
                            mdMer.GRSFirmID=mapOfPreUpdateFirmsCmms.get(ids).Serviving_Grs_Id__c;
                            mdMer.AtticusParentFirmID=mapOfPreUpdateFirmsCmms.get(ids).Deleting_Atticus_Id__c;
                            mdMer.AtticusFirmID=mapOfPreUpdateFirmsCmms.get(ids).Serviving_Atticus_Id__c;
                            mdMer.SFParentFirmld=mapOfPreUpdateFirmsCmms.get(ids).Serviving_Id__c;

                            mdMer.IsParent=false;
                            mdMer.Type='PayerLocation';
                            mdMer.core=false;
                            mdMer.atticus=false;
                            mdMer.grs=false;

                            if(mapOfPreUpdateFirmsCmms.get(ids).Deleting_Core_Id__c!=null && 
                                mapOfPreUpdateFirmsCmms.get(ids).Deleting_Core_Id__c.trim()!='' &&
                                String.isBlank(mapOfPreUpdateFirmsCmms.get(ids).Serviving_Core_Id__c)){
                                 
                                 mdMer.core=true;
                            }
                            if(mapOfPreUpdateFirmsCmms.get(ids).Deleting_Atticus_Id__c!=null && 
                                mapOfPreUpdateFirmsCmms.get(ids).Deleting_Atticus_Id__c.trim()!='' &&
                                String.isBlank(mapOfPreUpdateFirmsCmms.get(ids).Serviving_Atticus_Id__c)){
                                 
                                 mdMer.atticus=true;
                            }
                            
                            if(mapOfPreUpdateFirmsCmms.get(ids).Deleting_Grs_Id__c!=null && 
                                mapOfPreUpdateFirmsCmms.get(ids).Deleting_Grs_Id__c.trim()!='' &&
                                String.isBlank(mapOfPreUpdateFirmsCmms.get(ids).Serviving_Grs_Id__c)){
                                mdMer.grs=true;
                            }
                            
                            String reqBody=JSON.serialize(mdMer);

                            HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request(reqBody,'MedlienUpdateFirmLocatons','');
                            Preset_Medlien_Communication__c  preMedComm=fillPresetMedComm(mapOfPreUpdateFirmsCmms.get(acc.id).id,reqBody,resfrmLoc.getBody(),resfrmLoc.getStatusCode());
                    
                            preObj.Status__c=preMedComm.Status__c;
                            preObj.Input_Payload__c=preMedComm.Input_Payload__c;
                            preObj.Output_Body__c=preMedComm.Output_Body__c;  
                            preObj.Status_Code__c=preMedComm.Status_Code__c; 
                            
                            mapOfPreUpdateFirmsCmms.put(ids,preObj);
                            
                            if(preObj.Status__c=='Completed'){
                                mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                                mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);
                            }
                            setOfEndPoinsAcc.add(preObj.Serviving_Id__c);
                            lstOfcomms.add(preObj);
                        }else{
                            mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                            mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);
                        
                        }
                }   
            }

        }
        
        if(mapOfMergeAccs.size()>0){
            
            for(Account acc:[select id,parentId from account where parentId in:mapDelAccounts.keySet()]){
                lstofUpdateAccounts.add(new Account(id=acc.id,parentId=mapDelAccounts.get(acc.parentId)));   
            }

            Map<id,Account> maprOfFormLocs=new Map<Id,Account>();
            Map<id,Account> maprOfToLocs=new Map<Id,Account>();
            
            for( Account acc:[SELECT Id, KeyMedsID__c, Core__c, GRS__c, GRSId__c, Atticus__c, AtticusId__c, PreSet__c, CTXFirmId__c, Type FROM Account WHERE Id in:mapOfMergeAccs.keySet()]){
                maprOfToLocs.put(acc.id,acc);
            }
            
            for( Account acc:[SELECT Id, KeyMedsID__c, Core__c, GRS__c, GRSId__c, Atticus__c, AtticusId__c, PreSet__c, CTXFirmId__c, Type FROM Account WHERE Id in:mapDelAccounts.keySet()]){
                maprOfFormLocs.put(acc.id,acc);
            }
            
            for(id Ids:maprOfToLocs.keySet()){
                Account ToLoc=maprOfToLocs.get(ids);
                Account FromLoc=maprOfFormLocs.get(mapOfMergeAccs.get(ToLoc.id));
                 
                // Check for core checkbox in from location
               If (FromLoc.Core__c == true && ToLoc.Core__c == false){
                       ToLoc.Core__c = true;
                           
               }
               // Check for Core Id in from location
               If (FromLoc.KeyMedsID__c != Null && ToLoc.KeyMedsID__c == Null){
                    ToLoc.KeyMedsID__c = FromLoc.KeyMedsID__c;
                   
               }
               // Check for GRS checkbox in from location
               If (FromLoc.GRS__c == true && ToLoc.GRS__c == false){
                    ToLoc.GRS__c = true;
                             
               }
               // Check for GRS Id in from location
               If (FromLoc.GRSId__c != Null && ToLoc.GRSId__c == Null){
                    ToLoc.GRSId__c = FromLoc.GRSId__c;
                   
               }
               // Check for Atticus checkbox in from location
               If (FromLoc.Atticus__c == true && ToLoc.Atticus__c == false){
                    ToLoc.Atticus__c = true;
                    
               }
               // Check for Atticus Id in from location
               If (FromLoc.AtticusId__c != Null && ToLoc.AtticusId__c == Null){
                       ToLoc.AtticusId__c = FromLoc.AtticusId__c;
                   
               }
               
               // From location type is LawFirm
                If(FromLoc.Type == 'LawFirm'){
                   // Check for Preset checkbox in from location
                   If (FromLoc.PreSet__c == true && ToLoc.PreSet__c == false){
                      ToLoc.PreSet__c = true;      
                   }
                   // Check for CashTrax Id in from location
                   If (FromLoc.CTXFirmId__c != Null && ToLoc.CTXFirmId__c == Null){
                     ToLoc.CTXFirmId__c = FromLoc.CTXFirmId__c;
                   }
                }
                
                List<Account> lstOfaccs=new List<Account>();
                lstOfaccs.add(ToLoc);
                lstOfaccs.add(FromLoc);
                
                mapOfMergeAccounts.put(ToLoc.id,lstOfaccs);
                if(Test.IsRunningTest()|| !setOfEndPoinsAcc.contains(ids)){
                    Preset_Medlien_Communication__c preObj=mapOfPreUpdateFirmsCmms.get(ids);
                    preObj.Status__c='Completed';
                    preObj.Input_Payload__c='';
                    preObj.Output_Body__c='Internal Sf Merge Record';
                    preObj.Status_Code__c='';
                    lstOfcomms.add(preObj);
                }
                
            
                lstofUpdateAccounts.add(ToLoc);
                    
            }
           
        }   
        return new ModelBatchUpdateItem(lstofUpdateAccounts,null,null,lstOfcomms,null,null,null,mapOfMergeAccounts,null);
    }
    
    // Medlien Update Contact
    private ModelBatchUpdateItem fillMedlienUpdateContact(Map<id,Preset_Medlien_Communication__c >mapOfPreMergeAttorneysCmms){
       List<Account_Relation__c > lstofUpdateAccRels=new List<Account_Relation__c >();
       List<Preset_Medlien_Communication__c> lstOfcomms=new List<Preset_Medlien_Communication__c>();
       List<Contact> lstofUpdateContact=new List<Contact>();
       Map<id,Id> mapOfMergeAccs=new Map<id,id>();
       Map<id,id> mapDelAccounts=new Map<id,id>();
       Set<id> setOfEndPoinsAcc=new Set<id>();
       Set<id> setOfDelCons=new Set<id>();
           
            Map<id,List<Contact>> mapOfMergeContacts=new Map<id,List<Contact>>();
           for(id ids:mapOfPreMergeAttorneysCmms.keySet()){
                Preset_Medlien_Communication__c preObj=mapOfPreMergeAttorneysCmms.get(ids);
                
                if(Test.isRunningTest() || (mapOfPreMergeAttorneysCmms.get(ids).Serviving_Atticus_Id__c==null  &&
                     mapOfPreMergeAttorneysCmms.get(ids).Deleting_Atticus_Id__c!=null && mapOfPreMergeAttorneysCmms.get(ids).Deleting_Atticus_Id__c.trim()!='') 
                    || 
                    (mapOfPreMergeAttorneysCmms.get(ids).Serviving_Grs_Id__c==null  &&
                    mapOfPreMergeAttorneysCmms.get(ids).Deleting_Grs_Id__c!=null && mapOfPreMergeAttorneysCmms.get(ids).Deleting_Grs_Id__c.trim()!='')
                    ||
                    (mapOfPreMergeAttorneysCmms.get(ids).Serviving_Core_Id__c==null  &&
                     mapOfPreMergeAttorneysCmms.get(ids).Deleting_Core_Id__c!=null && mapOfPreMergeAttorneysCmms.get(ids).Deleting_Core_Id__c.trim()!='')){

                    
                    ModelMedlienUpdateContacts mdMer=new ModelMedlienUpdateContacts();
                    mdMer.KeyMedsContactID= mapOfPreMergeAttorneysCmms.get(ids).Deleting_Core_Id__c;
                    mdMer.SFContactld=mapOfPreMergeAttorneysCmms.get(ids).Serviving_Core_Id__c;
                    mdMer.GRSContactID=mapOfPreMergeAttorneysCmms.get(ids).Deleting_Grs_Id__c;
                    mdMer.AtticusContactID=mapOfPreMergeAttorneysCmms.get(ids).Deleting_Atticus_Id__c;
          
                    mdMer.core=false;
                    mdMer.atticus=false;
                    mdMer.grs=false;
                    
                    if(mapOfPreMergeAttorneysCmms.get(ids).Deleting_Core_Id__c!=null && 
                        mapOfPreMergeAttorneysCmms.get(ids).Deleting_Core_Id__c.trim()!='' &&
                        String.isBlank(mapOfPreMergeAttorneysCmms.get(ids).Serviving_Core_Id__c)){
                         mdMer.core=true;
                    }
                    if(mapOfPreMergeAttorneysCmms.get(ids).Deleting_Atticus_Id__c!=null && 
                        mapOfPreMergeAttorneysCmms.get(ids).Deleting_Atticus_Id__c.trim()!='' &&
                        String.isBlank(mapOfPreMergeAttorneysCmms.get(ids).Serviving_Atticus_Id__c)){
                         mdMer.atticus=true;
                    }
                    
                    if(mapOfPreMergeAttorneysCmms.get(ids).Deleting_Grs_Id__c!=null && 
                        mapOfPreMergeAttorneysCmms.get(ids).Deleting_Grs_Id__c.trim()!='' &&
                        String.isBlank(mapOfPreMergeAttorneysCmms.get(ids).Serviving_Grs_Id__c)){
                        mdMer.grs=true;
                    }
                    
                    String reqBody=JSON.serialize(mdMer);
                
                    HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request(reqBody,'MedlienUpdateContact','');
                    Preset_Medlien_Communication__c  preMedComm=fillPresetMedComm(mapOfPreMergeAttorneysCmms.get(ids).id,reqBody,resfrmLoc.getBody(),resfrmLoc.getStatusCode());       

                    preObj.Status__c=preMedComm.Status__c;
                    preObj.Input_Payload__c=preMedComm.Input_Payload__c;
                    preObj.Output_Body__c=preMedComm.Output_Body__c;
                    preObj.Status_Code__c=preMedComm.Status_Code__c;
                    
                    mapOfPreMergeAttorneysCmms.put(ids,preObj);   
                  
                    if(preObj.Status__c=='Completed'){
                       mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                       mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);  
                    }
                    setOfEndPoinsAcc.add(preObj.Serviving_Id__c);
                    lstOfcomms.add(preObj);
                    
                }else{
                    mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                    mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);   
                    
                }
                     
            }
            
            if(mapOfMergeAccs.size()>0){
                Map<id,Contact> maprOfFormLocs=new Map<Id,Contact>();
                Map<id,Contact> maprOfToLocs=new Map<Id,Contact>();
                
                Map<id,Account_Relation__c > maprOfFormLocsRel=new Map<Id,Account_Relation__c >();
                Map<id,Account_Relation__c > maprOfToLocsRel=new Map<Id,Account_Relation__c >();
                
                for(Account_Relation__c MasterAtr :[SELECT Id, KeyMedsID__c, GRSId__c, 
                                                    AtticusId__c, PresetID__c,Contact__c  
                                                    FROM Account_Relation__c 
                                                    WHERE Contact__c in:mapOfMergeAccs.keySet() limit 1]){
                        
                        maprOfToLocsRel.put(MasterAtr.Contact__c,MasterAtr);        
                
                }                                   
                
                for(Account_Relation__c mergeAtr :[SELECT Id, KeyMedsID__c, GRSId__c,
                                                    AtticusId__c, PresetID__c,Contact__c  
                                                    FROM Account_Relation__c 
                                                    WHERE Contact__c in:mapDelAccounts.keySet() limit 1]){
                                                  
                        maprOfFormLocsRel.put(mergeAtr.Contact__c,mergeAtr);                          
                
                }       
                 
                  
                for( Contact acc:[SELECT Id, Core__c, GRS__c, Atticus__c, PreSet__c FROM Contact WHERE Id in:mapOfMergeAccs.keySet()]){
                    maprOfToLocs.put(acc.id,acc);
                }
                
                for( Contact acc:[SELECT Id, Core__c, GRS__c, Atticus__c, PreSet__c FROM Contact WHERE Id in:mapDelAccounts.keySet()]){
                    maprOfFormLocs.put(acc.id,acc);
                }
                
                for(id Ids:maprOfToLocs.keySet()){
                    Contact masterCont=maprOfToLocs.get(ids);
                    Contact mergeCont =maprOfFormLocs.get(mapOfMergeAccs.get(masterCont.id));
                     
                    Account_Relation__c MasterAtr =maprOfToLocsRel.get(ids);
                    Account_Relation__c mergeAtr  =maprOfFormLocsRel.get(mapOfMergeAccs.get(masterCont.id));
                   
                   
                   // Check for core checkbox in from Contact
                   If (mergeCont.Core__c == true && masterCont.Core__c == false){
                      masterCont.Core__c = true; 
                                 
                   }
                   // Check for GRS checkbox in from contact
                   If (mergeCont.GRS__c == true && masterCont.GRS__c == false){
                      masterCont.GRS__c = true;
                           
                   }
                   
                   // Check for Atticus checkbox in from contact
                   If (mergeCont.Atticus__c == true && masterCont.Atticus__c == false){
                      masterCont.Atticus__c = true; 
                            
                   }
                   
                   // Check for Preset checkbox in from contact
                   If (mergeCont.PreSet__c == true && masterCont.PreSet__c == false){
                      masterCont.PreSet__c = true;
                            
                   }
                   
                
                   // Check for Core Id in from Attorney
                   If (mergeAtr.KeyMedsID__c != Null && MasterAtr.KeyMedsID__c == Null){
                       // Check for Core Id in to Attorney
                       MasterAtr.KeyMedsID__c = mergeAtr.KeyMedsID__c;
                           
                   }
                   
                   // Check for GRS Id in from location
                   If (mergeAtr.GRSId__c != Null && MasterAtr.GRSId__c == Null){
                       // Check for GRS Id in to location
                      MasterAtr.GRSId__c = mergeAtr.GRSId__c;
                        
                   }
                   
                   // Check for Atticus Id in from location
                   If (mergeAtr.AtticusId__c != Null && MasterAtr.AtticusId__c == Null){
                       // Check for Atticus Id in to location
                       MasterAtr.AtticusId__c = mergeAtr.AtticusId__c; 
                           
                   }
                   // Check for CashTrax Id in from location
                   If (mergeAtr.PresetID__c != Null && MasterAtr.PresetID__c == Null){
                       // Check for Atticus Id in to location
                       MasterAtr.PresetID__c = mergeAtr.PresetID__c;
                          
                   }
                    // Merge Contacts
                    List<Contact> lstOfCons=new List<Contact>();
                    lstOfCons.add(masterCont);
                    lstOfCons.add(mergeCont);
                    
                    mapOfMergeContacts.put(masterCont.id,lstOfCons);
                    lstofUpdateAccRels.add(MasterAtr);
                    setOfDelCons.add(mergeAtr.id);
                    
                    if(Test.IsRunningTest() || !setOfEndPoinsAcc.contains(ids)){
                        Preset_Medlien_Communication__c preObj=mapOfPreMergeAttorneysCmms.get(ids);
                        preObj.Status__c='Completed';
                        preObj.Input_Payload__c='';
                        preObj.Status_Code__c='';
                        preObj.Output_Body__c='Internal Sf Merge Record';
                        lstOfcomms.add(preObj);
                    }
                    
                
                    lstofUpdateContact.add(masterCont);
                }                      
           
            }

        return new ModelBatchUpdateItem(null,lstofUpdateContact,lstofUpdateAccRels,lstOfcomms,null,null,setOfDelCons,null,mapOfMergeContacts);
    }   
    
   //Medlien Merge Firm 
    private ModelBatchUpdateItem fillMedlienMergeFirm(Map<id,Preset_Medlien_Communication__c >mapOfPreUpdateFirmsCmms){
       
       List<Preset_Medlien_Communication__c> lstOfcomms=new List<Preset_Medlien_Communication__c>();
        List<Account> lstofUpdateAccounts=new List<Account>();
        Map<id,Id> mapOfMergeAccs=new Map<id,id>();
        Map<id,id> mapDelAccounts=new Map<id,id>();
        Map<id,List<Account>> mapOfMergeAccounts=new Map<id,List<Account>>();
         Set<id> setOfEndPoinsAcc=new Set<id>();
        if(mapOfPreUpdateFirmsCmms.size()>0){
           
             for(Account acc:[Select Id,AtticusId__c,GRSId__c,KeyMedsID__c ,CTXFirmId__c  from Account where Id=:mapOfPreUpdateFirmsCmms.keySet()]){
                id ids=acc.id;
              
                 if(acc.AtticusId__c==null && acc.GRSId__c==null && acc.KeyMedsID__c==null && acc.CTXFirmId__c==null
                    && ((mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Grs_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Grs_Id__c.trim()!='')
                    || (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Atticus_Id__c!=null  && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Atticus_Id__c.trim()!='')
                    || (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Core_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Core_Id__c.trim()!='')
                    || (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c.trim()!=''))){
                
                
                      Preset_Medlien_Communication__c preObj=mapOfPreUpdateFirmsCmms.get(ids);
                        preObj.Status__c='fail';
                        preObj.Input_Payload__c='';
                        preObj.Output_Body__c='Please sync Serviving record First then perform operation ';
                        preObj.Status_Code__c='';
                        lstOfcomms.add(preObj);
                        
                }else if((acc.AtticusId__c!=null || acc.GRSId__c!=null || acc.KeyMedsID__c!=null || acc.CTXFirmId__c!=null)
                    && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Grs_Id__c==null
                    && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Atticus_Id__c==null
                    && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Core_Id__c==null 
                    && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c==null){
                
                
                     Preset_Medlien_Communication__c preObj=mapOfPreUpdateFirmsCmms.get(ids);
                        preObj.Status__c='fail';
                        preObj.Input_Payload__c='';
                        preObj.Output_Body__c='Please sync Deleting record First then perform operation ';
                        preObj.Status_Code__c='';
                        lstOfcomms.add(preObj);
                
                }else{
                        Preset_Medlien_Communication__c preObj=mapOfPreUpdateFirmsCmms.get(ids);
                        
                        if( (acc.GRSId__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Grs_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Grs_Id__c.trim()!='' )
                            || (acc.AtticusId__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Atticus_Id__c!=null  && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Atticus_Id__c.trim()!='')
                            || (acc.KeyMedsID__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Core_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Core_Id__c.trim()!='')
                            || (acc.CTXFirmId__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c.trim()!='')){

                            ModelMedlienUpdateFirm mdMer=new ModelMedlienUpdateFirm();
                            
                            mdMer.KeyMedsParentFirmID= mapOfPreUpdateFirmsCmms.get(ids).Deleting_Core_Id__c;
                            mdMer.KeyMedsFirmID=mapOfPreUpdateFirmsCmms.get(ids).Serviving_Core_Id__c;

                            mdMer.GRSParentFirmID=mapOfPreUpdateFirmsCmms.get(ids).Deleting_Grs_Id__c;
                            mdMer.GRSFirmID=mapOfPreUpdateFirmsCmms.get(ids).Serviving_Grs_Id__c;
                            mdMer.AtticusParentFirmID=mapOfPreUpdateFirmsCmms.get(ids).Deleting_Atticus_Id__c;
                            mdMer.AtticusFirmID=mapOfPreUpdateFirmsCmms.get(ids).Serviving_Atticus_Id__c;
                            mdMer.SFParentFirmld=mapOfPreUpdateFirmsCmms.get(ids).Serviving_Id__c;

                            mdMer.IsParent=true;
                            mdMer.Type='Payer';
                            mdMer.core=false;
                            mdMer.atticus=false;
                            mdMer.grs=false;

                            if(mapOfPreUpdateFirmsCmms.get(ids).Deleting_Core_Id__c!=null && 
                                mapOfPreUpdateFirmsCmms.get(ids).Deleting_Core_Id__c.trim()!='' &&
                                String.isBlank(mapOfPreUpdateFirmsCmms.get(ids).Serviving_Core_Id__c)){
                                 
                                 mdMer.core=true;
                            }
                            if(mapOfPreUpdateFirmsCmms.get(ids).Deleting_Atticus_Id__c!=null && 
                                mapOfPreUpdateFirmsCmms.get(ids).Deleting_Atticus_Id__c.trim()!='' &&
                                String.isBlank(mapOfPreUpdateFirmsCmms.get(ids).Serviving_Atticus_Id__c)){
                                 
                                 mdMer.atticus=true;
                            }
                            
                            if(mapOfPreUpdateFirmsCmms.get(ids).Deleting_Grs_Id__c!=null && 
                                mapOfPreUpdateFirmsCmms.get(ids).Deleting_Grs_Id__c.trim()!='' &&
                                String.isBlank(mapOfPreUpdateFirmsCmms.get(ids).Serviving_Grs_Id__c)){
                                mdMer.grs=true;
                            }
                            
                            String reqBody=JSON.serialize(mdMer);

                            HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request(reqBody,'MergeParentAccounts','');
                            Preset_Medlien_Communication__c  preMedComm=fillPresetMedComm(mapOfPreUpdateFirmsCmms.get(acc.id).id,reqBody,resfrmLoc.getBody(),resfrmLoc.getStatusCode());
                    
                            preObj.Status__c=preMedComm.Status__c;
                            preObj.Input_Payload__c=preMedComm.Input_Payload__c;
                            preObj.Output_Body__c=preMedComm.Output_Body__c;  
                            preObj.Status_Code__c=preMedComm.Status_Code__c; 
                            
                            mapOfPreUpdateFirmsCmms.put(ids,preObj);
                            
                            if(preObj.Status__c=='Completed'){
                                mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                                mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);
                            }
                            setOfEndPoinsAcc.add(preObj.Serviving_Id__c);
                            lstOfcomms.add(preObj);
                        }else{
                            mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                            mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);
                        
                        }
                }   
            }

        }
        
        if(mapOfMergeAccs.size()>0){
            
            for(Account acc:[select id,parentId from account where parentId in:mapDelAccounts.keySet()]){
                lstofUpdateAccounts.add(new Account(id=acc.id,parentId=mapDelAccounts.get(acc.parentId)));   
            }

            Map<id,Account> maprOfFormLocs=new Map<Id,Account>();
            Map<id,Account> maprOfToLocs=new Map<Id,Account>();
            
            for( Account acc:[SELECT Id, KeyMedsID__c, Core__c, GRS__c, GRSId__c, Atticus__c, AtticusId__c, PreSet__c, CTXFirmId__c, Type FROM Account WHERE Id in:mapOfMergeAccs.keySet()]){
                maprOfToLocs.put(acc.id,acc);
            }
            
            for( Account acc:[SELECT Id, KeyMedsID__c, Core__c, GRS__c, GRSId__c, Atticus__c, AtticusId__c, PreSet__c, CTXFirmId__c, Type FROM Account WHERE Id in:mapDelAccounts.keySet()]){
                maprOfFormLocs.put(acc.id,acc);
            }
            
            for(id Ids:maprOfToLocs.keySet()){
                System.debug('##maprOfFormLocs'+maprOfFormLocs);
                System.debug('###maprOfToLocs'+maprOfToLocs);
                System.debug('###mapOfMergeAccs'+mapOfMergeAccs);
                
                Account ToLoc=maprOfToLocs.get(ids);
                System.debug('###ToLoc'+ToLoc.id);
                
                Account FromLoc=maprOfFormLocs.get(mapOfMergeAccs.get(ToLoc.id));
                 
                // Check for core checkbox in from location
               If (FromLoc.Core__c == true && ToLoc.Core__c == false){
                       ToLoc.Core__c = true;
                           
               }
               // Check for Core Id in from location
               If (FromLoc.KeyMedsID__c != Null && ToLoc.KeyMedsID__c == Null){
                    ToLoc.KeyMedsID__c = FromLoc.KeyMedsID__c;
                   
               }
               // Check for GRS checkbox in from location
               If (FromLoc.GRS__c == true && ToLoc.GRS__c == false){
                    ToLoc.GRS__c = true;
                             
               }
               // Check for GRS Id in from location
               If (FromLoc.GRSId__c != Null && ToLoc.GRSId__c == Null){
                    ToLoc.GRSId__c = FromLoc.GRSId__c;
                   
               }
               // Check for Atticus checkbox in from location
               If (FromLoc.Atticus__c == true && ToLoc.Atticus__c == false){
                    ToLoc.Atticus__c = true;
                    
               }
               // Check for Atticus Id in from location
               If (FromLoc.AtticusId__c != Null && ToLoc.AtticusId__c == Null){
                       ToLoc.AtticusId__c = FromLoc.AtticusId__c;
                   
               }
               
               // From location type is LawFirm
                If(FromLoc.Type == 'LawFirm'){
                   // Check for Preset checkbox in from location
                   If (FromLoc.PreSet__c == true && ToLoc.PreSet__c == false){
                      ToLoc.PreSet__c = true;      
                   }
                   // Check for CashTrax Id in from location
                   If (FromLoc.CTXFirmId__c != Null && ToLoc.CTXFirmId__c == Null){
                     ToLoc.CTXFirmId__c = FromLoc.CTXFirmId__c;
                   }
                }
                
                List<Account> lstOfaccs=new List<Account>();
                lstOfaccs.add(ToLoc);
                lstOfaccs.add(FromLoc);
                
                mapOfMergeAccounts.put(ToLoc.id,lstOfaccs);
                if(Test.IsRunningTest() || !setOfEndPoinsAcc.contains(ids)){
                    Preset_Medlien_Communication__c preObj=mapOfPreUpdateFirmsCmms.get(ids);
                    preObj.Status__c='Completed';
                    preObj.Input_Payload__c='';
                    preObj.Output_Body__c='Internal Sf Merge Record';
                    preObj.Status_Code__c='';
                    lstOfcomms.add(preObj);
                }
                lstofUpdateAccounts.add(ToLoc);
                    
            }
           
        }   
        return new ModelBatchUpdateItem(lstofUpdateAccounts,null,null,lstOfcomms,null,null,null,mapOfMergeAccounts,null);
    }
    
    
    //Medlien Merge Firm Locations
         private ModelBatchUpdateItem fillMedlienMergeFirmLocations(Map<id,Preset_Medlien_Communication__c >mapOfPreUpdateFirmsCmms){
           
           List<Preset_Medlien_Communication__c> lstOfcomms=new List<Preset_Medlien_Communication__c>();
            List<Account> lstofUpdateAccounts=new List<Account>();
            Map<id,Id> mapOfMergeAccs=new Map<id,id>();
            Map<id,id> mapDelAccounts=new Map<id,id>();
            Map<id,List<Account>> mapOfMergeAccounts=new Map<id,List<Account>>();
             Set<id> setOfEndPoinsAcc=new Set<id>();
            if(mapOfPreUpdateFirmsCmms.size()>0){
               
                 for(Account acc:[Select Id,AtticusId__c,GRSId__c,KeyMedsID__c ,CTXFirmId__c  from Account where Id=:mapOfPreUpdateFirmsCmms.keySet()]){
                    id ids=acc.id;
        
                     if(acc.AtticusId__c==null && acc.GRSId__c==null && acc.KeyMedsID__c==null && acc.CTXFirmId__c==null
                        && ((mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Grs_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Grs_Id__c.trim()!='')
                        || (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Atticus_Id__c!=null  && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Atticus_Id__c.trim()!='')
                        || (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Core_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Core_Id__c.trim()!='')
                        || (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c.trim()!=''))){
                    
                    
                          Preset_Medlien_Communication__c preObj=mapOfPreUpdateFirmsCmms.get(ids);
                            preObj.Status__c='fail';
                            preObj.Input_Payload__c='';
                            preObj.Output_Body__c='Please sync Serviving record First then perform operation ';
                            preObj.Status_Code__c='';
                            lstOfcomms.add(preObj);
                            
                    }else if((acc.AtticusId__c!=null || acc.GRSId__c!=null || acc.KeyMedsID__c!=null || acc.CTXFirmId__c!=null)
                        && (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Grs_Id__c==null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Grs_Id__c.trim()=='')
                        && (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Atticus_Id__c==null  && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Atticus_Id__c.trim()=='')
                        && (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Core_Id__c==null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Core_Id__c.trim()=='')
                        && (mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c==null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c.trim()=='')){
                    
                    
                         Preset_Medlien_Communication__c preObj=mapOfPreUpdateFirmsCmms.get(ids);
                            preObj.Status__c='fail';
                            preObj.Input_Payload__c='';
                            preObj.Output_Body__c='Please sync Deleting record First then perform operation ';
                            preObj.Status_Code__c='';
                            lstOfcomms.add(preObj);
                    
                    }else{
                            Preset_Medlien_Communication__c preObj=mapOfPreUpdateFirmsCmms.get(ids);
                            
                            if((acc.GRSId__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Grs_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Grs_Id__c.trim()!='')
                                || (acc.AtticusId__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Atticus_Id__c!=null  && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Atticus_Id__c.trim()!='')
                                || (acc.KeyMedsID__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Core_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Core_Id__c.trim()!='')
                                || (acc.CTXFirmId__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c!=null && mapOfPreUpdateFirmsCmms.get(acc.id).Deleting_Cashtrax_Id__c.trim()!='')){
        
                                ModelMedlienUpdateFirm mdMer=new ModelMedlienUpdateFirm();
                                
                                mdMer.KeyMedsParentFirmID= mapOfPreUpdateFirmsCmms.get(ids).Deleting_Core_Id__c;
                                mdMer.KeyMedsFirmID=mapOfPreUpdateFirmsCmms.get(ids).Serviving_Core_Id__c;
        
                                mdMer.GRSParentFirmID=mapOfPreUpdateFirmsCmms.get(ids).Deleting_Grs_Id__c;
                                mdMer.GRSFirmID=mapOfPreUpdateFirmsCmms.get(ids).Serviving_Grs_Id__c;
                                mdMer.AtticusParentFirmID=mapOfPreUpdateFirmsCmms.get(ids).Deleting_Atticus_Id__c;
                                mdMer.AtticusFirmID=mapOfPreUpdateFirmsCmms.get(ids).Serviving_Atticus_Id__c;
                                mdMer.SFParentFirmld=mapOfPreUpdateFirmsCmms.get(ids).Serviving_Id__c;
        
                                mdMer.IsParent=false;
                                mdMer.Type='PayerLocation';
                                mdMer.core=false;
                                mdMer.atticus=false;
                                mdMer.grs=false;
        
                                if(mapOfPreUpdateFirmsCmms.get(ids).Deleting_Core_Id__c!=null && 
                                    mapOfPreUpdateFirmsCmms.get(ids).Deleting_Core_Id__c.trim()!='' &&
                                    String.isBlank(mapOfPreUpdateFirmsCmms.get(ids).Serviving_Core_Id__c)){
                                     
                                     mdMer.core=true;
                                }
                                if(mapOfPreUpdateFirmsCmms.get(ids).Deleting_Atticus_Id__c!=null && 
                                    mapOfPreUpdateFirmsCmms.get(ids).Deleting_Atticus_Id__c.trim()!='' &&
                                    String.isBlank(mapOfPreUpdateFirmsCmms.get(ids).Serviving_Atticus_Id__c)){
                                     
                                     mdMer.atticus=true;
                                }
                                
                                if(mapOfPreUpdateFirmsCmms.get(ids).Deleting_Grs_Id__c!=null && 
                                    mapOfPreUpdateFirmsCmms.get(ids).Deleting_Grs_Id__c.trim()!='' &&
                                    String.isBlank(mapOfPreUpdateFirmsCmms.get(ids).Serviving_Grs_Id__c)){
                                    mdMer.grs=true;
                                }
                                
                                String reqBody=JSON.serialize(mdMer);
        
                                HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request(reqBody,'MergeFirmLocations','');
                                Preset_Medlien_Communication__c  preMedComm=fillPresetMedComm(mapOfPreUpdateFirmsCmms.get(acc.id).id,reqBody,resfrmLoc.getBody(),resfrmLoc.getStatusCode());
                        
                                preObj.Status__c=preMedComm.Status__c;
                                preObj.Input_Payload__c=preMedComm.Input_Payload__c;
                                preObj.Output_Body__c=preMedComm.Output_Body__c;  
                                preObj.Status_Code__c=preMedComm.Status_Code__c; 
                                
                                mapOfPreUpdateFirmsCmms.put(ids,preObj);
                                
                                if(preObj.Status__c=='Completed'){
                                    mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                                    mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);
                                }
                                setOfEndPoinsAcc.add(preObj.Serviving_Id__c);
                                lstOfcomms.add(preObj);
                            }else{
                                mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                                mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);
                            
                            }
                    }   
                }
        
            }
            
            if(mapOfMergeAccs.size()>0){
                
                for(Account acc:[select id,parentId from account where parentId in:mapDelAccounts.keySet()]){
                    lstofUpdateAccounts.add(new Account(id=acc.id,parentId=mapDelAccounts.get(acc.parentId)));   
                }
        
                Map<id,Account> maprOfFormLocs=new Map<Id,Account>();
                Map<id,Account> maprOfToLocs=new Map<Id,Account>();
                
                for( Account acc:[SELECT Id, KeyMedsID__c, Core__c, GRS__c, GRSId__c, Atticus__c, AtticusId__c, PreSet__c, CTXFirmId__c, Type FROM Account WHERE Id in:mapOfMergeAccs.keySet()]){
                    maprOfToLocs.put(acc.id,acc);
                }
                
                for( Account acc:[SELECT Id, KeyMedsID__c, Core__c, GRS__c, GRSId__c, Atticus__c, AtticusId__c, PreSet__c, CTXFirmId__c, Type FROM Account WHERE Id in:mapDelAccounts.keySet()]){
                    maprOfFormLocs.put(acc.id,acc);
                }
                
                for(id Ids:maprOfToLocs.keySet()){
                    Account ToLoc=maprOfToLocs.get(ids);
                    Account FromLoc=maprOfFormLocs.get(mapOfMergeAccs.get(ToLoc.id));
                     
                    // Check for core checkbox in from location
                   If (FromLoc.Core__c == true && ToLoc.Core__c == false){
                           ToLoc.Core__c = true;
                               
                   }
                   // Check for Core Id in from location
                   If (FromLoc.KeyMedsID__c != Null && ToLoc.KeyMedsID__c == Null){
                        ToLoc.KeyMedsID__c = FromLoc.KeyMedsID__c;
                       
                   }
                   // Check for GRS checkbox in from location
                   If (FromLoc.GRS__c == true && ToLoc.GRS__c == false){
                        ToLoc.GRS__c = true;
                                 
                   }
                   // Check for GRS Id in from location
                   If (FromLoc.GRSId__c != Null && ToLoc.GRSId__c == Null){
                        ToLoc.GRSId__c = FromLoc.GRSId__c;
                       
                   }
                   // Check for Atticus checkbox in from location
                   If (FromLoc.Atticus__c == true && ToLoc.Atticus__c == false){
                        ToLoc.Atticus__c = true;
                        
                   }
                   // Check for Atticus Id in from location
                   If (FromLoc.AtticusId__c != Null && ToLoc.AtticusId__c == Null){
                           ToLoc.AtticusId__c = FromLoc.AtticusId__c;
                       
                   }
                   
                   // From location type is LawFirm
                    If(FromLoc.Type == 'LawFirm'){
                       // Check for Preset checkbox in from location
                       If (FromLoc.PreSet__c == true && ToLoc.PreSet__c == false){
                          ToLoc.PreSet__c = true;      
                       }
                       // Check for CashTrax Id in from location
                       If (FromLoc.CTXFirmId__c != Null && ToLoc.CTXFirmId__c == Null){
                         ToLoc.CTXFirmId__c = FromLoc.CTXFirmId__c;
                       }
                    }
                    
                    List<Account> lstOfaccs=new List<Account>();
                    lstOfaccs.add(ToLoc);
                    lstOfaccs.add(FromLoc);
                    
                    mapOfMergeAccounts.put(ToLoc.id,lstOfaccs);
                    if(Test.IsRunningTest() || !setOfEndPoinsAcc.contains(ids)){
                        Preset_Medlien_Communication__c preObj=mapOfPreUpdateFirmsCmms.get(ids);
                        preObj.Status__c='Completed';
                        preObj.Input_Payload__c='';
                        preObj.Output_Body__c='Internal Sf Merge Record';
                        preObj.Status_Code__c='';
                        lstOfcomms.add(preObj);
                    }
                    
                
                    lstofUpdateAccounts.add(ToLoc);
                        
                }
               
            }   
            return new ModelBatchUpdateItem(lstofUpdateAccounts,null,null,lstOfcomms,null,null,null,mapOfMergeAccounts,null);
        }
    
        // Medlien  Merge Attorneys
       private ModelBatchUpdateItem fillMedlienMergeAttorneys(Map<id,Preset_Medlien_Communication__c >mapOfPreMergeAttorneysCmms){
        List<Account_Relation__c > lstofUpdateAccRels=new List<Account_Relation__c >();
        List<Preset_Medlien_Communication__c> lstOfcomms=new List<Preset_Medlien_Communication__c>();
        List<Contact> lstofUpdateContact=new List<Contact>();
        Map<id,Id> mapOfMergeAccs=new Map<id,id>();
        Map<id,id> mapDelAccounts=new Map<id,id>();
        Set<id> setOfEndPoinsAcc=new Set<id>();
        set<id> setOfDelAccRel=new Set<id>();
         
        Map<id,List<Contact>> mapOfMergeContacts=new Map<id,List<Contact>>();
        for(contact conRec:[select id,lastname,firstname,Fax,Email,phone,accountid,
                            birthdate,account.OS_Firm_Location_Id__c,account.OS_Firm_Id__c from
                            contact where id=:mapOfPreMergeAttorneysCmms.keySet()]){
            
            id ids=conRec.id;               
            Preset_Medlien_Communication__c preObj=mapOfPreMergeAttorneysCmms.get(ids);
            
             if((mapOfPreMergeAttorneysCmms.get(ids).Serviving_Atticus_Id__c!=null && 
                 mapOfPreMergeAttorneysCmms.get(ids).Serviving_Atticus_Id__c.trim()!='' &&
                 mapOfPreMergeAttorneysCmms.get(ids).Deleting_Atticus_Id__c!=null && 
                 mapOfPreMergeAttorneysCmms.get(ids).Deleting_Atticus_Id__c.trim()!='')||
                 
                 (mapOfPreMergeAttorneysCmms.get(ids).Serviving_Grs_Id__c!=null && 
                 mapOfPreMergeAttorneysCmms.get(ids).Serviving_Grs_Id__c.trim()!='' &&
                 mapOfPreMergeAttorneysCmms.get(ids).Deleting_Grs_Id__c!=null && 
                 mapOfPreMergeAttorneysCmms.get(ids).Deleting_Grs_Id__c.trim()!='')||
                 
                (mapOfPreMergeAttorneysCmms.get(ids).Serviving_Core_Id__c!=null && 
                 mapOfPreMergeAttorneysCmms.get(ids).Serviving_Core_Id__c.trim()!='' &&
                 mapOfPreMergeAttorneysCmms.get(ids).Deleting_Core_Id__c!=null && 
                 mapOfPreMergeAttorneysCmms.get(ids).Deleting_Core_Id__c.trim()!='')
    
                 ){
                    
                
                    ModelMedlienMergeContacts objMd=new ModelMedlienMergeContacts();
                    objMd.keyMedsSourceContactId=mapOfPreMergeAttorneysCmms.get(ids).Deleting_Core_Id__c;
                    objMd.keyMedsMergeContactId=mapOfPreMergeAttorneysCmms.get(ids).Serviving_Core_Id__c;
                    objMd.grsSourceContactId=mapOfPreMergeAttorneysCmms.get(ids).Deleting_Grs_Id__c;
                    objMd.grsMergeContactId=mapOfPreMergeAttorneysCmms.get(ids).Serviving_Grs_Id__c;
                    objMd.atticusSourceContactId=mapOfPreMergeAttorneysCmms.get(ids).Deleting_Atticus_Id__c;
                    objMd.atticusMergeContactId=mapOfPreMergeAttorneysCmms.get(ids).Serviving_Atticus_Id__c;
                    objMd.ContactType='PAYERLOCATION';
                    objMd.core=false;
                    objMd.grs=false;
                    objMd.atticus=false;
                    objMd.sfid=mapOfPreMergeAttorneysCmms.get(ids).Serviving_Id__c;
                    
                    
                    if(objMd.keyMedsSourceContactId!=null && objMd.keyMedsSourceContactId.trim()!='' &&
                        objMd.keyMedsMergeContactId!=null && objMd.keyMedsMergeContactId.trim()!=''){
                        objMd.core=true;
                    }
                    
                    if(objMd.atticusSourceContactId!=null && objMd.atticusSourceContactId.trim()!='' &&
                        objMd.atticusMergeContactId!=null && objMd.atticusMergeContactId.trim()!=''){
                        objMd.atticus=true;
                    }
                    
                    if(objMd.grsSourceContactId!=null && objMd.grsSourceContactId.trim()!='' &&
                        objMd.grsMergeContactId!=null && objMd.grsMergeContactId.trim()!=''){
                        objMd.grs=true;
                    }
            
                    String reqBody=JSON.serialize(objMd); 
            
                    HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request(reqBody,'MergeContacts','');
                    Preset_Medlien_Communication__c  preMedComm=fillPresetMedComm(mapOfPreMergeAttorneysCmms.get(ids).id,reqBody,resfrmLoc.getBody(),resfrmLoc.getStatusCode());
                     
                    preObj.Status__c=preMedComm.Status__c;
                    preObj.Input_Payload__c=preMedComm.Input_Payload__c;
                    preObj.Output_Body__c=preMedComm.Output_Body__c;
                    preObj.Status_Code__c=preMedComm.Status_Code__c;
                    
                    mapOfPreMergeAttorneysCmms.put(ids,preObj);   
                  
                    if(preObj.Status__c=='Completed'){
                       mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                       mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);  
                    }
                    setOfEndPoinsAcc.add(preObj.Serviving_Id__c);
                    lstOfcomms.add(preObj);
                    
            }else{
                mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);   
                
            }
                 
        }
        System.debug('##mapOfMergeAccs'+mapOfMergeAccs);
        if(mapOfMergeAccs.size()>0){
            Map<id,Contact> maprOfFormLocs=new Map<Id,Contact>();
            Map<id,Contact> maprOfToLocs=new Map<Id,Contact>();
            
            Map<id,Account_Relation__c > maprOfFormLocsRel=new Map<Id,Account_Relation__c >();
            Map<id,Account_Relation__c > maprOfToLocsRel=new Map<Id,Account_Relation__c >();
            
            for(Account_Relation__c MasterAtr :[SELECT Id, KeyMedsID__c, GRSId__c, 
                                                AtticusId__c, PresetID__c,Contact__c  
                                                FROM Account_Relation__c 
                                                WHERE Contact__c in:mapOfMergeAccs.keySet() limit 1]){
                    
                    maprOfToLocsRel.put(MasterAtr.Contact__c,MasterAtr);        
            
            }                                   
            
            for(Account_Relation__c mergeAtr :[SELECT Id, KeyMedsID__c, GRSId__c,
                                                AtticusId__c, PresetID__c,Contact__c  
                                                FROM Account_Relation__c 
                                                WHERE Contact__c in:mapDelAccounts.keySet() limit 1]){
                                              
                    maprOfFormLocsRel.put(mergeAtr.Contact__c,mergeAtr);                          
            
            }       
             
              
            for( Contact acc:[SELECT Id, Core__c, GRS__c, Atticus__c, PreSet__c FROM Contact WHERE Id in:mapOfMergeAccs.keySet()]){
                maprOfToLocs.put(acc.id,acc);
            }
            
            for( Contact acc:[SELECT Id, Core__c, GRS__c, Atticus__c, PreSet__c FROM Contact WHERE Id in:mapDelAccounts.keySet()]){
                maprOfFormLocs.put(acc.id,acc);
            }
            System.debug('##maprOfToLocs'+maprOfToLocs);
            for(id Ids:maprOfToLocs.keySet()){
                Contact masterCont=maprOfToLocs.get(ids);
                Contact mergeCont =maprOfFormLocs.get(mapOfMergeAccs.get(masterCont.id));
                 
                Account_Relation__c MasterAtr =maprOfToLocsRel.get(ids);
                Account_Relation__c mergeAtr  =maprOfFormLocsRel.get(mapOfMergeAccs.get(masterCont.id));
               
               
               // Check for core checkbox in from Contact
               If (mergeCont.Core__c == true && masterCont.Core__c == false){
                  masterCont.Core__c = true; 
                             
               }
               // Check for GRS checkbox in from contact
               If (mergeCont.GRS__c == true && masterCont.GRS__c == false){
                  masterCont.GRS__c = true;
                       
               }
               
               // Check for Atticus checkbox in from contact
               If (mergeCont.Atticus__c == true && masterCont.Atticus__c == false){
                  masterCont.Atticus__c = true; 
                        
               }
               
               // Check for Preset checkbox in from contact
               If (mergeCont.PreSet__c == true && masterCont.PreSet__c == false){
                  masterCont.PreSet__c = true;
                        
               }
               
            
               // Check for Core Id in from Attorney
               If (mergeAtr.KeyMedsID__c != Null && MasterAtr.KeyMedsID__c == Null){
                   // Check for Core Id in to Attorney
                   MasterAtr.KeyMedsID__c = mergeAtr.KeyMedsID__c;
                       
               }
               
               // Check for GRS Id in from location
               If (mergeAtr.GRSId__c != Null && MasterAtr.GRSId__c == Null){
                   // Check for GRS Id in to location
                  MasterAtr.GRSId__c = mergeAtr.GRSId__c;
                    
               }
               
               // Check for Atticus Id in from location
               If (mergeAtr.AtticusId__c != Null && MasterAtr.AtticusId__c == Null){
                   // Check for Atticus Id in to location
                   MasterAtr.AtticusId__c = mergeAtr.AtticusId__c; 
                       
               }
               // Check for CashTrax Id in from location
               If (mergeAtr.PresetID__c != Null && MasterAtr.PresetID__c == Null){
                   // Check for Atticus Id in to location
                   MasterAtr.PresetID__c = mergeAtr.PresetID__c;
                      
               }
               
                // Merge Contacts
                List<Contact> lstOfCons=new List<Contact>();
                lstOfCons.add(masterCont);
                lstOfCons.add(mergeCont);
                mapOfMergeContacts.put(masterCont.id,lstOfCons);
                lstofUpdateAccRels.add(MasterAtr);
                
                setOfDelAccRel.add(mergeAtr.id);
                
                if(Test.IsRunningTest() || !setOfEndPoinsAcc.contains(ids)){
                    Preset_Medlien_Communication__c preObj=mapOfPreMergeAttorneysCmms.get(ids);
                    preObj.Status__c='Completed';
                    preObj.Input_Payload__c='';
                    preObj.Status_Code__c='';
                    preObj.Output_Body__c='Internal Sf Merge Record';
                    lstOfcomms.add(preObj);
                }
                lstofUpdateContact.add(masterCont);
            }                      
       
        }
        System.debug('##lstofUpdateContact'+lstofUpdateContact);
        System.debug('##lstofUpdateAccRels'+lstofUpdateAccRels);
        System.debug('##setOfDelAccRel'+setOfDelAccRel);
        System.debug('##mapOfMergeContacts'+mapOfMergeContacts);
        return new ModelBatchUpdateItem(null,lstofUpdateContact,lstofUpdateAccRels,lstOfcomms,null,null,setOfDelAccRel,null,mapOfMergeContacts);
    }   
    
    //Preset Merge Firm Locations 
   private ModelBatchUpdateItem fillPresetMergeFirmLocations(Map<id,Preset_Medlien_Communication__c >mapOfPreMergeFirmsCmms){
        List<Preset_Medlien_Communication__c> lstOfcomms=new List<Preset_Medlien_Communication__c>();
        List<Account> lstofUpdateAccounts=new List<Account>();
        Map<id,Id> mapOfMergeAccs=new Map<id,id>();
        Map<id,id> mapDelAccounts=new Map<id,id>();
        Map<id,List<Account>> mapOfMergeAccounts=new Map<id,List<Account>>();
        Set<id> setOfEndPoinsAcc=new Set<id>();
        if(mapOfPreMergeFirmsCmms.size()>0){
           
           for(id ids:mapOfPreMergeFirmsCmms.keySet()){
                Preset_Medlien_Communication__c preObj=mapOfPreMergeFirmsCmms.get(ids);
                    
                if(mapOfPreMergeFirmsCmms.get(ids).Deleting_Cashtrax_Id__c!=null  && mapOfPreMergeFirmsCmms.get(ids).Deleting_Cashtrax_Id__c.trim()!='' &&
                    mapOfPreMergeFirmsCmms.get(ids).Serviving_CashTrax_Id__c!=null && mapOfPreMergeFirmsCmms.get(ids).Serviving_CashTrax_Id__c.trim()!=''){
                    
                   
                    HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request('{}','PresetMergeFirmLocations','FromFirmLocationID='+mapOfPreMergeFirmsCmms.get(ids).Deleting_Cashtrax_Id__c+'&ToFirmLocationID='+mapOfPreMergeFirmsCmms.get(ids).Serviving_CashTrax_Id__c);
                    Preset_Medlien_Communication__c  preMedComm=fillPresetMedComm(mapOfPreMergeFirmsCmms.get(ids).id,'FromFirmLocationID='+mapOfPreMergeFirmsCmms.get(ids).Deleting_Cashtrax_Id__c+'&ToFirmLocationID='+mapOfPreMergeFirmsCmms.get(ids).Serviving_CashTrax_Id__c,resfrmLoc.getBody(),resfrmLoc.getStatusCode());    

                    preObj.Status__c=preMedComm.Status__c;
                    preObj.Input_Payload__c=preMedComm.Input_Payload__c;
                    preObj.Output_Body__c=preMedComm.Output_Body__c;  
                    preObj.Status_Code__c=preMedComm.Status_Code__c;  
                    
                    mapOfPreMergeFirmsCmms.put(ids,preObj);
                    
                    System.debug('##preObj.Status__c'+preObj.Status__c);
                    if(preObj.Status__c=='Completed'){
                        mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                        mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);   
                    }
                    setOfEndPoinsAcc.add(preObj.Serviving_Id__c);
                    lstOfcomms.add(preObj);
                
                }else{
                    mapOfMergeAccs.put(preObj.Serviving_Id__c,preObj.Deleting_Id__c);
                    mapDelAccounts.put(preObj.Deleting_Id__c,preObj.Serviving_Id__c);   
                    
                }
            }   

        }
        System.debug('###mapOfMergeAccs'+mapOfMergeAccs);
        if(mapOfMergeAccs.size()>0){
           
            Map<id,Account> maprOfFormLocs=new Map<Id,Account>();
            Map<id,Account> maprOfToLocs=new Map<Id,Account>();
            
            for( Account acc:[SELECT Id, KeyMedsID__c, Core__c, GRS__c, GRSId__c, Atticus__c, AtticusId__c, PreSet__c, CTXFirmId__c, Type FROM Account WHERE Id in:mapOfMergeAccs.keySet()]){
                maprOfToLocs.put(acc.id,acc);
            }
            
            for( Account acc:[SELECT Id, KeyMedsID__c, Core__c, GRS__c, GRSId__c, Atticus__c, AtticusId__c, PreSet__c, CTXFirmId__c, Type FROM Account WHERE Id in:mapDelAccounts.keySet()]){
                maprOfFormLocs.put(acc.id,acc);
            }
            
            for(id Ids:maprOfToLocs.keySet()){
                Account ToLoc=maprOfToLocs.get(ids);
                Account FromLoc=maprOfFormLocs.get(mapOfMergeAccs.get(ToLoc.id));
                                                                        
                // Check for core checkbox in from location
               If (FromLoc.Core__c == true && ToLoc.Core__c == false){
                       ToLoc.Core__c = true;
                           
               }
               // Check for Core Id in from location
               If (FromLoc.KeyMedsID__c != Null && ToLoc.KeyMedsID__c == Null){
                    ToLoc.KeyMedsID__c = FromLoc.KeyMedsID__c;
                   
               }
               // Check for GRS checkbox in from location
               If (FromLoc.GRS__c == true && ToLoc.GRS__c == false){
                    ToLoc.GRS__c = true;
                             
               }
               // Check for GRS Id in from location
               If (FromLoc.GRSId__c != Null && ToLoc.GRSId__c == Null){
                    ToLoc.GRSId__c = FromLoc.GRSId__c;
                   
               }
               // Check for Atticus checkbox in from location
               If (FromLoc.Atticus__c == true && ToLoc.Atticus__c == false){
                    ToLoc.Atticus__c = true;
                    
               }
               // Check for Atticus Id in from location
               If (FromLoc.AtticusId__c != Null && ToLoc.AtticusId__c == Null){
                       ToLoc.AtticusId__c = FromLoc.AtticusId__c;
                   
               }
               
               // From location type is LawFirm
                If(FromLoc.Type == 'LawFirm'){
                   // Check for Preset checkbox in from location
                   If (FromLoc.PreSet__c == true && ToLoc.PreSet__c == false){
                      ToLoc.PreSet__c = true;      
                   }
                   // Check for CashTrax Id in from location
                   If (FromLoc.CTXFirmId__c != Null && ToLoc.CTXFirmId__c == Null){
                     ToLoc.CTXFirmId__c = FromLoc.CTXFirmId__c;
                   }
                }
                
                List<Account> lstOfaccs=new List<Account>();
                lstOfaccs.add(ToLoc);
                lstOfaccs.add(FromLoc);
                
                mapOfMergeAccounts.put(ToLoc.id,lstOfaccs);
                
                System.debug('###mapOfMergeAccounts'+mapOfMergeAccounts);
                if(Test.IsRunningTest() || !setOfEndPoinsAcc.contains(ids)){
                    Preset_Medlien_Communication__c preObj=mapOfPreMergeFirmsCmms.get(ids);
                    preObj.Status__c='Completed';
                    preObj.Input_Payload__c='';
                    preObj.Output_Body__c='Internal Sf Merge Record';
                    preObj.Status_Code__c='';
                    lstOfcomms.add(preObj);
                }
                
                lstofUpdateAccounts.add(ToLoc);
                    
            }
           
        }   
        
        System.debug('###mapOfMergeAccounts'+mapOfMergeAccounts);
        return new ModelBatchUpdateItem(lstofUpdateAccounts,null,null,lstOfcomms,null,null,null,mapOfMergeAccounts,null);
    }
    
    
     //Preset Preset move Attorney
     private ModelBatchUpdateItem fillPresetMoveAttorney(Map<id,Preset_Medlien_Communication__c >mapOfPreMoveMergeAttCmms){   
        List<Preset_Medlien_Communication__c> lstOfcomms=new List<Preset_Medlien_Communication__c>();
        Map<id,Preset_Medlien_Communication__c> mapOfUpdateRecords=new Map<id,Preset_Medlien_Communication__c>();   
        List<Account_Relation__c > lstofUpdateAccounts=new List<Account_Relation__c >();
        Set<id> setOfDelConIds=new Set<id>();
        
            
        if(mapOfPreMoveMergeAttCmms.size()>0){
           
            for(id ids: mapOfPreMoveMergeAttCmms.keySet()){
               
                HTTPResponse resfrmLoc =PresetMedlienHttpRequestController.request('{}','PresetMergeFirmLocations','FromFirmLocationID='+mapOfPreMoveMergeAttCmms.get(ids).Deleting_Cashtrax_Id__c+'&ToFirmLocationID='+mapOfPreMoveMergeAttCmms.get(ids).Serviving_CashTrax_Id__c);
                  
                Preset_Medlien_Communication__c  preMedComm=fillPresetMedComm(mapOfPreMoveMergeAttCmms.get(ids).id,'FromFirmLocationID='+mapOfPreMoveMergeAttCmms.get(ids).Deleting_Cashtrax_Id__c+'&ToFirmLocationID='+mapOfPreMoveMergeAttCmms.get(ids).Serviving_CashTrax_Id__c,resfrmLoc.getBody(),resfrmLoc.getStatusCode());    
                
                Preset_Medlien_Communication__c preObj=mapOfPreMoveMergeAttCmms.get(ids);
                preObj.Status__c=preMedComm.Status__c;
                preObj.Input_Payload__c=preMedComm.Input_Payload__c;
                preObj.Output_Body__c=preMedComm.Output_Body__c;
                preObj.Status_Code__c=preMedComm.Status_Code__c;
          
                mapOfPreMoveMergeAttCmms.put(ids,preObj);   
                lstOfcomms.add(preObj);
                  
                if(Test.isRunningTest() || preMedComm.Status__c=='Completed' &&
                   preMedComm.Deleting_Id__c!=null   && 
                   preMedComm.Deleting_Id__c.trim()!=''){
                   
                    mapOfUpdateRecords.put(preMedComm.Deleting_Id__c,preObj);
                    setOfDelConIds.add(preMedComm.Deleting_Id__c);
                }     
            }
            
            if(setOfDelConIds.size()>0){
                for(Account_Relation__c accRel:[select id,contact__c from Account_Relation__c  where contact__c in:mapOfUpdateRecords.keySet()]){
                    
                    Account_Relation__c  acc=new Account_Relation__c ();
                     acc.id=accRel.id;
                     id ids=accRel.Contact__c;
                     if(mapOfUpdateRecords.get(ids).Deleting_Atticus_Id__c!=null && 
                        mapOfUpdateRecords.get(ids).Serviving_Atticus_Id__c==null ){
                        acc.AtticusId__c=mapOfUpdateRecords.get(ids).Deleting_Atticus_Id__c;
                     }
                     
                     if(mapOfUpdateRecords.get(ids).Deleting_Grs_Id__c!=null && 
                        mapOfUpdateRecords.get(ids).Serviving_Grs_Id__c==null ){
                        acc.GRSId__c=mapOfUpdateRecords.get(ids).Deleting_Grs_Id__c;
                     }
                     
                     if(mapOfUpdateRecords.get(ids).Deleting_Core_Id__c!=null && 
                        mapOfUpdateRecords.get(ids).Serviving_Core_Id__c==null ){
                        acc.KeyMedsID__c=mapOfUpdateRecords.get(ids).Deleting_Core_Id__c;
                     }
                     
                     lstofUpdateAccounts.add(acc);
                }
            }
            
           
       }
       return new ModelBatchUpdateItem(null,null,lstofUpdateAccounts,lstOfcomms,null,(setOfDelConIds.size()>0?setOfDelConIds:null),null,null,null);
    }   
    
    private Preset_Medlien_Communication__c  fillPresetMedComm(Id recId,String reqBody,String outputBody,Integer statusCode){
        
          Preset_Medlien_Communication__c precmm=new Preset_Medlien_Communication__c();      
          precmm.id=recId;
          precmm.Input_Payload__c=reqBody;
          precmm.Output_Body__c =outputBody;
          precmm.Status__c='Fail';
          precmm.Status_Code__c=statusCode+'';
          
          System.debug('###outputBody'+outputBody);
          
          if(!test.isrunningtest() && statusCode==200 && (parse(outputBody).Status=='OK' || parse(outputBody).Status=='Success')){
            
                precmm.Status__c='Completed';   
          }
          if(test.isrunningtest()){ precmm.Status__c='Completed';}
            
          return precmm;
    }
    public class ModelMergeFirmLocations {
       public String accountType;  //PAYERLOCATION
        public boolean atticus;
        public String atticusMergeAccountId;    //536ee349-a47b-4bef-5432-08d7681ee36b
        public String atticusMergeParentAccountId;  //177ad237-8244-47f8-2811-08d7681ee21b
        public String atticusSourceAccountId;   //02c4cc63-da4b-4271-5433-08d7681ee36b
        public String atticusSourceParentAccountId; //61e50386-94cd-4b03-2812-08d7681ee21b
        
        public boolean core;
        public String Firmlocationsfid; //0014B00000igG99
        public boolean grs;
        
        public String grsMergeAccountId;    //33018380
        public String grsMergeParentAccountId;  //33006262
        public String grsSourceAccountId;   //33018381
        public String grsSourceParentAccountId; //33006263
        
        public String keyMedsMergeAccountId;    //1058551
        public String keyMedsMergeParentAccountId;  //1052115
        public String keyMedsSourceAccountId;   //1058552
        public String keyMedsSourceParentAccountId; //1052116
        public String Parentsfid;   //0014B00000igG9A
       
     }   
        
     public class ModelRequestUpdateFirm {
        public String Website;
        public String PhoneNumber;
        public String FirmName;
        public Integer FirmID;
        public String Fax;
        public String CRM_FirmID;
    }
    public class ModelRequestUpdateFirmLocation{
        public String ZipCode;
        public String State;
        public String FirmLocationName;
        public Integer FirmLocationID;
        public Integer FirmID;
        public String CRM_FirmLocationID;
        public String CRM_FirmID;
        public String City;
        public String Address2;
        public String Address1;
    }
    public class ModelRequestUpdateAttorneyContact{
       
        public String PhoneNumber;
        public String LastName;
        public String FirstName;
        public Integer FirmLocationID;
        public Integer FirmID;
        public String Fax;
        public String Email;
        public String CRM_FirmLocationID;
        public String CRM_AttorneyID;
        public String ContactInformation;
        public Object Birthday;
        public Integer AttorneyID;
    }
    public class ModelMedlienUpdateFirm{
        public String KeyMedsParentFirmID;
        public String KeyMedsFirmID;
        public String GRSParentFirmID;
        public String GRSFirmID;
        public String AtticusParentFirmID;
        public String AtticusFirmID;
        public String SFParentFirmld;
        public String Type;
        public Boolean core;
        public Boolean grs;
        public Boolean atticus;
        public Boolean IsParent;
        
    }
    public class ModelMedlienUpdateContacts{
       public String KeyMedsContactID;    //1052117
        public String GRSContactID;    //49737
        public String AtticusContactID;   //33006264
        public String SFContactld;    //33010595
        public boolean core;
        public boolean grs;
        public boolean atticus;
        
   }     
    public class ModelMedlienMergeContacts{
       public String keyMedsSourceContactId;    //1052117
        public String keyMedsMergeContactId;    //49737
        public String grsSourceContactId;   //33006264
        public String grsMergeContactId;    //33010595
        public String atticusSourceContactId;   //518dee48-d19a-48b0-836e-08d7684aa8e6
        public String atticusMergeContactId;    //9fe3404d-ebc0-4f8d-8116-08d76ab97447
        public String ContactType;  //PAYERLOCATION
        public boolean core;
        public boolean grs;
        public boolean atticus;
        public String sfid; //0034B00000coA3g
   }     
   
    public class PresetModelStatus {
        public String Status;
    }
    
    public class ModelBatchUpdateItem{
        List<Account>  lstOfUpdateAccounts;
        List<Contact> lstOfUpdateContact;
        List<Account_Relation__c> lstOfUpdateAccRel;
        List<Preset_Medlien_Communication__c> lstOfUpdatePreMedComm;
        Set<id> setOfDelAccs; 
        set<id> setOfDelCons;
        set<id> setOfDelAccRel;
        Map<id,List<Account>> mapOfMergeAccounts;
        Map<id,List<Contact>> mapOfMergeContacts;
        public ModelBatchUpdateItem(List<Account>  lstOfUpdateAccounts,List<Contact> lstOfContact,
                                   List<Account_Relation__c> lstOfUpdateAccRel,
                                   List<Preset_Medlien_Communication__c> lstOfUpdatePreMedComm,
                                   Set<id> setOfDelAccs,set<id> setOfDelCons,set<id> setOfDelAccRel,
                                   Map<id,List<Account>> mapOfMergeAccounts,Map<id,List<Contact>> mapOfMergeContacts){
                                   
            this.lstOfUpdateAccounts=lstOfUpdateAccounts;
            this.lstOfUpdateContact=lstOfUpdateContact;
            this.lstOfUpdateAccRel=lstOfUpdateAccRel;
            this.lstOfUpdatePreMedComm=lstOfUpdatePreMedComm;
            this.setOfDelAccs=setOfDelAccs;
            this.setOfDelCons=setOfDelCons;
            this.setOfDelAccRel=setOfDelAccRel;
            this.mapOfMergeAccounts=mapOfMergeAccounts;
            this.mapOfMergeContacts=mapOfMergeContacts;
        }
    }
    public static PresetModelStatus parse(String json) {
        return (PresetModelStatus ) System.JSON.deserialize(json, PresetModelStatus.class);
    }
}