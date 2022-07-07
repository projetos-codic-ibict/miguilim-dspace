<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Feedback form JSP
  -
  - Attributes:
  -    feedback.problem  - if present, report that all fields weren't filled out
  -    authenticated.email - email of authenticated user, if any
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    boolean problem = (request.getParameter("feedback.problem") != null);
    String email = request.getParameter("email");

    if (email == null || email.equals(""))
    {
        email = (String) request.getAttribute("authenticated.email");
    }

    if (email == null)
    {
        email = "";
    }

    String feedback = request.getParameter("feedback");
    if (feedback == null)
    {
        feedback = "";
    }

    String fromPage = request.getParameter("fromPage");
    if (fromPage == null)
    {
		fromPage = "";
    }
%>

<dspace:layout titlekey="jsp.feedback.form.title">
    <%-- <h1>Feedback Form</h1> --%>
    <h1><fmt:message key="jsp.feedback.form.title"/></h1>

    <%-- <p>Thanks for taking the time to share your feedback about the
    DSpace system. Your comments are appreciated!</p> --%>

<%
    if (problem)
    {
%>
        <%-- <p><strong>Please fill out all of the information below.</strong></p> --%>

<%
    }
%>
    <form action="<%= request.getContextPath() %>/feedback" method="post">
        <center>
            <table>
                <tr>
                    <td class="submitFormLabel"><label for="tsubject">Assunto:</label></td>
                    <td><input type="text" name="subject" id="tsubject" size="50" value="" /></td>
                </tr>

                <tr>
                    <td class="submitFormLabel"><label for="tfeedback"><fmt:message key="jsp.feedback.form.comment"/></label></td>
                    <td><textarea name="feedback" id="tfeedback" rows="6" cols="50"><%=StringEscapeUtils.escapeHtml(feedback)%></textarea></td>
                </tr>

                <tr>
                    <td class="submitFormLabel"><label for="tname">Nome:</label></td>
                    <td><input type="text" name="subject" id="tname" size="50" value="" /></td>
                </tr>

                <tr>
                    <td class="submitFormLabel"><label for="temail">E-mail:</label></td>
                    <td><input type="text" name="subject" id="temail" size="50" value="" /></td>
                </tr>

                <tr>
                    <td colspan="2" align="center">
                    <input type="submit" name="submit" value="<fmt:message key="jsp.feedback.form.send"/>" />
                    </td>
                </tr>
            </table>
        </center>

        <p>
            Caso prefira, entre em contato com a Equipe Miguilim por meio dos canais: <br/>
            <b>E-mail:</b> miguilim@ibict.br | <b>Telefone:</b> (55 61) 3217-6449
        </p>

    </form>

</dspace:layout>
