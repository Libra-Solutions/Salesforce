/**
  * @Created Date 04/24/2019
  * @author    OASISFINANCIAL GROUP
  * @copyright Copyright (c) 2019-2020 
  * @license   
  * @Modified Date
  * @Description 
*/
global  class GenericDeleteBatch implements Database.Batchable<sObject>, Database.Stateful{
   
   String query='';
     
    Global GenericDeleteBatch(String query){
    
        this.query = query;
        system.debug('query : '+query);
    }
    
   
    
    Global Database.QueryLocator start(Database.BatchableContext BC){
       
        
        return Database.getQueryLocator(this.query);
    }
    
    Global void execute(Database.BatchableContext BC, List<sObject> scope){
        if(scope.size()>0){
             delete scope;
        }
       
    }
    
    Global void finish(Database.BatchableContext BC){
        
        
    }
}