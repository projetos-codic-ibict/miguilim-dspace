/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.preenchimento.util;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.service.ItemService;
import org.dspace.services.factory.DSpaceServicesFactory;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class CalculadoraPreenchimento {
    private static String[] CAMPOS_REVISTAS;
    private static String[] CAMPOS_PORTAIS;

    private static int PONTUACAO_MAXIMA_REVISTAS;
    private static int PONTUACAO_MAXIMA_PORTAIS;

    private static Map<String, String[]> CAMPOS_PARA_PONTUACAO;

    static final String REVISTAS = "miguilim/2";

    private static ItemService itemService = ContentServiceFactory.getInstance().getItemService();

    private synchronized static void initialize() throws IOException {
        if(CAMPOS_PARA_PONTUACAO == null) {
            Map<String, String[]> camposMap = carregarCamposPontuacao();

            CAMPOS_REVISTAS = camposMap.get("revistas");
            CAMPOS_PORTAIS = camposMap.get("portais");
            PONTUACAO_MAXIMA_REVISTAS = CAMPOS_REVISTAS.length;
            PONTUACAO_MAXIMA_PORTAIS = CAMPOS_PORTAIS.length;
        }
    }

    public static String calcularPontuacaoTotalDoItem(DSpaceObject dso) throws IOException {
        initialize();
        int pontuacaoTotalDoItem = calcularPontuacao((Item)dso);
        return String.valueOf(pontuacaoTotalDoItem);
    }

    public static String calcularPorcentagemPontuacao(DSpaceObject dso) throws IOException {
        initialize();

        Item item = (Item)dso;
        int preenchimentoItem = calcularPontuacao(item);
        int porcentagem = (int)Math.floor((preenchimentoItem / Double.valueOf(getPontuacaoMaximaDoItem(item))) * 100);

        return String.valueOf(porcentagem);
    }

    public static String getPontuacaoMaximaDoItem(Item item) throws IOException {
        initialize();
        int pontuacao = item.isItemDaColecao(REVISTAS) ? PONTUACAO_MAXIMA_REVISTAS : PONTUACAO_MAXIMA_PORTAIS;
        return String.valueOf(pontuacao);
    }

    public static String getPorcentagemPontuacaoFromMetadado(Item item) {
        return itemService.getMetadataFirstValue(item, "dc", "identifier", "percentage", Item.ANY);
    }

    private static int calcularPontuacao(Item item) throws IOException {
        initialize();
        String[] campos = item.isItemDaColecao(REVISTAS) ? CAMPOS_REVISTAS : CAMPOS_PORTAIS;
        return Arrays.stream(campos).filter((campo) -> item.possuiCampo(campo)).toArray().length;
    }

    private static Map<String, String[]> carregarCamposPontuacao() throws IOException {
        String jsonCampos = obterArquivoCampos();
        ObjectMapper mapper = new ObjectMapper();
        JsonNode root = mapper.readTree(jsonCampos);

        Map<String, String[]> result = new HashMap<>();

        JsonNode revistasNode = root.get("revistas");
        List<String> allRevistasFields = new ArrayList<>();
        for (JsonNode classBlock : revistasNode) {
            for (JsonNode field : classBlock.get("fields")) {
                allRevistasFields.add(field.asText());
            }
        }
        result.put("revistas", allRevistasFields.toArray(new String[0]));

        List<String> portaisFields = new ArrayList<>();
        for (JsonNode field : root.get("portais")) {
            portaisFields.add(field.asText());
        }
        result.put("portais", portaisFields.toArray(new String[0]));

        return result;
    }

    private static String obterArquivoCampos() throws IOException {
        String CAMPOS_JSON_FILE = "padrao-metadados.json";
        String CONFIG_DIRECTORY = "config";

        String jsonPath = DSpaceServicesFactory.getInstance().getConfigurationService().getProperty("dspace.dir")
                + File.separator + CONFIG_DIRECTORY + File.separator + CAMPOS_JSON_FILE;
        File xmlFile = new File(jsonPath);

        return new String(Files.readAllBytes(xmlFile.toPath()), StandardCharsets.UTF_8);
    }
}
