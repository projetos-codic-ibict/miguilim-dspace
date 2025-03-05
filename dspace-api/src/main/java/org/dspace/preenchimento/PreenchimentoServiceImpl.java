/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.preenchimento;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Iterator;

import org.dspace.content.Collection;
import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;
import org.dspace.content.MetadataSchema;
import org.dspace.content.service.ItemService;
import org.dspace.core.Context;
import org.dspace.preenchimento.service.PreenchimentoService;
import org.dspace.preenchimento.util.CalculadoraPreenchimento;
import org.springframework.beans.factory.annotation.Autowired;

public class PreenchimentoServiceImpl implements PreenchimentoService {

    @Autowired(required = true)
    protected ItemService itemService;

    protected PreenchimentoServiceImpl() {
    }

    @Override
    public String calcularPorcentagemPontuacao(DSpaceObject dso) throws IOException {

        return CalculadoraPreenchimento.calcularPorcentagemPontuacao(dso);
    }

    @Override
    public String calcularPontuacaoTotalDoItem(DSpaceObject dso) throws IOException {

        return CalculadoraPreenchimento.calcularPontuacaoTotalDoItem(dso);
    }

    @Override
    public void atualizarMetadadosPreenchimento(Context context, Collection collection) throws SQLException, IOException {
        Iterator<Item> items =
            itemService.findAllByCollectionWhithoutThermometer(context, collection);

        int count = 0;
        while(items.hasNext())
        {
            Item item = items.next();
            String pontuacao = calcularPorcentagemPontuacao(item) + "%";
            itemService.addMetadata(context, item, MetadataSchema.DC_SCHEMA, "identifier", "percentage", "pt_BR", pontuacao);
            count++;
        }

        System.out.println(count);
    }

}

