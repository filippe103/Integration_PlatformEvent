public class TCCIntegracaoCaseSolicTratativaHelper {
    public static Set<Id> getSetIdCase(List<INTEGRACAO_CASE_SOLIC_TRATATIVA__e> listNew) {
        Set<Id> setIdCase = new Set<Id>();
        for(INTEGRACAO_CASE_SOLIC_TRATATIVA__e integracao : listNew) {
            setIdCase.add((Id) integracao.CASE_ID__c);
        }

        return setIdCase;
    }

    public static Set<Id> getSetAccountId(List<Case> caseList) {    
        Set<Id> setAccountId = new Set<Id>();
        for(Case objCase : caseList) {
            setAccountId.add(objCase.Account.Id);
        }

        return setAccountId;
    }

    public static Map<Id,INTEGRACAO_CASE_SOLIC_TRATATIVA__e> getMapReturnCaseId(List<INTEGRACAO_CASE_SOLIC_TRATATIVA__e> listNew) {
        Map<Id,INTEGRACAO_CASE_SOLIC_TRATATIVA__e> mapReturnCaseId = new Map<Id,INTEGRACAO_CASE_SOLIC_TRATATIVA__e>();
        
        for(INTEGRACAO_CASE_SOLIC_TRATATIVA__e integracao : listNew) {
            mapReturnCaseId.put((Id) integracao.CASE_ID__c,integracao);
        }

        return mapReturnCaseId;
    }

    public static Id getRecordTypeTask() {
        
        Id recordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Tarefa_Coordenador_de_Cuidado').getRecordTypeId();

        return recordTypeId;
    }
    
    public static List<Case> getClosedCaseList(List<Case> caseList, Map<Id,INTEGRACAO_CASE_SOLIC_TRATATIVA__e> mapReturnCaseId) {
        List<Case> closedCaseList = new List<Case>();

        for(Case objCase : caseList) {
            INTEGRACAO_CASE_SOLIC_TRATATIVA__e integracao = new INTEGRACAO_CASE_SOLIC_TRATATIVA__e();
            if(mapReturnCaseId.containsKey(objCase.Id)) {
                integracao = mapReturnCaseId.get(objCase.Id);
                if(integracao.Status_Tratativa__c == 'Finalizado') {
                    closedCaseList.add(objCase);
                }
            }
        }
        
        return closedCaseList;
    }

    public static Map<Id,Task> getMapAccountIdTask(Set<Id> setAccountId) {
        List<Task> taskList = new List<Task>();
        Map<Id,Task> mapAccountIdTask = new Map<Id,Task>();
        Date dateYesterday = System.today().addDays(-1);


        taskList = [SELECT Account.Id, CreatedDate from Task where Task_Source__c = 'Retorno Gestão de Internação' and Account.Id in : setAccountId and Status = 'Pendente' and CreatedDate >= :dateYesterday];

        for(Task objTask : taskList) {
            mapAccountIdTask.put(objTask.Account.Id, objTask);
        }

        return mapAccountIdTask;
    }

    public static List<String> getListCaseIdSolicLinhaCuidado(List<INTEGRACAO_CASE_SOLIC_TRATATIVA__e> listNew) {
        List<String> lstCaseId = new List<String>();

        for(INTEGRACAO_CASE_SOLIC_TRATATIVA__e integr : listNew){
            if(integr.Status_Tratativa__c == 'Aberto' && integr.EXTERNAL_ID__c != null){
                lstCaseId.add(integr.CASE_ID__c);
            }
        }

        return lstCaseId;
    }

    public static Set<Id> getBenefCaseIdSolicLinhaCuidado(List<String> lstReturnCaseId){
        Set<Id> setAccountId = new Set<Id>();

        for(Case caso : [SELECT AccountId FROM Case WHERE Id IN :lstReturnCaseId]){
            setAccountId.Add(caso.AccountId);
        }

        return setAccountId;
    }

    public static List<Account> atualizaBenefDoNotPerturb(Set<Id> setAccId){
        List<Account> lstAccNaoPerturbe = new List<Account>();
        List<Account> lstAcc = [SELECT DoNotDisturb__c FROM Account WHERE Id IN :setAccId];
        
        for(Account acc : lstAcc){
            acc.DoNotDisturb__c = true;
            lstAccNaoPerturbe.Add(acc);
        }

        return lstAccNaoPerturbe;
    }
   
}