({
	 onChange: function (component, evt, helper) {
        //alert(component.find('select').get('v.value') + ' pie is good.');
        component.set("v.showOpptyPage", true);
        component.set("v.selectedValue", component.find('select').get('v.value')); 
        var secValue = component.get('v.selectedValue');
        var recTypeId = component.get('c.getOpptyRecordTypeID'); 
        alert('selectedValue---'+component.get('v.selectedValue'));
        recTypeId.setParams({ 
            "selectedValue" : "Other"
        }); 		
        //alert('recTypeId---'+recTypeId);
		
        recTypeId.setCallback(this, function(response) {
            
            var state = response.getState();  
            alert('state---'+state);
            if (state === "SUCCESS") {
                var RecTypeID  = response.getReturnValue();
                createRecordEvent.setParams({
                   "entityApiName": "Opportunity",
                   "recordTypeId": "0124B0000004kow"
                });
            createRecordEvent.fire();
                
                // do something with response.getReturnValue(), such as firing your create event here.
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
    }    
})