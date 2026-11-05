/**
  * @Created Date 04/24/2019
  * @author    OASISFINANCIAL GROUP
  * @copyright Copyright (c) 2019-2020 
  * @license   
  * @Modified Date
  * @Description 
*/
global class SchedulePSCommunicationbatch implements Schedulable {


   global void execute(SchedulableContext sc) {
     
    
        DeletePSRecordsBatch job = new DeletePSRecordsBatch(1);
        ID existingForecastBatchProcessId = Database.executeBatch(job, 200);
    
   }


}