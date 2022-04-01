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

<div class="container" id="TopoPerguntasFrequentes">
    <h2><a href="#PqMiguilim">Por que o nome Miguilim?</a></h2>
    <h2><a href="#ComoCriarLogin">Como criar um login?</a></h2>
    <h2><a href="#ComoCadastroUmaRevista">Como cadastrar uma revista ou portal de periódicos?</a></h2>
    <h2><a href="#criteriosBasicos">Quais são os critérios básicos para cadastro?</a></h2>
    <h2><a href="#QualquerRevista">Qualquer revista pode ser cadastrada?</a></h2>
    <h2><a href="#QuemPodeAtualizar">Quem pode atualizar o cadastro de revistas?</a></h2>
    <h2><a href="#ComoSolicitarPermissao">Como solicitar permissão para atualizar minha revista?</a></h2>
    <h2><a href="#ComoAtualizarArevista">Como atualizar a minha revista?</a></h2>
    <h2><a href="#ComoAlterarOregistro">Como alterar o registro de um Portal de periódicos?</a></h2>
    <h2><a href="#PorqueEimportanteCadastrar">Porque é importante cadastrar uma revista no Miguilim?</a></h2>
    <h2><a href="#RevistasQueNaosaoPublicadas">Revistas que não são publicadas no Brasil também podem ser cadastradas?</a></h2>
    <h2><a href="#ComoForamDefinidosOsCampos">Como foram definidos os campos de descrição de revistas do Miguilim?</a></h2>
    <h2><a href="#DeOndeVieramAsInformacoes">De onde vieram as informações dos primeiros registros do Miguilim?</a></h2>
    <h2><a href="#EmQualSoftware">Em qual software foi desenvolvido o Miguilim?</a></h2>
    <h2><a href="#ComoFuncionaOformulario">Como funciona o formulário de atualização do Miguilim?</a></h2>
    <h2><a href="#OqueEoTermometro">O que é o Termômetro de Acesso Aberto?</a></h2>
    <h2><a href="#PorQueUmaColecaoDePortais">Por que existe uma coleção de portais de periódicos?</a></h2>

    <div class="espacamento">

        <h2><a id="PqMiguilim"><strong class="titulo-medio">Por que o nome Miguilim?</strong></a></h2>

            <p id="margem-unica">Miguilim é um dos personagens do livro “Manuelzão e Miguilim”, um dos clássicos romances da literatura brasileira cujo autor é João Guimarães Rosa.
            O nome foi escolhido com vistas a acompanhar a tendência internacional de nomear diretórios e serviços de informação homenageando obras da literatura do país em que o 
            sistema foi desenvolvido.</p>

            <p id="margem-unica">Além do mais, a escolha do nome se deu pelo fato do Miguilim ter sido criado em conjunto com outro serviço do Ibict, o Manuelzão - Portal brasileiro para as revistas
            científicas. Deste modo, Manuelzão e Miguilim representam duas importantes ações do Ibict em prol das revistas científicas brasileiras, cada qual com suas particularidades.</p>

        <h2><a id="ComoCriarLogin"><strong class="titulo-medio">Como criar um login?</strong></a></h2>

            <p id="margem-unica">O primeiro passo para fazer parte do Miguilim é criar login da Revista científica ou do Portal de periódicos que queira cadastrar. Aconselha-se 
            que o e-mail utilizado para a criação do login seja o e-mail institucional da Revista científica ou do Portal de periódicos. Deve-se evitar o uso de e-mails pessoais dos gestores, tendo em vista que a mudança dos responsáveis pode acarretar a perda do acesso.</p>
            
            <p id="margem-unica">Para criar o login, o responsável deve acessar a aba “Login”, clicar no link “Usuário novo? Clique aqui para se registrar”, informar o e-mail 
            institucional no campo “Endereço de e-mail” e clicar em “Registrar”. Ao efetuar estes passos, o responsável receberá um e-mail com um link para que faça o registro das
            informações e crie uma senha para o cadastro. Feito isso, o responsável deverá clicar em “Completar o registro”. A partir de então o login terá sido criado, o que permite 
            acesso interno ao Miguilim via aba “Login”, onde os cadastros de revistas científicas e portais de periódicos podem ser realizados.</p>

        <h2><a id="ComoCadastroUmaRevista"><strong class="titulo-medio">Como cadastrar uma revista ou portal de periódicos?</strong></a></h2>
         
            <p id="margem-unica">Assegurando-se que a Revista científica ou o Portal de periódicos não estão registrados no Miguilim, basta fazer o login pela aba “Entrar em”
            e clicar no botão “Iniciar um novo depósito”. Em seguida deve-se escolher uma das duas coleções do Miguilim, “Revistas” ou “Portais de periódicos”. Escolhida a 
            coleção o usuário terá acesso ao formulário de cadastro, momento em que deve iniciar a descrição do registro por meio do preenchimento dos campos de acordo com as 
            instruções indicadas. Após o preenchimento dos campos, o cadastro ficará pendente de aceite por parte da equipe gestora do Miguilim, cabendo a ela a verificação dos 
            dados e posterior aprovação. Assim que a equipe gestora realizar o aceite do cadastro, um e-mail com o link do registro finalizado será encaminhado ao responsável.</p>

        <h2><a id="criteriosBasicos"><strong class="titulo-medio">Quais são os critérios básicos para cadastro?</strong></a></h2>

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
            
        <h2><a id="QualquerRevista"><strong class="titulo-medio">Qualquer revista pode ser cadastrada?</strong></a></h2>   

            <p id="margem-unica">Cumprindo os critérios básicos para registro, qualquer revista pode ser cadastrada. No entanto, todos os cadastros estão sujeitos à revisão 
            pela equipe do Diretório antes de serem aprovados. Além de verificar o cumprimento dos critérios básicos, a revisão tem o objetivo de avaliar se os dados foram
            preenchidos de acordo com as instruções indicadas em cada campo e se as informações fornecidas condizem com o que se indica na página da revista.</p>

        <h2><a id="QuemPodeAtualizar"><strong class="titulo-medio">Quem pode atualizar o cadastro de revistas?</strong></a></h2>

            <p id="margem-unica">Para atualizar o cadastro de uma revista científica é necessário que o usuário  tenha o acesso autorizado para realizar tal ação. As revistas
            que foram cadastradas pelos próprios responsáveis já possuem essa autorização. Para verificar se possui autorização para atualizar a revista, faça o Login no diretório, 
            entre em “Meu espaço” e clique na aba “Ver depósito (s) aceito (s)”. As revistas listadas nessa seção estão vinculadas a esse login e podem ser atualizadas. As revistas
            que foram pré-cadastradas no Miguilim precisam solicitar a autorização para a atualização.</p>

        <h2><a id="ComoSolicitarPermissao"><strong class="titulo-medio">Como solicitar permissão para atualizar minha revista?</strong></a></h2>

            <p id="margem-unica">Caso o usuário localize um registro de revista de sua responsabilidade já registrada no Miguilim e deseje fazer alterações no mesmo, ele deve 
            primeiramente solicitar permissão para a atualização do registro. Para esta solicitação, o usuário deve acessar a página do registro da revista e clicar na aba 
            "Solicitar edição da revista". Ao clicar nessa aba o usuário terá acesso ao “Formulário de solicitação de edição de revista no Miguilim” e deverá preencher os 
            campos de acordo com as instruções indicadas e clicar em “Enviar”. Os dados informados serão verificados pela Equipe Miguilim no site da revista, que concederá ou
            não as permissões de atualização. Assim sendo, as informações fornecidas no formulário deverão ser as mesmas constantes no site da revista, caso contrário não será 
            possível conceder as autorizações. O endereço de e-mail informado deverá ser o mesmo utilizado para realizar o login no Miguilim, já que a permissão vai ser dada para
            este login. Assim que o formulário for enviado a Equipe Miguilim será notificada e irá proceder com os ajustes para a concessão das permissões de atualização. Em seguida
            a Equipe Miguilim entrará em contato com a revista indicando que esta possui as autorizações necessárias para a atualização do registro.</p>

        <h2><a id="ComoAtualizarArevista"><strong class="titulo-medio">Como atualizar a minha revista?</strong></a></h2>
            
            <p id="margem-unica">Para a atualização dos dados o usuário deverá dirigir-se ao registro da revista, clicar na aba “Editar dados do registro” e informar o número
            de ISSN, login e senha. Ao informar estes dados, o usuário efetuará o login e terá acesso ao formulário de edição, onde poderá alterar todos os campos que achar 
            necessário. Os campos devem ser preenchidos de acordo com as instruções indicadas. A atualização do registro será disponibilizada automaticamente no diretório, cabendo
            à equipe gestora do Miguilim a verificação e revisão dos dados indicados.</p>
        
        <h2><a id="ComoAlterarOregistro"><strong class="titulo-medio">Como alterar o registro de um Portal de periódicos?</strong></a></h2>

            <p id="margem-unica">Para alterar os dados desses registros, o gestor do Portal deverá entrar em contato com a Equipe Miguilim solicitando sua atualização. O contato pode ser feito
            por e-mail (revistas@ibict.br). Neste contato é importante que o solicitante apresente-se e informe por qual o Portal de periódicos é responsável. Os campos da 
            coleção Portais de periódicos são:</p>

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
        
        <h2><a id="PorqueEimportanteCadastrar"><strong class="titulo-medio">Porque é importante cadastrar uma revista no Miguilim?</strong></a></h2>

            <p id="margem-unica">O Miguilim foi criado com o intuito de agregar, em um único local, informações sobre as revistas científicas editadas e publicadas no Brasil que se encontravam
            dispersas em diferentes plataformas. O diretório reúne em sua base de dados o cadastro de informações essenciais das políticas editoriais  de milhares de revistas 
            científicas brasileiras, tendo como objetivos básicos:</p>

            <ol>
                <li>Facilitar o acesso ao conjunto das revistas científicas editadas e publicadas no Brasil;</li>
                <li>Promover a disseminação e a visibilidade das revistas científicas brasileiras com intuito de aumentar o impacto da sua produção no cenário internacional;</li>
                <li>Explicitar aspectos da política editorial com vistas a transparência dos processos editoriais empreendidos pelas revistas, assim como instruir os editores a respeito das possibilidades das práticas editoriais a seguir;</li>
                <li>Por meio dos dados informados pelas revistas busca promover, também, a transparência necessária à avaliação dessas revistas; </li>
                <li>Instruir os editores em relação aos critérios de avaliação requeridos por grandes indexadores e bases de dados que disseminam e atribuem credibilidade às revistas;</li>
                <li>Incentivar pesquisas no âmbito da Comunicação Científica e da Ciência da informação sobre os mais variados temas que possam ser extraídos dos dados disponíveis no Miguilim e, de maneira especial, sobre a qualidade editorial das revistas brasileiras;</li>
                <li>Tem a intenção de servir como porta de entrada para outros produtos do Ibict que fazem o cadastro de revistas científicas como Diadorim, Oasisbr, Latindex  e Emeri;</li>
                <li>Evitar o retrabalho dos editores responsáveis no preenchimento dos dados das revistas em diversas instâncias e promover a padronização e a consistência desses dados nas diversas plataformas;</li>
                <li>Assim como servir de porta de entrada para outros produtos do Ibict, a plataforma busca dar acesso aos dados das revistas brasileiras a bases de dados, repositórios diversos e outros diretórios de revistas nacionais ou internacionais;</li>
                <li>Incentivar ações práticas relacionadas aos movimentos de Ciência Aberta e Acesso Aberto à informação científica.</li>
            </ol>

            <p id="margem-unica">Em última análise, o Miguilim busca o aumento da qualidade editorial das revistas científicas brasileiras, a internacionalização da ciência 
            brasileira e a democratização do acesso ao conhecimento científico.</p>
            
        <h2><a id="RevistasQueNaosaoPublicadas"><strong class="titulo-medio">Revistas que não são publicadas no Brasil também podem ser cadastradas?</strong></a></h2>

            <p id="margem-unica">Não, o Miguilim engloba somente as revistas criadas e editadas no Brasil. Revistas estrangeiras podem ser registradas em outros diretórios, 
            índices e bases de dados com objetivos similares.</p>
        
        <h2><a id="ComoForamDefinidosOsCampos"><strong class="titulo-medio">Como foram definidos os campos de descrição de revistas do Miguilim?</strong></a></h2>

            <p id="margem-unica">O padrão de metadados original do Miguilim foi definido a partir de estudos feitos por sua equipe gestora com cerca de oito plataformas de acesso
            aberto que possuem o cadastro de revistas científicas, sendo elas: Diadorim, Latindex, DOAJ, Portal ISSN, Wikidata, Google Scholar Metrics, Sumários e a base do antigo
            e já desativado Portal de periódicos SEER. Desse modo, foi possível verificar quais as informações das revistas mais são cobradas e reuni-las em um único serviço.</p>

            <p id="margem-unica">Buscando descrever aspectos essenciais da política editorial das revistas, campos adicionais foram criados com base em alguns critérios de 
            avaliação de grandes diretórios e indexadores e avaliadores nacionais e internacionais como Latindex, Scielo, DOAJ,  Redalyc, Web of Science, Scopus e Qualis 
            Capes. Ao final chegou-se à relação de 65 campos descritivos, que incluem dados cadastrais/de identificação e sobre a política editorial das revistas.</p>
        
        <h2><a id="DeOndeVieramAsInformacoes"><strong class="titulo-medio">De onde vieram as informações dos primeiros registros do Miguilim?</strong></a></h2>

            <p id="margem-unica">O Miguilim foi lançado com aproximadamente 3000 registros de revistas científicas e portais de periódicos brasileiros pré-cadastrados no 
            diretório. Em relação às revistas científicas, os dados são provenientes de informações declaradas nas plataformas: Diadorim, Latindex, DOAJ, Portal ISSN, 
            Wikidata, Google Scholar Metrics, Sumário e a base do antigo e já desativado Portal de periódicos SEER. Estes dados foram coletados dessas bases, passaram por
            curadoria e então importados ao Miguilim. Em relação aos portais de periódicos, estes foram mapeados pela equipe gestora e preenchidos manualmente.</p>
        
        <h2><a id="EmQualSoftware"><strong class="titulo-medio">Em qual software foi desenvolvido o Miguilim?</strong></a></h2>

            <p id="margem-unica">O Miguilim foi desenvolvido na versão 6.3 do software DSpace. O Dspace é um software de código aberto desenvolvido pela Massachusetts Institute of 
            Technology (MIT).</p>

            <p id="margem-unica">A administração dos conteúdos descritos e depositados no Dspace segue estrutura de relação hierárquica. O Dspace se organiza em três 
            instâncias. Do mais específico ao mais abrangente, tem-se: os “Itens” que são subordinados às "Coleções" e que, por sua vez, são subordinadas as “Comunidades”.  
            Por ser de administração centralizada o Miguilim possui apenas uma Comunidade, denominada “Miguilim”. Subordinadas a esta Comunidade figuram as coleções “Portais de Periódicos” e “Revistas”, que abrigam os cadastros dos respectivos Itens de determinados portais de periódicos e revistas científicas. </p>
            
            <p id="margem-unica">O DSpace permite um fluxo de depósito em que os próprios editores das revistas e os administradores dos portais de periódicos podem realizar
            o cadastro dos itens pelos quais são responsáveis e os administradores do Miguilim, posteriormente, revisam o cadastro antes de aceitá-lo e torná-lo público.</p>
            
            
        <h2><a id="ComoFuncionaOformulario"><strong class="titulo-medio">Como funciona o formulário de atualização do Miguilim?</strong></a></h2>

            <p id="margem-unica">Uma das funções prioritárias do Miguilim é manter um cadastro com informações atualizadas das revistas que compõem. A interface para a 
            atualização dos dados disponível no DSpace não foi criada para contemplar as necessidades de usabilidade do usuário externo. Sendo assim, identificou-se a 
            necessidade de criar um formulário em que os próprios editores científicos possam atualizar os dados das revistas que editam.</p>

            <p id="margem-unica">O formulário de atualização é uma aplicação externa que se comunica com o DSpace. Dessa forma, os dados que são atualizados no formulário de
            atualização são exportados automaticamente para o cadastro da revista no Miguilim. Quando a atualização do cadastro é feita a equipe gestora do Miguilim recebe um
            e-mail comunicando da atualização do item, cabendo aos administradores a verificação dos dados informados e a realização de correções, se necessário.</p>
        
        <h2><a id="OqueEoTermometro"><strong class="titulo-medio">O que é o Termômetro de Acesso Aberto?</strong></a></h2>

            <p id="margem-unica">O termômetro de Acesso Aberto tem como objetivo identificar o alinhamento das revistas científicas brasileiras cadastradas no Miguilim aos 
            Movimentos de Acesso Aberto e de Ciência Aberta. Para fazer esta medição, o termômetro utiliza como parâmetro as respostas dadas pelo editor da revista a uma 
            série de metadados, sendo possível criar uma escala que mede o quão alinhada a revista está a estes Movimentos.	As revistas que cumprirem ao menos 80% dos 
            critérios de abertura definidos pela Equipe Miguilim receberão um selo de publicação em Acesso Aberto, que comprova os esforços realizados pela revista para 
            colocar a Ciência ao alcance de todos.</p>

            <p id="margem-unica">A pontuação indicada no termômetro leva em consideração as respostas dadas a 22 campos do registro da revista. Estes campos dizem respeito à abertura do
            processo editorial da revista como um todo e relacionam-se às questões de transparência, disseminação e acesso aos conteúdos, direitos autorais, interoperabilidade,
            ética, dentre outros. Para cada um dos 22 campos a revista pode pontuar entre 0 (zero), 1 (um) ou 2 (dois) pontos, sendo 2 (dois) a pontuação máxima para cada um. 
            Deste modo, ao pontuar 2 (dois) em cada um dos 22 campos a revista atinge a pontuação máxima de 44 pontos. O selo será atribuído àquelas revistas que marcarem 36 
            pontos ou mais, que corresponde a 80% da pontuação máxima.</p>
        
        <h2><a id="PorQueUmaColecaoDePortais"><strong class="titulo-medio">Por que existe uma coleção de portais de periódicos?</strong></a></h2>

            <p id="margem-unica">Além de criar a coleção de “Revistas científicas” notou-se a necessidade de criar uma coleção para os Portais de periódicos que abrigam as 
            revistas. Portais de periódicos, mais do que um simples agregador de revistas de uma instituição, agem, muitas vezes, como uma instância institucional no 
            gerenciamento de revistas científicas. Possuem equipes especializadas nos processos de gestão de revistas e trabalham no sentido de gerar políticas editoriais
            básicas para as revistas que agregam, treinar os editores científicos no manuseio do software de gestão de revistas e na implementação de ferramentas que aumentem
            a acessibilidade e a interoperabilidade das revistas. De forma geral buscam promover o acesso, a visibilidade, a segurança, a qualidade das revistas e o suporte
            aos editores dos periódicos científicos. Com base na proximidade de propósitos adotados pelo Miguilim e visando o desenvolvimento e valorização do trabalho 
            realizado nos portais de periódicos, a criação de uma coleção dessas plataformas se tornou primordial.</p>

            <p id="margem-unica">A coleção busca relacionar cada revista ao seu portal agregador, traçando uma responsabilização pela revista além de criar um diretório dos
            portais com o intuito de aumentar a visibilidade dessas plataformas. Como tem propósitos mais básicos, o cadastro de portais de periódicos possui apenas quatorze
            campos.</p>

            <button class="btn-customizado"><a href="#TopoPerguntasFrequentes">Voltar</a></button>        
    </div>
</div>


</dspace:layout>

