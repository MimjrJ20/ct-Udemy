public with sharing class CTPeopleTracingDataCleanupBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc){

        return Database.getQueryLocator('SELECT Id FROM People_Tracing__c WHERE Contact_Date__c < LAST_N_DAYS:30');
    }

    public void execute (Database.BatchableContext bc, List<People_Tracing__c> scope){

        delete scope;
    }

    public void finish (Database.BatchableContext bc){
        System.debug('CTPeopleTracingDataCleanupBatch executed.');
    }
    
    //Anonymous
    
    //para agendar 
    //CTDataCleanupSchedule dataCl = new CTDataCleanupSchedule();
	//String jobId = System.schedule('Data Cleanup Job', CTDataCleanupSchedule.CRON, dataCl);
	//System.debug('job id: ' + jobId);

    //para executar na hora 
    //CTDataCleanupSchedule dataCl = new CTDataCleanupSchedule();
	//dataCl.execute(null);
}