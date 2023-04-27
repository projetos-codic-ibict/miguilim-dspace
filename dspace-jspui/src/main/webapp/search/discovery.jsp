<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>

<%--
  - Display the form to refine the simple-search and dispaly the results of the search
  -
  - Attributes to pass in:
  -
  -   scope            - pass in if the scope of the search was a community
  -                      or a collection
  -   scopes 		   - the list of available scopes where limit the search
  -   sortOptions	   - the list of available sort options
  -   availableFilters - the list of filters available to the user
  -
  -   query            - The original query
  -   queryArgs		   - The query configuration parameters (rpp, sort, etc.)
  -   appliedFilters   - The list of applied filters (user input or facet)
  -
  -   search.error     - a flag to say that an error has occurred
  -   spellcheck	   - the suggested spell check query (if any)
  -   qResults		   - the discovery results
  -   items            - the results.  An array of Items, most relevant first
  -   communities      - results, Community[]
  -   collections      - results, Collection[]
  -
  -   admin_button     - If the user is an admin
  --%>

<%@page import="org.dspace.core.Utils" %>
<%@page import="com.coverity.security.Escape" %>
<%@page import="org.dspace.discovery.configuration.DiscoverySearchFilterFacet" %>
<%@page import="org.dspace.app.webui.util.UIUtil" %>
<%@page import="org.dspace.discovery.DiscoverFacetField" %>
<%@page import="org.dspace.discovery.configuration.DiscoverySearchFilter" %>
<%@page import="org.dspace.discovery.DiscoverFilterQuery" %>
<%@page import="org.dspace.discovery.DiscoverQuery" %>
<%@page import="org.apache.commons.lang.StringUtils" %>
<%@page import="org.dspace.discovery.DiscoverResult.FacetResult" %>
<%@page import="org.dspace.discovery.DiscoverResult" %>
<%@page import="org.dspace.content.DSpaceObject" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
           prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"
           prefix="c" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.sort.SortOption" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ page import="org.dspace.content.service.ItemService"%>
<%@ page import="org.dspace.content.factory.ContentServiceFactory"%>
<%@ page import="org.dspace.content.DCDate"%>
<%@ page import="java.util.*" %>
<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="java.text.Collator" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    

    // Get the attributes
    DSpaceObject scope = (DSpaceObject) request.getAttribute("scope");
    String searchScope = scope != null ? scope.getHandle() : "";
    List<DSpaceObject> scopes = (List<DSpaceObject>) request.getAttribute("scopes");
    List<String> sortOptions = (List<String>) request.getAttribute("sortOptions");

    String query = (String) request.getAttribute("query");
    if (query == null) {
        query = "";
    }
    Boolean error_b = (Boolean) request.getAttribute("search.error");
    boolean error = error_b == null ? false : error_b.booleanValue();

    DiscoverQuery qArgs = (DiscoverQuery) request.getAttribute("queryArgs");
    String sortedBy = qArgs.getSortField();
    String order = qArgs.getSortOrder().toString();
    String ascSelected = (SortOption.ASCENDING.equalsIgnoreCase(order) ? "selected=\"selected\"" : "");
    String descSelected = (SortOption.DESCENDING.equalsIgnoreCase(order) ? "selected=\"selected\"" : "");
    String httpFilters = "";
    String spellCheckQuery = (String) request.getAttribute("spellcheck");
    List<DiscoverySearchFilter> availableFilters = (List<DiscoverySearchFilter>) request.getAttribute("availableFilters");
    List<String[]> appliedFilters = (List<String[]>) request.getAttribute("appliedFilters");
    List<String> appliedFilterQueries = (List<String>) request.getAttribute("appliedFilterQueries");
    if (appliedFilters != null && appliedFilters.size() > 0) {
        int idx = 1;
        for (String[] filter : appliedFilters) {
            if (filter == null
                    || filter[0] == null || filter[0].trim().equals("")
                    || filter[2] == null || filter[2].trim().equals("")) {
                idx++;
                continue;
            }
            httpFilters += "&amp;filter_field_" + idx + "=" + URLEncoder.encode(filter[0], "UTF-8");
            httpFilters += "&amp;filter_type_" + idx + "=" + URLEncoder.encode(filter[1], "UTF-8");
            httpFilters += "&amp;filter_value_" + idx + "=" + URLEncoder.encode(filter[2], "UTF-8");
            idx++;
        }
    }
    int rpp = qArgs.getMaxResults();
    int etAl = ((Integer) request.getAttribute("etal")).intValue();

    String[] options = new String[]{"contains", "equals", "authority", "notequals", "notcontains", "notauthority"};

    // Admin user or not
    Boolean admin_b = (Boolean) request.getAttribute("admin_button");
    boolean admin_button = (admin_b == null ? false : admin_b.booleanValue());

    DiscoverResult qResults = (DiscoverResult) request.getAttribute("queryresults");
    List<Item> items = (List<Item>) request.getAttribute("items");
    List<Community> communities = (List<Community>) request.getAttribute("communities");
    List<Collection> collections = ContentServiceFactory.getInstance().getCollectionService().findAll(UIUtil.obtainContext(request));

    ItemService itemService = ContentServiceFactory.getInstance().getItemService();
    HttpServletRequest hrq = (HttpServletRequest) pageContext.getRequest();


    final String REVISTAS = "miguilim/2";
	final String PORTAL_DE_PERIODICOS = "miguilim/2669";
