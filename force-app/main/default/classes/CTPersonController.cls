public with sharing class CTPersonController {

    //método 1
    public static String getToken(String mobileNum){
        
        //variavel da representação binária --> transformando string em blob
        Blob value = Blob.valueOf(mobileNum);

        // MD5 gera uma sequência hexadecimal de 32 caracteres
        Blob hash = Crypto.generateDigest('MD5', value);

        //retorno transformando blob em string
        return EncodingUtil.base64Encode(hash);
    }

    //método 2
    public static List<Person__c> getRecentHealthChanges(){
        
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                FROM Person__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
    }

    //método 3    
    public static List<Person__c> searchPeople(String seachrTerm){
        
        seachrTerm = '%' + seachrTerm + '%';
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                FROM Person__c 
                WHERE Name LIKE :seachrTerm 
                    OR Mobile__c LIKE :seachrTerm 
                    OR Token__c LIKE :seachrTerm 
                ORDER BY Status_Update_Date__c DESC NULLS LAST];
    }

    //método 4
    public static Person__c getPersonById(String personId){

        List<Person__c> listPerson = [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                                        FROM Person__c WHERE Id = :personId];
    
        if(listPerson != null && listPerson.size() > 0){
            return listPerson[0];

        } else {
            return null; 
        }
   
    }

    //método 5
    public static Map<String,Integer> getHealthStatusCount(){

        Map<String,Integer> mapPersonStatus = new Map<String,Integer>();

        List<AggregateResult> listResults = [SELECT Health_Status__c, COUNT(Id) countId FROM Person__c GROUP BY Health_Status__c];

        for(AggregateREsult person : listResults){
            String status = (String) person.get('Health_Status__c');
            Integer count = (Integer) person.get('countId');
            mapPersonStatus.put(status, count);
        }

        return mapPersonStatus;

    }

    //método 6
    public static Set<Id> getCohabitantes(Set<Id> personIds, Set<Id> alreadyProcessed){

        List<String> healthStatus = new List<String>{'Green', 'Yellow'};

        Set<Id> cohabitantes = new Set<Id>();

        List<People_Tracing__c> listPersonTraces = [
            SELECT Id, Person_1__c, Person_2__c 
            FROM People_Tracing__c 
            WHERE (Person_1__c IN : personIds OR Person_2__c IN :personIds)
                AND Contact_Type__c = 'Cohabitant'
                AND (Person_1__r.Health_Status__c IN :healthStatus OR Person_2__r.Health_Status__c IN :healthStatus)
                ];

        for(People_Tracing__c personTrace : listPersonTraces){

            if(!alreadyProcessed.contains(personTrace.Person_1__c)){
                cohabitantes.add(personTrace.Person_1__c);
                alreadyProcessed.add(personTrace.Person_1__c);
            }

            if(!alreadyProcessed.contains(personTrace.Person_2__c)){
                cohabitantes.add(personTrace.Person_2__c);
                alreadyProcessed.add(personTrace.Person_2__c);

            }
        }

        return cohabitantes;
    }

    //método 7
    public static Set<Id> getNeighbours(Set<Id> personIds, Set<Id> alreadyProcessed){

        Set<Id> neighbours = new Set<Id>();

        List<People_Tracing__c> listPersonTraces = [
            SELECT Id, Person_1__c, Person_2__c
            FROM People_Tracing__c 
            WHERE (Person_1__c IN : personIds OR Person_2__c IN :personIds)
                AND Contact_Type__c = 'Neighbours'
                AND (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c = 'Green')
                ];

        for(People_Tracing__c personTrace : listPersonTraces){

            if(!alreadyProcessed.contains(personTrace.Person_1__c)){
                neighbours.add(personTrace.Person_1__c);
                alreadyProcessed.add(personTrace.Person_1__c);
            }

            if(!alreadyProcessed.contains(personTrace.Person_2__c)){
                neighbours.add(personTrace.Person_2__c);
                alreadyProcessed.add(personTrace.Person_2__c);
            }
        }

        return neighbours;
    }

    //método 8
    public static Set<Id> getPrimaryContacts(Set<Id> personIds, Set<Id> alreadyProcessed){

        List<String> healthStatus = new List<String>{'Green', 'Yellow'};

        Set<Id> primaryContacts = new Set<Id>();

        List<People_Tracing__c> listPersonTraces = [
            SELECT Id, Person_1__c, Person_2__c
            FROM People_Tracing__c 
            WHERE (Person_1__c IN : personIds OR Person_2__c IN :personIds)
                AND Contact_Type__c = 'Other'
                AND Contact_Date__c = LAST_N_DAYS:10
                AND (Person_1__r.Health_Status__c IN :healthStatus OR Person_2__r.Health_Status__c IN :healthStatus)
                ];

        for(People_Tracing__c personTrace : listPersonTraces){

            if(!alreadyProcessed.contains(personTrace.Person_1__c)){
                primaryContacts.add(personTrace.Person_1__c);
                alreadyProcessed.add(personTrace.Person_1__c);

            }

            if(!alreadyProcessed.contains(personTrace.Person_2__c)){
                primaryContacts.add(personTrace.Person_2__c);
                alreadyProcessed.add(personTrace.Person_2__c);

            }
        }

        return primaryContacts;
    }

    //método 9    
    public static Set<Id> getSecondaryContacts(Set<Id> primaryContactsIds,  Set<Id> alreadyProcessed){

        Set<Id> secondaryContacts = new Set<Id>();

        List<People_Tracing__c> listPersonTraces = [
            SELECT Id, Person_1__c, Person_2__c
            FROM People_Tracing__c 
            WHERE (Person_1__c IN : primaryContactsIds OR Person_2__c IN :primaryContactsIds)
                AND Contact_Type__c = 'Other'
                AND (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c = 'Green')
                ];

        for(People_Tracing__c personTrace : listPersonTraces){

            if(!alreadyProcessed.contains(personTrace.Person_1__c)){
                secondaryContacts.add(personTrace.Person_1__c);
                alreadyProcessed.add(personTrace.Person_1__c);

            }

            if(!alreadyProcessed.contains(personTrace.Person_2__c)){
                secondaryContacts.add(personTrace.Person_2__c);
                alreadyProcessed.add(personTrace.Person_2__c);

            }
        }

        return secondaryContacts;
    }

    //método 10
    public static Map<String, Integer> getHealthHeaderStatusCount(){
        
        AggregateResult[] healthCountMap = [SELECT Health_Status__c, Count(Id) countId FROM Person__c GROUP BY Health_Status__c];

        if (healthCountMap != null && healthCountMap.size() > 0) {

            Map<String, Integer> resultMap = new Map<String, Integer>();

            for (AggregateResult result : healthCountMap) {
                String status = (String)result.get('Health_Status__c');
                Integer count = (Integer)result.get('countId');
                resultMap.put(status, count);
            }
            return resultMap;
        }

        return null;
    }
}