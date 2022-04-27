/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.termometro.content;

public enum TipoAvaliacaoEscala {
    TEXTUAL(1),
    SELECAO(2),
    MULTIPLA_ESCOLHA(3);

    private final Integer codigo;

    TipoAvaliacaoEscala(Integer codigo) {
           this.codigo = codigo;
    }
    
    public Integer getCodigo() { 
        return codigo; 
    }
}
