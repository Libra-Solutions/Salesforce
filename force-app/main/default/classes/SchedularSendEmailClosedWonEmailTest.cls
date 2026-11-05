@istest
public class SchedularSendEmailClosedWonEmailTest {
    @istest
    public static void  testschedule() {
        Test.StartTest();
        SchedularSendEmailClosedWonEmail sh1 = new SchedularSendEmailClosedWonEmail();      
         String sch = '0 0 23 * * ?';
                system.schedule('Test check', sch, sh1);
        Test.stopTest();
    }
}