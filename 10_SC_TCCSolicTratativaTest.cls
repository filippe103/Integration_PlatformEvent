@isTest
public class TCCSolicTratativaTest {
  @testSetup
  static void setup (){
    Id rectypeAccEmp  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Empresa').getRecordTypeId();
    Id rectypeAccPres = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Prestador').getRecordTypeId();
    Id rectypeAccSeg  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Segurado').getRecordTypeId();
    Id rectypeSeg     = Schema.getGlobalDescribe().get('SEGURADO__c').getDescribe().getRecordTypeInfosByName().get('Titular').getRecordTypeId();
    Id rectypeGuia    = Schema.getGlobalDescribe().get('GUIA_SOLIC_PRINC__c').getDescribe().getRecordTypeInfosByName().get('Internação').getRecordTypeId();
    
    List<Account> accountsToInsert = new List<Account>();
    Account accEmp =  new Account(Name='EMPRESA TESTE', RecordTypeId=rectypeAccEmp);
    Account accPres = new Account(Name='PRESTADOR TESTE', RecordTypeId=rectypeAccPres);
    Account accSeg1 = new Account(Name='SEGURADO TESTE1', RecordTypeId=rectypeAccSeg, COD_BENEF_UNICO__c = 1234);
    Account accSeg2 = new Account(Name='SEGURADO TESTE2', RecordTypeId=rectypeAccSeg);
    Account accSeg3 = new Account(Name='SEGURADO TESTE3', RecordTypeId=rectypeAccSeg);
    Account accSeg4 = new Account(Name='SEGURADO TESTE4', RecordTypeId=rectypeAccSeg);
    Account accSeg5 = new Account(Name='SEGURADO TESTE5', RecordTypeId=rectypeAccSeg);
    Account accSeg6 = new Account(Name='SEGURADO TESTE6', RecordTypeId=rectypeAccSeg, COD_BENEF_UNICO__c = 4321);
    
    accountsToInsert.add(accEmp);
    accountsToInsert.add(accPres);
    accountsToInsert.add(accSeg1);
    accountsToInsert.add(accSeg2);
    accountsToInsert.add(accSeg3);
    accountsToInsert.add(accSeg4);
    accountsToInsert.add(accSeg5);
    accountsToInsert.add(accSeg6);
    
    insert accountsToInsert;

    system.debug('TCCSolictTratativaTest account1 id: ' + accSeg1);
    system.debug('TCCSolictTratativaTest account2 id: ' + accSeg2);
    system.debug('TCCSolictTratativaTest account3 id: ' + accSeg3);
    system.debug('TCCSolictTratativaTest account4 id: ' + accSeg4);
    system.debug('TCCSolictTratativaTest account5 id: ' + accSeg5);


    APOLICE__c ap2 = new APOLICE__c(NUM_APOLICE__c='002020202', COD_CONTA_EMPRESA__c = accEmp.Id);
    insert ap2;

    List<SEGURADO__c> seguradosToInsert = new List<SEGURADO__c>();
    Map<Integer,Id> mapSegurado = new Map<Integer,Id>();
    for(Integer i = 0; i < 6; i++) {
      Id seguradoId;
      
      switch on i {
        when 0 { seguradoId = accSeg1.Id; }	
        when 1 { seguradoId = accSeg2.Id; }	
        when 2 { seguradoId = accSeg3.Id; }	
        when 3 { seguradoId = accSeg4.Id; }	
        when 4 { seguradoId = accSeg5.Id; }	
        when 5 { seguradoId = accSeg6.Id; }	
      }
        
        SEGURADO__c seg = new SEGURADO__c(Name='020202020202020' + i, RecordTypeId=rectypeSeg, COD_CONTA_PESSOA__c=seguradoId, COD_APOLICE__c=ap2.Id, COD_IDENT_BENEF_ANT__c='020202020202020' + i);
        seguradosToInsert.add(seg);

    }

    insert seguradosToInsert;

    Integer cont = 0;

    for(SEGURADO__C seg : seguradosToInsert) {
      mapSegurado.put(cont,seg.id);
      cont ++;
    }

    List<GUIA_SOLIC_PRINC__c> guiaPrincipalList = new List<GUIA_SOLIC_PRINC__c>();

    for(Integer i = 0; i < 5; i++) {
      Id seguradoId = mapSegurado.get(i);
      
      GUIA_SOLIC_PRINC__c gp = new GUIA_SOLIC_PRINC__c(RecordTypeId=rectypeGuia, NUM_GUIA_SOLIC_PRINC__c='0101010'+i,COD_CARATER_ATEND_ANS__c='1', COD_PRESTADOR__c=accPres.Id, COD_SEGURADO__c=seguradoId, DAT_INI_INTERN_PREST__c=system.today(), IDC_PERMANENCIA__c='Longa Permanência', QTD_DIARIAS_AUTORIZ__c = 5, NUM_SENHA_AUTORIZ__c='11111'+i);
      guiaPrincipalList.add(gp);
    }

    GUIA_SOLIC_PRINC__c gp2 = new GUIA_SOLIC_PRINC__c(RecordTypeId=rectypeGuia, NUM_GUIA_SOLIC_PRINC__c='01010107',COD_CARATER_ATEND_ANS__c='1', COD_PRESTADOR__c=accPres.Id, COD_SEGURADO__c=mapSegurado.get(5), IDC_PERMANENCIA__c='Longa Permanência', QTD_DIARIAS_AUTORIZ__c = 5, NUM_SENHA_AUTORIZ__c='111119');
    GUIA_SOLIC_PRINC__c gp3 = new GUIA_SOLIC_PRINC__c(RecordTypeId=rectypeGuia, NUM_GUIA_SOLIC_PRINC__c='01010108',COD_CARATER_ATEND_ANS__c='1', COD_PRESTADOR__c=accPres.Id, DAT_ALTA__c = System.Today(), COD_SEGURADO__c=mapSegurado.get(5), IDC_PERMANENCIA__c='Longa Permanência', DAT_INI_INTERN_PREST__c=system.today(), QTD_DIARIAS_AUTORIZ__c = 5, NUM_SENHA_AUTORIZ__c='111116');
    GUIA_SOLIC_PRINC__c gp4 = new GUIA_SOLIC_PRINC__c(RecordTypeId=rectypeGuia, NUM_GUIA_SOLIC_PRINC__c='01010109',COD_CARATER_ATEND_ANS__c='1', DAT_ALTA_PREST__c = System.Today(), COD_PRESTADOR__c=accPres.Id, COD_SEGURADO__c=mapSegurado.get(5), IDC_PERMANENCIA__c='Longa Permanência', QTD_DIARIAS_AUTORIZ__c = 5, NUM_SENHA_AUTORIZ__c='111117');

    guiaPrincipalList.add(gp2);
    guiaPrincipalList.add(gp3);
    guiaPrincipalList.add(gp4);

    insert guiaPrincipalList;

    system.debug('Guias principais: ' + guiaPrincipalList.size());

    Programa__c prg1 = SObjectInstance.createPrograma( accEmp.Id, 'NOME PROGRAMA 1' );
    prg1.DataInicio__c = system.today().adddays(-5);
    prg1.StatusPrograma__c = 'Ativo';
    prg1.QTD_IDADE_DE__c = 0;
    prg1.QTD_IDADE_ATE__c = 150;
    Database.insert( prg1 );
   
    Programa__c prg2 = SObjectInstance.createPrograma( accEmp.Id, 'NOME PROGRAMA 2' );
    prg2.DataInicio__c = system.today().adddays(-3);
    prg2.StatusPrograma__c = 'Ativo';
    prg2.QTD_IDADE_DE__c = 0;
    prg2.QTD_IDADE_ATE__c = 150;
    Database.insert( prg2 );
   
    Programa__c prg3 = SObjectInstance.createPrograma( accEmp.Id, 'NOME PROGRAMA 3' );
    prg3.DataInicio__c = system.today().adddays(-1);
    prg3.StatusPrograma__c = 'Ativo';
    prg3.QTD_IDADE_DE__c = 0;
    prg3.QTD_IDADE_ATE__c = 150;
    Database.insert( prg3 );    

    CadastroOrigemIndicacao__c origemIndicacao = new CadastroOrigemIndicacao__c();
    origemIndicacao.Descricao__c = 'Teste';
    origemIndicacao.Status__c = 'Ativo';
    origemIndicacao.Sigla__c = 'abc';
    origemIndicacao.Name = 'HWS ANALITICS 2';
    insert origemIndicacao;
    
    List<ElegivelPrograma__c> elegProgram = new List<ElegivelPrograma__c>();

    for(Integer i = 0; i < 5; i++) {
      Id seguradoId;
      Integer maxValue = 0;
      
      switch on i {
        when 0 { seguradoId = accSeg1.Id; maxValue = 3;}	
        when 1 { seguradoId = accSeg2.Id; maxValue = 2;}	
        when 2 { seguradoId = accSeg3.Id; maxValue = 3;}	
        when 3 { seguradoId = accSeg4.Id; maxValue = 1;}	
        when 4 { seguradoId = accSeg5.Id; }
      }

      for(Integer j = 0; j < maxValue; j++) {
        Id prgId;
        String status;
        if(j == 0) {
          prgId =  prg1.Id; 
          status = 'A1 - Elegível Ativo';
        } else if (j == 1) {
          prgId =  prg2.Id;
          status = 'B6 - Elegível Inativo Internado';
        } else if (j == 2) {
          prgId =  prg3.Id;
          status = 'A2 - Elegível Ativo Transferência';          
        }

        system.debug('TCCSolictTratativaTest Segurado: ' + seguradoId);

        ElegivelPrograma__c prgElegivel = SObjectInstance.createElegivelPrograma(accEmp.Id, prgId, null, null, RecordTypeMemory.getRecType('ElegivelPrograma__c', 'Segurado'));
        prgElegivel.OrigemIndicacao__c = origemIndicacao.Id;
        prgElegivel.StatusSeguradoPrograma__c = status;
        prgElegivel.DataSelecao__c = System.Today();
        prgElegivel.DataStatus__c = System.Today();
        prgElegivel.segurado_del__c = seguradoId;
        elegProgram.add(prgElegivel);

      }
    }

    System.debug('TccSolicTratativaTest Programa Elegível size: ' + elegProgram.size());
    insert elegProgram;

    for(ElegivelPrograma__c elegivelProgram : elegProgram) {
      System.debug('TccSolicTratativaTest Programa Elegível: ' + elegivelProgram);
    }

    Especialidade__c especialidade = new Especialidade__c();
    especialidade.COD_ESPECIALIDADE__c = 1234;
    insert especialidade;

  }

