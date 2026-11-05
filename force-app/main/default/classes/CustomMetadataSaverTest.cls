@isTest
public with sharing class CustomMetadataSaverTest {
    @isTest
    static void deployShouldReturnMockDeploymentIdAndStoreJobId() {
        SObject customMetadataRecord = createCustomMetadataRecord();

        String deploymentId = CustomMetadataSaver.deploy(new List<SObject>{ customMetadataRecord });

        System.assertEquals(CustomMetadataSaver.MOCK_DEPLOYMENT_ID, deploymentId);
        System.assertEquals(1, CustomMetadataSaver.getDeploymentJobIds().size());
        System.assertEquals(CustomMetadataSaver.MOCK_DEPLOYMENT_ID, CustomMetadataSaver.getDeploymentJobIds()[0]);
    }

    @isTest
    static void deployWithProvidedCallbackShouldTrackMultipleDeployments() {
        SObject recordOne = createCustomMetadataRecord();
        SObject recordTwo = createCustomMetadataRecord();

        String firstDeploymentId = CustomMetadataSaver.deploy(
            new List<SObject>{ recordOne },
            new CustomMetadataSaver.DefaultDeployCallback()
        );
        String secondDeploymentId = CustomMetadataSaver.deploy(
            new List<SObject>{ recordTwo },
            new CustomMetadataSaver.DefaultDeployCallback(true, true)
        );

        System.assertEquals(CustomMetadataSaver.MOCK_DEPLOYMENT_ID, firstDeploymentId);
        System.assertEquals(CustomMetadataSaver.MOCK_DEPLOYMENT_ID, secondDeploymentId);
        System.assertEquals(2, CustomMetadataSaver.getDeploymentJobIds().size());
    }

    @isTest
    static void deployInvocableWithInvalidCallbackShouldFallbackToDefaultCallback() {
        CustomMetadataSaver.FlowInput input = new CustomMetadataSaver.FlowInput();
        input.customMetadataRecords = new List<SObject>{ createCustomMetadataRecord() };
        input.sendEmailOnError = true;
        input.sendEmailOnSuccess = false;
        input.customCallbackName = 'ClassThatDoesNotExist';

        Test.startTest();
        CustomMetadataSaver.deploy(new List<CustomMetadataSaver.FlowInput>{ input });
        Test.stopTest();

        System.assertEquals(1, CustomMetadataSaver.getDeploymentJobIds().size());
        System.assertEquals(CustomMetadataSaver.MOCK_DEPLOYMENT_ID, CustomMetadataSaver.getDeploymentJobIds()[0]);
    }

    @isTest
    static void deployInvocableWithCustomCallbackShouldInstantiateCustomCallback() {
        CustomMetadataSaver.FlowInput input = new CustomMetadataSaver.FlowInput();
        input.customMetadataRecords = new List<SObject>{ createCustomMetadataRecord() };
        input.sendEmailOnError = false;
        input.sendEmailOnSuccess = true;
        input.customCallbackName = 'CustomMetadataSaverTest.CustomMetadataSaverFlowCallbackMock';

        Test.startTest();
        CustomMetadataSaver.deploy(new List<CustomMetadataSaver.FlowInput>{ input });
        Test.stopTest();

        System.assertEquals(1, CustomMetadataSaver.getDeploymentJobIds().size());
        System.assertEquals(CustomMetadataSaver.MOCK_DEPLOYMENT_ID, CustomMetadataSaver.getDeploymentJobIds()[0]);
    }

    private static SObject createCustomMetadataRecord() {
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();

        for (String objectApiName : globalDescribe.keySet()) {
            if (!objectApiName.endsWith('__mdt')) {
                continue;
            }

            Schema.SObjectType customMetadataType = globalDescribe.get(objectApiName);
            SObject customMetadataRecord = customMetadataType.newSObject();
            customMetadataRecord.put('DeveloperName', 'UT_' + String.valueOf(Crypto.getRandomLong()).replace('-', ''));
            customMetadataRecord.put('MasterLabel', 'Unit Test ' + objectApiName);

            addOptionalCustomFieldValue(customMetadataRecord, customMetadataType);
            return customMetadataRecord;
        }

        System.assert(false, 'No custom metadata types are available in this org for testing');
        return null;
    }

    private static void addOptionalCustomFieldValue(SObject customMetadataRecord, Schema.SObjectType customMetadataType) {
        for (String fieldApiName : customMetadataType.getDescribe().fields.getMap().keySet()) {
            if (!fieldApiName.endsWith('__c')) {
                continue;
            }

            Schema.DescribeFieldResult fieldDescribe = customMetadataType.getDescribe().fields.getMap().get(fieldApiName).getDescribe();
            Object value = getValueForFieldType(fieldDescribe);
            if (value != null) {
                customMetadataRecord.put(fieldApiName, value);
                return;
            }
        }

    }
    private static Object getValueForFieldType(Schema.DescribeFieldResult fieldDescribe) {
        Schema.DisplayType fieldType = fieldDescribe.getType();
        if (fieldType == Schema.DisplayType.Boolean) {
            return true;
        }
        if (fieldType == Schema.DisplayType.String || fieldType == Schema.DisplayType.TextArea) {
            return 'Unit Test Value';
        }
        if (fieldType == Schema.DisplayType.Integer) {
            return 1;
        }
        if (fieldType == Schema.DisplayType.Double || fieldType == Schema.DisplayType.Currency || fieldType == Schema.DisplayType.Percent) {
            return 1.5;
        }
        if (fieldType == Schema.DisplayType.Date) {
            return Date.today();
        }
        if (fieldType == Schema.DisplayType.DateTime) {
            return System.now();
        }
        if (fieldType == Schema.DisplayType.Picklist) {
            List<Schema.PicklistEntry> picklistValues = fieldDescribe.getPicklistValues();
            if (!picklistValues.isEmpty()) {
                return picklistValues[0].getValue();
            }
        }
        return null;
    }

    static testMethod void testSendEmail() {
        CustomMetadataSaver.sendEmail('Test Subject', 'This is a test email body.');
    }

    private class CustomMetadataSaverFlowCallbackMock implements Metadata.DeployCallback {
        public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
            System.debug(LoggingLevel.INFO, 'Mock callback invoked.');
        }
    }
}