@isTest
private class HuntListCsvUploadControllerTest {
    @testSetup
    static void setupData() {
        insert new Account(
            Name = 'Hunt List Test Firm',
            CTXFirmId__c = 'FIRM-1001',
            BillingStreet = '123 Main St',
            BillingCity = 'Austin',
            BillingState = 'TX',
            BillingPostalCode = '78701'
        );
    }

    @isTest
    static void saveHuntListRows_blankPayload_returnsZeroes() {
        Test.startTest();
        HuntListCsvUploadController.UploadResult result = HuntListCsvUploadController.saveHuntListRows('   ');
        Test.stopTest();

        System.assertEquals(0, result.totalRows);
        System.assertEquals(0, result.successCount);
        System.assertEquals(0, result.errorCount);
        System.assertNotEquals(null, result.errors);
    }

    @isTest
    static void saveHuntListRows_emptyPayload_returnsZeroes() {
        Test.startTest();
        HuntListCsvUploadController.UploadResult result = HuntListCsvUploadController.saveHuntListRows('[]');
        Test.stopTest();

        System.assertEquals(0, result.totalRows);
        System.assertEquals(0, result.successCount);
        System.assertEquals(0, result.errorCount);
        System.assertNotEquals(null, result.errors);
    }

    @isTest
    static void saveHuntListRows_validValueRow_insertsRecord() {
        List<Object> rows = new List<Object>();
        rows.add(new Map<String, Object>{
            'Firm Location ID' => 'FIRM-1001',
            'Category' => 'Platinum',
            'Oasis Dir' => 'Jane Director',
            'PM Director' => 'Mark PM',
            'Total Orig - YTD' => '1000.50',
            'Current Year Budget Orig' => '3000',
            'How many cases per month does your law firm utilize non-healthcare medical liens on?' => 'test',
            'Previous Yr Forecast Orig' => '3000',
            'How many cases per month does your law firm utilize pre-set funding on?' => 'test',
            'Who\'s the pre-lit manager?' => 'test',
            'Who\'s the litigation manager?' => 'test',
            'Who is the case manager lead?' => 'test',
            'Who handles medical map/provider decisions?' => 'test',
            'Who handles pre-set funding decisions?' => 'test',
            'Does law firm use competitors for PM or PF?' => 'test'
                
        });

        String payload = JSON.serialize(rows);

        Test.startTest();
        HuntListCsvUploadController.UploadResult result = HuntListCsvUploadController.saveHuntListRows(payload);
        Test.stopTest();
    }
}