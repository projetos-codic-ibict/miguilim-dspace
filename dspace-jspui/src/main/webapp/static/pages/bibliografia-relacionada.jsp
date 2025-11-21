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

<style>
	.item-bibliografia {
		list-style: none;
		text-indent: -30px;
	}
</style>

<div class="espacamento minus-space breath-element"> 



<h2><strong class="titulo-medio">Bibliografia Relacionada</strong></h2>
	<ul>
		<li class="item-bibliografia">
			AMARO, Bianca. CAMPOS, Fhillipe de Freitas. VILAS BOAS, Raphael Faria. Manuelzão e Miguilim: iniciativas do Ibict para os editores e revistas científicas brasileiras. In: ABEC MEETING, 2022, virtual. Anais […]. São Paulo, SP: ABEC Brasil, 2022. DOI: 10.21452/abecmeeting2022.148
			<br>
			<a src="https://doi.org/10.21452/abecmeeting2022.148">https://doi.org/10.21452/abecmeeting2022.148</a>
			<br><br>
		</li>

		<li class="item-bibliografia">
			ANDRADE, Denise Aparecida Freitas; CAMPOS, Fhillipe de Freitas; SILVA, Janinne Barcelos de Morais; SENA, Priscila Machado Borges. Práticas inovadoras em revistas científicas: estudo exploratório sob a ótica da Ciência Aberta a partir do Diretório Miguilim. Ciência da Informação, Brasília, v. 54, n. 2., 2025. DOI:10.18225/ci.inf.v54i2.7217
			<br>
			<a src="https://doi.org/10.18225/ci.inf.v54i2.7217">https://doi.org/10.18225/ci.inf.v54i2.7217</a>
			<br><br>
		</li>

		<li class="item-bibliografia">
			CAMPOS, Fhillipe de Freitas; ANDRADE, Denise Aparecida Freitas de; AMARO, Bianca; CANTO, Fábio Lorensi do; CARVALHO, Francisco da Costa. Directorio de las revistas científicas electrónicas brasileñas (Miguilim): desarrollo, curaduría, funcionalidades y perspectivas futuras. Revista Interamericana de Bibliotecología, [S. l.], v. 48, n. 2, 2025. DOI: 10.17533/udea.rib.v48n2e357709.
			<br>
			<a src="https://doi.org/10.17533/udea.rib.v48n2e357709">https://doi.org/10.17533/udea.rib.v48n2e357709</a>
			<br><br>
		</li>

		<li class="item-bibliografia">
			CRUZ, Gabriela Garibaldi da. Justiça Informacional como prática de Ciência Aberta: uma análise das revistas científicas do diretório Miguilim. 2025. Dissertação (Programa de Pós-Graduação em Gestão da Informação) - Udesc, Florianópolis, 2025. Disponível em: https://repositorio.udesc.br/handle/UDESC/22724. Acesso em: insira aqui a data de acesso ao material. Ex: 18 fev. 2025.
			<br>
			<a src="https://repositorio.udesc.br/handle/UDESC/22724">https://repositorio.udesc.br/handle/UDESC/22724</a>
			<br><br>
		</li>

		<li class="item-bibliografia">
			MAIA, Maria Aniolly Queiroz;  MARQUES, Clediane de Araújo Guedes; PAIVA, Monica Lima de; ARAÚJO, Rita de Cássia Pereira de; CAMPOS, Fhillipe de Freitas. Portal de Periódicos eletrônicos da UFRN: análise das práticas de Acesso Aberto e de Ciência Aberta a partir do Diretório Miguilim. Ciência da Informação, Brasília, v. 54, n. 2, 2025. DOI: 10.18225/ci.inf.v54i2.7234.
			<br>
			<a src="https://doi.org/10.18225/ci.inf.v54i2.7234">https://doi.org/10.18225/ci.inf.v54i2.7234</a>
			<br><br>
		</li>

		<li class="item-bibliografia">
			SENA, Priscila; CAMPOS, Fhillipe de Freitas; BARCELOS, Janinne; ARAÚJO, Ronaldo Ferreira de; ANDRADE, Denise Aparecida Freitas de. Revistas con sello de prácticas de ciencia abierta en el directorio Miguilim: análisis de su presencia digital. In: ARAÚJO, Ronaldo Ferreira de; ARAÚJO, Kizi Mendonça de (org.). Reflexiones contemporáneas sobre la producción y comunicación de información en ciencia, tecnología e innovación. Brasília: Ibict, 2024. p. 427-443. DOI: 10.22477.9788570132437
			<br>
			<a src="https://omp-editora.prd.ibict.br/index.php/edibict/catalog/book/376">https://omp-editora.prd.ibict.br/index.php/edibict/catalog/book/376</a>
			<br><br>
		</li>
	</ul>
</div>
</dspace:layout>

