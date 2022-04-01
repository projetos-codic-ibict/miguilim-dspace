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

<div class="espacamento"> 
<h2><strong class="titulo-medio">Miguilim</strong></h2>

    <p>O Diretório das revistas científicas eletrônicas brasileiras - Miguilim é uma iniciativa do <a href="http://www.ibict.br/" target="_blank"> Instituto Brasileiro de Informação
        em Ciência e Tecnologia (Ibict)</a> criada com o intuito de agregar, em um único local, informações sobre as revistas científicas editadas e publicadas no Brasil que se encontravam dispersas em diferentes
    plataformas. O diretório reúne em sua base de dados o cadastro de informações essenciais das políticas editoriais  de milhares de revistas científicas brasileiras e tem
    como objetivos básicos: </p>
	
    <ol>
        <li>Facilitar o acesso ao conjunto das revistas científicas editadas e publicadas no Brasil;</li>
        <li>Promover a disseminação e a visibilidade das revistas científicas brasileiras com intuito de aumentar o impacto da sua produção no cenário internacional;</li>
        <li>Explicitar aspectos da política editorial com vistas a transparência dos processos editoriais empreendidos pelas revistas, assim como instruir os editores a respeito das possibilidades das práticas editoriais a seguir;</li>
        <li>Por meio dos dados informados pelas revistas busca promover, também, a transparência necessária à avaliação dessas revistas;</li>
        <li>Instruir os editores em relação aos critérios de avaliação requeridos por grandes indexadores e bases de dados que disseminam e atribuem credibilidade às revistas;</li>
        <li>Incentivar pesquisas no âmbito da Comunicação Científica e da Ciência da Informação sobre os mais variados temas que possam ser extraídos dos dados disponíveis no Miguilim e, de maneira especial, sobre a qualidade editorial das revistas brasileiras;</li>
        <li>Servir como porta de entrada para outros produtos do Ibict que fazem o cadastro de revistas científicas como Diadorim, OasisBr, Latindex  e EmeRI;</li>
        <li>Dar acesso aos dados das revistas brasileiras a bases de dados, repositórios diversos e outros diretórios de revistas nacionais ou internacionais;</li>
        <li>Evitar o retrabalho dos editores responsáveis no preenchimento dos dados das revistas em diversas instâncias e promover a padronização e a consistência desses dados nas diversas plataformas;</li>
        <li>Incentivar ações práticas relacionadas aos movimentos de Ciência Aberta e Acesso Aberto à informação científica.</li>
    </ol>  

    <p>Em última análise, o Miguilim busca o aumento da qualidade editorial das revistas científicas brasileiras, a internacionalização da Ciência brasileira e a democratização do acesso ao conhecimento científico.</p>
	
</div>
</dspace:layout>

