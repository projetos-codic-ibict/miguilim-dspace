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
        Predicate<FieldInputForm> qualifierIsEquals = f -> (f.getQualifier() != null
                && !f.getQualifier().isEmpty())
                && (qualifier != null && !qualifier.isEmpty()) ?
                f.getQualifier().equals(qualifier) :
                ((f.getQualifier() == null || f.getQualifier().isEmpty())
                        && (qualifier == null || qualifier.isEmpty()));
        Predicate<FieldInputForm> isSchemaElementQualifierEquals = schemaIsEquals.and(elementIsEquals).and(qualifierIsEquals);
        return this.fieldInputFormList.stream().filter(isSchemaElementQualifierEquals).findAny().orElse(null);
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
        return this.metadataValueList.stream().filter(isSchemaElementQualifierEquals).findAny().orElse(null);
    }
}
