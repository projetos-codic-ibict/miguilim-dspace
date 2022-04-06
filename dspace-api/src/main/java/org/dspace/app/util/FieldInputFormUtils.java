package org.dspace.app.util;

import org.dspace.content.MetadataValue;

import java.util.List;
import java.util.function.Predicate;

public class FieldInputFormUtils {
    List<FieldInputForm> fieldInputFormList;
    List<MetadataValue> metadataValueList;

    public FieldInputFormUtils(List<FieldInputForm> fieldInputFormList, List<MetadataValue> metadataValueList) {
        this.fieldInputFormList = fieldInputFormList;
        this.metadataValueList = metadataValueList;
    }

    public FieldInputForm getFieldFromXMLByKeys(String schema, String element, String qualifier) {
        Predicate<FieldInputForm> schemaIsEquals = f -> f.getSchema().equals(schema);
        Predicate<FieldInputForm> elementIsEquals = f -> f.getElement().equals( element);
        Predicate<FieldInputForm> qualifierIsEquals = f -> f.getQualifier().equals( qualifier);
        Predicate<FieldInputForm> isSchemaElementQualifierEquals = schemaIsEquals.and(elementIsEquals).and(qualifierIsEquals);
        FieldInputForm fieldInputForm =  this.fieldInputFormList.stream().filter(isSchemaElementQualifierEquals).findAny().orElse(null);
        if(fieldInputForm == null){
            System.out.println("####### Field not found in XML #######");
            System.out.println("schema:"+schema+";");
            System.out.println("element:"+element+";");
            System.out.println("qualifier:"+qualifier+";");
        }
        return fieldInputForm;
    }

    public MetadataValue getFieldFromMetadataByKeys(String schema, String element, String qualifier) {
        Predicate<MetadataValue> schemaIsEquals = f -> f.getMetadataField().getMetadataSchema().getName().equals(schema);
        Predicate<MetadataValue> elementIsEquals = f -> f.getMetadataField().getElement().equals(element);
        Predicate<MetadataValue> qualifierIsEquals = f -> f.getMetadataField().getQualifier() != null ?
                f.getMetadataField().getQualifier().equals(qualifier) :
                (qualifier == null || qualifier.isEmpty());
        Predicate<MetadataValue> isSchemaElementQualifierEquals = schemaIsEquals.and(elementIsEquals).and(qualifierIsEquals);
        MetadataValue fieldInputForm =  this.metadataValueList.stream().filter(isSchemaElementQualifierEquals).findAny().orElse(null);
        if(fieldInputForm == null){
            System.out.println("####### Field not found in MetadadaValues #######");
            System.out.println("schema:"+schema+";");
            System.out.println("element:"+element+";");
            System.out.println("qualifier:"+qualifier+";");
        }
        return fieldInputForm;
    }
}
