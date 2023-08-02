public with sharing class CTDataUpdateSchedule implements Schedulable{

    public static final String CRON = '0 0 3 * * ?';


    public void execute(SchedulableContext sc){
        CTPersonUpdateStatusBatch personBatch = new CTPersonUpdateStatusBatch();

        Database.executeBatch(personBatch, 2000);

        CTLocationUpdateStatusBatch locationBatch = new CTLocationUpdateStatusBatch();

        Database.executeBatch(locationBatch, 2000);

    }
}