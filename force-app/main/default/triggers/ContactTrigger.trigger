trigger ContactTrigger on Contact (before insert, after insert, before update, after update, after delete, after undelete) {

    switch on Trigger.operationType {

        when AFTER_INSERT {

            ContactTriggerHandler.afterInsert(Trigger.new);
        }

        when AFTER_UPDATE {

            ContactTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }

        when AFTER_DELETE {

            ContactTriggerHandler.afterDelete(Trigger.old);
        }

        when AFTER_UNDELETE {

            ContactTriggerHandler.afterUndelete(Trigger.new);
        }
    }
}