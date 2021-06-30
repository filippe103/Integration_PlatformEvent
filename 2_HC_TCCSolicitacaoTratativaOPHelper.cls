public without sharing class TCCSolicitacaoTratativaOPHelper {

    private String RT_DESOSPITALIZACAO = 'Desospitalizacao';

    public Set<String> getCasosDesospitalizacao(List<Case> listNewCasos){
        set<String> setIdsCasosDesospitalizacao = new Set<String>();
        
        Id rtDesospitalizacaoId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(this.RT_DESOSPITALIZACAO).getRecordTypeId();
        System.debug('CHG rtDesospitalizacaoId: ' + rtDesospitalizacaoId);
        
        for (Case caso : listNewCasos){
            if (caso.RecordTypeId == rtDesospitalizacaoId){
                setIdsCasosDesospitalizacao.add(caso.Id);
            }
        }
        return setIdsCasosDesospitalizacao;
    }

    public Set<String> getCasosLinhaCuidado(List<Case> lstNewCasos, Map<Id, Case> mapOldCasos){
        set<String> setIdsCasosLinhaCuidado = new Set<String>();

        for(Case caso : lstNewCasos){
            if(caso.Status == 'Fechada' && caso.Motivo_Alteracao_Status_Caso__c == 'Internação' && 
               mapOldCasos.get(caso.Id).Status != 'Fechada'){
                setIdsCasosLinhaCuidado.add(caso.Id);
            }
        }
        return setIdsCasosLinhaCuidado;
    }
    
    public List<Case> getCasosParaSolic(Set<String> setIdCasos){
        List<Case> lstCasosSolic = new List<Case>();

        RepositoryFactory repositoryFactory = new RepositoryFactory();
        IRepository repository = repositoryFactory.create(Case.sObjectType);

        if (!setIdCasos.isEmpty()){
            Specification caseSpec = new CaseSpec(setIdCasos, 'Id');

            Repository.QueryBuilder queryBuilder = new Repository.QueryBuilder()
            .selectFields(FieldSetUtil.getFieldsFromFieldSet(Case.sObjectType, 'INTEGRACAO_WELLNESS'))
            .whereSpecification(caseSpec);
            lstCasosSolic = (List<Case>) repository.queryObjects(queryBuilder);
        }

        return lstCasosSolic;
    }

    @future(callout=true)
    public STATIC void publicarEventoOrgPrincipal(String jsonBody){
        try {
            Http hp = new Http();
            HttpRequest httpReq = new HttpRequest();
            httpReq.setMethod('POST');
            httpReq.setBody(jsonBody);        
            httpReq.setHeader('Accept', 'application/json');
            httpReq.setHeader('Content-Type', 'application/json; charset=UTF-8');
            httpReq.setEndpoint('callout:PROGRAMAS_ELEGIVEIS/services/data/v45.0/composite/'); // Verificar credencial nomeada
            HttpResponse res = hp.send(httpReq);
            System.debug('CHG response: ' + res.getStatusCode());
        } catch(exception e) {
            system.debug('Erro na chamada de Publicação de Evento na Org Principal = ' + e.getMessage());    
        } 
    }

}