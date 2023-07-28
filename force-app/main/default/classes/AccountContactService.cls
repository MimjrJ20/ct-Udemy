public with sharing class AccountContactService {

    public static void updateActiveContacts(Set<Id> ids){

        List<AggregateResult> listContactRestult = [
            SELECT AccountId, COUNT(Id) countId 
            FROM Contact 
            WHERE Active__c  = true AND AccountId IN :ids
            GROUP BY AccountId
        ];

        Map<Id, Account> accountToUpMap = new Map<Id, Account>();

        //paraando os valores para Account com a quantidade de contatos ativo
        for(AggregateResult result : listContactRestult){

            String accId = (String) result.get('AccountId');
            Integer totalContacts = (Integer) result.get('countId');

            Account acc = new Account();
            acc.Id = accId;
            acc.Active_Contacts__c = totalContacts;

            accountToUpMap.put(accId, acc);
        }

        //passando ZERO para Account que não tiver nenhum contato ativo, pois ele não estará na lista
        for(Id accId : ids){
            if(!accountToUpMap.containsKey(accId)){

                Account acc = new Account();
                acc.Id = accId;
                acc.Active_Contacts__c = 0;

                accountToUpMap.put(accId, acc);
            }
        }

        update accountToUpMap.values();

    }
}