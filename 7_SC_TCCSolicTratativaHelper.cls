global with sharing class TCCSolicTratativaHelper {
    //TUCC 1150
    public static List<SOLIC_TRATATIVA__c> getSolicTratativasReabertas(List<SOLIC_TRATATIVA__c> lsNew, Map<id,SOLIC_TRATATIVA__c> mapOld){
        List<SOLIC_TRATATIVA__c> lstSolicTratativa = new List<SOLIC_TRATATIVA__c>();
        for(SOLIC_TRATATIVA__c tratataivaNew : lsNew){
            SOLIC_TRATATIVA__c tratativaOld = mapOld.get(tratataivaNew.Id);
            if(tratativaOld != null){
                if(tratataivaNew.IDC_STATUS_TRATATIVA__c != tratativaOld.IDC_STATUS_TRATATIVA__c &&
                    tratataivaNew.IDC_STATUS_TRATATIVA__c == 'Reaberto'){
                        lstSolicTratativa.add(tratataivaNew);
                }
            }
        }  
        
        return lstSolicTratativa;
    }
    
    public static Set<Id> getSetSeguradosId(List<SOLIC_TRATATIVA__c> lsNew){
        Set<Id> setSeguradoId = new Set<Id>();
        
        for(SOLIC_TRATATIVA__c solic : lsNew){
            setSeguradoId.add(solic.COD_CONTA_SEGURADO__c);
        }
        
        return setSeguradoId;
    }

    public static Map<Id,Set<String>> getMapProgramasElegiveisSegurados(List<ElegivelPrograma__c> lstElegivelPrograma){
        Map<Id,Set<String>> mapProgramasElegiveisSegurado = new Map<Id,Set<String>>();
        for(ElegivelPrograma__c elegivelPrograma : lstElegivelPrograma){
            Set<String> setNomeElegivelPrograma = new Set<String>();
                        
            if(mapProgramasElegiveisSegurado.containsKey(elegivelPrograma.Segurado_del__c)){
                setNomeElegivelPrograma = mapProgramasElegiveisSegurado.get(elegivelPrograma.Segurado_del__c);
            }
            setNomeElegivelPrograma.add(getProgramaElegivelConverted(elegivelPrograma.NomePrograma__c));
            mapProgramasElegiveisSegurado.put(elegivelPrograma.Segurado_del__c,setNomeElegivelPrograma);
        }
        return mapProgramasElegiveisSegurado;
    }

    public static Set<String> getSetStatusSolicTratativa(){
        Set<String> setStatusSolicTratativa     = new Set<String>();
        
        setStatusSolicTratativa.add('Aberto');
        setStatusSolicTratativa.add('Reaberto');
        setStatusSolicTratativa.add('Telemonitoramento');
        setStatusSolicTratativa.add('Questionamento Interno');
        setStatusSolicTratativa.add('Implantado AD');
        setStatusSolicTratativa.add('Em acompanhamento');
        setStatusSolicTratativa.add('Contato Inicial');
        
        return setStatusSolicTratativa;
    }

    public static Set<String> setStatusProgramaElegivel(){
        Set<String> setStatusSeguradoPrograma     = new Set<String>();

        setStatusSeguradoPrograma.add('A1 - Elegível Ativo');
        setStatusSeguradoPrograma.add('A2 - Elegível Ativo Transferência');
        setStatusSeguradoPrograma.add('G1 - Suspenso temporariamente Transição de Cuidado');
        setStatusSeguradoPrograma.add('D10 - Pendente Troca de Prestador');

        return setStatusSeguradoPrograma;
    
    }

    public static String getProgramaElegivelConverted (String nameToConvert) {
        String nameConverted = '';

        switch on nameToConvert  {
            when 'ATENCAO NO ALTO RISCO'        { nameConverted = 'Atencao no Alto Risco'; }	
            when 'COLUNA ATIVA'                 { nameConverted = 'Coluna Ativa';          }	
            when 'COLUNA IN COMPANY'            { nameConverted = 'Coluna In Company'; }	
            when 'CONSULTOR DE BEM ESTAR'       { nameConverted = 'Consultor de Bem Estar'; }	
            when 'DOENCAS CRONICAS'             { nameConverted = 'Doenças Crônicas'; }	
            when 'ENVELHECIMENTO SAUDAVEL'      { nameConverted = 'Envelhecimento Saudável'; }	
            when 'FUTURA MAMAE'                 { nameConverted = 'Futura Mamãe'; }	
            when 'GESTAO DE SAUDE E BEM ESTAR'  { nameConverted = 'Gestão de Saúde e Bem Estar'; }	
            when 'IDOSO BEM CUIDADO'            { nameConverted = 'Idoso Bem Cuidado'; }	
            when 'ONCOLOGIA'                    { nameConverted = 'Oncologia'; }	
            when 'ORTOPEDIA JOELHO'             { nameConverted = 'Ortopedia Joelho'; }	
            when 'ORTOPEDIA OMBRO'              { nameConverted = 'Ortopedia Ombro'; }	
            when 'ORTOPEDIA QUADRIL'            { nameConverted = 'Ortopedia Quadril'; }	
            when 'TRIAGEM PARA AS INICIATIVAS'  { nameConverted = 'Triagem para as Iniciativas'; }	
            when 'UNICA MENTE'                  { nameConverted = 'Única Mente'; }	
          }        

        return nameConverted;
    }

    public static String convertSetToString(Set<String> stringSet){
        List<String> stringList = new List<String>();
        String convertedString = '';
        

        if(!stringSet.isEmpty() ){
            stringList.addAll(stringSet);
            convertedString = String.join(stringList,';');
        }

        return convertedString;
    }

    public STATIC Map<Double, SOLIC_TRATATIVA_NCC__e> getMapCodUnicoEvent(List<SOLIC_TRATATIVA_NCC__e> listSolicEvento){

        Map<Double, SOLIC_TRATATIVA_NCC__e> mapCodUnicoEvent = new Map<Double, SOLIC_TRATATIVA_NCC__e>();

        for( SOLIC_TRATATIVA_NCC__e ev : listSolicEvento) {
            mapCodUnicoEvent.put(ev.COD_BENEF_UNICO__c, ev);
        }

        return mapCodUnicoEvent;
    }

    public STATIC Map<Double, GUIA_SOLIC_PRINC__c> getMapCodigosUnicoComGuias(List<GUIA_SOLIC_PRINC__c> listGuias){

        Map<Double, GUIA_SOLIC_PRINC__c> mapCodigoUnicoComGuias = new Map<Double, GUIA_SOLIC_PRINC__c>();

        for(GUIA_SOLIC_PRINC__c guia : listGuias) {
            if (mapCodigoUnicoComGuias.get(guia.COD_SEGURADO__r.COD_CONTA_PESSOA__r.COD_BENEF_UNICO__c) == null){
                mapCodigoUnicoComGuias.put(guia.COD_SEGURADO__r.COD_CONTA_PESSOA__r.COD_BENEF_UNICO__c, guia);
            }
        }

        return mapCodigoUnicoComGuias;
    }

    public STATIC Map<Double, String> getErrosGuiasSemParametros(List<GUIA_SOLIC_PRINC__c> listGuias, Map<Double,SOLIC_TRATATIVA_NCC__e> mapCodEvent){
    
        Map<Double, String> mapCodigosComErros = new Map<Double, String>();

        for(GUIA_SOLIC_PRINC__c guia : listGuias) {
            SOLIC_TRATATIVA_NCC__e evtPlatFromHC = mapCodEvent.get(guia.COD_SEGURADO__r.COD_CONTA_PESSOA__r.COD_BENEF_UNICO__c);
            String erros = mapCodigosComErros.get(guia.COD_SEGURADO__r.COD_CONTA_PESSOA__r.COD_BENEF_UNICO__c);
            if (erros == null){
                erros = '';
            }
            
            if (guia.COD_PRESTADOR__c == null){
                erros += ' Guia: ' + guia.Id + ' não possui código do prestador preenchido;';
            }

            if (guia.DAT_ALTA_PREST__c != null){
                erros += ' Guia: ' + guia.Id + '  possui data de alta do prestador preenchida;';
            }

            if (guia.FLG_TELEMONITORAMENTO__c != false && evtPlatFromHC.Status__c == 'Fechada'){
                erros += ' Guia: ' + guia.Id + ' Guia esta marcada com telemonitoramento;';
            }

            if (guia.DAT_ALTA__c != null){
                erros += ' Guia: ' + guia.Id + ' possui data de alta preenchida;';
            }

            if (guia.DAT_INI_INTERN_PREST__c == null){
                erros += ' Guia: ' + guia.Id + ' não possui Data de Internação;';
            }
            else if (guia.DAT_INI_INTERN_PREST__c > System.Today()){
                erros += ' Guia: ' + guia.Id + ' possui uma data de Internação Futura;';
            }
            else if (guia.DAT_INI_INTERN_PREST__c < System.Today().addDays(-9)){
                erros += ' Guia: ' + guia.Id + ' possui uma data de Internação anterior a 9 dias do processamento;';
            }
            else if (guia.DAT_INI_INTERN_PREST__c <= evtPlatFromHC.InicioInternacao__c && evtPlatFromHC.Status__c == 'Fechada'){
                erros += ' Guia: ' + guia.Id + ' possui uma data de Ativação de Pós internação menor que a data de internação;';
            }

            mapCodigosComErros.put(guia.COD_SEGURADO__r.COD_CONTA_PESSOA__r.COD_BENEF_UNICO__c, erros);
        }

        return mapCodigosComErros;

    }

    public STATIC Map<Double, String> tratarCUSSComGuiasNaoEncontradas(Map<Double, SOLIC_TRATATIVA_NCC__e> mapCodigoEvento, Map<Double, String> mapCodigosComErros, Map<Double, GUIA_SOLIC_PRINC__c> mapGuiasParaCriarSolicitacao){

        Map<Double, String> mapCodUnicoErroGerado = new Map<Double, String>();


        for(Double cod_benef_unico : mapCodigoEvento.keySet()) {
            if (mapGuiasParaCriarSolicitacao.get(cod_benef_unico) == null && (mapCodigosComErros.get(cod_benef_unico) == null || mapCodigosComErros.get(cod_benef_unico) == '')){
                mapCodUnicoErroGerado.put(cod_benef_unico, 'Nenhuma guia foi encontrada para este beneficiário');
            }
            else if(mapGuiasParaCriarSolicitacao.get(cod_benef_unico) == null && (mapCodigosComErros.get(cod_benef_unico) != null && mapCodigosComErros.get(cod_benef_unico) != '')){
                mapCodUnicoErroGerado.put(cod_benef_unico, mapCodigosComErros.get(cod_benef_unico));
            }
        }

        return mapCodUnicoErroGerado;
    } 

    public STATIC Map<Double, Id> getMapCodigoEspecialidade (map<Double, SOLIC_TRATATIVA_NCC__e> mapCodUnicoEvent){
        Map<Double, Id> mapCodigoEspecialidade = new Map<Double, Id>();
        RepositoryFactory repositoryFactory = new RepositoryFactory();
        IRepository repository = repositoryFactory.create(ESPECIALIDADE__c.sObjectType);

        Set<Decimal> codigoEspecialidadeParaProcurar = new Set<Decimal>();

        for (SOLIC_TRATATIVA_NCC__e evento : mapCodUnicoEvent.values()){
            if (evento.CodigoEspecialidade__c != null){
                codigoEspecialidadeParaProcurar.add(decimal.valueOf(evento.CodigoEspecialidade__c));
            }
        }

        if (!codigoEspecialidadeParaProcurar.isEmpty()){
            Specification especialidadePorCodigoSpec = new TCCEspecialidadePorCodigoSpec(codigoEspecialidadeParaProcurar);
            repository.QueryBuilder queryBuilder = new repository.QueryBuilder()
                    .selectFields(new List<String>{'id, COD_ESPECIALIDADE__c'})
                    .whereSpecification(especialidadePorCodigoSpec);
            List<ESPECIALIDADE__c> listEspecialidades = (List<ESPECIALIDADE__c>) repository.queryObjects(queryBuilder);    
            
            for (ESPECIALIDADE__c especialidade : listEspecialidades){
                mapCodigoEspecialidade.put(especialidade.COD_ESPECIALIDADE__c, especialidade.Id);
            }
        }

        return mapCodigoEspecialidade;
    }


    public STATIC List<GUIA_SOLIC_PRINC__c> getGuiasParaSolicNCCSemParametros(Map<Double, SOLIC_TRATATIVA_NCC__e> mapCodUnicoEvent){

        List<GUIA_SOLIC_PRINC__c> guiasParaSolicNCCSemParametro = [
                             SELECT Id, 
                                    COD_SEGURADO__c,
                                    Recordtype.Name,
                                    NUM_SENHA_AUTORIZ__c,
                                    DAT_ALTA_PREST__c,
                                    COD_PRESTADOR__c, 
                                    COD_PRESTADOR__r.Prestador_Auditado__c,
                                    DAT_INI_INTERN_PREST__c, 
                                    COD_SEGURADO__r.COD_CONTA_PESSOA__c,
                                    FRM_CARATER_ATEND_ANS__c, 
                                    COD_SEGURADO__r.COD_BENEFICIARIO__c,
                                    DAT_INI_INTERNACAO__c, 
                                    COD_SEGURADO__r.COD_APOLICE__r.COD_CONTA_EMPRESA__c,
                                    COD_SEGURADO__r.COD_CONTA_PESSOA__r.COD_BENEF_UNICO__c,  
                                    CreatedDate, DAT_ALTA__c, 
                                    IDC_PERMANENCIA__c, 
                                    FRM_QTD_DIARIAS_AUTORIZ__c,
                                    FLG_TELEMONITORAMENTO__c
                             FROM GUIA_SOLIC_PRINC__c 
                             WHERE COD_SEGURADO__r.COD_CONTA_PESSOA__r.COD_BENEF_UNICO__c IN :mapCodUnicoEvent.keySet()
                                    AND Recordtype.Name = 'Internação' 
                             ORDER BY COD_SEGURADO__r.COD_CONTA_PESSOA__c DESC, CreatedDate DESC
        ];

        return guiasParaSolicNCCSemParametro;
    }

    public STATIC List<GUIA_SOLIC_PRINC__c> getGuiasParaSolic(Map<Double, SOLIC_TRATATIVA_NCC__e> mapCodigosUnicoEvent){

        Date rangeMaxDataInternacao = System.Today().addDays(-9);

        List<GUIA_SOLIC_PRINC__c> guiasParaSolicNCC = [
                             SELECT Id, 
                                    COD_SEGURADO__c,
                                    NUM_SENHA_AUTORIZ__c,
                                    DAT_ALTA_PREST__c,
                                    COD_PRESTADOR__c, 
                                    COD_PRESTADOR__r.Prestador_Auditado__c,
                                    DAT_INI_INTERN_PREST__c, 
                                    COD_SEGURADO__r.COD_CONTA_PESSOA__c,
                                    FRM_CARATER_ATEND_ANS__c, 
                                    COD_SEGURADO__r.COD_BENEFICIARIO__c,
                                    DAT_INI_INTERNACAO__c, 
                                    COD_SEGURADO__r.COD_APOLICE__r.COD_CONTA_EMPRESA__c, 
                                    COD_SEGURADO__r.COD_CONTA_PESSOA__r.COD_BENEF_UNICO__c,  
                                    CreatedDate, DAT_ALTA__c, 
                                    IDC_PERMANENCIA__c,
                                    FLG_TELEMONITORAMENTO__c, 
                                    FRM_QTD_DIARIAS_AUTORIZ__c
                             FROM GUIA_SOLIC_PRINC__c 
                             WHERE COD_SEGURADO__r.COD_CONTA_PESSOA__r.COD_BENEF_UNICO__c IN :mapCodigosUnicoEvent.keySet()
                                    AND Recordtype.Name = 'Internação' 
                                    AND Id NOT IN (SELECT COD_GUIA_SOLIC_PRINC__c FROM SOLIC_TRATATIVA__c WHERE COD_CONTA_SEGURADO__r.COD_BENEF_UNICO__c IN :mapCodigosUnicoEvent.keySet())
                                    AND COD_PRESTADOR__c != null 
                                    AND DAT_INI_INTERN_PREST__c != null
                                    AND DAT_ALTA__c = null 
                                    AND DAT_ALTA_PREST__c = null
                             ORDER BY COD_SEGURADO__r.COD_CONTA_PESSOA__c DESC, CreatedDate DESC
        ];

        List<GUIA_SOLIC_PRINC__c> listGuiaParaRetornar = new List<GUIA_SOLIC_PRINC__c>();

        for (GUIA_SOLIC_PRINC__c guia : guiasParaSolicNCC){
            if (mapCodigosUnicoEvent.get(guia.COD_SEGURADO__r.COD_CONTA_PESSOA__r.COD_BENEF_UNICO__c).Status__c != 'Fechada' &&
                guia.DAT_INI_INTERN_PREST__c <= System.Today() && guia.DAT_INI_INTERN_PREST__c >= rangeMaxDataInternacao){
                listGuiaParaRetornar.add(guia);
            }
            else if(guia.FLG_TELEMONITORAMENTO__c == false &&
                    mapCodigosUnicoEvent.get(guia.COD_SEGURADO__r.COD_CONTA_PESSOA__r.COD_BENEF_UNICO__c).Status__c == 'Fechada' &&
                    guia.DAT_INI_INTERN_PREST__c <= System.Today() && 
                    guia.DAT_INI_INTERN_PREST__c >= mapCodigosUnicoEvent.get(guia.COD_SEGURADO__r.COD_CONTA_PESSOA__r.COD_BENEF_UNICO__c).InicioInternacao__c){
                listGuiaParaRetornar.add(guia);    
            }
             
        }


        return listGuiaParaRetornar; 
    }

    public STATIC void publicarRespostaHC(map<Double, String> mapCodUnicoGuiasIncorretas, List<SOLIC_TRATATIVA__c> listSolicitacoes, Map<Double, SOLIC_TRATATIVA_NCC__e> mapCodUnicoEvent){

        map<String, String> mapCaseIdErroGerado = new Map<String, String>();
        Set<Id> setSolicitacaoInserida = new Set<Id>();

        for (SOLIC_TRATATIVA__c solicitacao : listSolicitacoes){
            if (solicitacao.Id != null){
                setSolicitacaoInserida.add(solicitacao.CASE_ID_NCC__c);
            }
        }

        for (Double cod_benef_unico : mapCodUnicoEvent.keySet()){
            if (mapCodUnicoGuiasIncorretas.get(cod_benef_unico) == null && !setSolicitacaoInserida.contains(mapCodUnicoEvent.get(cod_benef_unico).caseId__c)){
                mapCaseIdErroGerado.put(mapCodUnicoEvent.get(cod_benef_unico).caseId__c, 'Erro ao tentar inserir a Solicitação de Tratativa');
            } else {
                mapCaseIdErroGerado.put(mapCodUnicoEvent.get(cod_benef_unico).caseId__c, mapCodUnicoGuiasIncorretas.get(cod_benef_unico));
            }
        }

        System.debug('CHG mapCaseIdErroGerado: ' + mapCaseIdErroGerado);

        if (!mapCaseIdErroGerado.isEmpty()){
            publicarRespostaHC(mapCaseIdErroGerado);
        }
    }

    public static void publicarRespostaHC(List<SOLIC_TRATATIVA__C> listSolicTratativa ) {
        String json = TCCSolicTratativaCaseHCService.gerarJsonBodySolicTratativa(listSolicTratativa);
        TCCSolicTratativaCaseHCService.publicarEventoHC(json);        
    }

    public static void publicarRespostaHC(Map<String, String> mapCaseIdErroGerado) {
        String json = TCCSolicTratativaCaseHCService.gerarJsonBodySolicTratativaNegativa(mapCaseIdErroGerado);
        TCCSolicTratativaCaseHCService.publicarEventoHC(json);        
    }

    public static List<SOLIC_TRATATIVA__C> getListSolicTratativaCaseIdPreenchido(List<SOLIC_TRATATIVA__C> listNew) {
        List<SOLIC_TRATATIVA__C> returnListSolicTratativa = new List<SOLIC_TRATATIVA__C>();
        
        for(SOLIC_TRATATIVA__C solicTratativa : listNew){
            if(solicTratativa.CASE_ID_NCC__c != null) {
                returnListSolicTratativa.add(solicTratativa);
            }
        }
        
        return returnListSolicTratativa;
    }   

    public static List<SOLIC_TRATATIVA__C> getListSolicTratativaStatusAlterado(List<SOLIC_TRATATIVA__C> listNew, Map<Id,SOLIC_TRATATIVA__C> mapOld) {
        List<SOLIC_TRATATIVA__C> returnListSolicTratativa = new List<SOLIC_TRATATIVA__C>();
        
        for(SOLIC_TRATATIVA__C solicTratativa : listNew){
            if(solicTratativa.IDC_STATUS_TRATATIVA__c != mapOld.get(solicTratativa.Id).IDC_STATUS_TRATATIVA__c) {
                returnListSolicTratativa.add(solicTratativa);
            }
        }
        
        return returnListSolicTratativa;
    }   

    public static Map<Double, SOLIC_TRATATIVA_NCC__e> getMapCodUnicoSemTratativa(Map<Double, SOLIC_TRATATIVA_NCC__e> mapCodUnicoEvent){
        Map<Double, SOLIC_TRATATIVA_NCC__e> mapCodUniSemTratativa = mapCodUnicoEvent;
        Set<String> setStatusTratativa = getSetStatusSolicTratativa();
        
        List<Solic_Tratativa__c> lstSolicTrat = [
                    SELECT Id,
                           IDC_STATUS_TRATATIVA__c,
                           IDC_FINALIZACAO__c,
                           IDC_MOTIVO_FINALIZ__c,
                           COD_SEGURADO__r.COD_CONTA_PESSOA__r.COD_BENEF_UNICO__c
                    FROM SOLIC_TRATATIVA__c
                    WHERE COD_SEGURADO__r.COD_CONTA_PESSOA__r.COD_BENEF_UNICO__c IN :mapCodUnicoEvent.keySet()
                    AND IDC_STATUS_TRATATIVA__c IN ('Aberto','Reaberto','Telemonitoramento','Questionamento Interno','Implantado AD','Em acompanhamento','Contato Inicial','Finalizado') 
        ];

        System.debug('lstSolicTrat: ' + lstSolicTrat);
        if(!lstSolicTrat.isEmpty()){

            for(SOLIC_TRATATIVA__c solic : lstSolicTrat){
                if(solic.IDC_STATUS_TRATATIVA__c != 'Finalizado' ||
                solic.IDC_STATUS_TRATATIVA__c == 'Finalizado' && 
                (solic.IDC_FINALIZACAO__c == 'Óbito' || solic.IDC_FINALIZACAO__c == 'Segurado Excluído' || solic.IDC_FINALIZACAO__c == 'Não Elegível')){
                    mapCodUniSemTratativa.remove(solic.COD_SEGURADO__r.COD_CONTA_PESSOA__r.COD_BENEF_UNICO__c);
                }
                else if(solic.IDC_STATUS_TRATATIVA__c == 'Finalizado' &&
                        solic.IDC_FINALIZACAO__c == 'Não Elegível' && 
                        (solic.IDC_MOTIVO_FINALIZ__c == 'Óbito no 1° contato' || solic.IDC_MOTIVO_FINALIZ__c == 'Óbito Triagem')){
                    mapCodUniSemTratativa.remove(solic.COD_SEGURADO__r.COD_CONTA_PESSOA__r.COD_BENEF_UNICO__c);
                }
            }
        }

        System.debug('mapCodUniSemTratativa: ' + mapCodUniSemTratativa);
        return mapCodUniSemTratativa;
    }

    public static List<GUIA_SOLIC_PRINC__c> getGuiasParaSolicLCSemParamExec(List<GUIA_SOLIC_PRINC__c> lstGuiasParaSolicLC){
        Set<Id> setIdCodServico = new Set<Id>();
        Set<Id> setIdGuiaBloqueada = new Set<Id>();
        List<GUIA_SOLIC_PRINC__c> lstGuiasParaSolic = new List<GUIA_SOLIC_PRINC__c>();
        List<PARM_AP__c> lstParmAp = [SELECT Id FROM PARM_AP__c WHERE IDC_PERMANENCIA__c in ('Longa Permanência','Longuíssima Permanência')];
        
        List<PARM_AP_EXCEC__c> lstParamExec = [SELECT COD_SERVICO__c 
                                               FROM PARM_AP_EXCEC__c 
                                               WHERE COD_SERVICO__c != null
                                               AND COD_PARM_AP__c IN :lstParmAp];

        for(PARM_AP_EXCEC__c param : lstParamExec){
            setIdCodServico.add(param.COD_SERVICO__c);
        }

        List<GUIA_SOLIC_ITEM__c> lstServGuia = [SELECT COD_GUIA_SOLIC_PRINC__c, 
                                                       COD_SERVICO__c 
                                                FROM GUIA_SOLIC_ITEM__c
                                                WHERE COD_GUIA_SOLIC_PRINC__c IN :lstGuiasParaSolicLC
        ];

        for(GUIA_SOLIC_ITEM__c itemGuia : lstServGuia){
            if(setIdCodServico.contains(itemGuia.COD_SERVICO__c)){
                setIdGuiaBloqueada.add(itemGuia.COD_GUIA_SOLIC_PRINC__c);
            }
        }

        for(GUIA_SOLIC_PRINC__c guiaPrin : lstGuiasParaSolicLC){
            if(!setIdGuiaBloqueada.contains(guiaPrin.Id)){
                lstGuiasParaSolic.add(guiaPrin);
            }
        }

        return lstGuiasParaSolic;
    }
}