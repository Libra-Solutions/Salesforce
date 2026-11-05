@istest
public class SchedularSendEmailForPendingOppDailyTest {
	public static testMethod void testschedule() {
		Test.StartTest();
		SchedularSendEmailForPendingOppDaily testsche = new SchedularSendEmailForPendingOppDaily();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
}