public with sharing class ContactTriggerHandler {

    //método 1
    public static void afterInsert (List<Contact> newContacts){

        Set<Id> accountIds = new Set<Id>();
            
            for(Contact cont : newContacts){

                if(String.isNotBlank(cont.AccountId)){

                    accountIds.add(cont.AccountId);
                }
            }
            AccountContactService.updateActiveContacts(accountIds);
    }

    //método 2
    public static void afterUpdate (List<Contact> newContacts, Map<Id, Contact> oldContactsMap){

        Set<Id> accountIds = new Set<Id>();
            
        for(Contact cont : newContacts){

            if(
                String.isNotBlank(cont.AccountId)
                && (oldContactsMap.get(cont.Id).Active__c != cont.Active__c)
            ){

                accountIds.add(cont.AccountId);

            } 
            
            if (oldContactsMap.get(cont.Id).AccountId != cont.AccountId){

                accountIds.add(oldContactsMap.get(cont.Id).AccountId);
                accountIds.add(cont.AccountId);

            }
        }

        AccountContactService.updateActiveContacts(accountIds);
    }
    
    //método 3
    public static void afterDelete (List<Contact> oldContacts){

        Set<Id> accountIds = new Set<Id>();
            
            for(Contact cont : oldContacts){

                if(String.isNotBlank(cont.AccountId)){

                    accountIds.add(cont.AccountId);
                }
            }
            AccountContactService.updateActiveContacts(accountIds);
    }

    //método 4
    public static void afterUndelete (List<Contact> newContacts){

        Set<Id> accountIds = new Set<Id>();
            
            for(Contact cont : newContacts){

                if(String.isNotBlank(cont.AccountId)){

                    accountIds.add(cont.AccountId);
                }
            }
            AccountContactService.updateActiveContacts(accountIds);
    }

}