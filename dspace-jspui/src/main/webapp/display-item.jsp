<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Renders a whole HTML page for displaying item metadata.  Simply includes
  - the relevant item display component in a standard HTML page.
  -
  - Attributes:
  -    display.all - Boolean - if true, display full metadata record
  -    item        - the Item to display
  -    collections - Array of Collections this item appears in.  This must be
  -                  passed in for two reasons: 1) item.getCollections() could
  -                  fail, and we're already committed to JSP display, and
  -                  2) the item might be in the process of being submitted and
  -                  a mapping between the item and collection might not
  -                  appear yet.  If this is omitted, the item display won't
  -                  display any collections.
  -    admin_button - Boolean, show admin 'edit' button
  -    submitter_button - Boolean, show submitter "new version" button
  --%>
<%@page contentType="text/html;charset=UTF-8" %>

<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@page import="org.apache.log4j.Logger" %>
<%@page import="org.dspace.content.Collection" %>
<%@page import="org.dspace.content.Item" %>
<%@page import="org.dspace.core.ConfigurationManager" %>
<%@page import="org.dspace.handle.HandleServiceImpl" %>
<%@page import="org.dspace.license.CreativeCommonsServiceImpl" %>
<%@page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@page import="org.dspace.versioning.Version" %>
<%@page import="org.dspace.core.Context" %>
<%@page import="org.dspace.app.webui.util.VersionUtil" %>
<%@page import="org.dspace.app.webui.util.UIUtil" %>
<%@page import="org.dspace.authorize.AuthorizeServiceImpl" %>
<%@page import="java.util.List" %>
<%@page import="org.dspace.core.Constants" %>
<%@page import="org.dspace.eperson.EPerson" %>
<%@page import="org.dspace.versioning.VersionHistory" %>
<%@page import="org.dspace.plugin.PluginException" %>
<%@page import="org.dspace.app.webui.servlet.MyDSpaceServlet" %>
<%@page import="org.dspace.content.factory.ContentServiceFactory" %>
<%@page import="org.dspace.content.MetadataValue" %>
<%@page import="org.dspace.license.factory.LicenseServiceFactory" %>
<%@page import="org.dspace.license.service.CreativeCommonsService" %>
<%@page import="org.dspace.handle.factory.HandleServiceFactory" %>
<%@page import="org.dspace.versioning.service.VersionHistoryService" %>
<%@page import="org.dspace.versioning.factory.VersionServiceFactory" %>
<%@ page import="org.dspace.termometro.service.TermometroService" %>
<%@ page import="org.dspace.termometro.factory.TermometroServiceFactory" %>
<%@ page import="org.dspace.app.webui.servlet.DisplayStatisticsServlet" %>
<%@ page import="org.dspace.content.service.ItemService"%>
<%@ page import="org.dspace.termometro.util.PrinterTermometro"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
	// Attributes
    Boolean displayAllBoolean = (Boolean) request.getAttribute("display.all");
    boolean displayAll = (displayAllBoolean != null && displayAllBoolean.booleanValue());
    Boolean suggest = (Boolean) request.getAttribute("suggest.enable");
    boolean suggestLink = (suggest == null ? false : suggest.booleanValue());
    Item item = (Item) request.getAttribute("item");
    List<Collection> collections = (List<Collection>) request.getAttribute("collections");
    Boolean admin_b = (Boolean) request.getAttribute("admin_button");
    boolean admin_button = (admin_b == null ? false : admin_b.booleanValue());
    Boolean submitter_b = (Boolean) request.getAttribute("submitter_button");
    boolean submitter_button = (submitter_b == null ? false : submitter_b.booleanValue());
    // get the workspace id if one has been passed
    Integer workspace_id = (Integer) request.getAttribute("workspace_id");

    // get the handle if the item has one yet
    String handle = item.getHandle();
    Context context = UIUtil.obtainContext(request);

    try {
        item.updateMetadadosComputados(context);
    } catch (Exception e) {
        Logger.getLogger(getClass()).error("Ocorreu um erro ao atualizar os metadados computados para visualização:", e);
    }

    // get the doi if the item has one
    String doi = (String) request.getAttribute("doi");
    // get the preferred identifier (as URL)
    String preferredIdentifier = (String) request.getAttribute("preferred_identifier");
    // get the latestVersionIdentifier
    String latestVersionIdentifier = (String) request.getAttribute("versioning.latest_version_identifier");

    // CC URL & RDF
    CreativeCommonsService creativeCommonsService = LicenseServiceFactory.getInstance().getCreativeCommonsService();
    String cc_url = creativeCommonsService.getLicenseURL(context, item);
    String cc_rdf = creativeCommonsService.getLicenseRDF(context, item);

    // Full title needs to be put into a string to use as tag argument
    String title = "";
    if (handle == null) {
        title = "Workspace Item";
    } else {
        List<MetadataValue> titleValue = ContentServiceFactory.getInstance().getItemService().getMetadata(item, "dc", "title", null, Item.ANY);
        if (titleValue.size() != 0) {
            title = titleValue.get(0).getValue();
        } else {
            title = "Item " + handle;
        }
    }

    Boolean versioningEnabledBool = (Boolean) request.getAttribute("versioning.enabled");
    boolean versioningEnabled = (versioningEnabledBool != null && versioningEnabledBool.booleanValue());
    Boolean hasVersionButtonBool = (Boolean) request.getAttribute("versioning.hasversionbutton");
    Boolean hasVersionHistoryBool = (Boolean) request.getAttribute("versioning.hasversionhistory");
    boolean hasVersionButton = (hasVersionButtonBool != null && hasVersionButtonBool.booleanValue());
    boolean hasVersionHistory = (hasVersionHistoryBool != null && hasVersionHistoryBool.booleanValue());

    Boolean newversionavailableBool = (Boolean) request.getAttribute("versioning.newversionavailable");
    boolean newVersionAvailable = (newversionavailableBool != null && newversionavailableBool.booleanValue());
    Boolean showVersionWorkflowAvailableBool = (Boolean) request.getAttribute("versioning.showversionwfavailable");
    boolean showVersionWorkflowAvailable = (showVersionWorkflowAvailableBool != null && showVersionWorkflowAvailableBool.booleanValue());

    VersionHistoryService versionHistoryService = VersionServiceFactory.getInstance().getVersionHistoryService();
    VersionHistory history = (VersionHistory) request.getAttribute("versioning.history");
    List<Version> historyVersions = (List<Version>) request.getAttribute("versioning.historyversions");

    ItemService itemService = ContentServiceFactory.getInstance().getItemService();
    TermometroService termometroService = TermometroServiceFactory.getInstance().getTermometroService();
    PrinterTermometro printer = new PrinterTermometro();

    String pontuacaoTotalTermometro = termometroService.calcularPontuacaoTotalDoItem(item);
    String porcentagemPontuacaoTermometro = termometroService.calcularPorcentagemPontuacao(item);
    String pontuacaoIndiceH5 = itemService.getMetadata(item, "dc.identifier.h5index");
    String REVISTAS = "miguilim/2";
    String PORTAL_DE_PERIODICOS = "miguilim/2669";

    List<MetadataValue> openAccessValues = itemService.getMetadata(item, "dc", "rights", "access", Item.ANY);
    List<MetadataValue> feesValues = itemService.getMetadata(item, "dc", "description", "publicationfees", Item.ANY);
    List<MetadataValue> abecValues = itemService.getMetadata(item, "dc", "identifier", "abecbrasil", Item.ANY);

    boolean possuiSeloCienciaAberto = openAccessValues.size() != 0 && openAccessValues.get(0).getValue().equals("Acesso aberto imediato") && Integer.parseInt(porcentagemPontuacaoTermometro) >= 80;
    boolean possuiSeloDiamante = openAccessValues.size() != 0 && openAccessValues.get(0).getValue().equals("Acesso aberto imediato") 
    		&& feesValues.size() != 0 && feesValues.get(0).getValue().equals("A revista não cobra qualquer taxa de publicação");
    boolean possuiSeloAbec = abecValues.size() != 0 && abecValues.get(0).getValue().equals("A revista é associada à ABEC Brasil");
    
    Boolean pendingReview = (Boolean) (request.getAttribute("pending_review") != null ? request.getAttribute("pending_review") : false);
