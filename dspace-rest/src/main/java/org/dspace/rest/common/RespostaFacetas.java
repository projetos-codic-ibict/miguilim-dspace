package org.dspace.rest.common;

import java.util.List;

public class RespostaFacetas {

	private Long quantidadeTotalItens;
	private List<Faceta> facetas;

	public Long getQuantidadeTotalItens() {
		return quantidadeTotalItens;
	}

	public void setQuantidadeTotalItens(Long quantidadeTotalItens) {
		this.quantidadeTotalItens = quantidadeTotalItens;
	}

	public List<Faceta> getFacetas() {
		return facetas;
	}

	public void setFacetas(List<Faceta> facetas) {
		this.facetas = facetas;
	}

}
