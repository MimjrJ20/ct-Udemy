({
    doInit : function(component, event, helper) {
        //definir as colunas e passar para o atribbuto do componente
        const columns = [
            {label: 'Game Number', fieldName: 'Name', type: 'text'},
            {label: 'Mode', fieldName: 'Mode__c', type: 'text'},
            {label: 'Played On', fieldName: 'CreatedDate', type: 'date'},
            {label: 'Result', fieldName: 'Result__c', type: 'text'}

        ];
        component.set("v.columns", columns);

        //pegar resultado
        helper.showResult(component);
    },

    //atualizar a tabela automático
    onResultHandler : function (component, event, helper){

        helper.showResult(component);
    }
})
