/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.termometro.util;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;
import org.dspace.content.MetadataValue;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.service.ItemService;
import org.dspace.services.factory.DSpaceServicesFactory;
import org.dspace.termometro.content.EscalaPontuacaoTermometro;
import org.dspace.termometro.content.TipoAvaliacaoEscala;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

public class CalculadoraTermometro {

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
    
    public static String calcularPontuacaoDoItemPorMetadado(DSpaceObject dso, String metadado) throws IOException {
        initialize();

        String[] estruturaMetadado = metadado.split("\\.");
        String schema = estruturaMetadado[0];
        String element = estruturaMetadado[1];
        String qualifier = estruturaMetadado[2];
        
        Map<String, List<String>> metadadosDoItem = obterValoresMetadados(dso, schema, element, qualifier);
        Double pontuacaoTotalDoItem = calcularPontuacao(metadadosDoItem);

        return String.valueOf(pontuacaoTotalDoItem.intValue());
    }

    public static String calcularPontuacaoTotalDoItem(DSpaceObject dso) throws IOException {
        initialize();
        
        Map<String, List<String>> metadadosDoItem = obterValoresMetadados(dso, Item.ANY, Item.ANY, Item.ANY);
        Double pontuacaoTotalDoItem = calcularPontuacao(metadadosDoItem);

        return String.valueOf(pontuacaoTotalDoItem.intValue());
    }

    public static String calcularPorcentagemPontuacao(DSpaceObject dso) throws IOException {
        initialize();
        
        Map<String, List<String>> metadadosDoItem = obterValoresMetadados(dso, Item.ANY, Item.ANY, Item.ANY);

        Double pontuacaoTotalDoItem = calcularPontuacao(metadadosDoItem);
        Double porcentagemPontuacao = Math.floor((pontuacaoTotalDoItem / PONTUACAO_MAXIMA_POSSIVEL) * 100);

        return String.valueOf(porcentagemPontuacao.intValue());
    }

    private static Map<String, List<String>> obterValoresMetadados(DSpaceObject dso, String schema, String element, String qualifier) {
        return itemService
            .getMetadata((Item) dso, schema, element, qualifier, Item.ANY)
            .stream()
            .collect(
                Collectors.groupingBy(
                    metadado -> metadado.getMetadataField().toString(), 
                    Collectors.mapping(MetadataValue::getValue, 
                    Collectors.toList())));
    }

    private static Double calcularPontuacao(Map<String, List<String>> metadadosDoItem) {
        Double pontuacaoTotalDoItem = 0.0;

        for (Map.Entry<String, EscalaPontuacaoTermometro> regra : REGRAS_PARA_PONTUACAO.entrySet()) 
        {
            List<String> valoresDoMetadado = metadadosDoItem.get(regra.getKey());

            if(valoresDoMetadado != null) 
            {
                EscalaPontuacaoTermometro escalaPontuacao = (EscalaPontuacaoTermometro) regra.getValue();

                if(escalaPontuacao.getTipoAvaliacao() == TipoAvaliacaoEscala.TEXTUAL.getCodigo()) {
                    String chavePontuacao = String.valueOf(valoresDoMetadado.size());
                    Integer valorPontuacao = Optional
                        .ofNullable(escalaPontuacao.getPontuacao().get(chavePontuacao))
                        .orElseGet(() -> escalaPontuacao.getPontuacao().get(CHAVE_PONTUACAO_DEFAULT));

                    pontuacaoTotalDoItem += valorPontuacao;
                }
                else if (isTipoAvaliacaoListagem(escalaPontuacao)) {
                    for(String chavePontuacao : valoresDoMetadado) 
                    {
                        String chaveFormatada = chavePontuacao.replaceAll("\\s{2,}", " ");
                        Integer valorPontuacao = Optional
                            .ofNullable(escalaPontuacao.getPontuacao().get(chaveFormatada))
                            .orElseGet(() -> 0);

                        pontuacaoTotalDoItem += valorPontuacao;
                    }
                }
            }
        }

        return pontuacaoTotalDoItem;
    }

    private static Integer calcularPontuacaoMaxima() {
        Integer valorPontuacaoMaxima = 0;

        for (Map.Entry<String, EscalaPontuacaoTermometro> regra : REGRAS_PARA_PONTUACAO.entrySet()) 
        {
            EscalaPontuacaoTermometro escalaPontuacao = (EscalaPontuacaoTermometro) regra.getValue();
           
            if(escalaPontuacao.getTipoAvaliacao() == TipoAvaliacaoEscala.MULTIPLA_ESCOLHA.getCodigo()) 
            {
                valorPontuacaoMaxima += Optional
                    .ofNullable(escalaPontuacao.getLimitePontuacao())
                    .orElseGet(() -> escalaPontuacao.getPontuacao().values().stream().reduce(0, Integer::sum));
            }
            else
            {
                valorPontuacaoMaxima += Collections.max(escalaPontuacao.getPontuacao().values());
            }
        }

        return valorPontuacaoMaxima;
    }

    private static boolean isTipoAvaliacaoListagem(EscalaPontuacaoTermometro escalaPontuacao) {
        return escalaPontuacao.getTipoAvaliacao() == TipoAvaliacaoEscala.SELECAO.getCodigo()
            || escalaPontuacao.getTipoAvaliacao() == TipoAvaliacaoEscala.MULTIPLA_ESCOLHA.getCodigo();
    }

    private static Map<String, EscalaPontuacaoTermometro> carregarRegrasPontuacao() throws IOException {
        String jsonRegras = obterArquivoRegras();
        return new ObjectMapper().readValue(jsonRegras, new TypeReference<Map<String, EscalaPontuacaoTermometro>>(){});
    }

    private static String obterArquivoRegras() throws IOException {
        String PONTUACAO_JSON_FILE = "pontuacao-termometro-mapping.json";
        String CONFIG_DIRECTORY = "config";
    
        String jsonPath = DSpaceServicesFactory.getInstance().getConfigurationService().getProperty("dspace.dir")
                + File.separator + CONFIG_DIRECTORY + File.separator + PONTUACAO_JSON_FILE;
        File xmlFile = new File(jsonPath);

        return new String(Files.readAllBytes(xmlFile.toPath()), StandardCharsets.UTF_8);
    }

}


