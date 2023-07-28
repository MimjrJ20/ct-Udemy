public with sharing class BoardPanelController {

    @AuraEnabled
    public static String addResult(String result, String mode){
        Word_Shuffle__c gameResult = new Word_Shuffle__c();
        gameResult.Mode__c = mode;
        gameResult.Result__c = result;
        insert gameResult;

        return 'success';
    }
}