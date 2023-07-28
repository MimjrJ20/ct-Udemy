({
    showInfo : function(component) {

        const recordId = component.get("v.recordId");
        const action = component.get("c.getLocationDetails");

        action.setParams({
            locationId  : recordId
        });

        action.setCallback(this, function (response) {

            const status = response.getState();

            if (status === "SUCCESS") {

                const resp = response.getReturnValue();

                if (!resp || !resp.name) {
                    console.log('nok ' + resp.name);

                    component.set("v.locationFound", false);
                    this.showToast("ERROR, verify!", "Please enter valid user id.", "error");

                } else {
                    console.log('ok' + resp.name);
                    component.set("v.locationFound", true);
                    component.set("v.locationInfo", resp);
                }

            } else {
                console.log('nok 2 ' + resp.name);

                component.set("v.locationFound", false);
                this.showToast("ERROR, verify!", "Please enter valid user id.", "error");
            }
        });
        $A.enqueueAction(action);
    },

    showToast : function(titleValue, messageValue, typeValue) {

        const toastEvent = $A.get("e.force:showToast");

        toastEvent.setParams({
            title: titleValue,
            message: messageValue,
            type :  typeValue
        });

        toastEvent.fire();
    }
})

