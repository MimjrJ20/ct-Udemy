public with sharing class LeadAsynchronous {


    @future
    public static void updateLeadRecords(Set<Id> listLeadExistingIds){

        List<Lead> listLeadExisting = [SELECT Id, LeadSource FROM Lead WHERE Id IN :listLeadExistingIds];

        for (Lead lead : listLeadExisting) {
            lead.LeadSource = 'Web';
        }

        update listLeadExisting;
    }

    @future
    public static void createLeadRecords(){
        
        Lead newLead = new Lead();
        newLead.LastName = 'Test Lead Single';
        newLead.Status = 'Open - Not Contacted';
        newLead.Company = 'Mimjr';

        insert newLead;
    
    }

}