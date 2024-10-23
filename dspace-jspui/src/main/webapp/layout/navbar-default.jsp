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
        <span class="none">Menu hambuguer</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
    </button>
    <a class="navbar-brand" href="https://ibict.br" target="_blank"><img height="45" src="<%= request.getContextPath() %>/image/logo-ibict.png" alt="Logo IBICT" /></a>

    <a class="navbar-brand logo-miguilim" href="<%= request.getContextPath() %>/"><img height="50px" src="<%= request.getContextPath() %>/image/logo-miguilim.png" alt="logo do projeto miguilim"/></a>
</div>
<nav class="collapse navbar-collapse bs-navbar-collapse" role="navigation">
    <ul class="nav navbar-nav">
        <li class="<%= currentPage.endsWith("/home.jsp")? "active" : "" %>"><a
                href="<%= request.getContextPath() %>/">
                <span class="glyphicon glyphicon-home"><span class="none">Página inicial</span></span>
            </a></li>

        <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown"><fmt:message key="jsp.layout.navbar-default.browse"/> <b class="caret"></b></a>
            <ul class="dropdown-menu">
                <li><a href="<%= request.getContextPath() %>/community-list"><fmt:message key="jsp.layout.navbar-default.communities-collections"/></a></li>
                <li class="divider"></li>
                <li class="dropdown-header"><fmt:message key="jsp.layout.navbar-default.browseitemsby"/></li>
                <%-- Insert the dynamic browse indices here --%>

                <%
                    for (int i = 0; i < bis.length; i++) 
                    {
                        BrowseIndex bix = bis[i];
                        
                        if(!bix.getName().equals("dateissued"))
                        {
                        	String key = "browse.menu." + bix.getName();
                %>
							<li>
								<a href="<%= request.getContextPath() %>/browse?type=<%= bix.getName() %>">
									<fmt:message key="<%= key %>"/>
								</a>
							</li>
                <%
                        }
                    }
                %>

                <%-- End of dynamic browse indices --%>

            </ul>
        </li>

        <!-- Miguilim -->
        <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
            	<fmt:message key="jsp.layout.navbar.miguilim"/> <b class="caret"></b>
            </a>
            <ul class="dropdown-menu">
                <li><a href="<%= request.getContextPath() %>/static/pages/miguilim.jsp"><fmt:message key="jsp.layout.navbar.miguilim.about"/></a></li>
                <li class="divider"></li>
                <li class="<%= currentPage.endsWith("/criterios") ? "active" : "" %>"><a href="<%= request.getContextPath() %>/static/pages/criterios.jsp"><fmt:message key="jsp.layout.navbar.miguilim.criteria"/></a></li>
                <li class="<%= currentPage.endsWith("/criacao-login") ? "active" : "" %>"><a href="<%= request.getContextPath() %>/static/pages/criacao-login.jsp"><fmt:message key="jsp.layout.navbar.miguilim.login"/></a></li>
                <li class="<%= currentPage.endsWith("/como-cadastro") ? "active" : "" %>"><a href="<%= request.getContextPath() %>/static/pages/como-cadastro.jsp"><fmt:message key="jsp.layout.navbar.miguilim.howregister"/></a></li>
                <li class="<%= currentPage.endsWith("/como-atualizar-cadastro") ? "active" : "" %>"><a href="<%= request.getContextPath() %>/static/pages/como-atualizar-cadastro.jsp"><fmt:message key="jsp.layout.navbar.miguilim.howupdateregisgter"/></a></li>
                <li class="<%= currentPage.endsWith("/documentos") ? "active" : "" %>"><a href="<%= request.getContextPath() %>/static/pages/documentos.jsp"><fmt:message key="jsp.layout.navbar.miguilim.docs"/></a></li>
                <li class="<%= currentPage.endsWith("/licenca-de-uso") ? "active" : "" %>"><a href="<%= request.getContextPath() %>/static/pages/licenca-de-uso.jsp"><fmt:message key="jsp.layout.navbar.miguilim.license"/></a></li>
                <li class="<%= currentPage.endsWith("/logomarcas") ? "active" : "" %>"><a href="<%= request.getContextPath() %>/static/pages/logomarcas.jsp"><fmt:message key="jsp.layout.navbar.miguilim.logos"/></a></li>
                <li class="<%= currentPage.endsWith("/padroes-de-metadados") ? "active" : "" %>"><a href="<%= request.getContextPath() %>/static/pages/padroes-de-metadados.jsp"><fmt:message key="jsp.layout.navbar.miguilim.metadata-standards"/></a></li>
                <li class="<%= currentPage.endsWith("/parceria-diadorim") ? "active" : "" %>"><a href="<%= request.getContextPath() %>/static/pages/parceria-diadorim.jsp"><fmt:message key="jsp.layout.navbar.miguilim.diadorim-partnership"/></a></li>
            </ul>
        </li>

        <li class="<%= currentPage.endsWith("/perguntas-frequentes") ? "active" : "" %>"><a href="<%= request.getContextPath() %>/static/pages/perguntas-frequentes.jsp"><fmt:message key="jsp.layout.navbar.miguilim.frequentquestions"/></a></li>
        <li class="<%= currentPage.endsWith("/indicadores") ? "active" : "" %>"><a href="<%= request.getContextPath() %>/static/pages/indicadores.jsp"><fmt:message key="jsp.layout.navbar.miguilim.indicadores"/></a></li>
        <li class="<%= currentPage.endsWith("/feedback") ? "active" : "" %>"><a href="<%= request.getContextPath() %>/feedback"> <fmt:message key="jsp.layout.navbar-default.feedback"/></a></li>

    </ul>

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

