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
<h2><strong class="titulo-medio">Miguilim</strong></h2>

    <p>O Diretório das revistas científicas eletrônicas brasileiras (Miguilim) é uma iniciativa do <a class="link-color" href="http://www.ibict.br/" title="link do IBICT" target="_blank"> Instituto Brasileiro de Informação
        em Ciência e Tecnologia (Ibict)</a> criada com o intuito de agregar, em um único local, informações sobre as revistas científicas editadas e publicadas no Brasil que se encontravam dispersas em diferentes
    plataformas. O Diretório reúne em sua base de dados o cadastro de informações essenciais das políticas editoriais de milhares de revistas científicas brasileiras e tem
    como objetivos básicos: </p>
	
    </ol>
        <li>Facilitar o acesso ao conjunto das revistas científicas editadas e publicadas no Brasil;</li>
        <li>Dar visibilidade às revistas científicas brasileiras com intuito de aumentar o impacto da sua produção no cenário internacional;</li>
        <li>Explicitar aspectos da política editorial com vistas a transparência dos processos editoriais empreendidos pelas revistas;</li>
        <li>Disseminar boas práticas editoriais aos editores científicos;</li>
        <li>Promover a transparência necessária à avaliação da qualidade editorial das revistas;</li>
        <li>Instruir editores científicos em relação aos critérios de avaliação requeridos por serviços de informação científica, nacionais e internacionais;</li>
        <li>Incentivar pesquisas no âmbito da Comunicação Científica e da Ciência da informação sobre os mais variados temas que possam ser extraídos dos dados disponíveis no Miguilim;</li>
        <li>Servir como porta de entrada para outros produtos do Ibict que fazem o cadastro de revistas científicas, como Diadorim, Oasisbr, Latindex  e Emeri;</li>
        <li>Evitar o retrabalho dos editores responsáveis no preenchimento dos dados das revistas em diversas instâncias e promover a padronização e a consistência desses dados nas diversas plataformas;</li>
	<li>Fomentar ações práticas relacionadas aos Movimentos de Ciência Aberta e de Acesso Aberto à informação científica.</li>
    </ol>
<br>
    <p>Em última análise, o Miguilim busca o aumento da qualidade editorial das revistas científicas brasileiras, a internacionalização da Ciência brasileira e a democratização do acesso ao conhecimento científico. </p>

        <div class="content-brand">
            <div class="col-logo">
                <a href='<%= request.getContextPath()%>/image/logo-texto.png' download>
                <div class="content-logo">                   
                        <img alt="Logo do projeto miguilim com descrição" src='<%= request.getContextPath()%>/image/logo-texto.png'>                                        
                </div>
                <div class="text">
                    <small>Tamanho: 110 KB</small>
                    <small>Faça download</small>
                </div>
                </a>
            </div>
            <div class="col-logo">
                <a href='<%= request.getContextPath()%>/image/logo.png' download>
                <div class="content-logo">
                    <img alt="Logo do projeto miguilim sem descrição" src='<%= request.getContextPath()%>/image/logo.png'>                   
                </div>
                <div class="text">
                    <small>Tamanho: 63 KB</small>
                    <small>Faça download</small>
                </div>

                </a>
            </div>
        </div>
</div>
</dspace:layout>

