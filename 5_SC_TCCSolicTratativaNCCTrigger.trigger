trigger TCCSolicTratativaNCCTrigger on SOLIC_TRATATIVA_NCC__e (after insert) {

    for( SOLIC_TRATATIVA_NCC__e ev : Trigger.New) {
        System.debug('CHG event COD_BENEF_UNICO__c' + ev.COD_BENEF_UNICO__c);
        System.debug('CHG event Status__c ' + ev.Status__c);
        
        if(ev.Status__c == 'Nova'){
            TCCSolicTratativaService.criarSolicitacaoDesospitalizacaoNCC(Trigger.new);
        }
        else if(ev.Status__c == 'Fechada'){
            TCCSolicTratativaService.criarSolicitacaoLinhaCuidado(Trigger.new);
        }
    }

}
