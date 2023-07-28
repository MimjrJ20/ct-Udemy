({
    showStatus : function(component) {

        const scope = component.get("v.scope");
        let action = scope === "person" ? component.get("c.getPersonHealthStatusCount") : component.get("c.getLocationHealthStatusCount");

        action.setCallback(this, function (response){

            const status = response.getState();

            if (status === "SUCCESS") {

                component.set("v.count", response.getReturnValue());
            }
        });

        $A.enqueueAction(action);
    }
});
