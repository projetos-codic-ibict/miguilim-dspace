package org.dspace.termometro.util;

import java.util.List;

import org.dspace.content.MetadataValue;

public class PrinterTermometro {
	
	public String formatarApresentacaoMensagem(List<MetadataValue> valoresMetadados, String mensagem, String pontuacao) {
		StringBuilder mensagemFormatada = new StringBuilder();
		
		boolean isMensagemPresenteNaLista = valoresMetadados
				.stream()
				.anyMatch(m -> m.getValue().trim().equals(mensagem));
		
		mensagemFormatada.append(mensagem);
		mensagemFormatada.append(" = ");
		mensagemFormatada.append(pontuacao);
		mensagemFormatada.append(" ");

		
		if(isMensagemPresenteNaLista) 
		{
			mensagemFormatada.append("<span>&#x2705;</span>");
		} 
		
		
		return mensagemFormatada.toString();
	}

}
