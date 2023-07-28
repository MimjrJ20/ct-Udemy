({
    doInit : function(component, event, helper) {

        const scope = component.get("v.scope");

        if (scope === "person") {

            //definir as colunas e passar para o atributo do componente - PERSON
            const columns = [
                {label: 'Name', fieldName: 'Name', type: 'text'},
                {label: 'Status', fieldName: 'Health_Status__c', type: 'text'},
                {label: 'Token', fieldName: 'Token__c', type: 'text'},
                {label: 'Phone', fieldName: 'Mobile__c', type: 'text'},
                {label: 'Status Update Date ', fieldName: 'Status_Update_Date__c', type: 'date'},
                {label: 'View', type: 'button', initialWidth: 135, typeAttributes: { label: 'View/Update', name: 'view_details', title: 'Click to View Details'}}
            ];
            component.set("v.columns", columns);
        } else {

            //definir as colunas e passar para o atributo do componente - LOCATION
            const columns = [
                {label: 'Name', fieldName: 'Name', type: 'text'},
                {label: 'Status', fieldName: 'Status__c', type: 'text'},
                {label: 'Pincode', fieldName: 'Pincode__c', type: 'text'},
                {label: 'Red Score', fieldName: 'Red_Score__c', type: 'text'},
                {label: 'Address', fieldName: 'Address__c', type: 'text'},
                {label: 'Status Update Date ', fieldName: 'Status_Update_Date__c', type: 'date'},
                {label: 'View', type: 'button', initialWidth: 135, typeAttributes: { label: 'View/Update', name: 'view_details', title: 'Click to View Details'}}
            ];
            component.set("v.columns", columns);
        }


        //pegar resultado
        helper.showResult(component);
    },


    handleKeyUp : function (component, event, helper) {

        const isEnterKey = event.keyCode === 13;
        const queryTerm = component.find("enter-search").get("v.value");

        if (!queryTerm) {

            const initialData = component.get("v.initialResponse");
            component.set("v.data", initialData);

        }
        if (isEnterKey) {

            component.set("v.issearching", true);
            helper.searchRecords(component, queryTerm);

        }
    },

    handleRowAction : function (component, event, helper) {

        const action = event.getParam("action");
        const row = event.getParam("row");
        const scope = component.get("v.scope");

        switch (action.name) {

            case "view_details":

                const appEvent = scope === "person" ? $A.get("e.c:CTPersonSelectEvent") : $A.get("e.c:CTLocationSelectEvent");

                appEvent.setParams({
                    recordId : row.Id,
                    status : scope === "person" ? row.Health_Status__c : row.Status__c
                });
                appEvent.fire();
                break;
        }
    }

    
})