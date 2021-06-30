/**************************************************************************************************************
* @company          Avanxo
* @author           Franz Mayenberger (fmayenberger@avanxo.com)
* @project          SULAMERICA
* @description      Helper trigger casos para Médico em Casa
*            No.   Date         Author                        Description
* --------   ---   ----------   ---------------------------   ------------------------------------------------
* @version   1.0   2018-11-21   Franz Mayenberger             Versión inicial
* @version   1.1   2018-11-21   Flávio Costa
**************************************************************************************************************/
public class SAS_CaseHandler extends SAS_TriggerHandler {
    
    private SMC_CaseHelper SMC_helper;
    private List< Case > listNew;
    private Map< Id, Case > oldMap;
    // Controle de recursividade
    public static Boolean medicalEeferralControl = false;
    private PLCRoteamentoBaseadoHabilidadesService plcRoteamentoCasos;
    
    public SAS_CaseHandler( List< Case > listNew, Map< Id, Case > oldMap ) {
        SMC_helper = new SMC_CaseHelper();
        this.listNew = listNew;
        this.oldMap = ( Map< Id, Case > ) oldMap;
        plcRoteamentoCasos = new PLCRoteamentoBaseadoHabilidadesService();
    }
    
    public override void beforeInsert() {
        if(!SMC_TriggerFlag.hasRunned()) {
        	this.SMC_helper.createCaseCovid(this.listNew);
        }
        CarePlanHandler carePlanHandler = new CarePlanHandler(Trigger.new);
        carePlanHandler.criaRelacionamentoCaseCarePlanTemplate();
        
        List< Case > lsCaseCarePlan = this.SMC_helper.getListCaseCarePlan( this.listNew, this.oldMap );
        this.SMC_helper.atribuirOwnerCaseCarePlan(lsCaseCarePlan);
    }
    
    public override void beforeUpdate() {
        this.SMC_helper.createCarePlanCovidCase(this.listNew, this.oldMap);
    }
    
    public override void afterInsert() {
        if(!SMC_TriggerFlag.hasRunned()) {
            if ( !medicalEeferralControl ) {
                // O set de String é para os tipos de registros que serão contemplados, deve ser informado o developerName
                List< Case > listCaseCreateForwarding = this.SMC_helper.getListCaseCreateForwarding( this.listNew, this.oldMap, new Set< String >{ 'MedicoEmCasa','OBSTETRICIA' } );
                //system.assert(false,listCaseCreateForwarding);
                if(this.SMC_helper.encaminhamentoValidation(this.listNew )){
                    this.SMC_helper.createEncaminhamento( listCaseCreateForwarding );
                    medicalEeferralControl = true;
                }
            }
        }

        CarePlanHandler carePlanHandler = new CarePlanHandler(Trigger.new);
        carePlanHandler.execute();      
        // Distribui casos por habilidades
        plcRoteamentoCasos.createPendingRoutingSkills();

        List< Id > lsCaseIdEmail = this.SMC_helper.getListCaseEmail(this.listNew, this.oldMap);
        if(!lsCaseIdEmail.isEmpty()) this.SMC_helper.excluirEmailRespostaAutomatica(lsCaseIdEmail);

        //TUCC 1210
        TCCSolicitacaoTratativaOPService solicitacaoTratativaService2 = new TCCSolicitacaoTratativaOPService(this.listNew, this.oldMap);
        solicitacaoTratativaService2.tratarCasosDesospitalizacao();

    }
    
    public override void afterUpdate() {
        if(!SMC_TriggerFlag.hasRunned()) {
            if ( !medicalEeferralControl ) {
                List< Case > listCaseCreateForwarding = this.SMC_helper.getListCaseCreateForwarding( this.listNew, this.oldMap, new Set< String >() );
                listCaseCreateForwarding = this.SMC_helper.updateQueries( listCaseCreateForwarding );
                //SMC_helper.sendSMS();
                //system.assert(false,listCaseCreateForwarding);
                if(this.SMC_helper.encaminhamentoValidation(this.listNew,this.oldMap)){
                    this.SMC_helper.createEncaminhamento( listCaseCreateForwarding );
                    SMC_TriggerFlag.run();
                }
            }
	    this.SMC_helper.updateClosedCases(this.listNew);
        }
        CarePlanHandler carePlanHandler = new CarePlanHandler(Trigger.new, Trigger.oldMap);
        carePlanHandler.atribuiCarePlan();
        PLCFinishedTasksCaseCarePlan.execute();
        TCCSolicitacaoTratativaOPService SolicitacaoTratativaServ = new TCCSolicitacaoTratativaOPService(this.listNew, this.oldMap);
        SolicitacaoTratativaServ.tratarCasosLinhaCuidado();
    }
}