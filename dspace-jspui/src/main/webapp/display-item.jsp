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

<%@page import="org.dspace.content.Collection" %>
<%@page import="org.dspace.content.Item" %>
<%@page import="org.dspace.core.ConfigurationManager" %>
<%@page import="org.dspace.handle.HandleServiceImpl" %>
<%@page import="org.dspace.license.CreativeCommonsServiceImpl" %>
<%@page import="javax.servlet.jsp.jstl.fmt.LocaleSupport"%>
<%@page import="org.dspace.versioning.Version"%>
<%@page import="org.dspace.core.Context"%>
<%@page import="org.dspace.app.webui.util.VersionUtil"%>
<%@page import="org.dspace.app.webui.util.UIUtil"%>
<%@page import="org.dspace.authorize.AuthorizeServiceImpl"%>
<%@page import="java.util.List"%>
<%@page import="org.dspace.core.Constants"%>
<%@page import="org.dspace.eperson.EPerson"%>
<%@page import="org.dspace.versioning.VersionHistory"%>
<%@page import="org.dspace.plugin.PluginException"%>
<%@page import="org.dspace.app.webui.servlet.MyDSpaceServlet"%>
<%@page import="org.dspace.content.factory.ContentServiceFactory" %>
<%@page import="org.dspace.content.MetadataValue" %>
<%@page import="org.dspace.license.factory.LicenseServiceFactory" %>
<%@page import="org.dspace.license.service.CreativeCommonsService" %>
<%@page import="org.dspace.handle.factory.HandleServiceFactory" %>
<%@page import="org.dspace.versioning.service.VersionHistoryService" %>
<%@page import="org.dspace.versioning.factory.VersionServiceFactory" %>
<%@ page import="org.dspace.termometro.service.TermometroService" %>
<%@ page import="org.dspace.termometro.factory.TermometroServiceFactory" %>

<%
    // Attributes
    Boolean displayAllBoolean = (Boolean) request.getAttribute("display.all");
    boolean displayAll = (displayAllBoolean != null && displayAllBoolean.booleanValue());
    Boolean suggest = (Boolean)request.getAttribute("suggest.enable");
    boolean suggestLink = (suggest == null ? false : suggest.booleanValue());
    Item item = (Item) request.getAttribute("item");
    List<Collection> collections = (List<Collection>) request.getAttribute("collections");
    Boolean admin_b = (Boolean)request.getAttribute("admin_button");
    boolean admin_button = (admin_b == null ? false : admin_b.booleanValue());
    Boolean submitter_b = (Boolean) request.getAttribute("submitter_button");
    boolean submitter_button = (submitter_b == null ? false : submitter_b.booleanValue());
    // get the workspace id if one has been passed
    Integer workspace_id = (Integer) request.getAttribute("workspace_id");

    // get the handle if the item has one yet
    String handle = item.getHandle();
    Context context = UIUtil.obtainContext(request);

    // get the doi if the item has one
    String doi = (String) request.getAttribute("doi");
    // get the preferred identifier (as URL)
    String preferredIdentifier = (String) request.getAttribute("preferred_identifier");
    // get the latestVersionIdentifier
    String latestVersionIdentifier = (String)request.getAttribute("versioning.latest_version_identifier");

    // CC URL & RDF
    CreativeCommonsService creativeCommonsService = LicenseServiceFactory.getInstance().getCreativeCommonsService();
    String cc_url = creativeCommonsService.getLicenseURL(context, item);
    String cc_rdf = creativeCommonsService.getLicenseRDF(context, item);

    // Full title needs to be put into a string to use as tag argument
    String title = "";
    if (handle == null)
 	{
		title = "Workspace Item";
	}
	else
	{
		List<MetadataValue> titleValue = ContentServiceFactory.getInstance().getItemService().getMetadata(item, "dc", "title", null, Item.ANY);
		if (titleValue.size() != 0)
		{
			title = titleValue.get(0).getValue();
		}
		else
		{
			title = "Item " + handle;
		}
	}

    Boolean versioningEnabledBool = (Boolean)request.getAttribute("versioning.enabled");
    boolean versioningEnabled = (versioningEnabledBool!=null && versioningEnabledBool.booleanValue());
    Boolean hasVersionButtonBool = (Boolean)request.getAttribute("versioning.hasversionbutton");
    Boolean hasVersionHistoryBool = (Boolean)request.getAttribute("versioning.hasversionhistory");
    boolean hasVersionButton = (hasVersionButtonBool!=null && hasVersionButtonBool.booleanValue());
    boolean hasVersionHistory = (hasVersionHistoryBool!=null && hasVersionHistoryBool.booleanValue());

    Boolean newversionavailableBool = (Boolean)request.getAttribute("versioning.newversionavailable");
    boolean newVersionAvailable = (newversionavailableBool!=null && newversionavailableBool.booleanValue());
    Boolean showVersionWorkflowAvailableBool = (Boolean)request.getAttribute("versioning.showversionwfavailable");
    boolean showVersionWorkflowAvailable = (showVersionWorkflowAvailableBool!=null && showVersionWorkflowAvailableBool.booleanValue());

    VersionHistoryService versionHistoryService = VersionServiceFactory.getInstance().getVersionHistoryService();
    VersionHistory history = (VersionHistory)request.getAttribute("versioning.history");
    List<Version> historyVersions = (List<Version>)request.getAttribute("versioning.historyversions");

    TermometroService termometroService = TermometroServiceFactory.getInstance().getTermometroService();
    String pontuacaoTermometro = termometroService.calcularPontuacaoDoItem(item);