  @isTest
  static void CriacaoSolicitacaoTratativa(){
    Id rectypeSolic = Schema.getGlobalDescribe().get('SOLIC_TRATATIVA__c').getDescribe().getRecordTypeInfosByName().get('Desospitalização').getRecordTypeId();
    List<GUIA_SOLIC_PRINC__c> ListGuiasSolicitantes = [SELECT ID, DAT_ALTA__c, IDC_PERMANENCIA__c, COD_PRESTADOR__c, COD_SEGURADO__c, COD_SEGURADO__r.COD_CONTA_PESSOA__c,
                                                      FRM_QTD_DIARIAS_AUTORIZ__c, COD_PRESTADOR__r.Prestador_Auditado__c, DAT_INI_INTERNACAO__c 
                                                      FROM GUIA_SOLIC_PRINC__c WHERE NUM_GUIA_SOLIC_PRINC__c NOT IN ('01010107', '01010108', '01010109')];

    List<SOLIC_TRATATIVA__c> solicTratativaToInsert = new List<SOLIC_TRATATIVA__c>();


    for(GUIA_SOLIC_PRINC__c guia : ListGuiasSolicitantes) {
      system.debug('TCCSolictTratativaTest Segurado Guia: ' + guia.COD_SEGURADO__r.COD_CONTA_PESSOA__c);
      SOLIC_TRATATIVA__c solicTratativa;       
      solicTratativa = new SOLIC_TRATATIVA__c(
          IDC_STATUS_TRATATIVA__c = 'Aberto', 
          COD_GUIA_SOLIC_PRINC__c = guia.Id, 
          DAT_ALTA__c             = guia.DAT_ALTA__c, 
          DSC_PERMANENCIA__c      = guia.IDC_PERMANENCIA__c, 
          COD_PRESTADOR__c        = guia.COD_PRESTADOR__c, 
          COD_SEGURADO__c         = guia.COD_SEGURADO__c,
          COD_CONTA_SEGURADO__c   = guia.COD_SEGURADO__r.COD_CONTA_PESSOA__c, 
          QTD_DIARIAS__c          = guia.FRM_QTD_DIARIAS_AUTORIZ__c, 
          FLG_PREST_AUDITADO__c   = guia.COD_PRESTADOR__r.Prestador_Auditado__c, 
          DAT_INI_INTERNACAO__c   = guia.DAT_INI_INTERNACAO__c, 
          DSC_OBSERVACOES__c      = 'Criado via parametro empresa',
          Parametro_Empresa__c    = true,
          RecordTypeId            = rectypeSolic
          );

          solicTratativaToInsert.add(solicTratativa);
    }  

      System.Test.startTest();
        insert solicTratativaToInsert;
      System.Test.stopTest();
      
      for(SOLIC_TRATATIVA__c solic : solicTratativaToInsert) {
          system.debug('TCCSolictTratativaTest Solicitação de tratativa : ' + solic);
          switch on solic.COD_SEGURADO__r.Name {
            when '0202020202020200' { System.assertEquals(solic.Programas_Saude_Ativa__c, 'NOME PROGRAMA 1;NOME PROGRAMA 2;NOME PROGRAMA 3'); }	
            when '0202020202020201' { System.assertEquals(solic.Programas_Saude_Ativa__c, 'NOME PROGRAMA 1;NOME PROGRAMA 2');  }	
            when '0202020202020202' { System.assertEquals(solic.Programas_Saude_Ativa__c, 'NOME PROGRAMA 1;NOME PROGRAMA 2;NOME PROGRAMA 3');  }	
            when '0202020202020203' { System.assertEquals(solic.Programas_Saude_Ativa__c, 'NOME PROGRAMA 1');  }	
            when '0202020202020204' { System.assertEquals(solic.Programas_Saude_Ativa__c, null); }	
          }
      }
  }

