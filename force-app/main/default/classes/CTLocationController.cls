public with sharing class CTLocationController {
    
    //método 1
    public static List<Location__c> getRecentHealthChanges(){
        
        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
                FROM Location__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
    }

    //método 2
    public static List<Location__c> searchLocations(String searchTerm){

        searchTerm = '%' + searchTerm + '%';

        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
                FROM Location__c 
                WHERE Name LIKE :searchTerm OR 
                    Pincode__c LIKE :searchTerm OR 
                    Address__c LIKE :searchTerm
                ORDER BY Status_Update_Date__c DESC NULLS LAST];
    }

    //método 3
    public static Location__c getLocationById(String locationId){
        
        List<Location__c> listLocation = [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
                                            FROM Location__c WHERE Id = :locationId]; 

        if(listLocation != null && listLocation.size() > 0){
            return listLocation[0];

        } else {
            return null; 
        }
    }

    //método 4
    public static Map<String,Integer> getStatusCount(){

        Map<String,Integer> mapLocationStatus = new Map<String,Integer>();

        List<AggregateResult> listResults = [SELECT Status__c, COUNT(Id) countId FROM Location__c GROUP BY Status__c]; 

        for(AggregateResult location : listResults){
            String status = (String) location.get('Status__c');
            Integer count = (Integer) location.get('countId');
            mapLocationStatus.put(status, count);
        }

        return mapLocationStatus;
    }

    //método 5
    public static void updateRedScore (Set<Id> locationsIds){

        List<Location__c> locationsToUpdate = new List<Location__c> ();
        
        AggregateResult[] redPeopleLocation = [
            SELECT Location__c, COUNT(Id) countId FROM Location_Tracing__c
            WHERE Person__r.Health_Status__c = 'Red'
                AND Visit_Date__c = LAST_N_DAYS:10
                AND Location__c IN :locationsIds
            GROUP BY Location__c];

            for(AggregateResult result : redPeopleLocation){
                String locationId = (String) result.get('Location__c');
                Integer redScore = (Integer) result.get('countId');
                String status = getStatus(redScore);

                Location__c updateLocation  = new Location__c();
                updateLocation.Id = locationId;
                updateLocation.Red_Score__c = redScore;
                updateLocation.Status__c = status;
                locationsToUpdate.add(updateLocation);
            }

            if(locationsToUpdate != null && locationsToUpdate.size() > 0){
                update locationsToUpdate;
            }
    }

    //método 6
    public static String getStatus(Integer redScore){
        if(redScore == 0 ){
            return 'Green';

        } else if (redScore <= 5) {
            return 'Yellow';

        } else if (redScore <= 10) {
            return 'Orange';

        } else {
            return 'Red';

        }
    }

    //método 10
    public static Map<String, Integer> getHealthHeaderStatusCount(){
    
        AggregateResult[] healthCountMap = [SELECT Status__c, Count(Id) countId FROM Location__c GROUP BY Status__c];

        if (healthCountMap != null && healthCountMap.size() > 0) {

            Map<String, Integer> resultMap = new Map<String, Integer>();

            for (AggregateResult result : healthCountMap) {
                String status = (String)result.get('Status__c');
                Integer count = (Integer)result.get('countId');
                resultMap.put(status, count);
            }
            return resultMap;
        }

        return null;
    }
}