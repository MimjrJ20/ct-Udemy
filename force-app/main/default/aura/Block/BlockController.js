({
    blockClickHandler: function (component, event, helper) {
        const open = component.get("v.open");
        if (!open) {
            component.set("v.open", true);

            // pegar o rótulo o valor
            const label = component.get("v.label");
            
            // bloqueia o click do evento
            let compEvent = component.getEvent("onclick");
            compEvent.setParams({ value: label });
            compEvent.fire();
        }
    },

    scriptsLoaded: function (component, event, helper) {
        const divElement = component.getElement(".board-block");
        fitText(divElement);
    }
});

