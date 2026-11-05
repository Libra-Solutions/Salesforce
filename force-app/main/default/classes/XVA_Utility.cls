public with sharing class XVA_Utility {


    public static List<string> getEditableFields(string objectName) 
    {
        Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        List<String> editableFields = new List<String>();
        for(Schema.SObjectField fieldRef : fields.values()) {
            Schema.DescribeFieldResult fieldResult = fieldRef.getDescribe();
            if(fieldResult.isUpdateable()) {
                editableFields.add(fieldResult.getname());
            }
        }

        return editableFields;
    }

}