  @isTest
  static void ReabrirSolicTratativa() {
    System.debug('TCCSolictTratativaTest Entrou no update ');
    Id rectypeSolic = Schema.getGlobalDescribe().get('SOLIC_TRATATIVA__c').getDescribe().getRecordTypeInfosByName().get('Desospitalização').getRecordTypeId();
    List<GUIA_SOLIC_PRINC__c> ListGuiasSolicitantes = [SELECT ID, DAT_ALTA__c, IDC_PERMANENCIA__c, COD_PRESTADOR__c, COD_SEGURADO__c, COD_SEGURADO__r.COD_CONTA_PESSOA__c,
                                                      FRM_QTD_DIARIAS_AUTORIZ__c, COD_PRESTADOR__r.Prestador_Auditado__c, DAT_INI_INTERNACAO__c 
                                                      FROM GUIA_SOLIC_PRINC__c WHERE NUM_GUIA_SOLIC_PRINC__c NOT IN ('01010107', '01010108', '01010109')];

    List<SOLIC_TRATATIVA__c> solicTratativaToInsert = new List<SOLIC_TRATATIVA__c>();

    for(GUIA_SOLIC_PRINC__c guia : ListGuiasSolicitantes) {
      system.debug('TCCSolictTratativaTest Segurado Guia: ' + guia.COD_SEGURADO__r.COD_CONTA_PESSOA__c);
      SOLIC_TRATATIVA__c solicTratativa;       
      solicTratativa = new SOLIC_TRATATIVA__c(
          IDC_STATUS_TRATATIVA__c = 'Aberto', 
          COD_GUIA_SOLIC_PRINC__c = guia.Id, 
          DAT_ALTA__c             = guia.DAT_ALTA__c, 
          DSC_PERMANENCIA__c      = guia.IDC_PERMANENCIA__c, 
          COD_PRESTADOR__c        = guia.COD_PRESTADOR__c, 
          COD_SEGURADO__c         = guia.COD_SEGURADO__c,
          COD_CONTA_SEGURADO__c   = guia.COD_SEGURADO__r.COD_CONTA_PESSOA__c, 
          QTD_DIARIAS__c          = guia.FRM_QTD_DIARIAS_AUTORIZ__c, 
          FLG_PREST_AUDITADO__c   = guia.COD_PRESTADOR__r.Prestador_Auditado__c, 
          DAT_INI_INTERNACAO__c   = guia.DAT_INI_INTERNACAO__c, 
          DSC_OBSERVACOES__c      = 'Criado via parametro empresa',
          Parametro_Empresa__c    = true,
          RecordTypeId            = rectypeSolic
          );

          solicTratativaToInsert.add(solicTratativa);
    }  
    
    insert solicTratativaToInsert;
    
    for(SOLIC_TRATATIVA__c solic : solicTratativaToInsert) {
      solic.IDC_STATUS_TRATATIVA__c = 'Reaberto';
    }

    System.Test.startTest();
      update solicTratativaToInsert;
    System.Test.stopTest();
    
  }


  
  @isTest 
  static void testSolicitacaoCriadaAtravesEventoNCC()
  {


    SOLIC_TRATATIVA_NCC__e eventoSolic = new SOLIC_TRATATIVA_NCC__e(
      Motivo_Encaminhamento__c = 'aloalo',
      Agilidade_VPP__c = true,
      Condicao_Desospitalizacao__c = false,
      Contato1__c = '(11) 11222-3333',
      Nome_Responsavel__c = 'João',
      caseId__c = '0013100001id40JAAF',
      CodigoEspecialidade__c = '1234',
      COD_BENEF_UNICO__c = 1234,
      Status__c = 'Nova'
    );

    System.Test.startTest();
      EventBus.publish(eventoSolic);
    System.Test.stopTest();

    List<SOLIC_TRATATIVA__c> listSolicitCriada = [SELECT ID FROM SOLIC_TRATATIVA__C WHERE CASE_ID_NCC__c != null];

    //System.assert(!listSolicitCriada.isEmpty());

  }

