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
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/documentos.css" type="text/css" />
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

<div class="espacamento minus-space breath-element">

    <h2 class="titulo-medio">Documentos úteis</h2>
    <div class="document-container">
        <a class="document-preview-image-link" href='<%= request.getContextPath()%>/static/pages/Documento-de-apoio.pdf' target="_blank">
            <img class="document-preview-image" src="<%= request.getContextPath() %>/image/documentos/Documento-de-apoio.png">
        </a>
        <a href='<%= request.getContextPath()%>/static/pages/Documento-de-apoio.pdf' target="_blank">» Documento de apoio ao Miguilim</a>
    </div>
    <div class="document-container">
        <a class="document-preview-image-link" href='<%= request.getContextPath()%>/static/pages/Cadastro_de_revistas_e_portais.pdf' target="_blank">
            <img class="document-preview-image" src="<%= request.getContextPath() %>/image/documentos/Cadastro_de_revistas_e_portais.png">
        </a>
        <a href='<%= request.getContextPath()%>/static/pages/Cadastro_de_revistas_e_portais.pdf' target="_blank">» Cadastro de revistas científicas e portais de revistas</a><br/>
    </div>
    <div class="document-container">
        <a class="document-preview-image-link" href='<%= request.getContextPath()%>/static/pages/Criar_login_no_Miguilim.pdf' target="_blank">
            <img class="document-preview-image" src="<%= request.getContextPath() %>/image/documentos/Criar_login_no_Miguilim.png">
        </a>
        <a href='<%= request.getContextPath()%>/static/pages/Criar_login_no_Miguilim.pdf' target="_blank">» Criar login no Miguilim</a><br/>
    </div>
    <div class="document-container">
        <a class="document-preview-image-link" href='<%= request.getContextPath()%>/static/pages/Etapas_para_solicitar_permissao.pdf' target="_blank">
            <img class="document-preview-image" src="<%= request.getContextPath() %>/image/documentos/Etapas_para_solicitar_permissao.png">
        </a>
        <a href='<%= request.getContextPath()%>/static/pages/Etapas_para_solicitar_permissao.pdf' target="_blank">» Etapas para solicitar permissão de edição de registro</a><br/>
    </div>
    <div class="document-container">
        <a class="document-preview-image-link" href='<%= request.getContextPath()%>/static/pages/Quem_pode_atualizar.pdf' target="_blank">
            <img class="document-preview-image" src="<%= request.getContextPath() %>/image/documentos/Quem_pode_atualizar.png">
        </a>
        <a href='<%= request.getContextPath()%>/static/pages/Quem_pode_atualizar.pdf' target="_blank">» Quem pode atualizar registros no Miguilim</a><br/>
    </div>

    
</div>
</dspace:layout>

