<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Home page JSP
  -
  - Attributes:
  -    communities - Community[] all communities in DSpace
  -    recent.submissions - RecetSubmissions
  --%>

<%@page import="org.dspace.core.factory.CoreServiceFactory"%>
<%@page import="org.dspace.core.service.NewsService"%>
<%@page import="org.dspace.content.service.CommunityService"%>
<%@page import="org.dspace.content.factory.ContentServiceFactory"%>
<%@page import="org.dspace.content.service.ItemService"%>
<%@page import="org.dspace.core.Utils"%>
<%@page import="org.dspace.content.Bitstream"%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.util.Locale"%>
<%@ page import="java.util.List"%>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.app.webui.components.RecentSubmissions" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.browse.ItemCounter" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.services.ConfigurationService" %>
<%@ page import="org.dspace.services.factory.DSpaceServicesFactory" %>

<c:set var="dspace.layout.head.last" scope="request">
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/FileSaver.min.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/jszip.min.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/logos-download.js"></script>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/logos.css" type="text/css" />
</c:set>

<%
    List<Community> communities = (List<Community>) request.getAttribute("communities");

    Locale sessionLocale = UIUtil.getSessionLocale(request);
    Config.set(request.getSession(), Config.FMT_LOCALE, sessionLocale);
	
    NewsService newsService = CoreServiceFactory.getInstance().getNewsService();
 /* String topNews = newsService.readNewsFile(LocaleSupport.getLocalizedMessage(pageContext, "news-top.html")); */
 /* String sideNews = newsService.readNewsFile(LocaleSupport.getLocalizedMessage(pageContext, "news-side.html")); */

    ConfigurationService configurationService = DSpaceServicesFactory.getInstance().getConfigurationService();
    
    boolean feedEnabled = configurationService.getBooleanProperty("webui.feed.enable");
    String feedData = "NONE";
    if (feedEnabled)
    {
        // FeedData is expected to be a comma separated list
        String[] formats = configurationService.getArrayProperty("webui.feed.formats");
        String allFormats = StringUtils.join(formats, ",");
        feedData = "ALL:" + allFormats;
    }
    
    ItemCounter ic = new ItemCounter(UIUtil.obtainContext(request));

    RecentSubmissions submissions = (RecentSubmissions) request.getAttribute("recent.submissions");
    ItemService itemService = ContentServiceFactory.getInstance().getItemService();
    CommunityService communityService = ContentServiceFactory.getInstance().getCommunityService();
%>

<dspace:layout locbar="nolink" titlekey="jsp.home.title" feedData="<%= feedData %>">