  @isTest 
  static void testSolicitacaoCriadaAtravesEventoLinhaCuidado()
  {


    SOLIC_TRATATIVA_NCC__e eventoSolic = new SOLIC_TRATATIVA_NCC__e(
      Motivo_Encaminhamento__c = 'aloalo',
      Agilidade_VPP__c = true,
      Condicao_Desospitalizacao__c = false,
      Contato1__c = '(11) 11222-3333',
      Nome_Responsavel__c = 'João',
      caseId__c = '0013100001id40JAAF',
      CodigoEspecialidade__c = '1234',
      COD_BENEF_UNICO__c = 1234,
      InicioInternacao__c = date.newInstance(2021, 02, 01),
      Status__c = 'Fechada'
    );

    System.Test.startTest();
      EventBus.publish(eventoSolic);
    System.Test.stopTest();

    List<SOLIC_TRATATIVA__c> listSolicitCriada = [SELECT ID FROM SOLIC_TRATATIVA__C WHERE CASE_ID_NCC__c != null];

    //System.assert(listSolicitCriada.isEmpty());

  }

  @isTest 
  static void testSolicitacaoNaoAchouGuia()
  {


    SOLIC_TRATATIVA_NCC__e eventoSolic = new SOLIC_TRATATIVA_NCC__e(
      Motivo_Encaminhamento__c = 'aloalo',
      Agilidade_VPP__c = true,
      Condicao_Desospitalizacao__c = false,
      Contato1__c = '(11) 11222-3333',
      Nome_Responsavel__c = 'João',
      caseId__c = '0013100001id40JAAF',
      CodigoEspecialidade__c = '1234',
      COD_BENEF_UNICO__c = 12345
    );

    System.Test.startTest();
      EventBus.publish(eventoSolic);
    System.Test.stopTest();

    List<SOLIC_TRATATIVA__c> listSolicitCriada = [SELECT ID FROM SOLIC_TRATATIVA__C WHERE CASE_ID_NCC__c != null];

    System.assert(listSolicitCriada.isEmpty());

  }

