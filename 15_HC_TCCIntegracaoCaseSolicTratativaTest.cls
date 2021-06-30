@isTest
public class TCCIntegracaoCaseSolicTratativaTest {
    
  @testSetup
  static void setup (){
    Id rtDesospitalizacaoId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Desospitalizacao').getRecordTypeId();

    Case c = new Case(RecordtypeId = rtDesospitalizacaoId,
                      Nome_Responsavel__c = 'teste',
                      Descricao_Indicacao__c = 'aloalo',
                      Contato1__c = '(11) 23332-8333',
                      Agilidade_VPP__c = true,
                      Condicao_Desospitalizacao__c = false);
    insert c;
  }

  @isTest
  public static void testPublicarEvento(){

    Case cs = [SELECT Id FROM Case WHERE Nome_Responsavel__c = 'teste'][0];

    INTEGRACAO_CASE_SOLIC_TRATATIVA__e evtCaseSolic = new INTEGRACAO_CASE_SOLIC_TRATATIVA__e(
      CASE_ID__c = cs.Id,
      EXTERNAL_ID__c = '0013100001id40JAAF',
      MENSAGEM_RETORNO__c = 'test',
      Motivo_Finalizacao__c = 'test',
      Status_Tratativa__c = 'Finalizado',
      Tipo_Finalizacao__c  = 'test'
    );

    Test.startTest();
      Database.SaveResult results = EventBus.publish(evtCaseSolic);
    Test.stopTest();

    System.assertEquals(true, results.isSuccess());
    //System.assertEquals(1, [SELECT count() FROM Task WHERE Subject = 'Call']);
  }

}
