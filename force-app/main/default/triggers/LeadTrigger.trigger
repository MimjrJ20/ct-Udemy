trigger LeadTrigger on Lead (before insert, after insert, before update, after update ) {
    /*
    System.debug('Trigger size: ' + Trigger.size);
    System.debug('Trigger executing: ' + Trigger.isExecuting);
    System.debug('Trigger operation type: ' + Trigger.operationType);
    */

    switch on Trigger.operationType {

        when BEFORE_INSERT{

            LeadTriggerHandler.beforeInsert(Trigger.new);
        }

        when AFTER_INSERT{

            LeadTriggerHandler.afterInsert(Trigger.new);
        }

        when BEFORE_UPDATE{

            LeadTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);

        }
    }
}