global class SchedularSendEmailClosedWonEmail implements Schedulable{
    global void execute(SchedulableContext sc) {
    
      BatchSendEmailToOppOwnerToClosed obj1 = new BatchSendEmailToOppOwnerToClosed();
      Database.executeBatch(obj1);
    
   }
}