public with sharing class TCCSolicTratativaFactory {
    private List<SOLIC_TRATATIVA__c> listaSolicitacoesTratativa;

    public TCCSolicTratativaFactory(List<SOLIC_TRATATIVA__c> listaSolicitacoesTratativa){
        this.listaSolicitacoesTratativa = listaSolicitacoesTratativa;
    }

    public List<SOLIC_TRATATIVA__c> preeencherProgramasSaudeAtiva(Map<Id,Set<String>> mapProgramasElegiveisSegurado, Set<String> setStatusSolicTratativa){
        List<SOLIC_TRATATIVA__c> preencherListaSolicitacoesTratativa = new List<SOLIC_TRATATIVA__c>();
        for(SOLIC_TRATATIVA__c solicTratativa : listaSolicitacoesTratativa){
            system.debug('Map Factory ' + mapProgramasElegiveisSegurado );
            Set<String> setProgramasElegiveisSegurado = mapProgramasElegiveisSegurado.get(solicTratativa.COD_CONTA_SEGURADO__c); 
            system.debug('setProgramasElegiveisSegurado: ' + setProgramasElegiveisSegurado);
            
            if(setStatusSolicTratativa.contains(solicTratativa.IDC_STATUS_TRATATIVA__c)){
                solicTratativa.Programas_saude_Ativa__c = setProgramasElegiveisSegurado != null ? TCCSolicTratativaHelper.convertSetToString(setProgramasElegiveisSegurado) : '';
                preencherListaSolicitacoesTratativa.add(solicTratativa);
            }
        }

        return preencherListaSolicitacoesTratativa;
    }

    public STATIC List<SOLIC_TRATATIVA__c> gerarListaSolicTrat(Map<Double, GUIA_SOLIC_PRINC__c> mapGuiasParaCriarSolicitacao, map<Double, SOLIC_TRATATIVA_NCC__e> mapCUSSEvent, map<Double, Id> mapCodEspecialidade){
        System.debug('Entrou em gerarListaSolicTrat');
        List<SOLIC_TRATATIVA__c> listSolicitacoesParaInserir = new List<SOLIC_TRATATIVA__c>();

        for (GUIA_SOLIC_PRINC__c guia : mapGuiasParaCriarSolicitacao.values()){
            SOLIC_TRATATIVA_NCC__e eventoPlataformaSolic = mapCUSSEvent.get(guia.COD_SEGURADO__r.COD_CONTA_PESSOA__r.COD_BENEF_UNICO__c);
            Id especialidadeId = null;
            if (eventoPlataformaSolic.CodigoEspecialidade__c != null){
                especialidadeId = mapCodEspecialidade.get(Decimal.ValueOf(eventoPlataformaSolic.CodigoEspecialidade__c));
            } 

            SOLIC_TRATATIVA__c solicTrat = new SOLIC_TRATATIVA__c();
                solicTrat.RecordTypeId = Schema.getGlobalDescribe().get('SOLIC_TRATATIVA__c').getDescribe().getRecordTypeInfosByName().get('Desospitalização').getRecordTypeId();
                solicTrat.IDC_STATUS_TRATATIVA__c = 'Aberto';
                solicTrat.FLG_Criada_Transicao_Cuidado__c = true;
                solicTrat.COD_GUIA_SOLIC_PRINC__c = guia.Id;
                solicTrat.DAT_ALTA__c = guia.DAT_ALTA__c;
                solicTrat.DSC_PERMANENCIA__c = guia.IDC_PERMANENCIA__c;
                solicTrat.COD_PRESTADOR__c = guia.COD_PRESTADOR__c;
                solicTrat.COD_SEGURADO__c = guia.COD_SEGURADO__c;
                solicTrat.COD_CONTA_SEGURADO__c = guia.COD_SEGURADO__r.COD_CONTA_PESSOA__c;
                solicTrat.QTD_DIARIAS__c = guia.FRM_QTD_DIARIAS_AUTORIZ__c;
                solicTrat.FLG_PREST_AUDITADO__c = guia.COD_PRESTADOR__r.Prestador_Auditado__c;
                solicTrat.DAT_INI_INTERNACAO__c = guia.DAT_INI_INTERN_PREST__c; //DAT_INI_INTERNACAO__c,
                solicTrat.Parametro_Empresa__c = false;
                solicTrat.CASE_ID_NCC__c = eventoPlataformaSolic.caseId__c;
                if(eventoPlataformaSolic.Status__c == 'Fechada'){
                    solicTrat.IDC_ORIGEM__c = 'Transição de Cuidado - Linha de Pós Internação';
                } else {
                    solicTrat.IDC_ORIGEM__c = 'Transição de Cuidado - Indicação NCC';
                    solicTrat.FLG_AGILIDADE_VPP__c = eventoPlataformaSolic.Agilidade_VPP__c;
                    solicTrat.FLG_CONDICOES_DESOSP__c = eventoPlataformaSolic.Condicao_Desospitalizacao__c;
                    solicTrat.NUM_TEL_CONTATO_1__c = eventoPlataformaSolic.Contato1__c;
                    solicTrat.NME_RESPONSAVEL__c = eventoPlataformaSolic.Nome_Responsavel__c;
                    solicTrat.COD_ESPECIALIDADE__c = especialidadeId;
                }          
            
            listSolicitacoesParaInserir.add(solicTrat);
        }

        return listSolicitacoesParaInserir;
    }

}