public without sharing class TCCSolicitacaoTratativaOPService {

    private List<Case> listNewCasos;
    private Map<Id, Case> mapOldCases;
    TCCSolicitacaoTratativaOPHelper helper = new TCCSolicitacaoTratativaOPHelper();
    TCCSolicitacaoTratativaOPFactory factory = new TCCSolicitacaoTratativaOPFactory();

    public TCCSolicitacaoTratativaOPService(List<Case> listNewCasos, Map<Id, Case> mapOldCases){
        this.listNewCasos = listNewCasos;
        this.mapOldCases  = mapOldCases;
    }

    public void tratarCasosDesospitalizacao(){
        Set<String> setIdsCasosDesospit = helper.getCasosDesospitalizacao(listNewCasos);
        List<Case>  lstCasosDesospit    = helper.getCasosParaSolic(setIdsCasosDesospit);
        setCasoParaOrgPrincipal(lstCasosDesospit);
    }
    
    public void tratarCasosLinhaCuidado(){
        Set<String> setIdsCasosLinhaCuidado = helper.getCasosLinhaCuidado(listNewCasos, mapOldCases);
        List<Case>  lstCasosLinhaCuidado    = helper.getCasosParaSolic(setIdsCasosLinhaCuidado);
        setCasoParaOrgPrincipal(lstCasosLinhaCuidado);
    }

    public void setCasoParaOrgPrincipal(List<Case> lstCasosParaSolic){

        if (!lstCasosParaSolic.isEmpty()) {
            String jsonBody = factory.gerarJsonBodySolicitacao(lstCasosParaSolic);
            
            System.debug('CHG jsonbody: ' + jsonBody);
            TCCSolicitacaoTratativaOPHelper.publicarEventoOrgPrincipal(jsonBody);
        }    
    }

}
