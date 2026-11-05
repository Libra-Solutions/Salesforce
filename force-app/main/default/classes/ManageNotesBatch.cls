/**
  * @Created Date 04/24/2019
  * @author    OASISFINANCIAL GROUP
  * @copyright Copyright (c) 2019-2020 
  * @license   
  * @Modified Date
  * @Description 
*/
global  class ManageNotesBatch implements Database.Batchable<sObject>, Database.Stateful{
   
   String query=null;
     
    Global ManageNotesBatch(){
    
       // this.query = query;
                
       query = 'select id,title, body,parentId,OwnerId, CreatedDate,IsPrivate from Note';
        system.debug('query : '+query);
    }
    
   
    
    Global Database.QueryLocator start(Database.BatchableContext BC){
       
        
        return Database.getQueryLocator(this.query);
    }
    
    Global void execute(Database.BatchableContext BC, List<Note> noteList){
        if(noteList.size()>0){
            List<ContentNote> notesTobeInserted = new List<ContentNote>();
            List<ContentDocumentLink > linkTobeInserted = new List<ContentDocumentLink >();
            for(Note oldNote: noteList)
            {
               
               
               String noteBody = ( String.isBlank( oldNote.body ) ? '' : oldNote.body )
                // the escape entity for '&' is '&amp;'
                // so it includes '&' in its own escape sequence, which is a problem
                // because escapeXml() changes '&' to '&amp;' as well
                // so a single '&' would become '&amp;amp;'
                // therefore we first find any normal '&'
                // and replace them with a token value that will
                // be later replaced with '&amp;'
                .replace('&', 'sfdcAMPERSANDsfdc')
                .escapeXml()
                .replace('sfdcAMPERSANDsfdc', '&amp;')
                // handle nitpick on apostrophe html entity
                .replace('&apos;', '&#39;')
                // handle known unsupported non-ascii characters
                // oddly, other symbols like ® ™ are ok unescaped
                .replace('©', '&copy;')
                // handle new lines
                .replace('\r\n', '<br>')
                .replace('\r', '<br>')
                .replace('\n', '<br>')
            ;

            // content version cannot have a null or empty string body
            // so set to empty paragraph which will appear as blank note.
            // we do this after escaping the original note body otherwise
            // the <p> tag would get escaped, doh!
            if ( String.isBlank( noteBody ) ) {
                noteBody = '<p></p>';
            }
               
               
               ContentVersion newNoteVersion = new ContentVersion(
                // data fields
                title = oldNote.title,
                versionData = Blob.valueOf( noteBody ),
                pathOnClient = oldNote.title + '.snote',
                firstPublishLocationId = oldNote.parentId,
                sharingPrivacy = ( oldNote.isPrivate ? 'P' : 'N' ),
                // custom fields for history tracking and conversion purposes
               // original_record_id__c = oldNote.id,
                //original_record_parent_id__c = oldNote.parentId,
               // original_record_owner_id__c = oldNote.ownerId,
                // audit fields
                ownerId = oldNote.ownerId, // system requirement, owner and creator must be the same
                createdById = oldNote.ownerId,
                createdDate = oldNote.createdDate
                //lastModifiedById = oldNote.lastModifiedById,
                //lastModifiedDate = oldNote.lastModifiedDate
               );
               
               insert newNoteVersion;
              /* 
                ContentNote cn = new ContentNote();
                cn.Title = jnote.Title;
                String body =  jnote.body;
                //cn.Content = Blob.valueOf(body.escapeHTML4());
                //cn.Content = Blob.valueOf(body.escapeXML().replace('\r\n', '<br>').replace('\r', '<br>').replace('\n', '<br>').replace('&apos;', '&#39;'));
                
                cn.Content =Blob.valueOf(body.escapeXML().replace('\r\n', '<br>').replace('\r', '<br>').replace('\n', '<br>').replace('&apos;', '&#39;'));
                notesTobeInserted.add(cn);
                //idList.add(cn.Id); 
                insert cn;
                 
             
                     ContentDocumentLink newCD = new ContentDocumentLink();
                    newCD.ContentDocumentId = cn.Id;
                    newCD.LinkedEntityId = jnote.ParentId;
                    newCD.ShareType = 'V';
                    newCD.Visibility = 'AllUsers';
                    insert newCD;
             */
            }
            /*
            Database.saveResult[] rslt=Database.insert(notesTobeInserted, false);
            integer row=0;
            for(Database.saveResult r: rslt){
                if(r.isSuccess()){
                    
                    ContentDocumentLink newCD = new ContentDocumentLink();
                    newCD.ContentDocumentId = r.getId();
                    newCD.LinkedEntityId = noteList.get(row).ParentId;
                    newCD.ShareType = 'V';
                    newCD.Visibility = 'AllUsers';
                    linkTobeInserted.add(newCD); 
                    
                    system.debug('-----------------'+noteList.get(row).Id+'--------->'+r.getId());
                    
                }
                else{
                      for(Database.Error err : r.getErrors()){
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Note fields that affected this error: ' + err.getFields());
                    }
                 }
                 
                 
                 row++;
                 
             }//for
           
            rslt=Database.insert(linkTobeInserted, false);
            row=0;
            for(Database.saveResult r: rslt){
                if(r.isSuccess()){
                    system.debug('Content link created -'+r.getId());
                //TODO:delete old notes here..
            }
            else{
                      for(Database.Error err : r.getErrors()){
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Note fields that affected this error: ' + err.getFields());
                    }
                 }
            
             }
             
             
             */
       
       }
    }
    
    
    Global void finish(Database.BatchableContext BC){
        
        
    }
}