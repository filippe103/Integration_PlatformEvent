trigger IntegracaoCaseSolicTratativa on INTEGRACAO_CASE_SOLIC_TRATATIVA__e (after insert) {
    for ( INTEGRACAO_CASE_SOLIC_TRATATIVA__e event : Trigger.New ) {
        
        System.debug('CHG event Case ID: ' + event.CASE_ID__c);
        
    }

    TCCIntegracaoCaseSolicTratativaService.tratarChamada(Trigger.new);

}