  @isTest 
  static void testSolicitacaoNaoAchouGuiaPorDatas()
  {


    SOLIC_TRATATIVA_NCC__e eventoSolic = new SOLIC_TRATATIVA_NCC__e(
      Motivo_Encaminhamento__c = 'aloalo',
      Agilidade_VPP__c = true,
      Condicao_Desospitalizacao__c = false,
      Contato1__c = '(11) 11222-3333',
      Nome_Responsavel__c = 'João',
      caseId__c = '0013100001id40JAAF',
      CodigoEspecialidade__c = '1234',
      COD_BENEF_UNICO__c = 4321
    );

    System.Test.startTest();
      EventBus.publish(eventoSolic);
    System.Test.stopTest();

    List<SOLIC_TRATATIVA__c> listSolicitCriada = [SELECT ID FROM SOLIC_TRATATIVA__C WHERE CASE_ID_NCC__c != null];

    System.assert(listSolicitCriada.isEmpty());

  }


  @isTest 
  static void TCCSolicTratativaSpec()
  {
    System.Test.startTest();
    Set<Id> setId = new Set<Id>{'0013100001id40JAAQ','0013100001id40KAAQ','0013100001id40LAAQ'};
    Set<String> setStatus = new Set<String>{'A1 - Elegível Ativo','A2 - Elegível Ativo Transferência','B6 - Elegível Inativo Internado','D10 - Pendente Troca de Prestador'};

    TCCSolicTratativaSpec TCCSolicTratativaSpec = new TCCSolicTratativaSpec(setId,setStatus);
    Boolean result1b = TCCSolicTratativaSpec.isSatisfiedBy(null); 
    String result2 = TCCSolicTratativaSpec.toSOQLClauses();
    
    System.Test.stopTest();
    
    System.assertEquals('Segurado_del__c IN(\'0013100001id40JAAQ\',\'0013100001id40KAAQ\',\'0013100001id40LAAQ\') AND StatusSeguradoPrograma__c IN (\'A1 - Elegível Ativo\',\'A2 - Elegível Ativo Transferência\',\'B6 - Elegível Inativo Internado\',\'D10 - Pendente Troca de Prestador\') AND Programa__r.StatusPrograma__c = '+'\''+'Ativo'+'\'', result2, 'result2='+result2);
  }
  
}