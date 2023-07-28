trigger CTLocationTracingTrigger on Location_Tracing__c (before insert, after insert, before update, after update, after delete, after undelete) {

    switch on Trigger.operationType {

        when BEFORE_INSERT {

            CTLocationTracingTriggerHandler.beforeInsert(Trigger.new);
        }

    }
}