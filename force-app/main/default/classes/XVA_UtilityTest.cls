@isTest
public with sharing class XVA_UtilityTest {

    static testMethod void testGetEditableFields() {
        List<String> editableFields = XVA_Utility.getEditableFields('Account');
        System.assertNotEquals(null, editableFields);
    }

}