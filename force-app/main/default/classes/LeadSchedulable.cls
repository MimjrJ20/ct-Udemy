public with sharing class LeadSchedulable  implements Schedulable{

    public void execute(SchedulableContext sc){

        List<Lead> listLeadExisting = [SELECT Id, LeadSource FROM Lead];

        for (Lead lead :  listLeadExisting) {
            lead.LeadSource = 'Web';
        }

        update listLeadExisting;
    }

}