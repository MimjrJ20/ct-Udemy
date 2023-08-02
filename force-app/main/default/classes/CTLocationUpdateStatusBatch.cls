public with sharing class CTLocationUpdateStatusBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc){

        List<String> status = new List<String>{'Red', 'Yellow', 'Orange'};
        Date today  = System.today();
        Date fouteenDaysAgo = today - 14;
        return Database.getQueryLocator('SELECT Id, Status__c FROM Location__c WHERE Status_Update_Date__c = :fouteenDaysAgo AND Status__c IN :status');
    }

    public void execute (Database.BatchableContext bc, List<Location__c> scope){

        for (Location__c location : scope) {
            location.Status__c = 'Green';
        }
        update scope;
    }

    public void finish (Database.BatchableContext bc){
        System.debug('CTLocationUpdateStatusBatch executed.');
    }
    
    //Anonymous
    
    //para agendar 
    //CTDataUpdateSchedule dataUp = new CTDataUpdateSchedule();
	//String jobId = System.schedule('Data Update Job', CTDataUpdateSchedule.CRON, dataUp);
	//System.debug('job id: ' + jobId);

    //para executar na hora 
    //CTDataUpdateSchedule dataUp = new CTDataUpdateSchedule();
	//dataUp.execute(null);
}