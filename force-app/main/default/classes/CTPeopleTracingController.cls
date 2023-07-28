public with sharing class CTPeopleTracingController {
    
    //método 1
    public static List<People_Tracing__c> getTraces (String peopleId){

        return[SELECT Id, Name, Contact_Date__c, Contact_Type__c, Person_1__c, Person_2__c, 
                        Person_1__r.Name, Person_1__r.Health_Status__c, Person_1__r.Mobile__c, Person_1__r.Token__c, Person_1__r.Status_Update_Date__c,
                        Person_2__r.Name, Person_2__r.Health_Status__c, Person_2__r.Mobile__c, Person_2__r.Token__c, Person_2__r.Status_Update_Date__c
                FROM People_Tracing__c 
                WHERE (Person_1__c = :peopleId
                    OR Person_2__c = :peopleId)
                    AND Contact_Date__c = LAST_N_DAYS:30
                ORDER BY Contact_Date__c DESC NULLS LAST];

    }

    //método 2
    public static List<People_Tracing__c> checkDuplicates (List<People_Tracing__c> listPeopleTraces){

        //criar Map e Set
        Set<Id> personIds = new Set<Id>();
        Map<Id, Set<Id>> mapPeopleTraces = new Map<Id, Set<Id>>();

        //iterar sobre os novos people_tracing e adicionar ids na lista de id
        for(People_Tracing__c peopleTrace : listPeopleTraces){
            personIds.add(peopleTrace.Person_1__c);
            personIds.add(peopleTrace.Person_2__c);
        }

        //consulta da existente location_tracing
        List<People_Tracing__c> listPeopleTracesExisting = [SELECT Id, Name, Contact_Date__c, Contact_Type__c, Person_1__c, Person_2__c
                                                                FROM People_Tracing__c
                                                                WHERE Person_1__c IN :personIds
                                                                    OR Person_2__c IN :personIds];
        
        //lista de registros duplicado
        List<People_Tracing__c> listPeopleDuplicates = new List<People_Tracing__c>();

        //loop para adicionar ids no map
        if(listPeopleTracesExisting != null && listPeopleTracesExisting.size() > 0 ){

            for (People_Tracing__c peopleTrace : listPeopleTracesExisting) {

                //person 1
                if(!mapPeopleTraces.containsKey(peopleTrace.Person_1__c)){

                    mapPeopleTraces.put(peopleTrace.Person_1__c, new Set<Id>());
                }

                mapPeopleTraces.get(peopleTrace.Person_1__c).add(peopleTrace.Person_2__c);
                
                //person 2
                if(!mapPeopleTraces.containsKey(peopleTrace.Person_2__c)){

                    mapPeopleTraces.put(peopleTrace.Person_2__c, new Set<Id>());
                }

                mapPeopleTraces.get(peopleTrace.Person_2__c).add(peopleTrace.Person_1__c);     
            }

            for (People_Tracing__c peopleTrace : listPeopleTraces) {

                if(
                    (mapPeopleTraces.containsKey(peopleTrace.Person_1__c)
                
                    && mapPeopleTraces.get(peopleTrace.Person_1__c).contains(peopleTrace.Person_2__c))
                    
                    ||

                    (mapPeopleTraces.containsKey(peopleTrace.Person_2__c)
                
                    && mapPeopleTraces.get(peopleTrace.Person_2__c).contains(peopleTrace.Person_1__c))
                    
                    ){

                        listPeopleDuplicates.add(peopleTrace);
                    }
            }
        }

        return listPeopleDuplicates;
    }
}