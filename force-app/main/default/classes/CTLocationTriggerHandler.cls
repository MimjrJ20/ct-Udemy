public with sharing class CTLocationTriggerHandler {

    //método 1
    public static void beforeInsert(List<Location__c> newLocations){

        for(Location__c location : newLocations){
            location.Status__c = 'Green';
        }

    }

    //método 2
    public static void beforeUpdate(List<Location__c> newLocations, Map<Id, Location__c> oldLocationsMap){

        for(Location__c location : newLocations){
            if(location.Status__c != oldLocationsMap.get(location.Id).Status__c){
    
                location.Status_Update_Date__c = System.today();
            }
        }

    }

    //método 3 
    public static void afterUpdate(List<Location__c> newLocations, Map<Id, Location__c> oldLocationsMap){

        Set<Id> statusChange = new Set<Id>();

        for(Location__c location : newLocations){

            if (location.Status__c == 'Red' && oldLocationsMap.get(location.Id).Status__c != 'Red') {
                statusChange.add(location.Id);
            }
        }

        List<Location_Tracing__c> locationTraces = CTLocationTracingController.getLocationsByLocationId(statusChange);
        Set<Id> personIds = new Set<Id>();
        for (Location_Tracing__c locationTrace : locationTraces) {
            personIds.add(locationTrace.Person__c);
        }

        List<Person__c> personsToUpdate = new List<Person__c>();
        for (Id personId : personIds) {
            Person__c personUpdate = new Person__c();
            personUpdate.Id = personId;
            personUpdate.Health_Status__c = 'Yellow';
        }

        if (personsToUpdate.size() > 0) {
            update personsToUpdate;
        }
    }
}