<div class="espacamento minus-space">
<h2><strong class="titulo-medio">Logomarcas</strong></h2>
    <section class="logos-section">
        <div class="principal">
            <div class="description">
                <img class="logo-image" src="<%= request.getContextPath() %>/image/logomarcas/miguilim-color-transparente.png" alt="Logotipo oficial do Miguilim">
                <p class="logo-description principal">Logotipo oficial do Miguilim, que pode ser utilizado por todas as revistas devidamente cadastradas no Diretório</p>
                <a href="<%= request.getContextPath() %>/image/logomarcas/miguilim-color-transparente.png" download title="Baixar logotipo oficial do Miguilim" class="download-icon">
                    <span class="glyphicon glyphicon-download-alt" />
                </a>
            </div>
        </div>
        <div class="secundario">
            <h4 class="title-logo">A critério de cada revista, pode também ser utilizado o logotipo em que consta o selo que foi atribuído à revista no Diretório</h4>

            <div class="descriptions-container">
                <div class="description">
                    <img class="logo-image" src="<%= request.getContextPath() %>/image/logomarcas/miguilim-praticasca.png" alt="Logotipo do Miguilim com selo de práticas para ciências abertas">
                    <p class="logo-description">Miguilim com o selo "Práticas de Ciência Aberta"</p>
                    <a href="<%= request.getContextPath() %>/image/logomarcas/miguilim-praticasca.png" download title="Baixar logotipo do Miguilim com selo de práticas para ciências abertas" class="download-icon">
                        <span class="glyphicon glyphicon-download-alt" />
                    </a>
                </div>

                <div class="description">
                    <img class="logo-image" src="<%= request.getContextPath() %>/image/logomarcas/miguilim-diamante.png" alt="Logotipo do Miguilim com selo diamante">
                    <p class="logo-description">Miguilim com o selo "Revista diamante"</p>
                    <a href="<%= request.getContextPath() %>/image/logomarcas/miguilim-diamante.png" download title="Baixar logotipo do Miguilim com selo diamante" class="download-icon">
                        <span class="glyphicon glyphicon-download-alt" />
                    </a>
                </div>

                <div class="description">
                    <img class="logo-image" src="<%= request.getContextPath() %>/image/logomarcas/miguilim-diamante-praticasca.png" alt="Logotipo do Miguilim com selo de práticas para ciências abertas e selo diamante">
                    <p class="logo-description">Miguilim com os selos "Práticas de Ciência Aberta" e "Revista diamante"</p>
                    <a href="<%= request.getContextPath() %>/image/logomarcas/miguilim-diamante-praticasca.png" download title="Baixar logotipo do Miguilim com selo de práticas para ciências abertas e selo diamante" class="download-icon">
                        <span class="glyphicon glyphicon-download-alt" />
                    </a>
                </div>
            </div>

            <h4 class="title-logo">Outras opções de logotipos também estão disponíveis para uso das revistas:</h4>

            <div class="descriptions-container">
                <div class="description">
                    <img class="logo-image" src="<%= request.getContextPath() %>/image/logomarcas/miguilim-preto-transparent.png" alt="Logotipo do Miguilim (preto com fundo transparente)">
                    <p class="logo-description">Preta com fundo transparente</p>
                    <a href="<%= request.getContextPath() %>/image/logomarcas/miguilim-preto-transparent.png" download title="Baixar logotipo do Miguilim (preto com fundo transparente)" class="download-icon">
                        <span class="glyphicon glyphicon-download-alt" />
                    </a>
                </div>

                <div class="description">
                    <img class="logo-image" src="<%= request.getContextPath() %>/image/logomarcas/miguilim-preto-branco.png" alt="Logotipo do Miguilim (preto com fundo branco)">
                    <p class="logo-description">Preta com o fundo branco</p>
                    <a href="<%= request.getContextPath() %>/image/logomarcas/miguilim-preto-branco.png" download title="Baixar logotipo do Miguilim (preto com fundo branco)" class="download-icon">
                        <span class="glyphicon glyphicon-download-alt" />
                    </a>
                </div>

                <div class="description">
                    <img class="logo-image" src="<%= request.getContextPath() %>/image/logomarcas/miguilim-color-branco.png" alt="Logotipo do Miguilim (com fundo branco)">
                    <p class="logo-description">Colorida com o fundo branco</p>
                    <a href="<%= request.getContextPath() %>/image/logomarcas/miguilim-color-branco.png" download title="Baixar logotipo do Miguilim (com fundo branco)" class="download-icon">
                        <span class="glyphicon glyphicon-download-alt" />
                    </a>
                </div>

                <div class="description">
                    <img class="logo-image" src="<%= request.getContextPath() %>/image/logomarcas/miguilim-branco-transparent.png" alt="Logotipo do Miguilim (branco com fundo transparente)">
                    <p class="logo-description">Branca com fundo transparente</p>
                    <a href="<%= request.getContextPath() %>/image/logomarcas/miguilim-branco-transparent.png" download title="Baixar logotipo do Miguilim (branco com fundo transparente)" class="download-icon">
                        <span class="glyphicon glyphicon-download-alt" />
                    </a>
                </div>

                <div class="description">
                    <img class="logo-image" src="<%= request.getContextPath() %>/image/logomarcas/miguilim-branco-preto.png" alt="Logotipo do Miguilim (branco com fundo preto)">
                    <p class="logo-description">Branca com fundo preto</p>
                    <a href="<%= request.getContextPath() %>/image/logomarcas/miguilim-branco-preto.png" download title="Baixar logotipo do Miguilim (branco com fundo preto)" class="download-icon">
                        <span class="glyphicon glyphicon-download-alt" />
                    </a>
                </div>
            </div>
        </div>
    </section>

    <button class="btn-download-all" id="btn-download-all" title="Baixar todas as logotipos">Baixar tudo</button>
</div>
</dspace:layout>