<% if (supportedLocales != null && supportedLocales.length > 0) {
    %>
    <div class="translateBtn" >
        <div>        
        <a class="toggle-me" tooltipbtn="traduzir página">
                    <svg version="1.1" xmlns="http://www.w3.org/2000/svg" x="0" y="0" viewBox="0 0 998.1 998.3" xml:space="preserve">
                        <path fill="#DBDBDB" d="M931.7 998.3c36.5 0 66.4-29.4 66.4-65.4V265.8c0-36-29.9-65.4-66.4-65.4H283.6l260.1 797.9h388z"/>
                        <path fill="#DCDCDC" d="M931.7 230.4c9.7 0 18.9 3.8 25.8 10.6 6.8 6.7 10.6 15.5 10.6 24.8v667.1c0 9.3-3.7 18.1-10.6 24.8-6.9 6.8-16.1 10.6-25.8 10.6H565.5L324.9 230.4h606.8m0-30H283.6l260.1 797.9h388c36.5 0 66.4-29.4 66.4-65.4V265.8c0-36-29.9-65.4-66.4-65.4z"/>
                        <polygon fill="#4352B8" points="482.3,809.8 543.7,998.3 714.4,809.8"/>
                        <path fill="#607988" d="M936.1 476.1V437H747.6v-63.2h-61.2V437H566.1v39.1h239.4c-12.8 45.1-41.1 87.7-68.7 120.8-48.9-57.9-49.1-76.7-49.1-76.7h-50.8s2.1 28.2 70.7 108.6c-22.3 22.8-39.2 36.3-39.2 36.3l15.6 48.8s23.6-20.3 53.1-51.6c29.6 32.1 67.8 70.7 117.2 116.7l32.1-32.1c-52.9-48-91.7-86.1-120.2-116.7 38.2-45.2 77-102.1 85.2-154.2H936v.1z"/>
                        <path fill="#4285F4" d="M66.4 0C29.9 0 0 29.9 0 66.5v677c0 36.5 29.9 66.4 66.4 66.4h648.1L454.4 0h-388z"/>
                        <linearGradient id="a" gradientUnits="userSpaceOnUse" x1="534.3" y1="433.2" x2="998.1" y2="433.2">
                          <stop offset="0" stop-color="#fff" stop-opacity=".2"/>
                          <stop offset="1" stop-color="#fff" stop-opacity=".02"/>
                        </linearGradient>
                        <path fill="url(#a)" d="M534.3 200.4h397.4c36.5 0 66.4 29.4 66.4 65.4V666L534.3 200.4z"/>
                        <path fill="#EEEEEE" d="M371.4 430.6c-2.5 30.3-28.4 75.2-91.1 75.2-54.3 0-98.3-44.9-98.3-100.2s44-100.2 98.3-100.2c30.9 0 51.5 13.4 63.3 24.3l41.2-39.6c-27.1-25-62.4-40.6-104.5-40.6-86.1 0-156 69.9-156 156s69.9 156 156 156c90.2 0 149.8-63.3 149.8-152.6 0-12.8-1.6-22.2-3.7-31.8h-146v53.4l91 .1z"/>
                        <radialGradient id="b" cx="65.208" cy="19.366" r="1398.271" gradientUnits="userSpaceOnUse">
                          <stop offset="0" stop-color="#fff" stop-opacity=".1"/>
                          <stop offset="1" stop-color="#fff" stop-opacity="0"/>
                        </radialGradient>
                        <path fill="url(#b)" d="M931.7 200.4H518.8L454.4 0h-388C29.9 0 0 29.9 0 66.5v677c0 36.5 29.9 66.4 66.4 66.4h415.9l61.4 188.4h388c36.5 0 66.4-29.4 66.4-65.4V265.8c0-36-29.9-65.4-66.4-65.4z"/>
                      </svg>
                      
                </a>
            </div>
                <div id="google_translate_element"></div>
    </div>
    <%
        }
    %>
<script type="text/javascript">
    function googleTranslateElementInit() {
        new google.translate.TranslateElement({pageLanguage: 'pt'}, 'google_translate_element');
    }
</script>
<script>
    jQuery('.toggle-me').click( function() {
        jQuery('.translateBtn').toggleClass('active');
    });
</script>
<script async type="text/javascript" src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>

<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-LKZ35LJF8F"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-LKZ35LJF8F');
</script>