package org.dspace.rest.common;

import java.util.List;

public class Faceta {

	private String metadado;
	private String descricao;
	private List<ResultadoFaceta> resultados;

	public String getMetadado() {
		return metadado;
	}

	public void setMetadado(String metadado) {
		this.metadado = metadado;
	}

	public String getDescricao() {
		return descricao;
	}

	public void setDescricao(String descricao) {
		this.descricao = descricao;
	}

	public List<ResultadoFaceta> getResultados() {
		return resultados;
	}

	public void setResultados(List<ResultadoFaceta> resultados) {
		this.resultados = resultados;
	}

}