%>

<head>
    <style>
        .legenda:hover::after {
            border-radius: 4px;
            display: block;
            position: absolute;
            background-color: #071D41;
            color: white;
            top: -35px;
            left: 5px;            
            padding: 8px;
            width: 180px;
            text-align: center;
            font-size: smaller;
            content: attr(textoLegenda);
        }
    </style>
</head>

<dspace:layout title="<%= title %>">

    <div class="search-main" <%= !admin_button ? "style='grid-template-columns: 1fr;'" : "" %>>


        <%
            if (admin_button)  // admin edit button
            { 
        %>
        <div class="search-content">
            <div class="panel panel-warning">
                <div class="panel-heading"><fmt:message key="jsp.admintools"/></div>
                <div class="panel-body">
                	
                	<%
                		if (!pendingReview) 
                		{
            		%>
		                    <form method="get" action="<%= request.getContextPath() %>/tools/edit-item">
		                        <input type="hidden" name="item_id" value="<%= item.getID() %>"/>
		                        <input class="btn btn-default col-md-12" type="submit" name="submit"
		                               value="<fmt:message key="jsp.general.edit.button"/>"/>
		                    </form>
                    <%
                		}
            		%>

                    <% if(UIUtil.obtainContext(request).getCurrentUser() != null) { %>

                    <form method="post" action="<%= request.getContextPath() %>/mydspace">
                        <input type="hidden" name="item_id" value="<%= item.getID() %>"/>
                        <input type="hidden" name="step" value="<%= MyDSpaceServlet.REQUEST_EXPORT_ARCHIVE %>"/>
                        <input class="btn btn-default col-md-12" type="submit" name="submit"
                               value="<fmt:message key="jsp.mydspace.request.export.item"/>"/>
                    </form>
                    <form method="post" action="<%= request.getContextPath() %>/mydspace">
                        <input type="hidden" name="item_id" value="<%= item.getID() %>"/>
                        <input type="hidden" name="step" value="<%= MyDSpaceServlet.REQUEST_MIGRATE_ARCHIVE %>"/>
                        <input class="btn btn-default col-md-12" type="submit" name="submit"
                               value="<fmt:message key="jsp.mydspace.request.export.migrateitem"/>"/>
                    </form>
                    <form method="post" action="<%= request.getContextPath() %>/dspace-admin/metadataexport">
                        <input type="hidden" name="handle" value="<%= item.getHandle() %>"/>
                        <input class="btn btn-default col-md-12" type="submit" name="submit"
                               value="<fmt:message key="jsp.general.metadataexport.button"/>"/>
                    </form>
                    <% if (hasVersionButton) { %>
                    <form method="get" action="<%= request.getContextPath() %>/tools/version">
                        <input type="hidden" name="itemID" value="<%= item.getID() %>"/>
                        <input class="btn btn-default col-md-12" type="submit" name="submit"
                               value="<fmt:message key="jsp.general.version.button"/>"/>
                    </form>
                    <% } %>
                    <% if (hasVersionHistory) { %>
                    <form method="get" action="<%= request.getContextPath() %>/tools/history">
                        <input type="hidden" name="itemID" value="<%= item.getID() %>"/>
                        <input type="hidden" name="versionID"
                               value="<%= versionHistoryService.getVersion(context, history, item)!=null?versionHistoryService.getVersion(context, history, item).getID():null %>"/>
                        <input class="btn btn-info col-md-12" type="submit" name="submit"
                               value="<fmt:message key="jsp.general.version.history.button"/>"/>
                    </form>
                    <% } %>
                    <% } %>
                </div>
            </div>
        </div>
        <%
            }
        %>

        <%
            // submitter create new version button
            if (submitter_button && hasVersionButton) {
        %>
        <div class="search-content">
            <div class="panel panel-warning">
                <div class="panel-heading"><fmt:message key="jsp.submittertools"/></div>
                <div class="panel-body">
                    <form method="get" action="<%= request.getContextPath()%>/tools/version">
                        <input type="hidden" name="itemID" value="<%= item.getID()%>"/>
                        <input class="btn btn-default col-md-12" type="submit" name="submit"
                               value="<fmt:message key="jsp.general.version.button"/>"/>
                    </form>
                </div>
            </div>
        </div>
        <%
            }
        %>

		<div class="search-filter">
            <div class="content-home">
                <h2><b><%= title %></b></h2>
            </div>

            <%
            if (pendingReview) 
            {
            %>
                <p class="alert alert-info"><fmt:message key="jsp.submit.complete.update"/></p> 
            <%
            }
            %>

            <%
            if (preferredIdentifier != null) 
            {
            %>
                <div class="well">
                    <fmt:message key="jsp.display-item.identifier"/>
                    <code style="padding:5px 2px 2px 5px;"><%= preferredIdentifier %></code>
                </div>
            <%
            }
            %>

            <div class="d-flex">
            	
				<% 
					String displaySeloAcessoAberto = possuiSeloCienciaAberto ? "block" : "none";
                    String displaySeloDiamante = possuiSeloDiamante ? "block" : "none";
                    String displaySeloAbec = possuiSeloAbec ? "block" : "none";
                %>
            
                <a class="tooltips-wrapper">
                    <div class="tooltips" tooltipbtn="Práticas de Ciência Aberta" style="display: <%= displaySeloAcessoAberto %>;">
                        <img height="80" src="../../image/aberto.svg" alt="selo sobre prática de ciência aberta">
                    </div>
                </a>
                <a class="tooltips-wrapper">
                    <div class="tooltips" tooltipbtn="Revista diamante" style="display: <%= displaySeloDiamante %>;">
                        <img height="80" src="../../image/diamante.svg" alt="selo sobre revista diamante">
                    </div>
                </a>	
                <a class="tooltips-wrapper">
                    <div class="tooltips" tooltipbtn="Revista associada à ABEC Brasil" style="display: <%= displaySeloAbec %>;">
                        <img height="80" src="../../image/abec.svg" alt="selo sobre revista abec">
                    </div>
                </a>
            </div>

            <ul class="nav nav-pills">
                <li class="nav-item active">
                    <a class="nav-link" aria-current="page" href="#" destiny="#item-data"><fmt:message
                            key="webui.displayitem.tab.itemdata"></fmt:message> </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" aria-current="page" href="#" destiny="#item-data-full"><fmt:message
                            key="webui.displayitem.tab.itemdata.complete"></fmt:message> </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" aria-current="page" href="#" destiny="#metadataservices"><fmt:message
                            key="webui.displayitem.tab.metadataservices"></fmt:message> </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" aria-current="page" href="#" destiny="#item-statistics"><fmt:message
                            key="webui.displayitem.tab.itemdata.stats"></fmt:message> </a>
                </li>
                <%
                    if (collections.get(0).getHandle().equals(REVISTAS)) 
                    {
                %>

		                <li class="nav-item">
		                    <a class="nav-link" href="#" destiny="#termometro">
		                    	<fmt:message key="webui.displayitem.tab.termometro"></fmt:message> 
		                    </a>
		                </li>
		                
		                <li class="nav-item">
		                    <a class="nav-link" href="#" destiny="#formulario">
		                    	<fmt:message key="webui.displayitem.tab.requestchange"></fmt:message> 
		                    </a>
		                </li>
              
                <%
                    }
                    else
                    {
                %>
                
						<li class="nav-item">
		                    <a class="nav-link" href="#" destiny="#formulario">
		                    	<fmt:message key="webui.displayitem.tab.requestchangeportal"></fmt:message> 
		                    </a>
		                </li>
                
                 <%
                    }
                %>
                
            </ul>

            <div id="item-data" tabcontent>

                <dspace:item-preview item="<%= item %>"/>
                <dspace:item item="<%= item %>" collections="<%= collections %>"/>
                
            </div>

            <div id="item-data-full" tabcontent class="d-hide">

                <dspace:item-preview item="<%= item %>"/>
                <dspace:item item="<%= item %>" collections="<%= collections %>" style="full"/>

            </div>

            <div id="metadataservices" tabcontent class="d-hide">
                <dspace:item-preview item="<%= item %>"/>
                <dspace:item item="<%= item %>" style="metadataservices" />
            </div>

            <div id="item-statistics" tabcontent >
                <%@include file="item-pages/display-stats.jsp" %>
            </div>

            <div id="termometro" tabcontent>
                <%@include file="item-pages/display-termometro.jsp" %>
            </div>

            <div id="formulario" tabcontent class="d-hide">
                <iframe width="100%" height="2000" frameborder="0" scrolling="yes" marginheight="0" marginwidth="0"
                        src="https://docs.google.com/forms/d/e/1FAIpQLScn-5vKw_RGeeA1_tmD66TbRH8KKl2Dn2GrH_wyd9e1amQnCg/viewform">
                </iframe>
            </div>
           
        </div>
    </div>

    
    
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/gauge/gauge.js"></script>
    <script type="text/javascript">
        initGauge();

        function initGauge() {
            termometro = new Gauge(document.getElementById("canvas-termometro"));
            var opts = {
                angle: 0,
                lineWidth: 0.4,
                radiusScale: 1,

                staticLabels: {
                    font: "18px sans-serif",
                    labels: [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100],
                    fractionDigits: 0
                },

                renderTicks: {
                    divisions: 100,
                    divWidth: 0.5,
                    divLength: 0.1,
                    divColor: '#333333',
                    subDivisions: 1,
                    subLength: 0.5,
                    subWidth: 0.6,
                    subColor: '#363030'
                },
                limitMax: true,
                limitMin: false,
                highDpiSupport: true
            };
            termometro.setOptions(opts);
            termometro.minValue = 0;
            termometro.maxValue = 100;
            termometro.animationSpeed = 10;
            termometro.set(<%= porcentagemPontuacaoTermometro %>);

            var textRenderer = new TextRenderer(document.getElementById('preview-textfield'))
            textRenderer.render = function(gauge) {
            	this.el.innerHTML = gauge.displayedValue + "%"
            };

            termometro.setTextField(textRenderer);
        }

        document.querySelector("#termometro").classList.add("d-hide");
   
    </script>

    <script>

        document.querySelectorAll("a[destiny]").forEach(element => {

            element.addEventListener("click", function () {

                document.querySelectorAll("div[tabcontent]").forEach(element => {
                    element.classList.add("d-hide");
                });

                document.querySelectorAll("li[class='nav-item active']").forEach(element => {
                    element.classList.remove("active");
                });
                document.querySelector(this.getAttribute("destiny")).classList.remove("d-hide");
                this.parentElement.classList.add("active");
            })
        });

        jQuery(document).ready(function() {
            document.querySelector("#item-statistics").classList.add("d-hide");
        });

    </script>



</dspace:layout>
