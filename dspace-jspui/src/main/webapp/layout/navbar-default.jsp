<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Default navigation bar
--%>

<%@page import="org.apache.commons.lang.StringUtils" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="/WEB-INF/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.browse.BrowseIndex" %>
<%@ page import="org.dspace.browse.BrowseInfo" %>
<%@ page import="java.util.Map" %>
<%
    // Is anyone logged in?
    EPerson user = (EPerson) request.getAttribute("dspace.current.user");

    // Is the logged in user an admin
    Boolean admin = (Boolean) request.getAttribute("is.admin");
    boolean isAdmin = (admin == null ? false : admin.booleanValue());

    Boolean communityAdmin = (Boolean) request.getAttribute("is.communityAdmin");
    boolean isCommunityAdmin = (communityAdmin == null ? false : communityAdmin.booleanValue());

    Boolean collectionAdmin = (Boolean) request.getAttribute("is.collectionAdmin");
    boolean isCollectionAdmin = (collectionAdmin == null ? false : collectionAdmin.booleanValue());

    // Get the current page, minus query string
    String currentPage = UIUtil.getOriginalURL(request);
    int c = currentPage.indexOf('?');
    if (c > -1) {
        currentPage = currentPage.substring(0, c);
    }

    // E-mail may have to be truncated
    String navbarEmail = null;

    if (user != null) {
        navbarEmail = user.getEmail();
    }

    // get the browse indices

    BrowseIndex[] bis = BrowseIndex.getBrowseIndices();
    BrowseInfo binfo = (BrowseInfo) request.getAttribute("browse.info");
    String browseCurrent = "";
    if (binfo != null) {
        BrowseIndex bix = binfo.getBrowseIndex();
        // Only highlight the current browse, only if it is a metadata index,
        // or the selected sort option is the default for the index
        if (bix.isMetadataIndex() || bix.getSortOption() == binfo.getSortOption()) {
            if (bix.getName() != null)
                browseCurrent = bix.getName();
        }
    }
    // get the locale languages
    Locale[] supportedLocales = I18nUtil.getSupportedLocales();
    Locale sessionLocale = UIUtil.getSessionLocale(request);
%>


<div class="navbar-header">
    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
    </button>
    <a class="navbar-brand" href="<%= request.getContextPath() %>/"><img height="45"
                                                                         src="<%= request.getContextPath() %>/image/logo-ibict.png"
                                                                         alt="Logo IBICT"/></a>
