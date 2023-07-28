public with sharing class LeadTriggerHandler {

    //variaveis

    public static Boolean alreadyExecuted = false; 

    //métodos

    public static void beforeInsert(List<Lead> newLeads){

        for(Lead leadRecord : newLeads){
        
            if(String.isBlank(leadRecord.LeadSource)){
                leadRecord.LeadSource = 'Other';            
            }
            
            if(String.isBlank(leadRecord.Industry)){
                leadRecord.addError('The industry field cannot be blank');
            }
        }
    }

    public static void afterInsert(List<Lead> newLeads){

        List<Task> leadTasks = new List<Task>();

        for(Lead leadRecord : newLeads){

            Task leadTask = new Task();
            leadTask.Subject = 'Follow up on Lead Status';
            leadTask.WhoId = leadRecord.Id;

            leadTasks.add(leadTask);
        }

        insert leadTasks;

        //resolver problema de loop infinito
        if(alreadyExecuted == false){

            LeadTriggerHandler.alreadyExecuted = true;

            Lead anotherLead = new Lead();
            anotherLead.LastName = 'Single Lead';
            anotherLead.Status = 'Open - Not Contacted';
            anotherLead.Company = 'CT Udemy';
            anotherLead.Industry = 'Finance';

            insert anotherLead;

        }

    }

    public static void beforeUpdate(List<Lead> newLeads, Map<Id, Lead> oldLeadMap){
        
        for(Lead leadRecord : newLeads){
        
            if(String.isBlank(leadRecord.LeadSource)){
                leadRecord.LeadSource = 'Other';            
            }
            
            if((leadRecord.Status == 'Closed - Converted' || leadRecord.Status == 'Closed - Not Converted') 
               && oldLeadMap.get(leadRecord.Id).Status == 'Working - Contacted'){
                leadRecord.Status.addError('You cannot directly close an open lead record');
            }
        }
    }

}