%>

<dspace:layout title="<%= title %>">

<div class="search-main">


        <%
            if (admin_button)  // admin edit button
            { %>
                <div class="search-facet">
                <div class="panel panel-warning">
                <div class="panel-heading"><fmt:message key="jsp.admintools"/></div>
                <div class="panel-body">
                    <form method="get" action="<%= request.getContextPath() %>/tools/edit-item">
                        <input type="hidden" name="item_id" value="<%= item.getID() %>" />
                        <input class="btn btn-default col-md-12" type="submit" name="submit" value="<fmt:message key="jsp.general.edit.button"/>" />
                    </form>
                    <form method="post" action="<%= request.getContextPath() %>/mydspace">
                        <input type="hidden" name="item_id" value="<%= item.getID() %>" />
                        <input type="hidden" name="step" value="<%= MyDSpaceServlet.REQUEST_EXPORT_ARCHIVE %>" />
                        <input class="btn btn-default col-md-12" type="submit" name="submit" value="<fmt:message key="jsp.mydspace.request.export.item"/>" />
                    </form>
                    <form method="post" action="<%= request.getContextPath() %>/mydspace">
                        <input type="hidden" name="item_id" value="<%= item.getID() %>" />
                        <input type="hidden" name="step" value="<%= MyDSpaceServlet.REQUEST_MIGRATE_ARCHIVE %>" />
                        <input class="btn btn-default col-md-12" type="submit" name="submit" value="<fmt:message key="jsp.mydspace.request.export.migrateitem"/>" />
                    </form>
                    <form method="post" action="<%= request.getContextPath() %>/dspace-admin/metadataexport">
                        <input type="hidden" name="handle" value="<%= item.getHandle() %>" />
                        <input class="btn btn-default col-md-12" type="submit" name="submit" value="<fmt:message key="jsp.general.metadataexport.button"/>" />
                    </form>
                    <% if(hasVersionButton) { %>
                    <form method="get" action="<%= request.getContextPath() %>/tools/version">
                        <input type="hidden" name="itemID" value="<%= item.getID() %>" />
                        <input class="btn btn-default col-md-12" type="submit" name="submit" value="<fmt:message key="jsp.general.version.button"/>" />
                    </form>
                    <% } %>
                    <% if(hasVersionHistory) { %>
                    <form method="get" action="<%= request.getContextPath() %>/tools/history">
                        <input type="hidden" name="itemID" value="<%= item.getID() %>" />
                        <input type="hidden" name="versionID" value="<%= versionHistoryService.getVersion(context, history, item)!=null?versionHistoryService.getVersion(context, history, item).getID():null %>" />
                        <input class="btn btn-info col-md-12" type="submit" name="submit" value="<fmt:message key="jsp.general.version.history.button"/>" />
                    </form>
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
        <div class="search-facet">
            <div class="panel panel-warning">
                <div class="panel-heading"><fmt:message key="jsp.submittertools"/></div>
                <div class="panel-body">
                    <form method="get" action="<%= request.getContextPath()%>/tools/version">
                        <input type="hidden" name="itemID" value="<%= item.getID()%>" />
                        <input class="btn btn-default col-md-12" type="submit" name="submit" value="<fmt:message key="jsp.general.version.button"/>" />
                    </form>
                </div>
            </div>
        </div>
        <%
            }
        %>

    <div class="search-filter">


        <%-- <strong>Please use this identifier to cite or link to this item:
        <code><%= HandleManager.getCanonicalForm(handle) %></code></strong>--%>
        <div class="well"><fmt:message key="jsp.display-item.identifier"/>
            <code><%= preferredIdentifier %></code></div>

        <ul class="nav nav-pills">
            <li class="nav-item active">
                <a class="nav-link" aria-current="page" href="#" destiny="#item-data"><fmt:message key="webui.displayitem.tab.itemdata"></fmt:message> </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" aria-current="page" href="#" destiny="#item-data-full"><fmt:message key="webui.displayitem.tab.itemdata.complete"></fmt:message> </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#" destiny="#termometro"><fmt:message key="webui.displayitem.tab.termometro"></fmt:message> </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#"  destiny="#formulario"><fmt:message key="webui.displayitem.tab.requestchange"></fmt:message> </a>
            </li>
        </ul>

        <div id="item-data" tabcontent>

            <% String displayStyle = (displayAll ? "full" : ""); %>


            <dspace:item-preview item="<%= item %>" />
            <dspace:item item="<%= item %>" collections="<%= collections %>" style="<%= displayStyle %>" />


        </div>

            <div id="item-data-full" tabcontent>

                <dspace:item-preview item="<%= item %>" />
                <dspace:item item="<%= item %>" collections="<%= collections %>" style="full" />

            </div>


            <div id="termometro" tabcontent>
            <h2>Termômetro</h2>

            <div class="header-termometro">
                <p>
                    <fmt:message key="termometro.display.title"/>
                </p>
            </div>
            <div class="container" id="div-termometro">
                <canvas height=180 id="canvas-termometro" width=340></canvas>
                <p>
                <div id="preview-textfield"></div>
                </p>
            </div>



        </div>

        <div id="formulario" tabcontent class="d-hide">
            <iframe width="800" height="2000" frameborder="0" scrolling="yes" marginheight="0" marginwidth="0" src="https://docs.google.com/forms/d/e/1FAIpQLSfi63n2szjUZo2f_K_9OXh-L71Q8nY1xAULe-d5T082nIO2tQ/viewform">
            </iframe>
        </div>

    </div>
</div>






<style id="style-termometro">

    .header-termometro {
        text-align: center;
        margin-top: 50px;
    }

    .header-termometro p {
        color: #9e1822;
    }

    #div-termometro {
        background: rgba(200, 200, 200, 0.99);
        position: relative;
        color: #fff;
        width: 380px;
        height: 300px;
        margin-bottom: 50px;
        -webkit-border-radius: 10px;
        -moz-border-radius: 10px;
        border-radius: 10px;
        clear: both;
        padding: 0 15px;
    }

    #canvas-termometro {
        width: 380px;
        top: 40px;
        right: 16px;
        position: relative;
    }

    #preview-textfield {
        position: relative;
        padding-top: 20px;
        top: 1px;
        left: 0;
        right: 0;
        text-align: center;
        font-size: 2em;
        font-weight: bold;
        color: black;
        font-family: 'Amaranth', sans-serif;
    }

</style>
<script type="text/javascript" src="<%= request.getContextPath() %>/static/js/gauge/gauge.js"> </script>
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
        termometro.set(<%= pontuacaoTermometro %>);
        termometro.setTextField(document.getElementById("preview-textfield"));
    }

    document.querySelector("#termometro").classList.add("d-hide");
</script>

<script>

    document.querySelectorAll("a[destiny]").forEach(element => {

        element.addEventListener("click", function(){

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

</script>
</dspace:layout>
