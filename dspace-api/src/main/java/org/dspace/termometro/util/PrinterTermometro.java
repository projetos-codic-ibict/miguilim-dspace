package org.dspace.termometro.util;

import java.util.List;

import org.dspace.content.MetadataValue;

public class PrinterTermometro {
	
	public String formatarApresentacaoMensagem(List<MetadataValue> valoresMetadados, String mensagem) {
		StringBuilder mensagemFormatada = new StringBuilder();
		
		boolean isMensagemPresenteNaLista = valoresMetadados
				.stream()
				.anyMatch(m -> m.getValue().trim().equals(mensagem));
		
		if(isMensagemPresenteNaLista) 
		{
			mensagemFormatada.append("<u><i>");
		}
		
		mensagemFormatada.append(mensagem);
		
		if(isMensagemPresenteNaLista) 
		{
			mensagemFormatada.append("</u></i>");
		}

		mensagemFormatada.append("</u></i>");
		
		return mensagemFormatada.toString();
	}

}
