@isTest
public with sharing class ContactTriggerHandlerTest {

    //método de teste (criar dados para o teste)
    @TestSetup
    static void makeData(){

        //inserir conta
        List<Account> accs = new List<Account>();

        Account accTest1 = new Account();
        accTest1.Name = 'Test Account 1';
        Account accTest2 = new Account();
        accTest2.Name = 'Test Account 2';

        accs.add(accTest1);
        accs.add(accTest2);

        insert accs;

        //inserir contato
        List<Contact> conts = new List<Contact>();

        Contact contTest1 = new Contact();
        contTest1.LastName = 'Test Contact 1';
        contTest1.AccountId = accs[0].Id;
        contTest1.Active__c = true;
        Contact contTest2 = new Contact();
        contTest2.LastName = 'Test Contact 2';
        contTest2.AccountId = accs[0].Id;
        contTest2.Active__c = true;
        Contact contTest3 = new Contact();
        contTest3.LastName = 'Test Contact 3';
        contTest3.AccountId = accs[0].Id;
        Contact contTest4 = new Contact();
        contTest4.LastName = 'Test Contact 4';
        contTest4.AccountId = accs[0].Id;
        Contact contTest5 = new Contact();
        contTest5.LastName = 'Test Contact 5';
        contTest5.AccountId = accs[1].Id;
        Contact contTest6 = new Contact();
        contTest6.LastName = 'Test Contact 6';
        contTest6.AccountId = accs[1].Id;

        conts.add(contTest1);
        conts.add(contTest2);
        conts.add(contTest3);
        conts.add(contTest4);
        conts.add(contTest5);
        conts.add(contTest6);

        insert conts;
    }

    /*
    //método 1
    @isTest
    public static void afterInsertTest1(){

        //assert conta
        List<Account> allAccs = [SELECT Id, Name, Active_Contacts__c FROM Account];
        System.assertEquals(2, allAccs.size());
        System.assertEquals(0, allAccs[0].Active_Contacts__c);
        System.assertEquals(0, allAccs[1].Active_Contacts__c);

        //assert contato
        List<Contact> allContacts = [SELECT Id FROM Contact];
        System.assertEquals(6, allContacts.size());
    }
    */

    //método 2
    @isTest
    public static void afterInsertTest2(){

        //assert conta
        List<Account> allAccs = [SELECT Id, Name, Active_Contacts__c FROM Account];
        System.assertEquals(2, allAccs.size());

        for (Account acc : allAccs) {

            if(acc.Name == 'Test Account 1'){
                System.assertEquals(2, acc.Active_Contacts__c);

            }

            if(acc.Name == 'Test Account 2'){
                System.assertEquals(0, acc.Active_Contacts__c);

            }
        }

        //assert contato
        List<Contact> allContacts = [SELECT Id FROM Contact];
        System.assertEquals(6, allContacts.size());
    }
    //método 3
    @isTest
    public static void afterInsertBulkTest(){

        Account accs = [SELECT Id FROM Account WHERE Name = 'Test Account 1'];

        //inserir contato
        List<Contact> conts = new List<Contact>();

        for (Integer i = 0; i < 1000; i++) {

            Contact contTest = new Contact();
            contTest.LastName = 'Test Contact ' + i;
            contTest.AccountId = accs.Id;
            contTest.Active__c = true;
            conts.add(contTest);

        }

        insert conts;

        //assert conta
        List<Account> allAccs = [SELECT Id, Name, Active_Contacts__c FROM Account];
        System.assertEquals(2, allAccs.size());

        for (Account acc : allAccs) {

            if(acc.Name == 'Test Account 1'){
                System.assertEquals(1002, acc.Active_Contacts__c);

            }

            if(acc.Name == 'Test Account 2'){
                System.assertEquals(0, acc.Active_Contacts__c);

            }
        }

        //assert contato
        List<Contact> allContacts = [SELECT Id FROM Contact];
        System.assertEquals(1006, allContacts.size());
    }

    //método 4
    @isTest
    public static void afterUpdateTest1(){

        //definir valroes para atualizar contato
        List<Contact> allContacts = [SELECT Id, LastName FROM Contact];

        for (Contact cont : allContacts) {

            if (cont.LastName == 'Test Contact 3' || cont.LastName == 'Test Contact 4') {
                
                cont.Active__c = true;
            }           
        }

        //iniciar o teste atualizando os contatos
        Test.startTest();
        update allContacts;
        Test.stopTest();

        //assert conta
        List<Account> allAccs = [SELECT Id, Name, Active_Contacts__c FROM Account];
        System.assertEquals(2, allAccs.size());

        for (Account acc : allAccs) {

            if(acc.Name == 'Test Account 1'){
                System.assertEquals(4, acc.Active_Contacts__c);

            }

            if(acc.Name == 'Test Account 2'){
                System.assertEquals(0, acc.Active_Contacts__c);

            }
        }

        //assert contato
        System.assertEquals(6, allContacts.size());
    }

    //método 5
    @isTest
    public static void afterUpdateTest2(){

        Account accs = [SELECT Id FROM Account WHERE Name = 'Test Account 2'];

        //definir valroes para atualizar contato
        List<Contact> allContacts = [SELECT Id, LastName FROM Contact];

        for (Contact cont : allContacts) {

            if (cont.LastName == 'Test Contact 3') {
                
                cont.Active__c = true;
                cont.AccountId = accs.Id;

                
            }           
        }

        //iniciar o teste atualizando os contatos
        Test.startTest();
        update allContacts;
        Test.stopTest();

        //assert conta
        List<Account> allAccs = [SELECT Id, Name, Active_Contacts__c FROM Account];
        System.assertEquals(2, allAccs.size());

        for (Account acc : allAccs) {

            if(acc.Name == 'Test Account 1'){
                System.assertEquals(2, acc.Active_Contacts__c);

            }

            if(acc.Name == 'Test Account 2'){
                System.assertEquals(1, acc.Active_Contacts__c);

            }
        }

        //assert contato
        System.assertEquals(6, allContacts.size());
    }

    //método 6
    @isTest
    public static void afterDeleteTest(){

        //definir valroes para atualizar contato
        List<Contact> allContacts = [SELECT Id, LastName FROM Contact WHERE Name IN ('Test Contact 1', 'Test Contact 5')];

        //iniciar o teste atualizadeletando os contatos
        Test.startTest();
        delete allContacts;
        Test.stopTest();

        //assert conta
        List<Account> allAccs = [SELECT Id, Name, Active_Contacts__c FROM Account];
        System.assertEquals(2, allAccs.size());

        for (Account acc : allAccs) {

            if(acc.Name == 'Test Account 1'){
                System.assertEquals(1, acc.Active_Contacts__c);

            }

            if(acc.Name == 'Test Account 2'){
                System.assertEquals(0, acc.Active_Contacts__c);

            }
        }

        allContacts = [SELECT Id, LastName FROM Contact];
        //assert contato
        System.assertEquals(4, allContacts.size());
    }

    //método 7
    @isTest
    public static void afterUndeleteTest(){

        //definir valroes para atualizar contato
        List<Contact> contactsDelete = [SELECT Id, LastName FROM Contact WHERE Name IN ('Test Contact 1', 'Test Contact 5')];
        delete contactsDelete;

        //iniciar o teste atualizadeletando os contatos
        Test.startTest();
        undelete contactsDelete;
        Test.stopTest();

        //assert conta
        List<Account> allAccs = [SELECT Id, Name, Active_Contacts__c FROM Account];
        System.assertEquals(2, allAccs.size());

        for (Account acc : allAccs) {

            if(acc.Name == 'Test Account 1'){
                System.assertEquals(2, acc.Active_Contacts__c);

            }

            if(acc.Name == 'Test Account 2'){
                System.assertEquals(0, acc.Active_Contacts__c);

            }
        }

        List<Contact> allContacts = [SELECT Id, LastName FROM Contact];
        //assert contato
        System.assertEquals(6, allContacts.size());
    }
}