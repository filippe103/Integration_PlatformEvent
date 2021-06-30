public class TCCSolicitacaoTratativaOPFactory {

    public String gerarJsonBodySolicitacao(List<Case> listCasos){      

        JSONGenerator gen = JSON.createGenerator(true);        
        gen.writeStartObject();
        gen.writeBooleanField('allOrNone', false);

        gen.writeFieldName('compositeRequest');
        gen.writeStartArray();       
        for (Case caso : listCasos) {
            gen.writeStartObject(); 

            gen.writeStringField('method', 'POST');
            gen.writeStringField('url', '/services/data/v45.0/sobjects/SOLIC_TRATATIVA_NCC__e');
            gen.writeStringField('referenceId', caso.Id);

            gen.writeFieldName('body');
            gen.writeStartObject();
           
            //Inserir campo do Event correto abaixo
            gen.writeStringField('caseId__c', caso.Id);

            if(caso.Nome_Responsavel__c != null){
                gen.writeStringField('Nome_Responsavel__c', caso.Nome_Responsavel__c);
            }

            if(caso.Descricao_Indicacao__c != null){
                gen.writeStringField('Motivo_Encaminhamento__c', caso.Descricao_Indicacao__c);   
            } 

            if(caso.Contato1__c != null){
                gen.writeStringField('Contato1__c', caso.Contato1__c);
            }

            if(caso.CreatedDate != null){
                date dataAtiv = caso.CreatedDate.date();
                //gen.writeDateField('InicioInternacao__c', caso.Inicio_Internacao__c);
                gen.writeDateField('InicioInternacao__c', dataAtiv);
            }

            gen.writeBooleanField('Agilidade_VPP__c', caso.Agilidade_VPP__c);
            gen.writeBooleanField('Condicao_Desospitalizacao__c', caso.Condicao_Desospitalizacao__c);
            

            /*if (caso.ContactId != null){
                gen.writeStringField('Contato__c', caso.Contact.Name);
            }*/

            if (caso.Specialty__r != null && caso.Specialty__r.COD_ESPECIALIDADE__c != null){
                gen.writeStringField('CodigoEspecialidade__c', caso.Specialty__r.COD_ESPECIALIDADE__c);
            }

            if (caso.AccountId != null && caso.Account.COD_BENEF_UNICO__c != null){
                gen.writeNumberField('Cod_Benef_Unico__c', caso.Account.COD_BENEF_UNICO__c);
            }

            if(caso.Status != null){
                gen.writeStringField('Status__c', caso.Status);
            }

            gen.writeEndObject();
            gen.writeEndObject();           
        }     
        gen.writeEndArray();
        gen.writeEndObject();

        return gen.getAsString();
    }


}