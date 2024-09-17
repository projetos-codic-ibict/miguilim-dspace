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
    <h2><strong class="titulo-medio">Conheça os padrões de metadados do Miguilim</strong></h2>
    <p>
        O Miguilim possui uma coleção para revistas científicas e outra para os portais de revistas.
        <br><br>
        Conheça abaixo os padrões de metadados para cada uma das coleções
    </p>

    <h2><strong class="titulo-medio">Revistas científicas</strong></h2>
    <p>
        O Padrão de metadados do Diretório das revistas científicas eletrônicas brasileiras (MRC-BR) foi desenvolvido com o objetivo de traçar um perfil abrangente das revistas científicas eletrônicas no Brasil.
        <br><br>
        A sigla MRC refere-se à “Metadados para revistas científicas”, enquanto o sufixo “BR” designa referir-se às revistas brasileiras.
        <br><br>
        Além das informações básicas sobre as revistas, como título, instituição editora, editor responsável e tipo de acesso, o MRC-BR visa aprofundar o conhecimento sobre as práticas de Acesso Aberto e Ciência Aberta adotadas pelas revistas.
        <br><br>
        Para atingir esses objetivos, foram considerados diversos serviços de informação sobre revistas científicas, incluindo o <a href="https://doaj.org/">Directory of Open Access Journals (DOAJ)</a>, o <a href="https://www.redalyc.org/home.oa">Sistema de Información Científica Redalyc</a> e a <a href="https://www.scielo.br/">Scientific Electronic Library Online (SciELO Brasil)</a>.
    </p>

    <a href="<%= request.getContextPath()%>/static/pages/MRC-BR-VERSAO-1.pdf" target="_blank" title="Padrão MRC-BR versão 1">» MRC-BR-VERSAO-1</a>

    <h2><strong class="titulo-medio">Portais de revistas</strong></h2>
    <p>
        O Padrão de metadados para descrição de portais de revistas (MPR-BR) foi desenvolvido com o ajudar de reunir informações básicas sobre os portais brasileiros de revistas científicas.
        <br><br>
        A sigla MPR refere-se à “Metadados para portais de revistas”, enquanto o sufixo “BR” designa referir-se aos portais brasileiros.
        <br><br>
        O MPR-BR também foi pensado para compilar a relação de revistas que compõe cada portal.
    </p>

    <a href="<%= request.getContextPath()%>/static/pages/MPR-BR-VERSAO-1.pdf" target="_blank" title="Padrão MPR-BR versão 1">» MPR-BR-VERSAO-1</a>
	<br><br>
</div>
</dspace:layout>

