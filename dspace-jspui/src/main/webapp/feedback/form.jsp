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

<div class="feedback-form">
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
    <form action="<%= request.getContextPath() %>/feedback" action="simple-search" method="post">
                <div>
                    <label for="tsubject">Assunto:</label>
                    <input type="text" class="feedback-field" name="feedsubject" id="tsubject" size="50" value="" />
                </div>

                <div>
                    <label for="tfeedback"><fmt:message key="jsp.feedback.form.comment"/></label>
                    <textarea name="feedback" class="feedback-textarea" id="tfeedback" rows="6" cols="50"><%=StringEscapeUtils.escapeHtml(feedback)%></textarea>
                </div>

                <div>
                    <label for="tname">Nome:</label>
                    <input type="text" class="feedback-field"  name="feedname" id="tname" size="50" value="" />
                </div>

                <div>
                    <label for="temail">E-mail:</label>
                    <input type="text" class="feedback-field"  name="email" id="temail" size="50" value="" />
                </div>

                <div>
                    <input type="submit" name="submit" class="button-main-outline" value="<fmt:message key="jsp.feedback.form.send"/>" />
                </div>

        <p>
            <small> prefira, entre em contato com a Equipe Miguilim por meio dos canais: </small>
            <strong>E-mail:</strong> miguilim@ibict.br | <strong>Telefone:</strong> (55 61) 3217-6449
        </p>
    </form>
</div>

</dspace:layout>
