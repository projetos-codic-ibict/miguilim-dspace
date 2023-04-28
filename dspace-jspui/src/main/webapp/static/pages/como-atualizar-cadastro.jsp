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
<div class="espacamento minus-space breath-element"> 
    <h2><strong class="titulo-medio">Como atualizar um cadastro?</strong></h2>

    <p>Para atualizar o cadastro de uma revista científica ou de um portal de revistas é necessário que o usuário tenha acesso autorizado para realizar tal 
    ação. As revistas e portais que foram cadastradas pelos próprios responsáveis já possuem essa autorização. Para verificar se possui 
    autorização, faça o Login no Miguilim, entre em “Meu espaço” e clique na aba “Ver depósito(s) aceito(s)”.
    As revistas e e portais de revistas listados nessa seção estão vinculados a esse login e podem ser atualizados. As revistas e portais de revistas que foram pré-cadastrados no
    Miguilim precisam solicitar autorização para a atualização. Segue abaixo as instruções de como atualizar os dados do registro em cada situação.</p>

    <h2><strong class="titulo-medio">Revistas e portais de revistas pré-cadastrados (Não possuem login vinculado)</strong></h2>
    
    <p>Caso o usuário localize um registro de revista ou de portal de revistas de sua responsabilidade já cadastrado no Miguilim e deseje fazer alterações no
    mesmo, deve primeiramente solicitar permissão para a atualização do registro. Para esta solicitação, o usuário deve acessar a
    página do registro da revista ou do portal de revistas e clicar na aba "Solicitar edição de registros". Ao clicar nessa aba o usuário terá acesso ao “Formulário 
    de solicitação de edição de registros” e deverá preencher os campos de acordo com as instruções indicadas e clicar em “Enviar”. 
    Os dados informados serão verificados pela Equipe Miguilim no site da revista ou do portal de revistas, que concederá ou não as permissões de atualização. 
    As informações fornecidas no formulário deverão ser as mesmas constantes no site da revista e/ou do portal de revistas, caso contrário não será possível 
    conceder as autorizações. O endereço de e-mail informado deverá ser o mesmo utilizado para realizar o login no Miguilim, já que a permissão 
    vai ser dada para este login. <a href="https://miguilim.ibict.br/static/pages/criacao-login.jsp">(Veja como criar um login aqui)</a>.</p>

    <p>Assim que o formulário for enviado a Equipe Miguilim será notificada e irá proceder com os ajustes para a concessão das permissões de atualização. Em seguida, a Equipe
    Miguilim entrará em contato com a revista ou portal de revistas informando que as autorizações necessárias para a atualização do registro foram concedidas.</p>
    
    <p>Com as devidas autorizações e logado no Miguilim, o usuário deverá dirigir-se ao registro da revista e clicar no botão “Editar” que se encontra no quadro "Ferramentas do administrador"
      <a href="http://200.130.0.162/static/pages/criacao-login.jsp" target="_blank">(Veja como criar um login aqui)</a>. Ao clicar em "Editar" o usuário terá acesso ao formulário de edição, onde poderá alterar todos os campos que achar necessário. 
	   Os campos devem ser preenchidos de acordo  com as instruções indicadas. Ao final do preenchimento deve-se clicar em "Atualizar. A atualização do registro será disponibilizada automaticamente no diretório, cabendo à equipe gestora a verificação e revisão dos dados indicados.</p>

    <h2><strong class="titulo-medio">Revistas e portais de revistas cadastrados pelos responsáveis (Possuem login vinculado)</strong></h2>
	
    <p>Revistas e portais de revistas que foram cadastrados pelos próprios responsáveis já possuem permissão de acesso interno aos registros e podem fazer a atualização dos dados sem 
    solicitar permissão para isso. Para a atualização dos dados, o usuário, logado no Miguilim, deverá dirigir-se ao registro da revista ou portal e clicar no botão “Editar”, que se encontra no quadro "Ferramentas do administrador" 
   <a href="https://miguilim.ibict.br/static/pages/criacao-login.jsp" target="_blank">(Veja como criar um login aqui)</a>. Ao clicar em "Editar" o usuário terá acesso ao formulário de edição, onde poderá alterar todos os campos que achar necessário. Os campos devem ser preenchidos de acordo com as instruções indicadas. 
    Ao final do preenchimento deve-se clicar em "Atualizar". A atualização do registro será disponibilizada automaticamente no diretório, cabendo à equipe gestora do Miguilim a verificação e revisão dos dados indicados.</p>
    
   
    </dl>

</div>
</dspace:layout>

