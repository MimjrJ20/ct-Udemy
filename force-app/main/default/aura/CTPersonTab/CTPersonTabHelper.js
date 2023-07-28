({
    showInfo : function(component) {

        const recordId = component.get("v.recordId");
        const action = component.get("c.getPersonDetails");

        action.setParams({
            personId  : recordId
        });

        action.setCallback(this, function (response) {

            const status = response.getState();

            if (status === "SUCCESS") {

                const resp = response.getReturnValue();

                if (!resp || !resp.name) {

                    component.set("v.userFound", false);
                    this.showToast("ERROR, verify!", "Please enter valid user id.", "error");

                } else {

                    component.set("v.userFound", true);
                    component.set("v.userInfo", resp);
                }

            } else {

                component.set("v.userFound", false);
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
