({
    addResultRecord : function(component, gameResult) {
        const resultValue = gameResult.toUpperCase();

        const action = component.get("c.addResult");

        const modeValue = component.get("v.selectedMode").toUpperCase();

        //passar parametros
        action.setParams({
            result : resultValue,
            mode : modeValue
        });

        action.setCallback(this, function(response){

            const status = response.getState();

            if (status !== "SUCCESS") {
                console.error("Error save record.");
            }
        });

        //chamando o método do apex 
        $A.enqueueAction(action);
    },

    showToast : function(titleValue, messageValue, typeValue) {
        const toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": titleValue,
            "message": messageValue,
            "type" :  typeValue
        });
        toastEvent.fire();
    }
})
