/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.termometro;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Iterator;

import org.dspace.content.Collection;
import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;
import org.dspace.content.MetadataSchema;
import org.dspace.content.service.ItemService;
import org.dspace.core.Context;
import org.dspace.termometro.service.TermometroService;
import org.dspace.termometro.util.CalculadoraTermometro;
import org.springframework.beans.factory.annotation.Autowired;

public class TermometroServiceImpl implements TermometroService {

    @Autowired(required = true)
    protected ItemService itemService;

    protected TermometroServiceImpl() {
    }
    
    @Override
    public String calcularPorcentagemPontuacao(DSpaceObject dso) throws IOException {
        
        return CalculadoraTermometro.calcularPorcentagemPontuacao(dso);
    }

    @Override
    public String calcularPontuacaoTotalDoItem(DSpaceObject dso) throws IOException {
        
        return CalculadoraTermometro.calcularPontuacaoTotalDoItem(dso);
    }

    @Override
    public String calcularPontuacaoDoItemPorMetadado(DSpaceObject dso, String metadado)  throws IOException {
        return CalculadoraTermometro.calcularPontuacaoDoItemPorMetadado(dso, metadado);
    }

    @Override
    public void atualizarMetadadosTermometro(Context context, Collection collection) throws SQLException, IOException {
        Iterator<Item> items = 
            itemService.findAllByCollectionWhithoutThermometer(context, collection);
							
        int count = 0;
		while(items.hasNext()) 
        {
            Item item = items.next();
			String pontuacao = calcularPorcentagemPontuacao(item);
			itemService.addMetadata(context, item, MetadataSchema.DC_SCHEMA, "identifier", "thermometer", "pt_BR", pontuacao);
			count++;
		}
        
        System.out.println(count);
        // context.commit();
    }

}

