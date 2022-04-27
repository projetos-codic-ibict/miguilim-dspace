/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.termometro.util;

import java.io.IOException;
import java.net.URL;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.base.Charsets;
import com.google.common.io.Resources;

import org.apache.log4j.Logger;
import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;
import org.dspace.content.MetadataValue;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.service.ItemService;
import org.dspace.termometro.content.EscalaPontuacaoTermometro;
import org.dspace.termometro.content.TipoAvaliacaoEscala;

public class CalculadoraTermometro {

    private static final Logger LOGGER = Logger.getLogger(CalculadoraTermometro.class);

    private static final String CHAVE_PONTUACAO_DEFAULT = "default";

    private static Integer PONTUACAO_MAXIMA_POSSIVEL = 0;
    private static ItemService itemService;
    private static Map<String, EscalaPontuacaoTermometro> REGRAS_PARA_PONTUACAO;

    private synchronized static void initialize() throws IOException {
		itemService = ContentServiceFactory.getInstance().getItemService();

        if(REGRAS_PARA_PONTUACAO == null) {
            REGRAS_PARA_PONTUACAO = carregarRegrasPontuacao();
            PONTUACAO_MAXIMA_POSSIVEL = calcularPontuacaoMaxima();
        }
	}
    
    public static String calcularPontuacaoDoItem(DSpaceObject dso) throws IOException {
        initialize();
        
        Double pontuacaoFinal = 0.0;
        Double pontuacaoTotalDoItem = 0.0;
        Map<String, List<String>> metadadosDoItem = obterMetadadosDoItem(dso);

        for (Map.Entry<String, EscalaPontuacaoTermometro> regra : REGRAS_PARA_PONTUACAO.entrySet()) 
        {
            List<String> valoresDoMetadado = metadadosDoItem.get(regra.getKey());

            if(valoresDoMetadado != null) 
            {
                LOGGER.info("CALCULANDO METADADO: " + regra.getKey());
                EscalaPontuacaoTermometro escalaPontuacao = (EscalaPontuacaoTermometro) regra.getValue();

                if(escalaPontuacao.getTipoAvaliacao() == TipoAvaliacaoEscala.TEXTUAL.getCodigo()) {
                    String chavePontuacao = String.valueOf(valoresDoMetadado.size());
                    Integer valorPontuacao = Optional
                        .ofNullable(escalaPontuacao.getPontuacao().get(chavePontuacao))
                        .orElseGet(() -> escalaPontuacao.getPontuacao().get(CHAVE_PONTUACAO_DEFAULT));

                    LOGGER.info(valorPontuacao + " PONTOS PARA " + regra.getKey());
                    pontuacaoTotalDoItem += valorPontuacao;
                }
                else if (isTipoAvaliacaoListagem(escalaPontuacao)) {
                    for(String chavePontuacao : valoresDoMetadado) 
                    {
                        LOGGER.info("chavePontuacao: [" + chavePontuacao + "], " + chavePontuacao.length());
                        
                        String chaveFormatada = chavePontuacao
                            .replaceAll("\"", "")
                            .replaceAll("\n", "");
                            
                        LOGGER.info("chaveFormatada: [" + chaveFormatada + "], " + chaveFormatada.length());

                        Integer valorPontuacao = Optional
                            .ofNullable(escalaPontuacao.getPontuacao().get(chaveFormatada))
                            .orElseGet(() -> 0);
                        
                        LOGGER.info(valorPontuacao + " PONTOS PARA " + regra.getKey());
                        pontuacaoTotalDoItem += valorPontuacao;
                    }
                }
            }
        }

        pontuacaoFinal = Math.floor((pontuacaoTotalDoItem / PONTUACAO_MAXIMA_POSSIVEL) * 100);
        LOGGER.info("PONTUACAO_TOTAL_DO_ITEM: " + pontuacaoTotalDoItem);
        LOGGER.info("PONTUACAO_MAXIMA_POSSIVEL: " + PONTUACAO_MAXIMA_POSSIVEL);
        LOGGER.info("PONTUACAO_FINAL: " + pontuacaoFinal);

        return String.valueOf(pontuacaoFinal);
    }

    private static Map<String, List<String>> obterMetadadosDoItem(DSpaceObject dso) {
        return itemService
            .getMetadata((Item) dso, Item.ANY, Item.ANY, Item.ANY, Item.ANY)
            .stream()
            .collect(
                Collectors.groupingBy(
                    metadado -> metadado.getMetadataField().toString(), 
                    Collectors.mapping(MetadataValue::getValue, 
                    Collectors.toList())));
    }

    private static boolean isTipoAvaliacaoListagem(EscalaPontuacaoTermometro escalaPontuacao) {
        return escalaPontuacao.getTipoAvaliacao() == TipoAvaliacaoEscala.SELECAO.getCodigo()
            || escalaPontuacao.getTipoAvaliacao() == TipoAvaliacaoEscala.MULTIPLA_ESCOLHA.getCodigo();
    }

    private static Map<String, EscalaPontuacaoTermometro> carregarRegrasPontuacao() throws IOException {
        URL url = Resources.getResource("/termometro/pontuacao-termometro-mapping.json");
        String jsonRegras = Resources.toString(url, Charsets.UTF_8);

        return new ObjectMapper().readValue(jsonRegras, new TypeReference<Map<String, EscalaPontuacaoTermometro>>(){});
    }

    private static Integer calcularPontuacaoMaxima() {
        Integer valorPontuacaoMaxima = 0;

        for (Map.Entry<String, EscalaPontuacaoTermometro> regra : REGRAS_PARA_PONTUACAO.entrySet()) 
        {
            EscalaPontuacaoTermometro escalaPontuacao = (EscalaPontuacaoTermometro) regra.getValue();
           
            if(escalaPontuacao.getTipoAvaliacao() == TipoAvaliacaoEscala.MULTIPLA_ESCOLHA.getCodigo()) {
                valorPontuacaoMaxima += escalaPontuacao.getPontuacao()
                    .values()
                    .stream()
                    .reduce(0, Integer::sum);
            }
            else
            {
                valorPontuacaoMaxima += Collections.max(escalaPontuacao.getPontuacao().values());
            }
        }

        return valorPontuacaoMaxima;
    }

}


