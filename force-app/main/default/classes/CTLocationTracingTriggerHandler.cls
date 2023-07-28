public with sharing class CTLocationTracingTriggerHandler {

    public static void beforeInsert(List<Location_Tracing__c> newLocationsTraces){

        List<Location_Tracing__c> locationsTracesDuplicates = CTLocationTracingController.checkDuplicates(newLocationsTraces);

        for (Location_Tracing__c locationTrace : locationsTracesDuplicates) {
            locationTrace.addError('Duplicate record found. Person: ' + locationTrace.Person__c 
            + ' and Location: ' + locationTrace.Location__c);
        }
    }
}