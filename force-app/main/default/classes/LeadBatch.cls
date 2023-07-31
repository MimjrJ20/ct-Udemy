public with sharing class LeadBatch implements Database.Batchable<SObject>{

    //método start
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id, LeadSource FROM Lead');
    }

    //método exceute
    public void execute(Database.BatchableContext bc, List<Lead> scope){
       
        for (Lead lead : scope) {
            lead.LeadSource = 'Web';
        }

        update scope;
    }

    //método finish
    public void finish (Database.BatchableContext bc){
        System.debug('Batch finished.');
    }
}