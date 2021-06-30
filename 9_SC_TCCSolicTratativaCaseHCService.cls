public class TCCSolicTratativaCaseHCService {
    
    public static string gerarJsonBodySolicTratativa(List<SOLIC_TRATATIVA__c> lstSolicTrat) {

        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeBooleanField('allOrNone', false);
        
        gen.writeFieldName('compositeRequest');
        gen.writeStartArray();
        for(SOLIC_TRATATIVA__c solicTrat : lstSolicTrat) {
            gen.writeStartObject();

            gen.writeStringField('method', 'POST');
            gen.writeStringField('url','/services/data/v45.0/sobjects/INTEGRACAO_CASE_SOLIC_TRATATIVA__e');
            gen.writeStringField('referenceId', solicTrat.Id);

            gen.writeFieldName('body');
            gen.writeStartObject();

            gen.writeStringField('EXTERNAL_ID__c', solicTrat.Id);
            
            if(solicTrat.CASE_ID_NCC__c != null){
                gen.writeStringField('CASE_ID__c', solicTrat.CASE_ID_NCC__c);
            }

            if(solicTrat.IDC_STATUS_TRATATIVA__c != null){
                gen.writeStringField('Status_Tratativa__c', solicTrat.IDC_STATUS_TRATATIVA__c);
            }

            if(solicTrat.IDC_FINALIZACAO__c != null){
                gen.writeStringField('Tipo_Finalizacao__c', solicTrat.IDC_FINALIZACAO__c);
            }

            if(solicTrat.IDC_MOTIVO_FINALIZ__c != null){
                gen.writeStringField('Motivo_Finalizacao__c', solicTrat.IDC_MOTIVO_FINALIZ__c);
            }

            if(solicTrat.DSC_OBSERVACOES__c != null){
                gen.writeStringField('Tipo_Solicitacao__c', solicTrat.DSC_OBSERVACOES__c);
            }

            gen.writeEndObject();
            gen.writeEndObject();
        }
        gen.writeEndArray();
        gen.writeEndObject();

        return gen.getAsString();
    }

    public static string gerarJsonBodySolicTratativaNegativa(Map<String, String> mapSolicTrat){

        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeBooleanField('allOrNone', false);
    
        gen.writeFieldName('compositeRequest');
        gen.writeStartArray();
        for(String caseNeg : mapSolicTrat.KeySet()){
            gen.writeStartObject();
    
            gen.writeStringField('method', 'POST');
            gen.writeStringField('url', '/services/data/v45.0/sobjects/INTEGRACAO_CASE_SOLIC_TRATATIVA__e');
            gen.writeStringField('referenceId', caseNeg);
    
            gen.writeFieldName('body');
            gen.writeStartObject();
    
            gen.writeStringField('CASE_ID__c', caseNeg);
    
            
            if(mapSolicTrat.get(caseNeg) != null){
                gen.writeStringField('MENSAGEM_RETORNO__c', mapSolicTrat.get(caseNeg));
            }
    
            gen.writeEndObject();
            gen.writeEndObject();
        }
        gen.writeEndArray();
        gen.writeEndObject();
    
        return gen.getAsString();
    }

    @future(callout=true)
    public static void publicarEventoHC(String jsonBody){
        try{
            Http hp = new Http();
            HttpRequest httpReq = new HttpRequest();
            httpReq.setMethod('POST');
            httpReq.setBody(jsonBody);
            httpReq.setHeader('Accept', 'application/json');
            httpReq.setHeader('Content-Type', 'application/json; charset=UTF-8');
            httpReq.setEndpoint('callout:PROGRAMAS_ELEGIVEIS/services/data/v45.0/composite/');
            HttpResponse res = hp.send(httpReq);
            System.debug('Wellness response: ' + res.getStatusCode());
        } catch(exception e) {
            System.debug('Erro na chamada de Publicação de Evento na Org Health Cloud = ' + e.getMessage());
        }
    }

}