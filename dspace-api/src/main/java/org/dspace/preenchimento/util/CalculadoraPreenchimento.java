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
import java.util.Arrays;
import java.util.Map;

import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.service.ItemService;
import org.dspace.services.factory.DSpaceServicesFactory;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

public class CalculadoraPreenchimento {
    private static String[] CAMPOS_REVISTAS;

    private static int PONTUACAO_MAXIMA_REVISTAS;

    private static Map<String, String[]> CAMPOS_PARA_PONTUACAO;

    static final String REVISTAS = "miguilim/2";

    private static ItemService itemService = ContentServiceFactory.getInstance().getItemService();

    private synchronized static void initialize() throws IOException {
        if(CAMPOS_PARA_PONTUACAO == null) {
            Map<String, String[]> camposMap = carregarCamposPontuacao();

            CAMPOS_REVISTAS = camposMap.get("revistas");
            PONTUACAO_MAXIMA_REVISTAS = CAMPOS_REVISTAS.length;
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
        int porcentagem = (int)Math.floor((preenchimentoItem / Double.valueOf(getPontuacaoMaximaRevistas())) * 100);

        return String.valueOf(porcentagem);
    }

    public static String getPontuacaoMaximaRevistas() throws IOException {
        initialize();

        return String.valueOf(PONTUACAO_MAXIMA_REVISTAS);
    }

    public static String getPorcentagemPontuacaoFromMetadado(Item item) {
        return itemService.getMetadataFirstValue(item, "dc", "identifier", "percentage", Item.ANY);
    }

    private static int calcularPontuacao(Item item) {
        if (!item.isItemDaColecao(REVISTAS)) {
            throw new RuntimeException("Porcentagem de preenchimento só está implementado para revistas.");
        }

        return Arrays.stream(CAMPOS_REVISTAS).filter((campo) -> item.possuiCampo(campo)).toArray().length;
    }

    private static Map<String, String[]> carregarCamposPontuacao() throws IOException {
        String jsonCampos = obterArquivoCampos();
        return new ObjectMapper().readValue(jsonCampos, new TypeReference<Map<String, String[]>>(){});
    }

    private static String obterArquivoCampos() throws IOException {
        String PONTUACAO_JSON_FILE = "pontuacao-preenchimento-mapping.json";
        String CONFIG_DIRECTORY = "config";

        String jsonPath = DSpaceServicesFactory.getInstance().getConfigurationService().getProperty("dspace.dir")
                + File.separator + CONFIG_DIRECTORY + File.separator + PONTUACAO_JSON_FILE;
        File xmlFile = new File(jsonPath);

        return new String(Files.readAllBytes(xmlFile.toPath()), StandardCharsets.UTF_8);
    }
}