</div>
<nav class="collapse navbar-collapse bs-navbar-collapse" role="navigation">
    <ul class="nav navbar-nav">
        <li class="<%= currentPage.endsWith("/home.jsp")? "active" : "" %>"><a
                href="<%= request.getContextPath() %>/"><fmt:message
                key="jsp.layout.navbar-default.home"/></a></li>

        <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown"><fmt:message
                    key="jsp.layout.navbar-default.browse"/> <b class="caret"></b></a>
            <ul class="dropdown-menu">
                <li><a href="<%= request.getContextPath() %>/community-list"><fmt:message
                        key="jsp.layout.navbar-default.communities-collections"/></a></li>
                <li class="divider"></li>
                <li class="dropdown-header"><fmt:message key="jsp.layout.navbar-default.browseitemsby"/></li>
                <%-- Insert the dynamic browse indices here --%>

                <%
                    for (int i = 0; i < bis.length; i++) {
                        BrowseIndex bix = bis[i];
                        String key = "browse.menu." + bix.getName();
                %>
                <li><a href="<%= request.getContextPath() %>/browse?type=<%= bix.getName() %>"><fmt:message
                        key="<%= key %>"/></a></li>
                <%
                    }
                %>

                <%-- End of dynamic browse indices --%>

            </ul>
        </li>

        <!-- Miguilim -->
        <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown"><fmt:message
                    key="jsp.layout.navbar.miguilim"/> <b class="caret"></b></a>
            <ul class="dropdown-menu">
                <li><a href="<%= request.getContextPath() %>/static/pages/miguilim.jsp"><fmt:message key="jsp.layout.navbar.miguilim.about"/></a></li>
                <li class="divider"></li>
                <li class="<%= currentPage.endsWith("/criterios")? "active" : "" %>"><a href="<%= request.getContextPath() %>/static/pages/criterios.jsp"><fmt:message key="jsp.layout.navbar.miguilim.criteria"/></a></li>
                <li class="<%= currentPage.endsWith("/criacao-login")? "active" : "" %>"><a href="<%= request.getContextPath() %>/static/pages/criacao-login.jsp"><fmt:message key="jsp.layout.navbar.miguilim.login"/></a></li>
                <li class="<%= currentPage.endsWith("/como-cadastro")? "active" : "" %>"><a href="<%= request.getContextPath() %>/static/pages/como-cadastro.jsp"><fmt:message key="jsp.layout.navbar.miguilim.howregister"/></a></li>
                <li class="<%= currentPage.endsWith("/como-atualizar-cadastro")? "active" : "" %>"><a href="<%= request.getContextPath() %>/static/pages/como-atualizar-cadastro.jsp"><fmt:message key="jsp.layout.navbar.miguilim.howupdateregisgter"/></a></li>
                <li class="<%= currentPage.endsWith("/documentos")? "active" : "" %>"><a href="<%= request.getContextPath() %>/static/pages/documentos.jsp"><fmt:message key="jsp.layout.navbar.miguilim.docs"/></a></li>

                <%-- End of dynamic browse indices --%>

            </ul>
        </li>

        <li class="<%= currentPage.endsWith("/perguntas-frequentes")? "active" : "" %>"><a href="<%= request.getContextPath() %>/static/pages/perguntas-frequentes.jsp"><fmt:message key="jsp.layout.navbar.miguilim.frequentquestions"/></a></li>
        <li class="<%= currentPage.endsWith("/feedback")? "active" : "" %>"><a href="<%= request.getContextPath() %>/feedback"> <fmt:message key="jsp.layout.navbar-default.feedback"/></a></li>

    </ul>


    <% if (supportedLocales != null && supportedLocales.length > 1) {
    %>
    <div class="nav navbar-nav navbar-right">
        <ul class="nav navbar-nav navbar-right">
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown"><fmt:message
                        key="jsp.layout.navbar-default.language"/><b class="caret"></b></a>
                <ul class="dropdown-menu">
                    <%
                        for (int i = supportedLocales.length - 1; i >= 0; i--) {
                    %>
                    <li>
                        <a
                           href="<%= currentPage %>?locale=<%=supportedLocales[i].toString()%>">
                            <%= supportedLocales[i].getDisplayLanguage(supportedLocales[i])%>
                        </a>
                    </li>
                    <%
                        }
                    %>
                </ul>
            </li>
        </ul>
    </div>
    <%
        }
    %>

    <div class="nav navbar-nav navbar-right">
        <ul class="nav navbar-nav navbar-right">
            <li class="dropdown">
                <%
                    if (user != null) {
                %>
                <a href="#" class="dropdown-toggle" data-toggle="dropdown"><span
                        class="glyphicon glyphicon-user"></span> <fmt:message key="jsp.layout.navbar-default.loggedin">
                    <fmt:param><%= StringUtils.abbreviate(navbarEmail, 20) %>
                    </fmt:param>
                </fmt:message> <b class="caret"></b></a>
                <%
                } else {
                %>
                <a href="#" class="dropdown-toggle" data-toggle="dropdown"><span
                        class="glyphicon glyphicon-user"></span> <fmt:message key="jsp.layout.navbar-default.sign"/> <b
                        class="caret"></b></a>
                <% } %>
                <ul class="dropdown-menu">
                    <li><a href="<%= request.getContextPath() %>/mydspace"><fmt:message
                            key="jsp.layout.navbar-default.users"/></a></li>
                    <li><a href="<%= request.getContextPath() %>/subscribe"><fmt:message
                            key="jsp.layout.navbar-default.receive"/></a></li>
                    <li><a href="<%= request.getContextPath() %>/profile"><fmt:message
                            key="jsp.layout.navbar-default.edit"/></a></li>

                    <%
                        if (isAdmin || isCommunityAdmin || isCollectionAdmin) {
                    %>
                    <li class="divider"></li>
                    <% if (isAdmin) {%>

                    <li><a href="<%= request.getContextPath()%>/dspace-admin">
                            <% } else if (isCommunityAdmin || isCollectionAdmin) {%>

                    <li><a href="<%= request.getContextPath()%>/tools">
                        <% } %>
                        <fmt:message key="jsp.administer"/></a></li>
                    <%
                        }
                        if (user != null) {
                    %>
                    <li><a href="<%= request.getContextPath() %>/logout"><span
                            class="glyphicon glyphicon-log-out"></span> <fmt:message
                            key="jsp.layout.navbar-default.logout"/></a></li>
                    <% } %>
                </ul>
            </li>
        </ul>

    </div>
</nav>
