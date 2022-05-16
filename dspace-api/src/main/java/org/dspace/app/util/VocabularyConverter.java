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
import java.util.Collections;
import java.util.List;

public class VocabularyConverter {
    private static final String CONFIG_DIRECTORY = "config";
    private static final String VOCABULARY_DIRECTORY = "controlled-vocabularies";
    private final List<String> vocabularies = new ArrayList<>();
    private String vocabularyCNPQ = "CNPQ";

    public List<String> getListOfVocabularies(String vocabularyName) {

        boolean isCNPQ = false;
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
                    this.vocabularies.add(nodes.get(i).get("label").asText());
                }
            } else {
                isCNPQ = true;
                JsonNode node = json.get("node").get("isComposedBy").get("node");
                process(node);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        if (!isCNPQ) {
            Collections.sort(this.vocabularies);
        }
        return this.vocabularies;
    }

    private void process(JsonNode node) {
        if (node == null) {
            if (vocabularyCNPQ.contains("::")) {

                vocabularyCNPQ = vocabularyCNPQ.substring(0, vocabularyCNPQ.lastIndexOf("::"));
            }
            return;
        }

        if (!node.isArray()) {
            vocabularyCNPQ = vocabularyCNPQ + node.get("label").asText();
        } else {
            for (int i = 0; i < node.size(); i++) {
                vocabularyCNPQ = vocabularyCNPQ + "::" + node.get(i).get("label").asText();
                this.vocabularies.add(vocabularyCNPQ);
                if (node.get(i).get("isComposedBy") != null && node.get(i).get("isComposedBy").get("node") != null) {
                    process(node.get(i).get("isComposedBy").get("node"));
                } else {
                    vocabularyCNPQ = vocabularyCNPQ.replace("::" + node.get(i).get("label").asText(), "");
                }
            }
        }
        node = node.get("isComposedBy") != null ? node.get("isComposedBy").get("node") : null;
        process(node);
    }
}
