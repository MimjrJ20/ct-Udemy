public with sharing class CTPersonTriggerHandler {

    //método 1
    public static void beforeInsert(List<Person__c> newPersons){

        for(Person__c person : newPersons){
            person.Health_Status__c = 'Green';
            person.Token__c = CTPersonController.getToken(person.Mobile__c);
        }
    }

    //método 2
    public static void beforeUpdate(List<Person__c> newPersons, Map<Id, Person__c> oldPersonsMap){

        for(Person__c person : newPersons){

            if(person.Health_Status__c != oldPersonsMap.get(person.Id).Health_Status__c){

                person.Status_Update_Date__c = System.today();
            }
        }
    }

    //método 3
    public static void afterUpdate(List<Person__c> newPersons, Map<Id, Person__c> oldPersonsMap){

        Set<Id> statusChange = new Set<Id>();
        Set<Id> redStatus = new Set<Id>();

        for(Person__c person : newPersons){
            
            if(person.Health_Status__c != oldPersonsMap.get(person.Id).Health_Status__c){

                statusChange.add(person.Id);
            }

            if(person.Health_Status__c == 'Red' && oldPersonsMap.get(person.Id).Health_Status__c == 'Red'){

                redStatus.add(person.Id);
            }
        }

        Set<Id> alreadyProcessed = new Set<Id>();
        alreadyProcessed.addAll(redStatus);

        Set<Id> orangeStatus = new Set<Id>();
        Set<Id> yellowStatus = new Set<Id>();

        List<Person__c> personsToUpdate = new List<Person__c>();
        
        //passando ids
        orangeStatus.addAll(CTPersonController.getCohabitantes(redStatus, alreadyProcessed));

        yellowStatus.addAll(CTPersonController.getNeighbours(redStatus, alreadyProcessed));

        //pegando lista
        Set<Id> primaryCoontacts = CTPersonController.getPrimaryContacts(redStatus, alreadyProcessed);

        orangeStatus.addAll(primaryCoontacts);

        yellowStatus.addAll(CTPersonController.getSecondaryContacts(primaryCoontacts, alreadyProcessed));

        for(Id personId : orangeStatus){

            Person__c updatePerson = new Person__c();
            updatePerson.Id = personId;
            updatePerson.Health_Status__c = 'Orange';
            personsToUpdate.add(updatePerson);
        }

        for(Id personId : yellowStatus){

            Person__c updatePerson = new Person__c();
            updatePerson.Id = personId;
            updatePerson.Health_Status__c = 'Yellow';
            personsToUpdate.add(updatePerson);
        }

        if(personsToUpdate.size() > 0){
            update personsToUpdate;
        }

        List<Location_Tracing__c> locationTraces = CTLocationTracingController.getLocationsByPersonIds(statusChange);
        if(locationTraces != null && locationTraces.size() > 0){
            Set<Id> locationsIds = new Set<Id>();
            for(Location_Tracing__c locationTrace : locationTraces){
                locationsIds.add(locationTrace.Location__c);
            }
            CTLocationController.updateRedScore(locationsIds);
        }

    }

}