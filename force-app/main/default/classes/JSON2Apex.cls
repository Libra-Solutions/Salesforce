/**
  * @Created Date 04/24/2019
  * @author    OASISFINANCIAL GROUP
  * @copyright Copyright (c) 2019-2020 
  * @license   
  * @Modified Date
  * @Description 
*/

public class JSON2Apex {

    public Integer Count {get;set;} 
    public List<Notes> Notes {get;set;} 

    public JSON2Apex(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'Count') {
                        Count = parser.getIntegerValue();
                    } else if (text == 'Notes') {
                        Notes = arrayOfNotes(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class Notes {
        public String CRM_FirmID {get;set;} 
        public String CRM_FirmLocationID {get;set;} 
        public String CRM_AttorneyID {get;set;} 
        public Integer NoteID {get;set;} 
        public String NoteText {get;set;} 
        public String Name {get;set;} 
        public String DateCreated {get;set;} 

        public Notes(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'CRM_FirmID') {
                            CRM_FirmID = parser.getText();
                        } else if (text == 'CRM_FirmLocationID') {
                            CRM_FirmLocationID = parser.getText();
                        } else if (text == 'CRM_AttorneyID') {
                            CRM_AttorneyID = parser.getText();
                        } else if (text == 'NoteID') {
                            NoteID = parser.getIntegerValue();
                        } else if (text == 'NoteText') {
                            NoteText = parser.getText();
                        } else if (text == 'Name') {
                            Name = parser.getText();
                        } else if (text == 'DateCreated') {
                            DateCreated = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Notes consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public static JSON2Apex parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new JSON2Apex(parser);
    }
    
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT ||
                curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }
    

    private static List<Notes> arrayOfNotes(System.JSONParser p) {
        List<Notes> res = new List<Notes>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Notes(p));
        }
        return res;
    }





}