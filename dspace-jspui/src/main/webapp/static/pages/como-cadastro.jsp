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
<h2><strong class="titulo-medio">Como fazer um cadastro?</strong></h2>

	<p>Antes de iniciar o cadastro de uma revista científica ou de um Portal de periódicos deve-se verificar se estes já não possuem
    um cadastro no Miguilim. Para isso, o responsável deve usar a barra de busca da página inicial do Diretório e pesquisar por 
    título, instituição responsável ou número de ISSN. Também é possível verificar todos os registros do Diretório por meio da aba
    “Navegar” > “Comunidades e coleções”. Aconselha-se que esta verificação seja feita mesmo para a revista científica ou para o 
    Portal de periódicos que os responsáveis não tenham feito o cadastro no Miguilim, pois vários itens foram pré-cadastrados pela 
    equipe do Diretório. Caso localize o registro da revista científica ou do Portal de periódicos que desejava cadastrar, não 
    realize um novo registro. Neste caso, deve ser feita a <a href="http://200.130.45.73:8080/jspui/como-atualizar-cadastro.jsp" target="_blank">atualização do cadastro</a> existente.</p>
    
    <p>Assegurando-se que a revista científica ou o Portal de periódicos não se encontram previamente cadastrados no Miguilim, 
    basta fazer o login pela aba “Entrar em” e clicar no botão “Iniciar um novo depósito” <a href="http://200.130.45.73:8080/jspui/criacao-login.jsp" target="_blank">(Veja como criar um login aqui)</a>. Em seguida
    deve-se escolher uma das duas coleções do Miguilim, “Revistas” ou “Portais de periódicos”. Escolhida a coleção o usuário terá
    acesso ao formulário de cadastro, momento em que ele deve iniciar a descrição do registro por meio do preenchimento dos campos de
    acordo com as instruções indicadas. Após o preenchimento dos campos, o cadastro ficará pendente de aceite por parte da equipe 
    gestora do Miguilim, cabendo a ela a verificação dos dados e posterior aprovação. Assim que a equipe gestora realizar o aceite do cadastro, 
    um e-mail com o link do registro finalizado será encaminhado ao responsável.</p>
	
	
</div>
</dspace:layout>

