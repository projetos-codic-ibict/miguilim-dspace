<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
           prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="java.util.List" %>

<%
    EPerson eperson = (EPerson) request.getAttribute("user");
    List<Item> items = (List<Item>) request.getAttribute("items");
%>

<dspace:layout style="submission" locbar="link"
               parentlink="/mydspace"
               parenttitlekey="jsp.mydspace"
               titlekey="jsp.mydspace">

    <h2>
        <fmt:message key="jsp.mydspace.edition-submissions.title"/></h2>

    <%
        if (items.size() == 0)
        {
    %>
            <p><fmt:message key="jsp.mydspace.edition-submissions.text1"/></p>
    <%
        }
        else
        {
    %>
            <p><fmt:message key="jsp.mydspace.edition-submissions.text2"/></p>
    <%
            if (items.size() == 1)
            {
    %>
                <p><fmt:message key="jsp.mydspace.edition-submissions.text3"/></p>
    <%
            }
            else
            {
    %>
                <p>
                    <fmt:message key="jsp.mydspace.edition-submissions.text4">
                        <fmt:param><%= items.size() %></fmt:param>
                    </fmt:message>
                </p>
    <%
            }
    %>
                <dspace:itemlist items="<%= items %>"/>
    <%
        }
    %>

    <p align="center"><a href="<%= request.getContextPath() %>/mydspace"><fmt:message key="jsp.mydspace.general.backto-mydspace"/></a></p>
</dspace:layout>
