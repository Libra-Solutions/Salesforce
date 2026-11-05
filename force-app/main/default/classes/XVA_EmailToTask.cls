public class XVA_EmailToTask implements Messaging.InboundEmailHandler 
{

    public static List<string> keepSubjectStrnigs = new List<string>{
        
    'New Provider Accounts Receivables Consult Request from movedocs.com',
    'New submission from Schedule a Demo on MoveDocs website'

    };

   public static List<string> sourceSkipStrings = new List<string> {
    'trio-providers'
   };

   public static final List<string> demoRequestSubjects = new List<string>{
    'New CASEpeer + MDs Demo Request for Oasis Attorney',
    'New CASEpeer Demo Request from movedocs.com',
    'New Filevine Demo Request from movedocs.com', 
    'New submission from Request Oasis Access on MoveDocs',
    'New SmartAdvocate Demo Request from movedocs.com'
   };
   public static final List<string> websiteRequestSubjects = new List<string>{
    'New submission from Schedule a Demo on MoveDocs website',
    'New submission from Schedule Demo on MoveDocs website',
    'New submission from Trio - Firms', 
    'New Provider Accounts Receivables Consult Request from movedocs.com'
   };

	  public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
		  Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          system.debug('message: '+email.plainTextBody);
          //system.debug('message html: '+email.HtmlBody);
          system.debug('email: '+email);
          //system.debug('envelope: '+envelope.fromAddress+'  - '+envelope.toAddress);

          // Parse all field values once, combining prefix variants from every form type
          String businesstype = GetLineStartingWith(email, new List<String>{ 'Business Type:', 'Select your business type::' })
              ?? GetParsedValue(email, 'Select your business type::', 'Additional Info:')
              ?? GetParsedValue(email, 'Select your business type::', 'Source:')
              ?? GetParsedValue(email, 'Select your business type::', 'How did you hear about MoveDocs?:')
              ?? GetParsedValue(email, 'Business Type:', 'Address:')
              ?? 'Law Firm';

          String name = GetLineStartingWith(email, 'Name:')
              ?? GetParsedValue(email, 'Name:', 'Email:')
              ?? '';

          String formEmail = GetLineStartingWith(email, 'Email:')
              ?? GetParsedValue(email, 'Email:', 'Phone:')
              ?? GetParsedValue(email, 'Email:', 'Address:')
              ?? GetParsedValue(email, 'Email:', 'Company:')
              ?? GetParsedValue(email, 'Email:', 'Select your business type::')
              ?? GetParsedValue(email, 'Email:', 'Additional Info:')
              ?? GetParsedValue(email, 'Email:', 'Source:')
              ?? '';

          String phone = GetLineStartingWith(email, 'Phone:')
              ?? GetParsedValue(email, 'Phone:', 'Address:')
              ?? GetParsedValue(email, 'Phone:', 'State:')
              ?? GetParsedValue(email, 'Phone:', 'Company:')
              ?? GetParsedValue(email, 'Phone:', 'Select your business type::')
              ?? GetParsedValue(email, 'Phone:', 'Additional Info:')
              ?? GetParsedValue(email, 'Phone:', 'Source:')
              ?? '';

          String address = GetLineStartingWith(email, 'Address:')
              ?? GetParsedValue(email, 'Address:', 'Company:')
              ?? GetParsedValue(email, 'Address:', 'Select your business type::')
              ?? GetParsedValue(email, 'Address:', 'Additional Info:')
              ?? GetParsedValue(email, 'Address:', 'Source:');

          String state = GetLineStartingWith(email, 'State:')
              ?? GetParsedValue(email, 'State:', 'Company:');

          String company = GetLineStartingWith(email, 'Company:')
              ?? GetParsedValue(email, 'Company:', 'Select your business type::')
              ?? GetParsedValue(email, 'Company:', 'Additional Info:')
              ?? GetParsedValue(email, 'Company:', 'Source:')
              ?? '';

          String comments = GetParsedValue(email, 'Additional Info:', 'Source:') ?? '';

          String source = GetLineStartingWith(email, 'Source:')
              ?? email.plainTextBody.normalizeSpace().substringAfter('Source:');

        Contact existingContact = null;
        if (!string.isBlank(formEmail)) {
            try {
                existingContact = [Select Id, Account.BillingState from Contact where email = :formEmail limit 1];
            } catch (Exception e) {

            }
        } 

        boolean isWebsiteRequest = false;

        system.debug('testing subject');
        for(String subject : websiteRequestSubjects) {
            system.debug('email subject: ' + email.subject);
            system.debug('testing against: ' + subject);
            if (email.subject.contains(subject)) {
                system.debug('found match');
                isWebsiteRequest = true;
                break;
            }
        }

        boolean isDemoRequest = false;
        for(String subject : demoRequestSubjects) {
            if (email.subject.contains(subject)) {
                isDemoRequest = true;
                break;
            }
        }

        
        system.debug('isWebsiteRequest: ' + isWebsiteRequest);
        system.debug('isDemoRequest: ' + isDemoRequest);
        
          try{
              if(isWebsiteRequest)
              {
                Contact MDwr = [SELECT Id, firstname, lastname from contact where firstname = 'Website Request' LIMIT 1];

                system.debug('State: ' + state);

                //check for various skips
                boolean shouldSkip = false;

                for(String skipString : sourceSkipStrings) { 
                  system.debug('testing ' + source + ' against ' + skipString);
                  
                  if (source != null && source.toLowerCase().contains(skipString.toLowerCase())) {
                    shouldSkip = true;
                    system.debug('skipping the email due to skip string match: ' + skipString);
                    break;
                  }
                }
                if (shouldSkip)  {
                    system.debug('running should skip');
                    return new Messaging.InboundEmailResult();
                }

                String blockComments = comments != '' ? comments + '\n' : '';
                blockComments += company != null ? '\n' + 'Company: ' + company + '\n' : '';
                blockComments += name != null ? 'Name: ' + name + '\n' : '';
                blockComments += formEmail != null ? 'Email: ' + formEmail + '\n' : '';
                blockComments += phone != null ? 'Phone: ' + phone + '\n' : '';
                blockComments += source != null ? 'Source: ' + source + '\n' : '';
                blockComments += businesstype != null ? 'Business Type: ' + businesstype + '\n' : '';
                blockComments += 'Address: ' + (state ?? address ?? '');

                system.debug('block comments:' + blockComments);
                
                Task t = new Task();

                if (keepSubjectStrnigs.contains(email.subject)) {
                    t.Subject = email.subject;
                } else {
                    t.Subject = 'Website Request Reachout - Demo';
                }

                t.Oasis_Type__c = 'Email';
                t.Oasis_Sub_Type__c = 'Website Request Reachout';
                t.Description = blockComments;
                t.whoId = existingContact?.Id ??  MDwr?.Id ?? null;
                t.State__c = state;

                Date activityDate = Date.today().addDays(7);
                Integer dayOfWeek = activityDate.toStartOfWeek().daysBetween(activityDate);

                if (dayOfWeek == 5) {
                    activityDate = activityDate.addDays(2);
                } else if (dayOfWeek == 6) { 
                    activityDate = activityDate.addDays(1);
                }
                t.ActivityDate = activityDate;

                DateTime reminderDateTime = DateTime.now().addDays(4);
                Integer reminderDayOfWeek = reminderDateTime.date().toStartOfWeek().daysBetween(reminderDateTime.date());

                if (reminderDayOfWeek == 5) {
                    reminderDateTime = reminderDateTime.addDays(2);
                } else if (reminderDayOfWeek == 6) { 
                    reminderDateTime = reminderDateTime.addDays(1);
                }
                t.reminderDateTime = reminderDateTime;
                t.Successfully_Contacted__c = null;
                t.Parsed_From_Email__c = true;
                t.Business_Type__c = businesstype ?? 'Law Firm';
                t.Company__c = company;

                t.Email_Subject__c = email.subject;

                //t.RVP__c = GetRVPId(businesstype, existingContact?.Account?.BillingState ?? state);

                system.debug('new task record');
                system.debug(t);
                  insert t;
              } else if(isDemoRequest){
                result = handleCASEPeerForm(email, envelope, businesstype, name, formEmail, phone, address, state, company, comments, source);
              } else {
                system.debug('Subject does not match expected subjects');

              }
          } catch(exception e){
            Error_logs__c el = new Error_logs__c(
              exception_message__c ='Error Message: '+ e.getMessage() + '\n' + 'Email: '+email,
              source_method__c = 'handleInboundEmail',
              source_object__c = 'XVA_EmailToTask'
            );
            system.debug('Error:');
            system.debug(e.getMessage());
            insert el;
          }
            return result;
    }

    public static Messaging.InboundEmailResult handleCASEPeerForm(
            Messaging.InboundEmail email, Messaging.InboundEnvelope envelope,
            String businesstype, String name, String formEmail, String phone,
            String address, String state, String company, String comments, String source) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

          //check for various skips
          boolean shouldSkip = false;
          for(String skipString : sourceSkipStrings) { 
            system.debug('testing ' + source + ' against ' + skipString);
            if (source != null && source.toLowerCase().contains(skipString.toLowerCase())) {
                system.debug('skipping due to skip string');
              shouldSkip = true;
              break;
            }
          }
          if (shouldSkip) return new Messaging.InboundEmailResult();

        Contact existingContact = null;
        if (!string.isBlank(formEmail)) {
            try {
                existingContact = [Select Id from Contact where email = :formEmail limit 1];
            } catch (Exception e) {
                system.debug('error finding contact: ' + formEmail);
            }
        } 

          String taskComments = comments != '' ? comments + '\n' : '';
          taskComments += company != null ? '\n' + 'Company: ' + company + '\n' : '';
          taskComments += name != null ? 'Name: ' + name + '\n' : '';
          taskComments += formEmail != null ? 'Email: ' + formEmail + '\n' : '';
          taskComments += phone != null ? 'Phone: ' + phone + '\n' : '';
          taskComments += source != null ? 'Source: ' + source + '\n' : '';
          taskComments += businesstype != null ? 'Business Type: ' + businesstype + '\n' : '';
          taskComments += 'Address: ' + (state ?? address ?? '');

          Contact MDcr = [SELECT Id, firstname, lastname from contact where firstname = 'CMS Request' LIMIT 1];

          Task t = new Task();
            t.Subject = 'CMS Demo Follow Up';
            t.Oasis_Type__c = 'Task';
            t.Oasis_Sub_Type__c = 'CMS Demo Follow up (Filevine/Casepeer/Smartadvocate)';
            t.Description = taskComments;
            t.WhoId = existingContact?.Id ?? MDcr?.Id ?? null;
            t.State__c = state;
            t.Business_Type__c = businesstype;
            t.Email_Subject__c = email.subject;
            //t.From_MS_Bookings__c = true;

          Date activityDate = Date.today().addDays(7);
          Integer dayOfWeek = activityDate.toStartOfWeek().daysBetween(activityDate);

          if (dayOfWeek == 5) {
              activityDate = activityDate.addDays(2);
          } else if (dayOfWeek == 6) { 
              activityDate = activityDate.addDays(1);
          }
          t.ActivityDate = activityDate;

          DateTime reminderDateTime = DateTime.now().addDays(4);
          Integer reminderDayOfWeek = reminderDateTime.date().toStartOfWeek().daysBetween(reminderDateTime.date());

          if (reminderDayOfWeek == 5) {
              reminderDateTime = reminderDateTime.addDays(2);
          } else if (reminderDayOfWeek == 6) { 
              reminderDateTime = reminderDateTime.addDays(1);
          }
          t.reminderDateTime = reminderDateTime;
          t.Successfully_Contacted__c = null;

          //t.OwnerId = GetAssignedToFromState(state ?? address, businesstype);
          //t.rvp__c = t.OwnerId;
          t.Parsed_From_Email__c = true;
          t.Company__c = company;

          if(email.subject.contains('New submission from Request Oasis Access on MoveDocs')){
              t.subject = 'Request Oasis Access on MoveDocs';
              t.OwnerId = [SELECT Id, email FROM User WHERE email IN ('dgraubart@oasisfinancial.com','dgraubart@oasisfinancial.com.invalid') LIMIT 1].Id;
              t.rvp__c = t.OwnerId;
              t.Oasis_Sub_Type__c = 'Oasis on MoveDocs';
          }
            insert t;
        return result;
    }

    //email.plainTextBody.normalizeSpace().substringBetween('Select your business type::','Additional Info:')

    public static string GetParsedValue(Messaging.InboundEmail email, string startText, string endText) 
    {
        return GetParsedValue(email.plainTextBody, startText, endText);
    }

    public static string GetParsedValue(string sourceText, string startText, string endText) 
    { 

        system.debug('Get Parsed Value: ' + sourceText + ' from ' + startText + ' to ' + endText);
      if (sourceText == null || startText == null || endText == null) {
          return null;
      }

      string returnValue = sourceText.normalizeSpace().substringBetween(startText, endText);

      system.debug(returnValue);

      if (returnValue == '' || returnValue == null) return null;

      return returnValue.trim();
    }

    public static List<String> GetEmailLines(Messaging.InboundEmail email) {
        return GetEmailLines(email.plainTextBody);
    }

    public static List<String> GetEmailLines(String sourceText) {
        if (sourceText == null) {
            return new List<String>();
        }
        // Normalise CRLF → LF then split on LF so carriage-return characters are stripped
        return sourceText.replace('\r\n', '\n').replace('\r', '\n').split('\n');
    }

    public static String GetLineStartingWith(Messaging.InboundEmail email, String startsWith) {
        return GetLineStartingWith(email.plainTextBody, new List<String>{ startsWith });
    }

    public static String GetLineStartingWith(Messaging.InboundEmail email, List<String> startsWithOptions) {
        return GetLineStartingWith(email.plainTextBody, startsWithOptions);
    }

    public static String GetLineStartingWith(String sourceText, String startsWith) {
        return GetLineStartingWith(sourceText, new List<String>{ startsWith });
    }

    public static String GetLineStartingWith(String sourceText, List<String> startsWithOptions) {
        if (sourceText == null || startsWithOptions == null || startsWithOptions.isEmpty()) {
            return null;
        }
        List<String> lines = GetEmailLines(sourceText);
        for (String prefix : startsWithOptions) {
            for (String line : lines) {
                String trimmedLine = line.trim(); 
                if (trimmedLine.startsWith(prefix)) {
                    String value = trimmedLine.substring(prefix.length()).trim();
                    system.debug('GetLineStartingWith [' + prefix + ']: ' + value);
                    return value;
                }
            }
        }
        return null;
    }

    public static boolean StringContainsList(string searchText, List<string> searchFor) {
        if (searchText == null || searchFor == null || searchFor.isEmpty()) {
            return false;
        }
        for (string s : searchFor) {
            if (searchText.contains(s)) {
                return true;
            }
        }
        return false;
    }

    public static string GetAssignedToFromState(string state, string businessType) 
    {
      string returnValue = null;

      system.debug('GetAssignedToFromState state: '+state+' businessType: '+businessType);    

      /* we don't want to do this - it needs to happen against the assignment flow
      if(!String.isBlank(businessType) && businessType.contains('Provider')){
          return [SELECT Id, email FROM User WHERE email IN ('miglinski@movedocs.com.invalid', 'miglinski@movedocs.com') LIMIT 1].Id;
      } else if(StringContainsList(state, new List<string>{'Tennessee', 'Virginia', 'Maryland', 'North Carolina', 'South Carolina', 'Delaware', 'Washington D.C.', 'Georgia'})) {
          return [SELECT Id, email FROM User WHERE email IN ('jason@movedocs.com.invalid', 'jason@movedocs.com') LIMIT 1].Id;
      } else if(StringContainsList(state, new List<string>{'Texas', 'Louisiana', 'Arkansas', 'Oklahoma'})) {
          return [SELECT Id, email FROM User WHERE email IN ('lchristensen@movedocs.com.invalid', 'lchristensen@movedocs.com') LIMIT 1].Id;
      } else if(StringContainsList(state, new List<string>{'California', 'Nevada', 'Oregon', 'Washington', 'Utah', 'Arizona', 'New Mexico', 'Colorado'})) {
          return [SELECT Id, email FROM User WHERE email IN ('mfuqua@movedocs.com.invalid','mfuqua@movedocs.com') LIMIT 1].Id;
      } else if(StringContainsList(state, new List<string>{'Illinois', 'Indiana', 'Ohio', 'Michigan', 'Wisconsin', 'Minnesota', 'Iowa', 'Missouri', 'Pennsylvania', 'Rhode Island', 'New Jersey', 'Massachusetts', 'New York'})) {
          return [SELECT Id, email FROM User WHERE email IN ('clawler@movedocs.com','clawler@movedocs.com.invalid', 'clawler@oasisfinancial.com.invalid') LIMIT 1].Id;
      } else if(StringContainsList(state, new List<string>{'Florida', 'Alabama', 'Mississippi'})) {
          return [SELECT Id, email FROM User WHERE email IN ('clawler@movedocs.com.invalid', 'clawler@movedocs.com') LIMIT 1].Id;
      } */

      return null;
    }

    public static string GetRVPId(string businessType, string state) 
    {
        //this isn't different between providers and non-providers currently, but we'll separate it for when it inevitably becomes different
        Ownership_Routing__mdt routingRecord = [Select Id, RVP_ID__c from Ownership_Routing__mdt where State_Code__c = :state or STate_Name__C = :state limit 1];
        return routingRecord?.RVP_ID__c;
    
    }
}