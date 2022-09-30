package org.dspace.app.util;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import org.dspace.services.factory.DSpaceServicesFactory;
import org.json.JSONObject;
import org.json.XML;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class FieldInputFormXMLConvert {
    static final String XML_FORM_FILE_NAME = "input-forms.xml";
    public static final String CONFIG_DIRECTORY = "config";

    static public List<FieldInputForm> getListOfFieldInputForm(String collectionName) {
        try {
            String xmlPath = DSpaceServicesFactory.getInstance().getConfigurationService().getProperty("dspace.dir")
                    + File.separator + CONFIG_DIRECTORY + File.separator + XML_FORM_FILE_NAME;
            File xmlFile = new File(xmlPath);
            String xml = new String(Files.readAllBytes(xmlFile.toPath()), StandardCharsets.UTF_8);
            JSONObject xmlJSONObj = XML.toJSONObject(xml);
            String jsonPrettyPrintString = xmlJSONObj.toString();
            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode json = objectMapper.readTree(jsonPrettyPrintString);

            List<FieldInputForm> listOfFieldInputForm = new ArrayList<>();

            JsonNode forms = json.get("input-forms").get("form-definitions").get("form");
            JsonNode valuePairs = json.get("input-forms").get("form-value-pairs").get("value-pairs");

            for (int i = 0; i < forms.size(); i++) {

                String formName = forms.get(i).get("name").asText();
                collectionName = collectionName.toLowerCase(Locale.ROOT);
                formName = formName.toLowerCase(Locale.ROOT);
                if (collectionName.startsWith(formName)) {
                    JsonNode pages = forms.get(i).get("page");

                    for (int j = 0; j < pages.size(); j++) {
                        JsonNode fields = pages.get(j) != null ? pages.get(j).get("field") : pages.get("field");
                        if (fields != null) {
                            for (int k = 0; k < fields.size(); k++) {
                                try {
                                    ObjectMapper mapper = new ObjectMapper();
                                    FieldInputForm field = mapper.readValue(fields.get(k).toString(), FieldInputForm.class);
                                    if(fields.get(k).get("hint-edit") != null ){
                                        field.setHintEdit(fields.get(k).get("hint-edit").asText());
                                    }
                                    if(fields.get(k).get("vocabulary") != null ){
                                        field.setSimpleVocabulary(fields.get(k).get("vocabulary").isContainerNode() ?
                                                fields.get(k).get("vocabulary").get("content").asText() : fields.get(k).get("vocabulary").asText());

                                    }
                                    if (fields.get(k).get("input-type").isContainerNode()) {
                                        field.setComplextInputType(getMapFromValuesPairs(valuePairs,
                                                fields.get(k).get("input-type").get("value-pairs-name").asText().replaceAll("\\s{2,}", " ")));
                                    } else {
                                        field.setSimpleInputType(fields.get(k).get("input-type").asText().replaceAll("\r", "").replaceAll("\n", "").replaceAll("\\s{2,}", " "));
                                    }
                                    listOfFieldInputForm.add(field);

                                } catch (Exception e) {
                                    System.out.println("ERROR: " + fields.get(k));
                                    e.printStackTrace();
                                }
                            }
                        }
                    }
                }
            }
            return removeDuplications(listOfFieldInputForm);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static List<FieldInputForm> removeDuplications(List<FieldInputForm> fieldInputForms){
        Set<FieldInputForm> set = new LinkedHashSet<>(fieldInputForms);
        return new ArrayList<>(set);
    }

    private static Map<String, String> getMapFromValuesPairs(JsonNode valuePairs, String valuePairsName) {
        Map<String, String> values = new LinkedHashMap<>();
        for (JsonNode node : valuePairs) {
            if (node.get("value-pairs-name").asText().replaceAll("\\s{2,}", " ").equalsIgnoreCase(valuePairsName)) {
                JsonNode pairs = node.get("pair");
                for (JsonNode valueItem : pairs) {
                    values.put(valueItem.get("stored-value").asText().replaceAll("\r", "").replaceAll("\n", "").replaceAll("\\s{2,}", " "),
                            valueItem.get("displayed-value").asText().replaceAll("\r", "").replaceAll("\n", "").replaceAll("\\s{2,}", " "));
                }
            }
        }
        return values;
    }
}
