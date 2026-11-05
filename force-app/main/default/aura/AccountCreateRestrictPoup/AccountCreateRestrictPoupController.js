({
    doInit : function(component,event,helper) {
         // Set isModalOpen attribute to true
      component.set("v.isModalOpen", true);
    },
    
   closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
      var action = component.get("c.getListViews");
    action.setCallback(this, function(response){
        var state = response.getState();
        if (state === "SUCCESS") {
            var listviews = response.getReturnValue();
            var navEvent = $A.get("e.force:navigateToList");
            navEvent.setParams({
                "listViewId": listviews.Id,
                "listViewName": null,
                "scope": "Account"
            });
            navEvent.fire();
        }
    });
    $A.enqueueAction(action);
   }    
})