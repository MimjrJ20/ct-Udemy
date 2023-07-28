public with sharing class CTPeopleTracingTriggerHandler {

    public static void beforeInsert(List<People_Tracing__c> newPeoples){

        List<People_Tracing__c> peoplesDuplicates = CTPeopleTracingController.checkDuplicates(newPeoples);

        for (People_Tracing__c peopleTrace : peoplesDuplicates) {
            peopleTrace.addError('Duplicate record found. Person 1: ' + peopleTrace.Person_1__c 
            + ' and Person 2: ' + peopleTrace.Person_2__c);
        }
    }
}