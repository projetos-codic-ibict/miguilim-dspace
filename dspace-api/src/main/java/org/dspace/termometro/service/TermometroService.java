/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.termometro.service;

import java.io.IOException;
import java.sql.SQLException;

import org.dspace.content.Collection;
import org.dspace.content.DSpaceObject;
import org.dspace.core.Context;

public interface TermometroService {

    String calcularPorcentagemPontuacao(DSpaceObject dso) throws IOException;

    String calcularPontuacaoTotalDoItem(DSpaceObject dso) throws IOException;

    String calcularPontuacaoDoItemPorMetadado(DSpaceObject dso, String metadado)  throws IOException;

    void atualizarMetadadosTermometro(Context context, Collection collection) throws SQLException, IOException;
}
