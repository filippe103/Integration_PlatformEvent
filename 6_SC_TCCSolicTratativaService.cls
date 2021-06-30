global with sharing class TCCSolicTratativaService {
    public static void tratativaReaberta(List<SOLIC_TRATATIVA__c> lsNew, Map<id,SOLIC_TRATATIVA__c> mapOld){
        List<SOLIC_TRATATIVA__c> lstSolicTratativa = new List<SOLIC_TRATATIVA__c>();
        System.debug('newListReaberto :' + lsNew.get(0).IDC_STATUS_TRATATIVA__c);
        System.debug('oldMapReaberto :' + mapOld.get(lsNew.get(0).Id).IDC_STATUS_TRATATIVA__c);
        
        
        lstSolicTratativa = TCCSolicTratativaHelper.getSolicTratativasReabertas(lsNew, mapOld);
        
        if(!lstSolicTratativa.isEmpty()){
            preencherProgramasSaudeAtiva(lstSolicTratativa);
        }
    }

    public Static List<SOLIC_TRATATIVA__c> preencherProgramasSaudeAtiva(List<SOLIC_TRATATIVA__c> lsNewValue ){   
        Set<String> setStatusSolicTratativa     = new Set<String>();
        Set<String> setStatusProgramaElegivel   = new Set<String>();
        Set<Id>     setSeguradoId               = new Set<Id>();
        List<ElegivelPrograma__c> lstElegivelPrograma = new List<ElegivelPrograma__c>();
        Map<Id,Set<String>> mapProgramasElegiveisSegurado = new Map<Id,Set<String>>();
        List<SOLIC_TRATATIVA__c> listSolicTratativa = new List<SOLIC_TRATATIVA__c>();
        RepositoryFactory repositoryFactory = new RepositoryFactory();
        
        //
        
        setStatusSolicTratativa = TCCSolicTratativaHelper.getSetStatusSolicTratativa();
        setStatusProgramaElegivel = TCCSolicTratativaHelper.setStatusProgramaElegivel();

        system.debug('SetStatusSolicTratativa '+ setStatusSolicTratativa);
        setSeguradoId = TCCSolicTratativaHelper.getSetSeguradosId(lsNewValue);
        
        system.debug('SetSeguradoId '+ setSeguradoId);

        if (!setSeguradoId.isEmpty()){
            Specification TCCSolicTratativaSpec = new TCCSolicTratativaSpec(setSeguradoId,setStatusProgramaElegivel);
            IRepository repository = repositoryFactory.create(ElegivelPrograma__c.sObjectType);
            
            Repository.QueryBuilder queryBuilder = new Repository.QueryBuilder()
                .selectFields(FieldSetUtil.getFieldsFromFieldSet(ElegivelPrograma__c.sObjectType, 'ATUALIZAR_PROGRAMAS_SAUDE_ATIVA'))
                .whereSpecification(TCCSolicTratativaSpec);
        
            lstElegivelPrograma = (List<ElegivelPrograma__c>) repository.queryObjects(queryBuilder);  
            
            system.debug('lstElegivelPrograma '+ lstElegivelPrograma);            
        }

        if(!lstElegivelPrograma.isEmpty()){
            mapProgramasElegiveisSegurado = TCCSolicTratativaHelper.getMapProgramasElegiveisSegurados(lstElegivelPrograma);

            TCCSolicTratativaFactory factory = new TCCSolicTratativaFactory(lsNewValue);
            listSolicTratativa = factory.preeencherProgramasSaudeAtiva(mapProgramasElegiveisSegurado,setStatusSolicTratativa);
        }

        return listSolicTratativa;
    }   


    public STATIC void criarSolicitacaoDesospitalizacaoNCC(List<SOLIC_TRATATIVA_NCC__e> listEventosSolicTratativa){

        Map<Double, SOLIC_TRATATIVA_NCC__e> mapCodUnicoEvent = TCCSolicTratativaHelper.getMapCodUnicoEvent(listEventosSolicTratativa);
        Map<Double, Id> mapCodUnicoEspecialidade = TCCSolicTratativaHelper.getMapCodigoEspecialidade(mapCodUnicoEvent);

        List<GUIA_SOLIC_PRINC__c> guiasDesospitalizacaoSemParametros = TCCSolicTratativaHelper.getGuiasParaSolicNCCSemParametros(mapCodUnicoEvent);
        //Map<Double, GUIA_SOLIC_PRINC__c> mapCodigosUnicoComGuias = TCCSolicTratativaHelper.getMapCodigosUnicoComGuias(guiasDesospitalizacaoSemParametros);
        //Map<Double, String>              mapCodigosUnicoSemGuias = TCCSolicTratativaHelper.getMapCodigosUnicoSemGuias(mapCodigosUnicoComGuias, mapCodUnicoEvent);
        Map<Double, String> mapGuiasIncorretas = TCCSolicTratativaHelper.getErrosGuiasSemParametros(guiasDesospitalizacaoSemParametros, mapCodUnicoEvent);


        List<GUIA_SOLIC_PRINC__c> guiasDesospitalizacao = TCCSolicTratativaHelper.getGuiasParaSolic(mapCodUnicoEvent);
        Map<Double, GUIA_SOLIC_PRINC__c> mapGuiasParaCriarSolicitacao = TCCSolicTratativaHelper.getMapCodigosUnicoComGuias(guiasDesospitalizacao);

        Map<Double, String> mapCodigoUnicoErrosGuia = TCCSolicTratativaHelper.tratarCUSSComGuiasNaoEncontradas(mapCodUnicoEvent, mapGuiasIncorretas, mapGuiasParaCriarSolicitacao);

        List<SOLIC_TRATATIVA__c> listSolicTratativaParaInserir = TCCSolicTratativaFactory.gerarListaSolicTrat(mapGuiasParaCriarSolicitacao, mapCodUnicoEvent, mapCodUnicoEspecialidade);

        System.debug('CHG listSolicTratativaParaInserir: ' + listSolicTratativaParaInserir);
        System.debug('CHG mapCodigoUnicoErrosGuia: ' + mapCodigoUnicoErrosGuia);
        

        try{
            Database.insert(listSolicTratativaParaInserir, false);
        } catch (Exception e) {
            System.debug('Erro ao salvar a Solicitação de Tratativa' + e.getMessage());
        }

        TCCSolicTratativaHelper.publicarRespostaHC(mapCodigoUnicoErrosGuia, listSolicTratativaParaInserir, mapCodUnicoEvent);
          
    }
    public STATIC void criarSolicitacaoLinhaCuidado(List<SOLIC_TRATATIVA_NCC__e> lstEventoSolicTratativa){
        
        Map<Double, SOLIC_TRATATIVA_NCC__e> mapCodUnicoEvent = TCCSolicTratativaHelper.getMapCodUnicoEvent(lstEventoSolicTratativa);
        Map<Double, SOLIC_TRATATIVA_NCC__e> mapCodUnicoSemTratativa = TCCSolicTratativaHelper.getMapCodUnicoSemTratativa(mapCodUnicoEvent); 
        
        if(!mapCodUnicoSemTratativa.isEmpty()){
            List<GUIA_SOLIC_PRINC__c> lstGuiasParaSolic = TCCSolicTratativaHelper.getGuiasParaSolic(mapCodUnicoSemTratativa);
            List<GUIA_SOLIC_PRINC__c> lstGuiasSemCodigoParamExc = TCCSolicTratativaHelper.getGuiasParaSolicLCSemParamExec(lstGuiasParaSolic);
    
            Map<Double,GUIA_SOLIC_PRINC__c> mapGuiasParaSolicLinhaCuidado = TCCSolicTratativaHelper.getMapCodigosUnicoComGuias(lstGuiasSemCodigoParamExc);
            List<SOLIC_TRATATIVA__c> lstSolicTratParaInserir = TCCSolicTratativaFactory.gerarListaSolicTrat(mapGuiasParaSolicLinhaCuidado, mapCodUnicoEvent, null);
    
            System.debug('CHG mapGuiasParaSolicLinhaCuidado: ' + mapGuiasParaSolicLinhaCuidado);
            System.debug('CHG lstSolicTratParaInserir: ' + lstSolicTratParaInserir);
            
            try{
                Database.insert(lstSolicTratParaInserir, false);
            }catch (Exception ex){
                System.debug('Erro ao salvar a Solicitação de Tratativa' + ex.getMessage());
            }
        }

    }

    public static void atualizarCasoNCCHealthCloud(List<SOLIC_TRATATIVA__c> listNew, Map<Id,SOLIC_TRATATIVA__c> oldMap, boolean isUpdate) {
        List<SOLIC_TRATATIVA__c> listSolicTratativaCaseIdPreenchido = new List<SOLIC_TRATATIVA__c>();
        List<SOLIC_TRATATIVA__c> listSolicTratativaStatusAlterado = new List<SOLIC_TRATATIVA__c>();
        
        listSolicTratativaCaseIdPreenchido = TCCSolicTratativaHelper.getListSolicTratativaCaseIdPreenchido(listNew);
        if(!listSolicTratativaCaseIdPreenchido.isEmpty()) {
            if(isUpdate) {
                listSolicTratativaStatusAlterado = TCCSolicTratativaHelper.getListSolicTratativaStatusAlterado(listSolicTratativaCaseIdPreenchido, oldMap);
            } else {
                listSolicTratativaStatusAlterado = listSolicTratativaCaseIdPreenchido;
            }
    
            if(!listSolicTratativaStatusAlterado.isEmpty()) {
                TCCSolicTratativaHelper.publicarRespostaHC(listSolicTratativaStatusAlterado);
            }
    
        }
    }     
}