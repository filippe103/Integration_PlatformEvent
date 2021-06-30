public class TCCIntegracaoCaseSolicTratativaService {
    public static void tratarChamada(List<INTEGRACAO_CASE_SOLIC_TRATATIVA__e> listNew) {
        RepositoryFactory        repositoryFactory = new RepositoryFactory();
        IRepository              repository = repositoryFactory.create(Case.sObjectType);
        List<Case> listCase = new List<Case>();
        List<Case> listCaseAtualizado = new List<Case>();
        Map<Id,INTEGRACAO_CASE_SOLIC_TRATATIVA__e> mapReturnCaseId = new Map<Id,INTEGRACAO_CASE_SOLIC_TRATATIVA__e>();
        Set<Id> setIdCase = new Set<Id>();

        setIdCase = TCCIntegracaoCaseSolicTratativaHelper.getSetIdCase(listNew);
        
        mapReturnCaseId = TCCIntegracaoCaseSolicTratativaHelper.getMapReturnCaseId(listNew);

        Specification TCCIntegracaoCaseSolicTratativaSpec = new TCCIntegracaoCaseSolicTratativaSpec(setIdCase);
        Repository.QueryBuilder queryBuilderCase = new Repository.QueryBuilder()
            .selectFields(FieldSetUtil.getFieldsFromFieldSet(Case.sObjectType, 'INTEGRACAO_WELLNESS'))
            .whereSpecification(TCCIntegracaoCaseSolicTratativaSpec);  
        
        listCase = (List<Case>) repository.queryObjects(queryBuilderCase);        

        TCCIntegracaoCaseSolicTratativaFactory factory = new TCCIntegracaoCaseSolicTratativaFactory(listCase);
        listCaseAtualizado = factory.preencherCamposIntegracao(mapReturnCaseId);

        if(!listCaseAtualizado.isEmpty()){
            repository.updateObject(listCaseAtualizado);
            
            criarTarefaSolicTratativaFinalizada(listCaseAtualizado, mapReturnCaseId);
        }
        
        atualizarNaoPerturbeBenef(listNew);
    }
    
    public static void criarTarefaSolicTratativaFinalizada(List<Case> caseList, Map<Id,INTEGRACAO_CASE_SOLIC_TRATATIVA__e> mapReturnCaseId) {
        RepositoryFactory        repositoryFactory = new RepositoryFactory();
        IRepository              repository = repositoryFactory.create(Task.sObjectType);
        List<Task> taskList = new List<Task>();              

        List<Case> closedSolicTratativaCaseList = new List<Case>();
        closedSolicTratativaCaseList = TCCIntegracaoCaseSolicTratativaHelper.getClosedCaseList(caseList,mapReturnCaseId);

        if(!closedSolicTratativaCaseList.isEmpty()) {
            TCCIntegracaoCaseSolicTratativaFactory factory = new TCCIntegracaoCaseSolicTratativaFactory(closedSolicTratativaCaseList);
            Map<Id,Task> mapAccountIdTask = new Map<Id,Task>();
            Set<Id> setAccountId = new Set<Id>();
            
            setAccountId     = TCCIntegracaoCaseSolicTratativaHelper.getSetAccountId(caseList);
            mapAccountIdTask = TCCIntegracaoCaseSolicTratativaHelper.getMapAccountIdTask(setAccountId);

            taskList = factory.popularTarefas(mapAccountIdTask);
    
            try {
                if(!taskList.isEmpty()){
                    repository.insertObject(taskList);
                }          
            } catch (Exception e) {
                System.debug('Tarefa não pode ser criada devido ao seguinte problema: ' + e.getMessage());
            }        
        }

    }

    public static void atualizarNaoPerturbeBenef(List<INTEGRACAO_CASE_SOLIC_TRATATIVA__e> lstNew){

        RepositoryFactory        repositoryFactory = new RepositoryFactory();
        IRepository              repository = repositoryFactory.create(Account.sObjectType);

        List<String> lstReturnCaseIdSolicLinhaCuidado = TCCIntegracaoCaseSolicTratativaHelper.getListCaseIdSolicLinhaCuidado(lstNew);
        Set<Id> setIdBenefCaseSolicLinhaCuidado       = TCCIntegracaoCaseSolicTratativaHelper.getBenefCaseIdSolicLinhaCuidado(lstReturnCaseIdSolicLinhaCuidado);
        List<Account> lstAccParaAtualizar = TCCIntegracaoCaseSolicTratativaHelper.atualizaBenefDoNotPerturb(setIdBenefCaseSolicLinhaCuidado);

        System.debug('setIdBenefCaseSolicLinhaCuidado: ' + setIdBenefCaseSolicLinhaCuidado);
        System.debug('lstAccParaAtualizar: ' + lstAccParaAtualizar);

        if(!lstAccParaAtualizar.isEmpty()) {
            repository.updateObject(lstAccParaAtualizar);
        }
    }

}
