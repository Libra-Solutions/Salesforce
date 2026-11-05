/**
  * @Created Date 04/24/2019
  * @author    OASISFINANCIAL GROUP
  * @copyright Copyright (c) 2019-2020 
  * @license   
  * @Modified Date
  * @Description 
*/
global class SchedulerPSCommunicationbatch {
    global void SchedulerPSCommunicationbatch() {}
    public static void start(){
        String CRON_EXP = '0 0 * * * ?'; 
        System.schedule('Hourly Batch Schedule job', CRON_EXP, new SchedulePSCommunicationbatch());
    } 
}