%>

<c:set var="dspace.layout.head.last" scope="request">
    <script type='text/javascript' src='<%= request.getContextPath() %>/static/js/facet-handle.js'></script>
    <script type="text/javascript">
        var jQ = jQuery.noConflict();
        jQ(document).ready(function () {
            jQ("#spellCheckQuery").click(function () {
                jQ("#query").val(jQ(this).attr('data-spell'));
                jQ("#main-query-submit").click();
            });
            jQ("#filterquery")
                .autocomplete({
                    source: function (request, response) {
                        jQ.ajax({
                            url: "<%= request.getContextPath() %>/json/discovery/autocomplete?query=<%= URLEncoder.encode(query,"UTF-8")%><%= httpFilters.replaceAll("&amp;","&") %>",
                            dataType: "json",
                            cache: false,
                            data: {
                                auto_idx: jQ("#filtername").val(),
                                auto_query: request.term,
                                auto_sort: 'count',
                                auto_type: jQ("#filtertype").val(),
                                location: '<%= searchScope %>'
                            },
                            success: function (data) {
                                response(jQ.map(data.autocomplete, function (item) {
                                    var tmp_val = item.authorityKey;
                                    if (tmp_val == null || tmp_val == '') {
                                        tmp_val = item.displayedValue;
                                    }
                                    return {
                                        label: item.displayedValue + " (" + item.count + ")",
                                        value: tmp_val
                                    };
                                }))
                            }
                        })
                    }
                });
        });

        function validateFilters() {
            return document.getElementById("filterquery").value.length > 0;
        }
    </script>
</c:set>

