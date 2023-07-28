({
    handleSelect : function(component, event, helper) {

        //pegar o id da tab
        const selectedTab = event.getParam("id");

        //
        if (selectedTab === "person") {
            component.set("v.headerTitle", "Person View");
            component.set("v.scope", selectedTab);

        } else {
            component.set("v.headerTitle", "Location View");

        }
        component.set("v.scope", selectedTab);

        const healthHeaderComp = component.find("health-header");
        healthHeaderComp.showCount();


    }
})
