({
    doInit : function(component, event, helper) {   		
        helper.finalMethod(component, event, helper);       
        component.set("v.hideOkButton", false);
        component.set("v.hideMessage", false);
        //$A.get("e.force:closeQuickAction").fire() ;
    },
    closeModal: function(component, event, helper) {
    	$A.get("e.force:closeQuickAction").fire() ;
    }  
})