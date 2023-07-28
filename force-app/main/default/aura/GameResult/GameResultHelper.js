({
    showResult : function(component) {

        const action = component.get("c.getResults");

        action.setCallback(this, function(response){

            const status = response.getState();

            if (status === "SUCCESS") {

                const resp = response.getReturnValue();
                component.set("v.data", resp);
            }
        });

        //chamando o método do apex 
        $A.enqueueAction(action);
    }
})

