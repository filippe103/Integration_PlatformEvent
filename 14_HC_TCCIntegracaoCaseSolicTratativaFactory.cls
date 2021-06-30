public class TCCIntegracaoCaseSolicTratativaFactory {
    private List<Case> caseList;

    public TCCIntegracaoCaseSolicTratativaFactory(List<Case> caseList){
        this.caseList = caseList;
    }    

    public List<Case> preencherCamposIntegracao(Map<Id,INTEGRACAO_CASE_SOLIC_TRATATIVA__e> mapReturnCaseId) {
        List<Case> updatedCaseList = new List<Case>();

        for(Case objCase : this.caseList) {
            INTEGRACAO_CASE_SOLIC_TRATATIVA__e integracao = new INTEGRACAO_CASE_SOLIC_TRATATIVA__e();
            if(mapReturnCaseId.containsKey(objCase.Id)) {
                integracao = mapReturnCaseId.get(objCase.Id);
                objCase.Status_Tratativa__c             = integracao.Status_Tratativa__c;
                objCase.Tipo_Finalizacao__c             = integracao.Tipo_Finalizacao__c;
                objCase.Motivo_Finalizacao__c           = integracao.Motivo_Finalizacao__c;
                objCase.SOLIC_TRATATIVA_ID__c           = integracao.EXTERNAL_ID__c;
                objCase.MENSAGEM_RETORNO_INTEGRACAO__c  = integracao.MENSAGEM_RETORNO__c;
                if(integracao.Status_Tratativa__c == 'Finalizado') {
                    objCase.Status = 'Fechada';
                }
                if(integracao.Tipo_Solicitacao__c == 'Criado via Linha do Cuidado'){
                    objCase.Tipo_Solicitacao_Tratativa__c = 'Gestão de Internação - Linha de Pós internação';
                }
                updatedCaseList.add(objCase);
            }
        }

        return updatedCaseList;
    }

    public List<Task> popularTarefas(Map<Id,Task> mapAccountIdTask) {
        List<Task> taskList = new List<Task>();
 
        Id recordTypeId = TCCIntegracaoCaseSolicTratativaHelper.getRecordTypeTask();

        for(Case objCase : this.caseList) {
            if(!mapAccountIdTask.containsKey(objCase.Account.Id)) {
                Task newTask = new Task();
                newTask.Subject = 'Call';
                newTask.OwnerId = objCase.OwnerId;
                newTask.WhatId = objCase.Account.Id;
                newTask.Task_Source__c = 'Retorno Gestão de Internação';
                newTask.ActivityDate = System.today();
                newTask.IsReminderSet = true;
                newTask.ReminderDateTime = System.now();
                newTask.recordTypeId = recordTypeId;
                newTask.Description = 'Status da tratativa: ' + objCase.Status_Tratativa__c  + ', Tipo de finalização: ' + objCase.Tipo_Finalizacao__c + ', Motivo da finalização: ' + objCase.Motivo_Finalizacao__c;
                taskList.add(newTask);
            }
        }

        return taskList;
    }

}