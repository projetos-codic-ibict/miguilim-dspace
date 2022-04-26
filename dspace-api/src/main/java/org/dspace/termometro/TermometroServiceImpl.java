/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.termometro;

import java.io.IOException;

import org.dspace.content.DSpaceObject;
import org.dspace.termometro.service.TermometroService;
import org.dspace.termometro.util.CalculadoraTermometro;

public class TermometroServiceImpl implements TermometroService {

    protected TermometroServiceImpl() {
    }
   
    @Override
    public String calcularPontuacaoDoItem(DSpaceObject dso) throws IOException {
        
        return CalculadoraTermometro.calcularPontuacaoDoItem(dso);
    }

}

