public with sharing class HuntListCsvUploadController {
    public class UploadResult {
        @AuraEnabled public Integer totalRows;
        @AuraEnabled public Integer successCount;
        @AuraEnabled public Integer errorCount;
        @AuraEnabled public List<String> errors;
    }

    @AuraEnabled
    public static UploadResult saveHuntListRows(String rowsJson) {
        UploadResult result = new UploadResult();
        result.totalRows = 0;
        result.successCount = 0;
        result.errorCount = 0;
        result.errors = new List<String>();

        if (String.isBlank(rowsJson)) {
            return result;
        }

        Object parsed = JSON.deserializeUntyped(rowsJson);
        if (!(parsed instanceof List<Object>)) {
            throw new AuraHandledException('Invalid payload. Expected a JSON array.');
        }

        List<Object> rowObjects = (List<Object>) parsed;
        result.totalRows = rowObjects.size();
        if (rowObjects.isEmpty()) {
            return result;
        }

        Map<String, Schema.SObjectField> fieldsByApi = Schema.SObjectType.Hunt_List__c.fields.getMap();
        Map<String, String> apiByNormalizedLabel = new Map<String, String>();

        for (String apiName : fieldsByApi.keySet()) {
            Schema.DescribeFieldResult fieldDescribe = fieldsByApi.get(apiName).getDescribe();
            if (fieldDescribe.isCreateable()) {
                apiByNormalizedLabel.put(normalizeKey(fieldDescribe.getLabel()), apiName);
            }
        }

        List<Hunt_List__c> recordsToInsert = new List<Hunt_List__c>();

        List<String> accountIds = new List<String>();
        for (Object rowObject : rowObjects) {
          Map<String, Object> row = (Map<String, Object>) rowObject;
          String accountId = (String) row.get('Firm Location ID');
          accountIds.add(accountId);
        }

        List<Account> accounts = [SELECT Id,CTXFirmId__c,BillingStreet,BillingState,BillingCity,BillingPostalCode FROM Account WHERE CTXFirmId__c IN :accountIds];
        Map<String, Account> accountMap = new Map<String, Account>();
        for (Account acc : accounts) {
            accountMap.put(acc.CTXFirmId__c, acc);
        }


        Integer rowNumber = 1;
        for (Object rowObject : rowObjects) {
            if (!(rowObject instanceof Map<String, Object>)) {
                result.errorCount++;
                result.errors.add('Row ' + rowNumber + ': invalid row format.');
                rowNumber++;
                continue;
            }

            Map<String, Object> row = (Map<String, Object>) rowObject;
            Hunt_List__c recordToInsert = new Hunt_List__c();

            for (String csvHeader : row.keySet()) {
                Object rawValue = row.get(csvHeader);
                String value = rawValue == null ? '' : String.valueOf(rawValue).trim();
                if (String.isBlank(value)) {
                    continue;
                }

                switch on csvHeader {
                    when 'Firm Name', 'Firm Address', 'Postal Code', 'City', 'State','CMS','CMS Integrated' {
                        // These are valid headers, do nothing
                      continue; 
                    }
                    when 'Firm Location ID' {
                        if (!accountMap.containsKey(value)) {
                            result.errorCount++;
                            result.errors.add('Row ' + rowNumber + ', column "Firm Location ID": Account with ID "' + value + '" not found.');
                            continue;
                        }
                        Account acc = accountMap.get(value);
                        recordToInsert.Firm_Address__City__s = acc.BillingCity;
                        recordToInsert.Firm_Address__StateCode__s = acc.BillingState;
                        recordToInsert.Firm_Address__PostalCode__s = acc.BillingPostalCode;
                        recordToInsert.Firm_Address__Street__s = acc.BillingStreet;
                        recordToInsert.Firm_Name__c = acc.Id;
                        continue;
                    }
                    when 'Category' {
                        recordToInsert.Category__c = value;
                        continue;
                    }
                    when 'Oasis Dir' {
                      recordToInsert.Oasis_Director__c = value;
                      continue;
                    }
                    when 'PM Director'{
                      recordToInsert.PM_Director__c = value;
                      continue;
                    }
                    when 'Total Orig - YTD'{
                      recordToInsert.Total_Orig_YTD__c = Decimal.valueOf(value);
                      continue; 
                    }
                    when 'Previous Yr Forecast Orig'{
                      recordToInsert.Previous_Year_Forecast_Origination__c = Decimal.valueOf(value);
                      continue; 
                    }
                    when 'Current Year Budget Orig'{
                      recordToInsert.Current_Year_Budget_Originations__c = Decimal.valueOf(value);
                      continue; 
                    }
                    when 'How many cases per month does your law firm utilize non-healthcare medical liens on?'{
                      recordToInsert.Cases_Month_for_Non_healthcare_Med_Liens__c = value;
                      continue;
                    }
                    when 'How many cases per month does your law firm utilize pre-set funding on?'{
                      recordToInsert.Cases_Month_for_Pre_Set_Funding__c = value;
                      continue;
                    }
                    when 'Who\'s the pre-lit manager?'{
                      recordToInsert.Pre_Lit_Manager__c = value;
                      continue;
                    }
                    when 'Who\'s the litigation manager?'{
                      recordToInsert.Litigation_Manger__c = value;
                      continue;
                    }
                    when 'Who is the case manager lead?'{
                      recordToInsert.Case_Manager_Lead__c = value;
                      continue;
                    }
                    when 'Who handles medical map/provider decisions?'{
                      recordToInsert.Who_handles_medical_map_provider_decisio__c = value;
                      continue;
                    }
                    when 'Who handles pre-set funding decisions?'{
                      recordToInsert.Who_handles_pre_set_funding_decisions__c = value;
                      continue;
                    }
                    when 'Does law firm use competitors for PM or PF?'{
                      recordToInsert.Does_Law_Firm_use_competitor_for_PM_orPF__c = value;
                      continue;
                    }
                    when else {
                        result.errorCount++;
                        result.errors.add('Row ' + rowNumber + ', column "' + csvHeader + '": unrecognized header.');
                        continue;
                    }
                }
            }

            recordsToInsert.add(recordToInsert);
            rowNumber++;
        }

        if (recordsToInsert.isEmpty()) {
            result.errorCount += result.totalRows;
            if (result.errors.isEmpty()) {
                result.errors.add('No valid rows were found in the CSV.');
            }
            return result;
        }

        Database.SaveResult[] saveResults = Database.insert(recordsToInsert, false);
        for (Integer i = 0; i < saveResults.size(); i++) {
            if (saveResults[i].isSuccess()) {
                result.successCount++;
            } else {
                result.errorCount++;
                for (Database.Error err : saveResults[i].getErrors()) {
                    result.errors.add('Row ' + (i + 1) + ': ' + err.getMessage());
                }
            }
        }

        return result;
    }

    private static String normalizeKey(String keyValue) {
        if (String.isBlank(keyValue)) {
            return '';
        }

        String cleaned = keyValue.toLowerCase();
        cleaned = cleaned.replace('&', 'and');
        cleaned = cleaned.replaceAll('[^a-z0-9]', '');
        return cleaned;
    }
}