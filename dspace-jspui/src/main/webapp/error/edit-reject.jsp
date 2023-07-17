<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<dspace:layout style="submission" locbar="link"
               parentlink="/mydspace"
               parenttitlekey="jsp.mydspace"
               titlekey="jsp.error.edit.title">

	<h1>
		<fmt:message key="jsp.error.edit.title"/>
	</h1>

	<p class="alert alert-danger"><fmt:message key="jsp.error.edit.text1"/></p> 
 	<br/>

    <p align="center">
    	<a href="<%= request.getContextPath() %>/mydspace">
    		<fmt:message key="jsp.mydspace.general.returnto-mydspace"/>
    	</a>
    </p>
 
</dspace:layout>
