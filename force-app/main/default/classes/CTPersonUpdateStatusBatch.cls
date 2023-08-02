public with sharing class CTPersonUpdateStatusBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc){

        List<String> healthStatus = new List<String>{'Red', 'Yellow', 'Orange'};
        Date today  = System.today();
        Date fouteenDaysAgo = today - 14;
        return Database.getQueryLocator('SELECT Id, Health_Status__c FROM Person__c WHERE Status_Update_Date__c = :fouteenDaysAgo AND Health_Status__c IN :healthStatus');
    }

    public void execute (Database.BatchableContext bc, List<Person__c> scope){

        for (Person__c person : scope) {
            person.Health_Status__c = 'Green';
        }
        update scope;
    }

    public void finish (Database.BatchableContext bc){
        System.debug('CTPersonUpdateStatusBatch executed.');
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