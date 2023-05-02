package org.dspace.termometro.util;

import java.util.List;

import org.dspace.content.MetadataValue;

public class PrinterTermometro {
	
	private static final String CHECK_SYMBOL = "<span>&#x2705;</span>";
	
	public String formatarApresentacaoPorCriterioDeIgualdade(List<MetadataValue> valoresMetadados, String mensagem, String pontuacao) {
		boolean isOpcaoSelecionada = valoresMetadados
				.stream()
				.anyMatch(m -> m.getValue().trim().equals(mensagem));
		
		StringBuilder mensagemFormatada = new StringBuilder();
		mensagemFormatada.append(mensagem);
		mensagemFormatada.append(" = ");
		mensagemFormatada.append(pontuacao);
		mensagemFormatada.append(" ");
		
		if(isOpcaoSelecionada) 
		{
			mensagemFormatada.append(CHECK_SYMBOL);
		} 
		
		return mensagemFormatada.toString();
	}
	
	public String formatarApresentacaoPorCriterioDeQuantidade(List<MetadataValue> valoresMetadados, Integer quantidade, boolean isQuantidadeDefault) {
		boolean isQuantidadeDeEscolhas = Boolean.FALSE;
		
		if(isQuantidadeDefault)
		{
			isQuantidadeDeEscolhas = valoresMetadados.size() >= quantidade;
		}
		else
		{
			isQuantidadeDeEscolhas = valoresMetadados.size() == quantidade;
		}
		
		StringBuilder mensagemFormatada = new StringBuilder();
		mensagemFormatada.append(" ");
		
		if(isQuantidadeDeEscolhas) 
		{
			mensagemFormatada.append(CHECK_SYMBOL);
		} 
		
		return mensagemFormatada.toString();
	}

}
