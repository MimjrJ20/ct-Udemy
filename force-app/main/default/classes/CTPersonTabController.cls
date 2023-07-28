public with sharing class CTPersonTabController {

    @AuraEnabled
    public static UserInformation getPersonDetails(String personId){
        UserInformation infos = new UserInformation();

        Person__c person = CTPersonController.getPersonById(personId);

        if (person != null) {
            infos.name = person.Name;
            infos.token = person.Token__c;
            infos.statusUpdate = person.Status_Update_Date__c;
            infos.phone = person.Mobile__c;
            infos.status = person.Health_Status__c;

        }

        List<People_Tracing__c> listPeople = CTPeopleTracingController.getTraces(personId);

        if (listPeople!= null && listPeople.size() > 0) {
            
            List<CloseContacts> listContacts = new List<CloseContacts>();

            Set<Id> ids = new Set<Id>();
            ids.add(personId);

            for (People_Tracing__c people : listPeople) {

                CloseContacts cc = new CloseContacts();

                if (!ids.contains(people.Person_1__c)) {
                    cc.id = people.Person_1__c;
                    cc.status = people.Person_1__r.Health_Status__c;
                    cc.token = people.Person_1__r.Token__c;
                    cc.contactDate = people.Contact_Date__c;
                }

                if (!ids.contains(people.Person_2__c)) {
                    cc.id = people.Person_2__c;
                    cc.status = people.Person_2__r.Health_Status__c;
                    cc.token = people.Person_2__r.Token__c;
                    cc.contactDate = people.Contact_Date__c;
                }

                listContacts.add(cc);
            }

            infos.contacts = listContacts;
            infos.contactsCount = listContacts.size();
        }

        return infos;
    }


    public class UserInformation{

        @AuraEnabled public String name;
        @AuraEnabled public String token;
        @AuraEnabled public Date statusUpdate;
        @AuraEnabled public String phone;
        @AuraEnabled public String status;
        @AuraEnabled public Integer contactsCount = 0;
        @AuraEnabled public List<CloseContacts> contacts;


    }

    public class CloseContacts{

        @AuraEnabled public String id;
        @AuraEnabled public String token;
        @AuraEnabled public Date contactDate;
        @AuraEnabled public String status;

    }
}