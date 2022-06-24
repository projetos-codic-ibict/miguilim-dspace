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
    <h2><strong class="titulo-medio">Criação de login</strong></h2>
    <p id="margem-unica">O primeiro passo para fazer parte do Miguilim é a criação do login da Revista científica ou do Portal de 
    revistas que queira cadastrar. Aconselha-se que o e-mail utilizado para a criação do login seja o e-mail institucional da
    revista científica ou do portal de revistas. Deve-se evitar o uso de e-mails pessoais dos gestores, tendo em vista que a 
    mudança dos responsáveis pode acarretar a perda do acesso.</p>

    <p id="margem-unica">Para a criação do login, o responsável deve clicar em “Login”, depois em "Meu espaço" e, por fim, em
    “Usuário novo? Clique aqui para se registrar”. Seguidos esses passos, informe o e-mail institucional no campo “Endereço de e-mail” 
    e clique em “Registrar”. Ao efetuar estes passos, o responsável receberá um e-mail com um link para que faça o registro das informações e 
    crie uma senha para o cadastro. Feito isso, o responsável deverá clicar em “Complete o registro”. A partir de então o login 
    terá sido criado, o que permite acesso interno ao Miguilim por meio da aba “Login”, onde os cadastros de revistas científicas e portais
    de revistas podem ser realizados.</p>

    <h2><strong class="titulo-medio">Login no diretório </strong></h2>

    <p id="margem-unica">Para fazer login no Miguilim o usuário deve dirigir-se ao canto superior direito da tela, clicar em “Login” >
    “Meu espaço” e fazer login no Diretório com os dados de e-mail e senha. Feito isso o usuário irá se deparar com o ambiente 
    de trabalho interno do Miguilim.</p>
	
    <p id="margem-unica">Caso o usuário tenha esquecido sua senha basta clicar na aba "Login" > "Esqueceu sua senha?" e indicar o e-mail
    cadastrado no Miguilim. Em seguida um link será enviado para o e-mail cadastrado. Ao clicar no link, o usuário poderá configurar uma
    nova senha para continuar usando o Miguilim.</p>
		
</div>
</dspace:layout>

