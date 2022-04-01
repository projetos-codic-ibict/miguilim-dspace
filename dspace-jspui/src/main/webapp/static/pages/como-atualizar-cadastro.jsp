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
    <h2><strong class="titulo-medio">Como atualizar um cadastro?</strong></h2>

    <p>Para atualizar o cadastro de uma revista científica é necessário que o usuário  tenha o acesso autorizado para realizar tal 
    ação. As revistas que foram cadastradas pelos próprios responsáveis já possuem essa autorização. Para verificar se possui 
    autorização para atualizar a revista, faça o Login no diretório, entre em “Meu espaço” e clique na aba “Ver depósito(s) aceito(s)”.
    As revistas listadas nessa seção estão vinculadas a esse login e podem ser atualizadas. As revistas que foram pré-cadastradas no
    Miguilim pela equipe administradora do diretório precisam solicitar a autorização para a atualização. Segue abaixo o informativo de
    como atualizar os dados da revista em cada situação.</p>

    <h2><strong class="titulo-medio">Revistas pré-cadastradas (Não possuem login vinculado)</strong></h2>
    
    <p>Caso o usuário localize um registro de revista de sua responsabilidade já registrada no Miguilim e deseje fazer alterações no
    mesmo, ele deve primeiramente solicitar permissão para a atualização do registro. Para esta solicitação, o usuário deve acessar a
    página do registro da revista e clicar na aba "Solicitar edição da revista". Ao clicar nessa aba o usuário terá acesso ao “Formulário 
    de solicitação de edição de revista no Miguilim” e deverá preencher os campos de acordo com as instruções indicadas e clicar em “Enviar”. 
    Os dados informados serão verificados pela Equipe Miguilim no site da revista, que concederá ou não as permissões de atualização. 
    Assim sendo, as informações fornecidas no formulário deverão ser as mesmas constantes no site da revista, caso contrário não será possível 
    conceder as autorizações. O endereço de e-mail informado deverá ser o mesmo utilizado para realizar o login no Miguilim, já que a permissão 
    vai ser dada para este login <a href="http://200.130.45.73:8080/jspui/criacao-login.jsp" target="_blank">(Veja como criar um login aqui)</a>.</p>

    <p>Assim que o formulário for enviado a Equipe Miguilim será notificada e irá proceder com os ajustes para a concessão das permissões de atualização. Em seguida a Equipe
    Miguilim entrará em contato com a revista indicando que esta possui as autorizações necessárias para a atualização do registro.</p>
    
    <p>Com as devidas autorizações, o usuário deverá dirigir-se ao registro da revista, clicar na aba “Editar dados do registro” e informar o número de ISSN, login e senha
        <a href="http://200.130.45.73:8080/jspui/criacao-login.jsp" target="_blank">(Veja como criar um login aqui)</a>. Ao informar estes dados o usuário terá acesso ao formulário de edição, onde poderá alterar todos os campos que achar necessário. Os campos
    devem ser preenchidos de acordo  com as instruções indicadas. A atualização do registro será disponibilizada automaticamente no diretório, cabendo à equipe gestora do 
    Miguilim a verificação e revisão dos dados indicados.</p>

    <h2><strong class="titulo-medio">Revistas cadastradas pelos responsáveis (Possuem login vinculado)</strong></h2>
	
    <p>Revistas que foram cadastradas pelos próprios responsáveis já possuem permissão de acesso interno aos registros e podem fazer a atualização dos dados da revista sem 
    solicitar permissão para isso. Para a atualização dos dados o usuário deverá dirigir-se ao registro da revista, clicar na aba “Editar dados do registro” e informar o 
    número de ISSN, login e senha <a href="http://200.130.45.73:8080/jspui/criacao-login.jsp" target="_blank">(Veja como criar um login aqui)</a>. Ao informar estes dados, o usuário efetuará o login e terá acesso ao formulário de edição, onde poderá 
    alterar todos os campos que achar necessário. Os campos devem ser preenchidos de acordo com as instruções indicadas. A atualização do registro será disponibilizada 
    automaticamente no diretório, cabendo à equipe gestora do Miguilim a verificação e revisão dos dados indicados.</p>
    
    <h2><strong class="titulo-medio">Atualização do cadastro de Portais de periódicos</strong></h2>

    <p>As instruções de alteração apresentadas anteriormente não se aplicam à coleção “Portal de periódicos”. Para alterar os dados desses registros, o gestor do Portal deverá
    entrar em contato com a Equipe Miguilim solicitando sua atualização. O contato pode ser feito por e-mail (revistas@ibict.br). Neste contato é importante que o solicitante
    apresente-se e informe por qual o Portal de periódicos ele é responsável. Os campos da coleção Portais de periódicos são:</p>

    <dl>
        <dd>Nome do portal de periódicos* </dd>
        <dd>URL* </dd>
        <dd>Instituição responsável* </dd>
        <dd>Organismo subordinado </dd>
        <dd>Administrador responsável* </dd>
        <dd>E-mail* </dd>
        <dd>Código Postal (CEP)* </dd>
        <dd>Estado (UF)* </dd>
        <dd>Cidade* </dd>
        <dd>Bairro/Setor* </dd>
        <dd>Rua/Quadra ou similar</dd>
        <dd>Casa/Prédio/ Sala ou similar</dd>
        <dd>Telefone</dd>
        <dd>Revistas do portal*</dd>
    </dl>

</div>
</dspace:layout>

