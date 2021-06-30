@isTest
public without sharing class TCCSolicitacaoTratativaOPTest {

    @isTest
    public static void testPublicarEventoCriarSolicParaOP(){
        Id rtDesospitalizacaoId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Desospitalizacao').getRecordTypeId();

        Case c = new Case(RecordtypeId = rtDesospitalizacaoId,
                          Nome_Responsavel__c = 'teste',
                          Descricao_Indicacao__c = 'aloalo',
                          Contato1__c = '(11) 23332-8333',
                          Agilidade_VPP__c = true,
                          Condicao_Desospitalizacao__c = false);

        Test.StartTest();
            insert c;
        Test.StopTest();
    }

}