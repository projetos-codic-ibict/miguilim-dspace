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
<h2><strong class="titulo-medio">Critérios básicos para cadastro</strong></h2>
		<p id="margem-unica">Para que uma revista seja aceita no Miguilim ela deverá cumprir os seguintes requisitos mínimos:</p>

		<ul>
			<li>Ter registro de ISSN para o suporte eletrônico;</li>
			<li>Ter o Brasil como país de publicação na rede ISSN;</li>  
            <li>Ser eletrônica e estar disponível online;</li>
            <li>Manter conexão permanente e estável com a internet;</li>
            <li>Não ser publicada por uma <a href="https://predatoryjournals.com/publishers/" target="_blank">editora listada como 
            possivelmente predatória</a> no site <a href="https://predatoryjournals.com/" target="_blank">Stop Predatory Journals</a>, não 
            integrar a <a href="https://predatoryjournals.com/journals/" target="_blank">lista de revistas possivelmente predatórias</a> e 
            não apresentar comportamentos predatórios conforme os <a href="https://predatoryjournals.com/about/" target="_blank">
            critérios listados</a> pelo referido site (a avaliação será realizada pela equipe do Miguilim);</li>
            <li>Ser de caráter acadêmico-científico, levando em consideração os seguintes requisitos:</li> 
			<ul>
				<li>Publicar artigos originais e inéditos e que tenham sido previamente submetidos à revisão por pares;</li>
                <li>Ter corpo editorial composto por pesquisadores especialistas na área de atuação da revista.</li>
			</ul>
		</ul>
		
		<p id="margem-unica">O Miguilim também aceita o cadastro de Portais de periódicos, os quais devem ser integrados por revistas científicas que cumpram os requisitos indicados acima.</p>
</div>
</dspace:layout>

