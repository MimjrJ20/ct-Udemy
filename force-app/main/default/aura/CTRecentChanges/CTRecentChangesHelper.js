({
    showResult : function(component) {

        const action = component.get("v.scope") === "person" ? component.get("c.getRecentPersonHealthChanges") : component.get("c.getRecentLocationHealthChanges"); 

        action.setCallback(this, function(response){

            const status = response.getState();

            if (status === "SUCCESS") {

                const resp = response.getReturnValue();
                component.set("v.data", resp);
                component.set("v.initialResponse", resp);
                
            }
        });

        //chamando o método do apex 
        $A.enqueueAction(action);
    },

    searchRecords : function (component, queryTerm){

        const action = component.get("v.scope") === "person" ? component.get("c.searchPeople") : component.get("c.searchLocations"); 

        action.setParams({
            searchTerm : queryTerm
        });

        action.setCallback(this, function(response){

            const status = response.getState();

            if (status === "SUCCESS") {

                const resp = response.getReturnValue();

                if (resp && resp.length > 0) {

                    component.set("v.data", resp);

                }

                component.set("v.issearching", false);

            }
        });

        //chamando o método do apex 
        $A.enqueueAction(action);

    }
})