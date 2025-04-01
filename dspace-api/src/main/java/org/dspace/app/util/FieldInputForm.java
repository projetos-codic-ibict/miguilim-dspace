package org.dspace.app.util;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Map;
import java.util.Objects;
import java.util.SortedMap;

@JsonIgnoreProperties(ignoreUnknown = true)
public class FieldInputForm {
    @JsonProperty("dc-schema")
    private String schema;
    @JsonProperty("dc-element")
    private String element;
    @JsonProperty("dc-qualifier")
    private String qualifier;
    @JsonProperty("repeatable")
    private boolean repeatable;
    @JsonProperty("repeatLimit")
    private int repeatLimit = -1;
    @JsonProperty("label")
    private String label;
    @JsonProperty("hint")
    private String hint;
    @JsonProperty("required")
    private String required;

    private String simpleVocabulary;
    private String simpleInputType;
    private Map<String, String> complextInputType;
    private String hintEdit;

    public String getKey() {
        String separator = "_";
        if (qualifier == null || qualifier.isEmpty())
        {
            return this.schema + separator + element;
        }
        else
        {
            return this.schema + separator + element + separator + qualifier;
        }
    }

    public String getSchema() {
        return schema;
    }

    public void setSchema(String schema) {
        this.schema = schema;
    }

    public String getElement() {
        return element;
    }

    public void setElement(String element) {
        this.element = element;
    }

    public String getQualifier() {
        return qualifier;
    }

    public void setQualifier(String qualifier) {
        this.qualifier = qualifier;
    }

    public int getRepeatLimit() {
        return repeatLimit;
    }

    public void setRepeatLimit(int repeatLimit) {
        this.repeatLimit = repeatLimit;
    }

    public boolean getRepeatable() {
        return repeatable;
    }

    public void setRepeatable(boolean repeatable) {
        this.repeatable = repeatable;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getHint() {
        return hint;
    }

    public void setHint(String hint) {
        this.hint = hint;
    }

    public String getRequired() {
        return required;
    }

    public void setRequired(String required) {
        this.required = required;
    }

    public String getSimpleInputType() {
        return simpleInputType;
    }

    public void setSimpleInputType(String simpleInputType) {
        this.simpleInputType = simpleInputType;
    }

    public Map<String, String> getComplextInputType() {
        return complextInputType;
    }

    public void setComplextInputType(Map<String, String> complextInputType) {
        this.complextInputType = complextInputType;
    }

    public void setSimpleVocabulary(String simpleVocabulary) {
        this.simpleVocabulary = simpleVocabulary;
    }

    public String getSimpleVocabulary() {
        return simpleVocabulary;
    }

    public String getHintEdit() {
        return hintEdit;
    }

    public void setHintEdit(String hintEdit) {
        this.hintEdit = hintEdit;
    }

    @Override
    public String toString() {
        return "FieldInputForm{" +
                "schema='" + schema + '\'' +
                ", element='" + element + '\'' +
                ", qualifier='" + qualifier + '\'' +
                ", repeatable='" + repeatable + '\'' +
                ", label='" + label + '\'' +
                ", hint='" + hint + '\'' +
                ", required='" + required + '\'' +
                ", vocabulary='" + simpleVocabulary + '\'' +
                ", simpleInputType='" + simpleInputType + '\'' +
                ", complextInputType=" + complextInputType +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        FieldInputForm that = (FieldInputForm) o;
        return Objects.equals(schema, that.schema) && Objects.equals(element, that.element) && Objects.equals(qualifier, that.qualifier);
    }

    @Override
    public int hashCode() {
        return Objects.hash(schema, element, qualifier);
    }
}
