public with sharing class CTPersonViewController {

    @AuraEnabled
    public static void updateHealthStatus(String personId){

        Person__c person = new Person__c();
        person.Id = personId;
        person.Health_Status__c = 'Red';
        
        update person;
    }
}