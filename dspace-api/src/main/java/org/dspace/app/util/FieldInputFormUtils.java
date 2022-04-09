package org.dspace.app.util;

import org.dspace.content.MetadataValue;

import java.util.List;
import java.util.function.Predicate;

public class FieldInputFormUtils {
    List<FieldInputForm> fieldInputFormList;
    List<MetadataValue> metadataValueList;
    private int countXMLNotFound;
    private int countMetadataNotFound;

    public FieldInputFormUtils(List<FieldInputForm> fieldInputFormList, List<MetadataValue> metadataValueList) {
        System.out.println("<<<<<<<<<<<<<<<< FieldInputFormUtils >>>>>>>>>>>>>>>>>");
        System.out.println("fieldInputFormList size: "+ fieldInputFormList.size());
        System.out.println("metadataValueList size: "+ metadataValueList.size());
        this.fieldInputFormList = fieldInputFormList;
        this.metadataValueList = metadataValueList;
    }

    public FieldInputForm getFieldFromXMLByKeys(String schema, String element, String qualifier) {
        Predicate<FieldInputForm> schemaIsEquals = f -> f.getSchema().equals(schema);
        Predicate<FieldInputForm> elementIsEquals = f -> f.getElement().equals( element);
        Predicate<FieldInputForm> qualifierIsEquals = f -> (f.getQualifier() != null
                && !f.getQualifier().isEmpty())
                && (qualifier != null && !qualifier.isEmpty()) ?
                f.getQualifier().equals(qualifier) :
                ((f.getQualifier() == null || f.getQualifier().isEmpty())
                        && (qualifier == null || qualifier.isEmpty()));
        Predicate<FieldInputForm> isSchemaElementQualifierEquals = schemaIsEquals.and(elementIsEquals).and(qualifierIsEquals);
        FieldInputForm fieldInputForm =  this.fieldInputFormList.stream().filter(isSchemaElementQualifierEquals).findAny().orElse(null);
        if(fieldInputForm == null){
            countXMLNotFound++;
            System.out.println("####### "+countXMLNotFound+" Field not found in XML #######");
            System.out.println("schema :"+schema+", element: "+ element +", qualifier: "+qualifier+";");
        }
        return fieldInputForm;
    }

    public MetadataValue getFieldFromMetadataByKeys(String schema, String element, String qualifier) {
        Predicate<MetadataValue> schemaIsEquals = f -> f.getMetadataField().getMetadataSchema().getName().equals(schema);
        Predicate<MetadataValue> elementIsEquals = f -> f.getMetadataField().getElement().equals(element);
        Predicate<MetadataValue> qualifierIsEquals = f -> (f.getMetadataField().getQualifier() != null
                && !f.getMetadataField().getQualifier().isEmpty())
                && (qualifier != null && !qualifier.isEmpty()) ?
                f.getMetadataField().getQualifier().equals(qualifier) :
                ((f.getMetadataField().getQualifier() == null || f.getMetadataField().getQualifier().isEmpty())
                        && (qualifier == null || qualifier.isEmpty()));
        Predicate<MetadataValue> isSchemaElementQualifierEquals = schemaIsEquals.and(elementIsEquals).and(qualifierIsEquals);
        MetadataValue fieldInputForm =  this.metadataValueList.stream().filter(isSchemaElementQualifierEquals).findAny().orElse(null);
        if(fieldInputForm == null){
            countMetadataNotFound++;
            System.out.println("####### "+countMetadataNotFound+" Field not found in Metadata #######");
            System.out.println("schema :"+schema+", element: "+ element +", qualifier: "+qualifier+";");
        }
        return fieldInputForm;
    }
}
