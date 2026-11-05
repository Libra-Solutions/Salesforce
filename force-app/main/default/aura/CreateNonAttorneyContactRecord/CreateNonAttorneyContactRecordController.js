({
    doInit : function(component, event, helper) {
        
        var parentRecid=component.get("v.recordId");
        
        if(parentRecid.substr(0,3)=='003'){
        	component.set("v.AttorneyConId",component.get("v.recordId"));
            component.set("v.isAccount",false); 
        }else{
             component.set("v.isAccount",true); 
        }
      
        component.set("v.isSpinner",true);
        var action = component.get("c.getPickValues");
        action.setParams({
            "objectName" : 'Contact',
            "fieldName" : 'Salutation,Role__c'

        });
        action.setCallback(this,function(a){
            
            if(a.getState()==='SUCCESS'){
                var result = a.getReturnValue();
                var contactPickListValues = [];
                for(var key in result){
                    contactPickListValues.push(result[key]);
                }
                component.set("v.contactPickListValues",contactPickListValues);
                
            }else if(a.getState()==="ERROR"){
                console.log('Error at stringArrays');
            }
            component.set("v.isSpinner",false);
        });
        $A.enqueueAction(action);
        
        var newContact={};
        newContact['FirstName']='';
        newContact['Salutation']='';
        newContact['LastName']='';
        newContact['MiddleName__c']='';
        newContact['Phone']='';
        newContact['Mobile']='';
        newContact['Fax']='';
        newContact['Email']='';
        newContact['Role__c']='';
        component.set("v.newContact",newContact);
        
    },
    showNewAttorney : function(component, event, helper) {
        var newContact={};
        newContact['FirstName']='';
        newContact['Salutation']='';
        newContact['LastName']='';
        newContact['MiddleName__c']='';
        newContact['Phone']='';
        newContact['Mobile']='';
        newContact['Fax']='';
        newContact['Email']='';
        newContact['Role__c']='';
        component.set("v.newContact",newContact);
        component.set("v.isNewModel",true);
    },
    closeNewAttorney : function(component, event, helper) {
        component.set("v.isNewModel",false);
    },
    saveRecord : function(cmp, evt, helper) {
       var errMsg='';
        if(cmp.get("v.isAccount")){
            var attcon=cmp.get("v.selectedLookUpRecord");
            cmp.set("v.AttorneyConId",attcon.Id);
            if(attcon.Id==undefined){
                 errMsg=' Attorney Contact,';
                 cmp.set("v.attErrMsg",'Complete this field.');
            }else{
                cmp.set("v.attErrMsg",'');
            }
           
        }
        
        
        var newContact=cmp.get("v.newContact");
        
        if(newContact.LastName.trim()==''){
            errMsg+='Last Name,';
        }
        if(newContact.FirstName.trim()==''){
            errMsg+='First Name,';
        }
        if(newContact.Email.trim()==''){
            errMsg+=' Email,';
        }
        if(newContact.Role__c.trim()==''){
            errMsg+='Role,';
        }
        if(errMsg!=''){
            errMsg=errMsg.substring(0,errMsg.length-1);
        }
        cmp.set('v.errMsg',errMsg);
        
        var allValid = cmp.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        if (allValid) {
            cmp.set('v.isErrMsg',false);
        } else {
            cmp.set('v.isErrMsg',true);
        }
        
        if(errMsg==''){
            cmp.set("v.isSpinner",true);
            var action = cmp.get("c.saveReocrds");
            action.setParams({
                "contactRecord" : JSON.stringify(cmp.get("v.newContact")),
                 "recordId" :cmp.get("v.AttorneyConId")
            });
            action.setCallback(this,function(a){
                if(a.getState()==='SUCCESS'){
                    var result = a.getReturnValue();
                    
                    if(result){
                        cmp.set("v.isNewModel",false);
                    }else{
                        cmp.set("v.isNewModel",false);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "type":"success",
                            "message": "The record has been Created successfully."
                        });
                        toastEvent.fire();
                        
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": "/"+cmp.get("v.recordId")
                        });
                        urlEvent.fire();
                        
                        
                    }
                    cmp.set("v.isEmail",result);
                }else{
                    var errul='<ul>';
                    var errRecord=a.getError();
                    
                    for(var i=0;i<errRecord.length;i++){
                        for(var j=0;j<errRecord[i].pageErrors.length;j++){
                            errul+='<li>'+errRecord[i].pageErrors[i].message+'</li>';
                        }
                        
                        if(childRecordField=errRecord[i].fieldErrors!=undefined){
                            var childRecordField=errRecord[i].fieldErrors;
                            var childKeys=Object.keys(childRecordField)+'';
                            childKeys=childKeys.split(",");                           
                            
                            for(var m=0;m<childKeys.length;m++){
                                if(childRecordField[childKeys[m]]!=undefined){
                                    for(var l=0;l<childRecordField[childKeys[m]].length;l++){
                                        errul+='<li>'+childRecordField[childKeys[m]][l].message+'</li>';
                                    }
                                }
                            }
                            
                        }
                    }
                    errul+='</ul>';
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type":"error",
                        "message": errul
                    });
                    toastEvent.fire();
                    
                }
                
               cmp.set("v.isSpinner",false);
            });
            $A.enqueueAction(action);
        }
    },
    closeEmailAlert : function(component, event, helper) {
        component.set("v.isNewModel",true);
        component.set("v.isEmail",false);
    },
    nonAttorneyShow: function(component, event, helper) {
        component.set("v.isNewModel",false);
        component.set("v.isEmail",false);
        
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Non_Attorney_Contact__c",
            "defaultFieldValues": {
                'Attorney__c' : component.get("v.recordId")
            }
            
        });
        createRecordEvent.fire();
        $A.get("e.force:closeQuickAction").fire();
       /* var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/"+component.get("v.recordId")
        });
        urlEvent.fire();*/
        
    },
})