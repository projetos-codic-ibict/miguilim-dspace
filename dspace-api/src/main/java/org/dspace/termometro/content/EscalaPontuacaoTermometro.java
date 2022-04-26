/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.termometro.content;

import java.util.Map;

public class EscalaPontuacaoTermometro implements java.io.Serializable
{
    private Integer tipoAvaliacao;
    private Map<String, Integer> pontuacao;

    public Integer getTipoAvaliacao()
    {
        return this.tipoAvaliacao;
    }
    
    public void setTipoAvaliacao(final Integer tipoAvaliacao)
    {
        this.tipoAvaliacao = tipoAvaliacao;
    }
    
    public Map<String, Integer> getPontuacao()
    {
        return this.pontuacao;
    }
    
    public void setPontuacao(final Map<String, Integer>  pontuacao)
    {
        this.pontuacao = pontuacao;
    }
}