<dspace:layout titlekey="jsp.search.title">

    <div class="search-main">


        <%
            boolean brefine = false;

            List<DiscoverySearchFilterFacet> facetsConf = (List<DiscoverySearchFilterFacet>) request.getAttribute("facetsConfig");
            Map<String, Boolean> showFacets = new HashMap<String, Boolean>();

            for (DiscoverySearchFilterFacet facetConf : facetsConf)
            {
                if (qResults != null) {
                    String f = facetConf.getIndexFieldName();
                    List<FacetResult> facet = qResults.getFacetResult(f);
                    if (facet.size() == 0) {
                        facet = qResults.getFacetResult(f + ".year");
                        if (facet.size() == 0) {
                            showFacets.put(f, false);
                            continue;
                        }
                    }
                    boolean showFacet = false;
                    for (FacetResult fvalue : facet) {
                        if (!appliedFilterQueries.contains(f + "::" + fvalue.getFilterType() + "::" + fvalue.getAsFilterQuery())) {
                            showFacet = true;
                            break;
                        }
                    }
                    showFacets.put(f, showFacet);
                    brefine = brefine || showFacet;
                }
            }
            if (brefine)
            {
        %>
                <div class="search-content">
                    <h3><fmt:message key="jsp.search.facet.refine"/></h3>

                    <%
                        for (DiscoverySearchFilterFacet facetConf : facetsConf)
                        {
                            String f = facetConf.getIndexFieldName();
                            if (!showFacets.get(f))
                                continue;
                            List<FacetResult> facet = qResults.getFacetResult(f);
                            if (facet.size() == 0) {
                                facet = qResults.getFacetResult(f + ".year");
                            }
                            int limit = facetConf.getFacetLimit() + 1;

                            String fkey = "jsp.search.facet.refine." + f;
                    %>
                            <div class="accordion-body kk1">

                                <div class="accordion-header collapsed" data-toggle="collapse" href="#facet_<%= f %>" role="button" aria-expanded="false" aria-controls="facet_<%= f %>">
                                    <span><fmt:message key="<%= fkey %>"/></span>
                                </div> 
                                <div class="collapse" id="facet_<%= f %>">
                                    <ul class="accordion-content">
                                        <%
                                            int idx = 1;
                                            int currFp = UIUtil.getIntParameter(request, f + "_page");
                                            if (currFp < 0) {
                                                currFp = 0;
                                            }
                                            for (FacetResult fvalue : facet)
                                            {
                                                if (idx != limit && !appliedFilterQueries.contains(f + "::" + fvalue.getFilterType() + "::" + fvalue.getAsFilterQuery())) 
                                                {
                                        %>
                                        <li>
                                            <a href="<%= request.getContextPath()
                                                                                                                        + (!searchScope.equals("")?"/handle/"+searchScope:"")
                                                                                                + "/simple-search?query="
                                                                                                + URLEncoder.encode(query,"UTF-8")
                                                                                                + "&amp;sort_by=" + sortedBy
                                                                                                + "&amp;order=" + order
                                                                                                + "&amp;rpp=" + rpp
                                                                                                + httpFilters
                                                                                                + "&amp;etal=" + etAl
                                                                                                + "&amp;filtername="+URLEncoder.encode(f,"UTF-8")
                                                                                                + "&amp;filterquery="+URLEncoder.encode(fvalue.getAsFilterQuery(),"UTF-8")
                                                                                                + "&amp;filtertype="+URLEncoder.encode(fvalue.getFilterType(),"UTF-8") %>"
                                            title="<fmt:message key="jsp.search.facet.narrow"><fmt:param><%=fvalue.getDisplayedValue() %></fmt:param></fmt:message>">
                                                <%= StringUtils.abbreviate(fvalue.getDisplayedValue(), 36) %>
                                            </a>
                                            <a class="number-a" href="#"><%= fvalue.getCount() %></a>

                                        </li>
                                        <%
                                                    idx++;
                                                }
                                                if (idx > limit) {
                                                    break;
                                                }
                                            }
                                            if (currFp > 0 || idx == limit) 
                                            {
                                        %>
                                        <li class="list-group-item"><span style="visibility: hidden;">.</span>
                                            <% if (currFp > 0) { %>
                                            <a class="pull-left" href="<%= request.getContextPath()
                                                                                                                                + (!searchScope.equals("")?"/handle/"+searchScope:"")
                                                                                                    + "/simple-search?query="
                                                                                                    + URLEncoder.encode(query,"UTF-8")
                                                                                                    + "&amp;sort_by=" + sortedBy
                                                                                                    + "&amp;order=" + order
                                                                                                    + "&amp;rpp=" + rpp
                                                                                                    + httpFilters
                                                                                                    + "&amp;etal=" + etAl
                                                                                                    + "&amp;"+f+"_page="+(currFp-1) %>"><fmt:message key="jsp.search.facet.refine.previous"/></a>
                                            <% } %>
                                            <%
                                                if (idx == limit)
                                                {
                                            %>
                                            <a href="<%= request.getContextPath()
                                                                                                                    + (!searchScope.equals("")?"/handle/"+searchScope:"")
                                                                                                    + "/simple-search?query="
                                                                                                    + URLEncoder.encode(query,"UTF-8")
                                                                                                    + "&amp;sort_by=" + sortedBy
                                                                                                    + "&amp;order=" + order
                                                                                                    + "&amp;rpp=" + rpp
                                                                                                    + httpFilters
                                                                                                    + "&amp;etal=" + etAl
                                                                                                    + "&amp;"+f+"_page="+(currFp+1) %>">
                                                <span class="pull-right"><fmt:message key="jsp.search.facet.refine.next"/></span>
                                            </a>
                                        <%
                                                }
                                        %>
                                        </li>
                                        <%
                                            }
                                        %>
                                    </ul>
                                </div>
                            </div>
                    <%
                        }
                    %>

                </div>
        <%  } 
            else
            {
        %>
                <div class="search-content">
                    <h3><fmt:message key="jsp.search.facet.refine"/></h3>
                    <div class="accordion-body kk2">
                      
                    </div>
                </div>
        <%
            }
        %>
       
       

        <div class="search-filter">
            <h3><fmt:message key="jsp.search.results.searchin.header"></fmt:message></h3>
            
            <%
            if (qResults != null && qResults.getTotalSearchResults() == 0) 
            {
            %>
                <p align="center"><fmt:message key="jsp.search.general.noresults"/></p>
            <%
            } 
            %>
            
            <div class="search-element searchfilter">
                <div class="accordion-header" data-toggle="collapse" href="#searchAccordion" role="button"
                     aria-expanded="false" aria-controls="searchAccordion">
                    <span><fmt:message key="jsp.search.results.searchin"></fmt:message></span>
                </div>
                <div class="in" id="searchAccordion">
                    <form action="simple-search" method="get">

                        <input type="hidden" value="<%= rpp %>" name="rpp"/>
                        <input type="hidden" value="<%= sortedBy %>" name="sort_by"/>
                        <input type="hidden" value="<%= order %>" name="order"/>

                        <!-- Primeira linha -->
                        <div class="grid-col-3 space-double">
                            <div>
                                <select name="location" id="tlocation" class="field-s w100">
                                        <%
                                            if (scope == null) {
                                                // Scope of the search was all of DSpace.  The scope control will list
                                                // "all of DSpace" and the communities.
                                        %>
                                            <%-- <option selected value="/">All of DSpace</option> --%>
                                            <option selected="selected" value="/"><fmt:message
                                                    key="jsp.general.genericScope"/></option>
                                            <% } else {
                                            %>
                                            <option value="/"><fmt:message key="jsp.general.genericScope"/></option>
                                            <% }
                                                for (DSpaceObject dso : collections) {
                                            %>
                                            <option value="<%= dso.getHandle() %>" <%=dso.getHandle().equals(searchScope) ? "selected=\"selected\"" : "" %>>
                                                <%= dso.getName() %>
                                            </option>
                                        <%
                                            }
                                        %>
                                </select>
                            </div>
                            <div>
                                <input type="text" class="field-s w100" id="query" name="query"
                                       value="<%= (query==null ? "" : StringEscapeUtils.escapeHtml(query)) %>"
                                       class="field-s"
                                       placeholder="<fmt:message key="jsp.search.results.searchfor"/>">
                            </div>
                            <div>
                                <button type="submit" class="button-main">&nbsp;&nbsp;<fmt:message key="jsp.general.go"/>&nbsp;</button>
                            </div>
                        </div>
                        <br>

                        <input type="hidden" value="<%= rpp %>" name="rpp" />
                        <input type="hidden" value="<%= Utils.addEntities(sortedBy) %>" name="sort_by" />
                        <input type="hidden" value="<%= Utils.addEntities(order) %>" name="order" />


                        <!-- filtros já utilizados -->
                        <% if (appliedFilters.size() > 0) { %>


                                        <%
                                            int idx = 1;
                                            for (String[] filter : appliedFilters)
                                            {
                                                boolean found = false;
                                            %>
                                            <div class="grid-col-2">
                                                <div>
                                                    <select id="filter_field_<%=idx %>" name="filter_field_<%=idx %>" class="field-s w100">
                                                        <%
                                                            for (DiscoverySearchFilter searchFilter : availableFilters) {
                                                                String fkey = "jsp.search.filter." + searchFilter.getIndexFieldName();
                                                        %>
                                                        <option value="<%= searchFilter.getIndexFieldName() %>"<%
                                                            if (filter[0].equals(searchFilter.getIndexFieldName())) {
                                                        %> selected="selected"<%
                                                                found = true;
                                                            }
                                                        %>><fmt:message key="<%= fkey %>"/></option>
                                                        <%
                                                            }
                                                            if (!found) {
                                                                String fkey = "jsp.search.filter." + filter[0];
                                                        %>
                                                        <option value="<%= filter[0] %>" selected="selected"><fmt:message
                                                                key="<%= fkey %>"/></option>
                                                        <%
                                                            }
                                                        %>
                                                    </select>
                                                </div>

                                                <div>
                                                    <select id="filter_type_<%=idx %>" name="filter_type_<%=idx %>" class="field-s w100">
                                                        <%
                                                            for (String opt : options) {
                                                                String fkey = "jsp.search.filter.op." + opt;
                                                        %>
                                                        <option value="<%= opt %>"<%= opt.equals(filter[1]) ? " selected=\"selected\"" : "" %>>
                                                            <fmt:message key="<%= fkey %>"/></option>
                                                        <%
                                                            }
                                                        %>
                                                    </select>
                                                </div>

                                                <div class="space-b">
                                                    <input type="text" id="filter_value_<%=idx %>" name="filter_value_<%=idx %>"
                                                           value="<%= StringEscapeUtils.escapeHtml(filter[2]) %>" class="field-s w100"/>
                                                </div>
                                                <div>
<%--
                                                    <button type="submit" class="button-main-outline"><fmt:message key="jsp.general.go"/></button>
--%>
                                                    <button type="submit" class="button-main-outline" id="submit_filter_remove_<%=idx %>" name="submit_filter_remove_<%=idx %>">Remover</button>
                                                </div>
                                            </div>
                        <%
                                idx++;
                            }
                        %>
                        <% } %>

                        <!-- fim já utilizados -->


                    </form>
                    <hr>
                    <% if (StringUtils.isNotBlank(spellCheckQuery)) {%>
                    <br/>
                    <p class="lead white-font"><fmt:message key="jsp.search.didyoumean"><fmt:param><a class="white-font"
                                                                                                      id="spellCheckQuery"
                                                                                                      data-spell="<%= Utils.addEntities(spellCheckQuery) %>"
                                                                                                      href="#"><%= spellCheckQuery %>
                    </a></fmt:param></fmt:message></p>
                    <% } %>

                    <% if (availableFilters.size() > 0) { %>

                    <form action="simple-search" method="get">

                        <input type="hidden" value="<%= StringEscapeUtils.escapeHtml(searchScope) %>" name="location"/>
                        <input type="hidden" value="<%= StringEscapeUtils.escapeHtml(query) %>" name="query"/>
                        <% if (appliedFilterQueries.size() > 0) {
                            int idx = 1;
                            for (String[] filter : appliedFilters) {
                                boolean found = false;
                        %>
                        <input type="hidden" id="filter_field_<%=idx %>" name="filter_field_<%=idx %>"
                               value="<%= filter[0] %>"/>
                        <input type="hidden" id="filter_type_<%=idx %>" name="filter_type_<%=idx %>"
                               value="<%= filter[1] %>"/>
                        <input type="hidden" id="filter_value_<%=idx %>" name="filter_value_<%=idx %>"
                               value="<%= StringEscapeUtils.escapeHtml(filter[2]) %>"/>
                        <%
                                    idx++;
                                }
                            } %>
                        <!-- Primeira linha -->
                        <div class="grid-col-2b">
                            <div>
                                <div id="tool" class="fieldAuxiliary deletar">
                                    <p></p>
                                </div>                                
                                <select id="filtername" name="filtername" class="field-s w100">
                                    <%
                                        Collator instance = Collator.getInstance();

                                        // This strategy mean it'll ignore the accents
                                        instance.setStrength(Collator.NO_DECOMPOSITION);
                                    Collections.sort(availableFilters, new Comparator<DiscoverySearchFilter>() {
                                        @Override
                                        public int compare(DiscoverySearchFilter t0, DiscoverySearchFilter t1) {
                                            return instance.compare(I18nUtil.getMessage("jsp.search.filter." + t0.getIndexFieldName()),
                                                    I18nUtil.getMessage("jsp.search.filter." + t1.getIndexFieldName()));
                                        }
                                    });
                                        for (DiscoverySearchFilter searchFilter : availableFilters) {
                                            String fkey = "jsp.search.filter." + searchFilter.getIndexFieldName();
                                    %>
                                    <option value="<%= searchFilter.getIndexFieldName() %>"><fmt:message
                                            key="<%= fkey %>"/></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                            <div>
                                <select id="filtertype" name="filtertype" class="field-s w100">
                                    <%
                                        for (String opt : options) {
                                            String fkey = "jsp.search.filter.op." + opt;
                                    %>
                                    <option value="<%= opt %>"><fmt:message key="<%= fkey %>"/></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                            <div>

                                <input type="text" id="filterquery" name="filterquery" class="field-s w100"
                                       placeholder="Escolha por"/>
                                <input type="hidden" value="<%= rpp %>" name="rpp" />
                                <input type="hidden" value="<%= Utils.addEntities(sortedBy) %>" name="sort_by" />
                                <input type="hidden" value="<%= Utils.addEntities(order) %>" name="order" />

                            </div>
                            <div>
                                <button type="submit" class="button-main-outline" type="submit"><fmt:message
                                        key="jsp.search.filter.add"/></button>

                            </div>
                        </div>
                        <!--p class="lead white-font">Did you mean: <b><i><a class="white-font" id="spellCheckQuery" data-spell="sds" href="#"-->
                        </a></i></b></p>

                    </form>

                </div>
                <% } %>

            </div>

            <!-- Controles adicionais -->
            <div class="search-element searchfilter spacing-element">
                <form action="simple-search" method="get">
                    <input type="hidden" value="<%= Utils.addEntities(searchScope) %>" name="location" />
                    <input type="hidden" value="<%= Utils.addEntities(query) %>" name="query" />
                    <% if (appliedFilterQueries.size() > 0 ) {
                        int idx = 1;
                        for (String[] filter : appliedFilters)
                        {
                            boolean found = false;
                    %>
                    <input type="hidden" id="filter_field_<%=idx %>" name="filter_field_<%=idx %>" value="<%= Utils.addEntities(filter[0]) %>" />
                    <input type="hidden" id="filter_type_<%=idx %>" name="filter_type_<%=idx %>" value="<%= Utils.addEntities(filter[1]) %>" />
                    <input type="hidden" id="filter_value_<%=idx %>" name="filter_value_<%=idx %>" value="<%= Utils.addEntities(filter[2]) %>" />
                    <%
                                idx++;
                            }
                        } %>
                    <div class="result-pagination">
                        <div>
                            <label for="rpp"><fmt:message key="search.results.perpage"/></label>
                            <select name="rpp" id="rpp" class="field-s w100">
                        <%
                            for (int i = 5; i <= 100 ; i += 5)
                            {
                                String selected = (i == rpp ? "selected=\"selected\"" : "");
                        %>
                        <option value="<%= i %>" <%= selected %>><%= i %></option>
                        <%
                            }
                        %>
                    </select>
                        </div>

                        <div>
                            <label for="sort_by"><fmt:message key="search.results.sort-by"/></label>
                            <select name="sort_by" id="sort_by" class="field-s w100">
                                <option value="score"><fmt:message key="search.sort-by.relevance"/></option>
                                <%
                                    for (String sortBy : sortOptions)
                                    {
                                        String selected = (sortBy.equals(sortedBy) ? "selected=\"selected\"" : "");
                                        String mKey = "search.sort-by." + Utils.addEntities(sortBy);
                                %> <option value="<%= Utils.addEntities(sortBy) %>" <%= selected %>><fmt:message key="<%= mKey %>"/></option><%
                                }
                            %>
                            </select>

                        </div>

                        <div>
                            <label for="order"><fmt:message key="search.results.order"/></label>
                            <select name="order" id="order" class="field-s w100">
                                <option value="ASC" <%= ascSelected %>><fmt:message key="search.order.asc" /></option>
                                <option value="DESC" <%= descSelected %>><fmt:message key="search.order.desc" /></option>
                            </select>
                        </div>



                        <div>
                            <input class="button-main-outline" type="submit" name="submit_search" value="<fmt:message key="search.update" />" />

                            <%
                                if (admin_button)
                                {
                            %><input type="submit" class="button-main" name="submit_export_metadata" value="<fmt:message key="jsp.general.metadataexport.button"/>" /><%
                            }
                        %>
                        </div>

                    </div>

                </form>
            </div>


            <%
                
                if (qResults != null && qResults.getTotalSearchResults() > 0) 
                {
                    long pageTotal = ((Long) request.getAttribute("pagetotal")).longValue();
                    long pageCurrent = ((Long) request.getAttribute("pagecurrent")).longValue();
                    long pageLast = ((Long) request.getAttribute("pagelast")).longValue();
                    long pageFirst = ((Long) request.getAttribute("pagefirst")).longValue();

                    // create the URLs accessing the previous and next search result pages
                    String baseURL = request.getContextPath()
                            + (!searchScope.equals("") ? "/handle/" + searchScope : "")
                            + "/simple-search?query="
                            + URLEncoder.encode(query, "UTF-8")
                            + httpFilters
                            + "&amp;sort_by=" + sortedBy
                            + "&amp;order=" + order
                            + "&amp;rpp=" + rpp
                            + "&amp;etal=" + etAl
                            + "&amp;start=";

                    String nextURL = baseURL;
                    String firstURL = baseURL;
                    String lastURL = baseURL;

                    String prevURL = baseURL
                            + (pageCurrent - 2) * qResults.getMaxResults();

                    nextURL = nextURL
                            + (pageCurrent) * qResults.getMaxResults();

                    firstURL = firstURL + "0";
                    lastURL = lastURL + (pageTotal - 1) * qResults.getMaxResults();

                    long lastHint = qResults.getStart() + qResults.getMaxResults() <= qResults.getTotalSearchResults() ?
                            qResults.getStart() + qResults.getMaxResults() : qResults.getTotalSearchResults();
            %>


            <div class="pagination-number">
                <div class="pagination-number-itens">
                    <ol class="pagination-number-itens">
                        <li class="results">
                            <fmt:message key="jsp.search.results.results">
                                <fmt:param><%=qResults.getStart() + 1%>
                                </fmt:param>
                                <fmt:param><%=lastHint%>
                                </fmt:param>
                                <fmt:param><%=qResults.getTotalSearchResults()%>
                                </fmt:param>
                                <fmt:param><%=(float) qResults.getSearchTime() / 1000 %>
                                </fmt:param>
                            </fmt:message>
                        </li>

                        <%
                            if (pageFirst != pageCurrent) 
                            {
                        %>
                                <li>
                                    <a class="first-pagination" href="<%= prevURL %>">
                                        <fmt:message key="jsp.search.general.previous"/>
                                    </a>
                                </li>
                        <%
                            } 
                            else 
                            {
                        %>
                                <li>
                                    <a class="first-pagination">
                                        <fmt:message key="jsp.search.general.previous"/>
                                    </a>
                                </li>
                        <%
                            }

                            if (pageFirst != 1) 
                            {
                        %>
                            <li><a href="<%= firstURL %>">1</a></li>
                            <li class="disabled"><span>...</span></li>
                        <%
                            }

                            for (long q = pageFirst; q <= pageLast; q++) 
                            {
                                String myLink = "<li><a href=\""
                                        + baseURL;

                                if (q == pageCurrent) 
                                {
                                    myLink = "<li class=\"active\"><a>" + q + "</a></li>";
                                } 
                                else 
                                {
                                    myLink = myLink
                                            + (q - 1) * qResults.getMaxResults()
                                            + "\">"
                                            + q
                                            + "</a></li>";
                                }
                        %>

                        <%= myLink %>

                        <%
                            }

                            if (pageTotal > pageLast) 
                            {
                        %>
                                <li class="disabled"><span>...</span></li>
                                <li><a href="<%= lastURL %>"><%= pageTotal %></a></li>
                        <%
                            }
                            if (pageTotal > pageCurrent) 
                            {
                        %>
                                <li><a href="<%= nextURL %>"><fmt:message key="jsp.search.general.next"/></a></li>
                        <%
                            } 
                            else 
                            {
                        %>
                                <li class="disabled"><span><fmt:message key="jsp.search.general.next"/></span></li>
                        <%
                            }
                        %>
                    </ol>
                </div>
            </div>
            <%  }  %>

            <% 
                if (items != null && items.size() > 0)
                { 
            %>
                    <div class="results-cards">
                        <%
                            for (Item item : items) 
                            {
                                String titulo = itemService.getMetadataFirstValue(item, "dc", "title", null, Item.ANY);
                                if (titulo == null)
                                {
                                    titulo = "Untitled";
                                }

                                String subtitulo = itemService.getMetadataFirstValue(item, "dc", "identifier", "issn", Item.ANY);
                                if (subtitulo == null)
                                {
                                    subtitulo = "";
                                }

                                String editora = itemService.getMetadataFirstValue(item, "dc", "publisher", "name", Item.ANY);
                                if (editora == null)
                                {
                                    editora = "";
                                }

                                DCDate dataPublicacao = new DCDate(itemService.getMetadataFirstValue(item, "dc", "date", "available", Item.ANY));

                                String dataPublicacaoFormatada = null;
                                if (dataPublicacao.toDate() == null)
                                {
                                	// Data default definida pela equipe do IBICT.
                                    dataPublicacaoFormatada = "15-Jul-2022";
                                }
                                else
                                {
                                	dataPublicacaoFormatada = UIUtil.displayDate(dataPublicacao, false, false, hrq);
                                }
                                
                                String dataAtualizacaoFormatada = null;
                                String dataAtualizacao = itemService.getMetadataFirstValue(item, "dc", "date", "update", Item.ANY);
                                String[] partesData = dataAtualizacao.split(" ");
                                
                                if(partesData.length > 2)
                                {
                                	SimpleDateFormat formatoData = new SimpleDateFormat("dd/MM/yyyy"); 

                                	DCDate data = new DCDate(formatoData.parse(partesData[0]));
                                	dataAtualizacaoFormatada = UIUtil.displayDate(data, false, false, hrq);
                                }
                              
                                String url = itemService.getMetadataFirstValue(item, "dc", "identifier", "url", Item.ANY);
                                String handleCollection = item.getCollections().get(0).getHandle();
                        %>

                                <div class="cards">
                                    <h3 onclick="location.href = '<%= request.getContextPath() %>/handle/<%= item.getHandle() %>'" style="cursor:pointer"><%= titulo %></h3>
                                    <h2><%= editora %></h2>
                                    <div class="group-footer">
                                        <div class="info">
                                            <div class="kind">
                                                <%
                                                    if(handleCollection.equals(REVISTAS)) 
                                                    {
                                                %>
                                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                                <path fill-rule="evenodd" clip-rule="evenodd" d="M6.5 18C6.10218 18 5.72064 18.158 5.43934 18.4393C5.15804 18.7206 5 19.1022 5 19.5C5 20.0523 4.55228 20.5 4 20.5C3.44772 20.5 3 20.0523 3 19.5C3 18.5717 3.36875 17.6815 4.02513 17.0251C4.6815 16.3687 5.57174 16 6.5 16H20C20.5523 16 21 16.4477 21 17C21 17.5523 20.5523 18 20 18H6.5Z" fill="#071D41"/>
                                                <path fill-rule="evenodd" clip-rule="evenodd" d="M6.5 3C6.10218 3 5.72064 3.15804 5.43934 3.43934C5.15804 3.72064 5 4.10218 5 4.5V19.5C5 19.8978 5.15804 20.2794 5.43934 20.5607C5.72064 20.842 6.10218 21 6.5 21H19V3H6.5ZM6.5 1H20C20.5523 1 21 1.44772 21 2V22C21 22.5523 20.5523 23 20 23H6.5C5.57174 23 4.6815 22.6313 4.02513 21.9749C3.36875 21.3185 3 20.4283 3 19.5V4.5C3 3.57174 3.36875 2.6815 4.02513 2.02513C4.6815 1.36875 5.57174 1 6.5 1Z" fill="#071D41"/>
                                                </svg>
                                                <span>Revista</span>
                                                <%
                                                    } 
                                                    else if(handleCollection.equals(PORTAL_DE_PERIODICOS)) 
                                                    {
                                                %>
                                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                                <path d="M3.614 21C3.284 21 2.944 20.91 2.654 20.75C2.354 20.59 2.104 20.35 1.924 20.06C1.744 19.77 1.644 19.43 1.624 19.09C1.604 18.75 1.684 18.41 1.834 18.1L3.004 15.76V7C3.004 6.2 3.314 5.45 3.884 4.88C4.454 4.31 5.204 4 6.004 4H18.004C18.804 4 19.564 4.31 20.124 4.88C20.694 5.44 21.004 6.2 21.004 7V15.76L22.174 18.1C22.324 18.4 22.404 18.74 22.384 19.08C22.364 19.43 22.264 19.76 22.084 20.05C21.904 20.34 21.644 20.59 21.344 20.75C21.054 20.92 20.714 21 20.374 21H3.624C3.614 21 3.614 21 3.614 21ZM4.614 17L3.614 19H20.384L19.384 17H4.614ZM5.004 15H19.004V7C19.004 6.73 18.904 6.48 18.714 6.29C18.524 6.1 18.264 6 18.004 6H6.004C5.734 6 5.484 6.11 5.294 6.29C5.104 6.48 5.004 6.74 5.004 7V15Z" fill="#071D41"/>
                                                </svg>
                                                <span>Portal de revistas</span>
                                                <%
                                                    }
                                                %>
                                            </div>

                                            <% if(subtitulo != null && !subtitulo.isEmpty()) { %><div class="line"></div><div class="kind"><strong>ISSN:</strong> <%= subtitulo %></div><% } %>

                                        </div>
                                        <div class="bt">
                                            <div>
                                                <strong>Registrado em:</strong> <%= dataPublicacaoFormatada %><br/>
                                                <%
                                                    if(dataAtualizacaoFormatada != null) 
                                                    {
                                                %>
                                                    <strong>Atualizado em:</strong> <%= dataAtualizacaoFormatada %>
                                                 <%
                                                    } 
                                                %>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                        <%
                            }
                        %>

                        <%
                            if (error) 
                            {
                        %>
                            <p align="center" class="submitFormWarn">
                                <fmt:message key="jsp.search.error.discovery"/>
                            </p>
                        <%
                            } 
                        %>
                    </div>
            <%    
                } 
            %>
                    

            <%
            if (qResults != null) {
                    long pageTotal = ((Long) request.getAttribute("pagetotal")).longValue();
                    long pageCurrent = ((Long) request.getAttribute("pagecurrent")).longValue();
                    long pageLast = ((Long) request.getAttribute("pagelast")).longValue();
                    long pageFirst = ((Long) request.getAttribute("pagefirst")).longValue();

                    // create the URLs accessing the previous and next search result pages
                    String baseURL = request.getContextPath()
                    + (!searchScope.equals("") ? "/handle/" + searchScope : "")
                    + "/simple-search?query="
                    + URLEncoder.encode(query, "UTF-8")
                    + httpFilters
                    + "&amp;sort_by=" + sortedBy
                    + "&amp;order=" + order
                    + "&amp;rpp=" + rpp
                    + "&amp;etal=" + etAl
                    + "&amp;start=";

                    String nextURL = baseURL;
                    String firstURL = baseURL;
                    String lastURL = baseURL;

                    String prevURL = baseURL
                    + (pageCurrent - 2) * qResults.getMaxResults();

                    nextURL = nextURL
                    + (pageCurrent) * qResults.getMaxResults();

                    firstURL = firstURL + "0";
                    lastURL = lastURL + (pageTotal - 1) * qResults.getMaxResults();

                    long lastHint = qResults.getStart() + qResults.getMaxResults() <= qResults.getTotalSearchResults() ?
                    qResults.getStart() + qResults.getMaxResults() : qResults.getTotalSearchResults();


            %>
            <div class="pagination-number">

                    <%-- <p align="center">Results <//%=qResults.getStart()+1%>-<//%=qResults.getStart()+qResults.getHitHandles().size()%> of --%>
                <div class="pagination-number-itens">
                    <ol class="pagination-number-itens">

                        <li class="results">
                            <fmt:message key="jsp.search.results.results">
                                <fmt:param><%=qResults.getStart() + 1%>
                                </fmt:param>
                                <fmt:param><%=lastHint%>
                                </fmt:param>
                                <fmt:param><%=qResults.getTotalSearchResults()%>
                                </fmt:param>
                                <fmt:param><%=(float) qResults.getSearchTime() / 1000 %>
                                </fmt:param>
                            </fmt:message>
                        </li>

                        <%
                            if (pageFirst != pageCurrent) {
                        %>
                        <li><a  class="first-pagination" href="<%= prevURL %>">
                            <!--svg class="color-svg" width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path fill-rule="evenodd" clip-rule="evenodd" d="M9.52858 6.19526C9.78892 5.93491 10.211 5.93491 10.4714 6.19526L13.8047 9.5286C14.0651 9.78894 14.0651 10.2111 13.8047 10.4714L10.4714 13.8047C10.211 14.0651 9.78892 14.0651 9.52858 13.8047C9.26823 13.5444 9.26823 13.1223 9.52858 12.8619L12.3905 10L9.52858 7.13807C9.26823 6.87772 9.26823 6.45561 9.52858 6.19526Z" fill="svg"></path>
                                <path fill-rule="evenodd" clip-rule="evenodd" d="M2.66667 2C3.03486 2 3.33333 2.29848 3.33333 2.66667V7.33333C3.33333 7.86377 3.54405 8.37247 3.91912 8.74755C4.29419 9.12262 4.8029 9.33333 5.33333 9.33333H13.3333C13.7015 9.33333 14 9.63181 14 10C14 10.3682 13.7015 10.6667 13.3333 10.6667H5.33333C4.44928 10.6667 3.60143 10.3155 2.97631 9.69036C2.35119 9.06523 2 8.21739 2 7.33333V2.66667C2 2.29848 2.29848 2 2.66667 2Z" fill="svg"></path>
                            </svg-->
                            <fmt:message key="jsp.search.general.previous"/></a></li>
                        <%
                        } else {
                        %>
                        <li><a  class="first-pagination"><!--svg class="color-svg" width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path fill-rule="evenodd" clip-rule="evenodd" d="M9.52858 6.19526C9.78892 5.93491 10.211 5.93491 10.4714 6.19526L13.8047 9.5286C14.0651 9.78894 14.0651 10.2111 13.8047 10.4714L10.4714 13.8047C10.211 14.0651 9.78892 14.0651 9.52858 13.8047C9.26823 13.5444 9.26823 13.1223 9.52858 12.8619L12.3905 10L9.52858 7.13807C9.26823 6.87772 9.26823 6.45561 9.52858 6.19526Z" fill="svg"></path>
                                <path fill-rule="evenodd" clip-rule="evenodd" d="M2.66667 2C3.03486 2 3.33333 2.29848 3.33333 2.66667V7.33333C3.33333 7.86377 3.54405 8.37247 3.91912 8.74755C4.29419 9.12262 4.8029 9.33333 5.33333 9.33333H13.3333C13.7015 9.33333 14 9.63181 14 10C14 10.3682 13.7015 10.6667 13.3333 10.6667H5.33333C4.44928 10.6667 3.60143 10.3155 2.97631 9.69036C2.35119 9.06523 2 8.21739 2 7.33333V2.66667C2 2.29848 2.29848 2 2.66667 2Z" fill="svg"></path>
                            </svg--><fmt:message key="jsp.search.general.previous"/></a></li>
                        <%
                            }

                            if (pageFirst != 1) {
                        %>
                        <li><a href="<%= firstURL %>">1</a></li>
                        <li class="disabled"><span>...</span></li>
                        <%
                            }

                            for (long q = pageFirst; q <= pageLast; q++) {
                                String myLink = "<li><a href=\""
                                        + baseURL;


                                if (q == pageCurrent) {
                                    myLink = "<li class=\"active\"><a>" + q + "</a></li>";
                                } else {
                                    myLink = myLink
                                            + (q - 1) * qResults.getMaxResults()
                                            + "\">"
                                            + q
                                            + "</a></li>";
                                }
                        %>

                        <%= myLink %>

                        <%
                            }

                            if (pageTotal > pageLast) {
                        %>
                        <li class="disabled"><span>...</span></li>
                        <li><a href="<%= lastURL %>"><%= pageTotal %>
                        </a></li>
                        <%
                            }
                            if (pageTotal > pageCurrent) {
                        %>
                        <li><a href="<%= nextURL %>"><fmt:message key="jsp.search.general.next"/></a></li>
                        <%
                        } else {
                        %>
                        <li class="disabled"><span><fmt:message key="jsp.search.general.next"/></span></li>
                        <%
                            }
                        %>
                    </ol>


                </div>
            </div>

            <% }%>
        </div>

</dspace:layout>

<script>
    const selectField = document.getElementById('filtername');
    var elem = document.querySelector('#tool'); 

    function showDiv() {
        elem.classList.remove('deletar');
        const selectedValue = selectField.options[selectField.selectedIndex].text;
        elem.innerText = selectedValue;  
    }

    function hideDiv() {
        elem.classList.add('deletar');
        const selectedValue = selectField.options[selectField.selectedIndex].text;
        elem.innerText = selectedValue;         
    }

    selectField.onmouseover = showDiv;
    selectField.onmouseleave = hideDiv;
    
</script>