public with sharing class CTLocationTracingController {

    //método 1
    public static List<Location_Tracing__c> getVisitors(String locationId){
                
        return [SELECT Id, Name, Person__c, Location__c, Visit_Date__c, 
                        Person__r.Name, Person__r.Health_Status__c, Person__r.Mobile__c ,Person__r.Token__c ,Person__r.Status_Update_Date__c
                FROM Location_Tracing__c 
                WHERE Location__c = :locationId
                    AND Visit_Date__c = LAST_N_DAYS:30
                ORDER BY Visit_Date__c DESC NULLS LAST LIMIT 100];
    }

    //método 2
    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> personIds){

        return [SELECT Id, Name, Person__c, Location__c, Visit_Date__c 
                FROM Location_Tracing__c 
                WHERE Person__c IN :personIds 
                    AND Visit_Date__c = LAST_N_DAYS:10];
    }

    //método 3
    public static List<Location_Tracing__c> getLocationsByLocationId(Set<Id> locationId){
        
        return [SELECT Id, Name, Person__c, Location__c, Visit_Date__c,Person__r.Health_Status__c 
                FROM Location_Tracing__c  
                WHERE Location__c IN :locationId
                    AND Person__r.Health_Status__c = 'Green'
                    AND Visit_Date__c = LAST_N_DAYS:10]; 
    }

    //método 4
    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> listLocationsTraces){

        //criar Map e Set
        Set<Id> locationsIds = new Set<Id>();
        Set<Id> personIds = new Set<Id>();
        Map<Id, Set<Id>> mapLocationsTraces = new Map<Id, Set<Id>>();

        //iterar sobre os novos location_tracing e adicionar ids na lista de id
        for(Location_Tracing__c locationTrace : listLocationsTraces){
            locationsIds.add(locationTrace.Location__c);
            personIds.add(locationTrace.Person__c);
        }

        //consulta da existente location_tracing
        List<Location_Tracing__c> listLocationsTracesExisting = [SELECT Id, Location__c, Person__c 
                                                            FROM Location_Tracing__c
                                                            WHERE Location__c IN :locationsIds
                                                                AND Person__c IN :personIds];
                                            
        //lista de registros duplicado
        List<Location_Tracing__c> listLocationsTraceDuplicate = new List<Location_Tracing__c>();
        
        //loop para adicionar ids no map
        if(listLocationsTracesExisting != null && listLocationsTracesExisting.size() > 0 ){

            for (Location_Tracing__c locationTrace : listLocationsTracesExisting) {

                if(!mapLocationsTraces.containsKey(locationTrace.Location__c)){

                    mapLocationsTraces.put(locationTrace.Location__c, new Set<Id>());
                }

                mapLocationsTraces.get(locationTrace.Location__c).add(locationTrace.Person__c);             
            }

            for (Location_Tracing__c locationTrace : listLocationsTraces) {

                if(mapLocationsTraces.containsKey(locationTrace.Location__c)

                    && mapLocationsTraces.get(locationTrace.Location__c).contains(locationTrace.Person__c)){

                        listLocationsTraceDuplicate.add(locationTrace);
                    }
            }
        }

        return listLocationsTraceDuplicate;
    }
}