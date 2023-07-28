public with sharing class CTLocationTabController {

    @AuraEnabled
    public static LocationInformation getLocationDetails(String locationId){
        
        LocationInformation infos = new LocationInformation();

        Location__c location = CTLocationController.getLocationById(locationId);

        if (location != null) {
            infos.name = location.Name;
            infos.redScore = (Integer)location.Red_Score__c;
            infos.statusUpdate = location.Status_Update_Date__c;
            infos.pincode = location.Pincode__c;
            infos.status = location.Status__c;

        }

        List<Location_Tracing__c> listLocations = CTLocationTracingController.getVisitors(locationId);

        if (listLocations!= null && listLocations.size() > 0) {
            
            List<CloseContacts> listContacts = new List<CloseContacts>();

            Set<Id> ids = new Set<Id>();
            ids.add(locationId);

            for (Location_Tracing__c locations : listLocations) {

                CloseContacts cc = new CloseContacts();

                cc.id = locations.Person__c;
                cc.status = locations.Person__r.Health_Status__c;
                cc.token = locations.Person__r.Token__c;
                cc.visitDate = locations.Visit_Date__c;

                listContacts.add(cc);
            }

            infos.contacts = listContacts;
            infos.contactsCount = listContacts.size();
        }

        return infos;
    }


    public class LocationInformation{

        @AuraEnabled public String name;
        @AuraEnabled public Integer redScore;
        @AuraEnabled public Date statusUpdate;
        @AuraEnabled public String pincode;
        @AuraEnabled public String status;
        @AuraEnabled public Integer contactsCount = 0;
        @AuraEnabled public List<CloseContacts> contacts;


    }

    public class CloseContacts{

        @AuraEnabled public String id;
        @AuraEnabled public String token;
        @AuraEnabled public Date visitDate;
        @AuraEnabled public String status;

    }
}