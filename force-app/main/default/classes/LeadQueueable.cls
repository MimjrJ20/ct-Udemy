public with sharing class LeadQueueable implements Queueable{

    public void execute(QueueableContext ct){

        List<Lead> listLeadExisting = [SELECT Id, LeadSource FROM Lead];

        for (Lead lead :  listLeadExisting) {
            lead.LeadSource = 'Web';
        }

        update listLeadExisting;
    }
}