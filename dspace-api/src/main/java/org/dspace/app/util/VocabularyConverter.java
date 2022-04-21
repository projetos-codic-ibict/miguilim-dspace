package org.dspace.app.util;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.dspace.services.factory.DSpaceServicesFactory;
import org.json.JSONObject;
import org.json.XML;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;

public class VocabularyConverter {
    public static final String CONFIG_DIRECTORY = "config";
    public static final String VOCABULARY_DIRECTORY = "controlled-vocabularies";
    private final List<String> vocabularies = new ArrayList<>();
    private String vocabulary = "CNPQ";

    public List<String> getListOfVocabularies(String vocabularyName) {
        try {
            String xmlPath = DSpaceServicesFactory.getInstance().getConfigurationService().getProperty("dspace.dir")
                    + File.separator + CONFIG_DIRECTORY + File.separator + VOCABULARY_DIRECTORY + File.separator + vocabularyName + ".xml";
            File xmlFile = new File(xmlPath);
            String xml = new String(Files.readAllBytes(xmlFile.toPath()), StandardCharsets.UTF_8);
            JSONObject xmlJSONObj = XML.toJSONObject(xml);
            String jsonPrettyPrintString = xmlJSONObj.toString();
            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode json = objectMapper.readTree(jsonPrettyPrintString);

            JsonNode isComposedBy = json.get("isComposedBy");
            if (isComposedBy != null) {
                JsonNode nodes = isComposedBy.get("node");
                for (int i = 0; i < nodes.size(); i++) {
                    vocabularies.add(nodes.get(i).get("label").asText());
                }
            } else {
                JsonNode node = json.get("node").get("isComposedBy").get("node");
                process(node);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return this.vocabularies;
    }

    private void process(JsonNode node) {
        if (node == null) {
            if (vocabulary.contains("::")) {

                vocabulary = vocabulary.substring(0, vocabulary.lastIndexOf("::"));
            }
            return;
        }

        if (!node.isArray()) {
            vocabulary = vocabulary + node.get("label").asText();
        } else {
            for (int i = 0; i < node.size(); i++) {
                vocabulary = vocabulary + "::" + node.get(i).get("label").asText();
                vocabularies.add(vocabulary);
                if (node.get(i).get("isComposedBy") != null && node.get(i).get("isComposedBy").get("node") != null) {
                    process(node.get(i).get("isComposedBy").get("node"));
                } else {
                    vocabulary = vocabulary.replace("::" + node.get(i).get("label").asText(), "");
                }
            }
        }
        node = node.get("isComposedBy") != null ? node.get("isComposedBy").get("node") : null;
        process(node);
    }
}
