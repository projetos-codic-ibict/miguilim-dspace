<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="javax.servlet.jsp.PageContext" %>

<%@ page import="org.dspace.app.webui.servlet.admin.AuthorizeAdminServlet" %>
<%@ page import="org.dspace.app.webui.servlet.admin.EditItemServlet" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.core.Utils" %>
<%@ page import="org.dspace.content.authority.service.MetadataAuthorityService" %>
<%@ page import="org.dspace.content.authority.service.ChoiceAuthorityService" %>
<%@ page import="org.dspace.content.authority.Choices" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="java.util.*" %>
<%@ page import="org.dspace.content.authority.service.MetadataAuthorityService" %>
<%@ page import="org.dspace.content.*" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.authority.factory.ContentAuthorityServiceFactory" %>
<%@ page import="org.dspace.content.factory.ContentServiceFactory" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.app.util.FieldInputForm" %>
<%@ page import="org.dspace.app.util.FieldInputFormXMLConvert" %>
<%@ page import="org.dspace.app.util.FieldInputFormUtils" %>
<%@ page import="org.dspace.app.util.VocabularyConverter" %>

<%
    Item item = (Item) request.getAttribute("item");
    String handle = (String) request.getAttribute("handle");
    List<Collection> collections = (List<Collection>) request.getAttribute("collections");
    List<MetadataField> dcTypes = (List<MetadataField>) request.getAttribute("dc.types");
    HashMap metadataFields = (HashMap) request.getAttribute("metadataFields");
    request.setAttribute("LanguageSwitch", "hide");

    // Is anyone logged in?
    EPerson user = (EPerson) request.getAttribute("dspace.current.user");

    // Is the logged in user an admin of the item
    Boolean itemAdmin = (Boolean) request.getAttribute("admin_button");
    boolean isItemAdmin = (itemAdmin == null ? false : itemAdmin.booleanValue());

    // Is the logged in user an admin or community admin or collection admin
    Boolean admin = (Boolean) request.getAttribute("is.admin");
    boolean isAdmin = (admin == null ? false : admin.booleanValue());

    Boolean communityAdmin = (Boolean) request.getAttribute("is.communityAdmin");
    boolean isCommunityAdmin = (communityAdmin == null ? false : communityAdmin.booleanValue());

    Boolean collectionAdmin = (Boolean) request.getAttribute("is.collectionAdmin");
    boolean isCollectionAdmin = (collectionAdmin == null ? false : collectionAdmin.booleanValue());

    String naviAdmin = "admin";
    String link = "/dspace-admin";

    if (!isAdmin && (isCommunityAdmin || isCollectionAdmin)) {
        naviAdmin = "community-or-collection-admin";
        link = "/tools";
    }

    Boolean policy = (Boolean) request.getAttribute("policy_button");
    boolean bPolicy = (policy == null ? false : policy.booleanValue());

    Boolean delete = (Boolean) request.getAttribute("delete_button");
    boolean bDelete = (delete == null ? false : delete.booleanValue());

    Boolean createBits = (Boolean) request.getAttribute("create_bitstream_button");
    boolean bCreateBits = (createBits == null ? false : createBits.booleanValue());

    Boolean removeBits = (Boolean) request.getAttribute("remove_bitstream_button");
    boolean bRemoveBits = (removeBits == null ? false : removeBits.booleanValue());

    Boolean ccLicense = (Boolean) request.getAttribute("cclicense_button");
    boolean bccLicense = (ccLicense == null ? false : ccLicense.booleanValue());

    Boolean withdraw = (Boolean) request.getAttribute("withdraw_button");
    boolean bWithdraw = (withdraw == null ? false : withdraw.booleanValue());

    Boolean reinstate = (Boolean) request.getAttribute("reinstate_button");
    boolean bReinstate = (reinstate == null ? false : reinstate.booleanValue());

    Boolean privating = (Boolean) request.getAttribute("privating_button");
    boolean bPrivating = (privating == null ? false : privating.booleanValue());

    Boolean publicize = (Boolean) request.getAttribute("publicize_button");
    boolean bPublicize = (publicize == null ? false : publicize.booleanValue());

    Boolean reOrderBitstreams = (Boolean) request.getAttribute("reorder_bitstreams_button");
    boolean breOrderBitstreams = (reOrderBitstreams != null && reOrderBitstreams);

    // owning Collection ID for choice authority calls
    Collection collection = null;
    if (collections.size() > 0)
        collection = collections.get(0);
%>

<c:set var="dspace.layout.head.last" scope="request">
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/scriptaculous/prototype.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/scriptaculous/builder.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/scriptaculous/effects.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/scriptaculous/controls.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/dspace-admin/js/bitstream-ordering.js"></script>
    <script type='text/javascript' src='<%= request.getContextPath() %>/static/js/slimselect.min.js'></script>
    <script type='text/javascript' src='<%= request.getContextPath() %>/static/js/required.js'></script>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/slimselect.min.css" type="text/css" />
</c:set>

<dspace:layout style="submission" titlekey="jsp.tools.edit-item-form.title"
               navbar="<%= naviAdmin %>"
               locbar="link"
               parenttitlekey="jsp.administer"
               parentlink="<%= link %>"
               nocache="true">

<div class="title-edit">
    <%-- <h1>Edit Item</h1> --%>
    <h1><fmt:message key="jsp.tools.edit-item-form.title"/>
    <span class="edit-help">
          <dspace:popup
                  page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"help.collection-admin\") + \"#editmetadata\"%>"><fmt:message
                  key="jsp.morehelp"/></dspace:popup>
    </span>
    </h1>

    <%-- <p><strong>PLEASE NOTE: These changes are not validated in any way.
    You are responsible for entering the data in the correct format.
    If you are not sure what the format is, please do NOT make changes.</strong></p> --%>
<%--    <p class="alert alert-danger"><strong><fmt:message key="jsp.tools.edit-item-form.note"/></strong></p>--%>
    <p>
        <strong><fmt:message key="jsp.tools.edit-item-form.modified"/></strong>
        <dspace:date date="<%= new DCDate(item.getLastModified()) %>"/>
    </p>
    </div>
<%--    <div class="row">--%>
<%--        <div class="col-md-9">--%>
<%--            <div class="panel panel-primary">--%>
<%--                <div class="panel-heading"><fmt:message key="jsp.tools.edit-item-form.details"/></div>--%>

<%--                <div class="panel-body">--%>
<%--                    <table class="table">--%>
<%--                        <tr>--%>
<%--                            <td><fmt:message key="jsp.tools.edit-item-form.itemID"/>--%>
<%--                            </td>--%>
<%--                            <td><%= item.getID() %>--%>
<%--                            </td>--%>
<%--                        </tr>--%>

<%--                        <tr>--%>
<%--                            <td><fmt:message key="jsp.tools.edit-item-form.handle"/>--%>
<%--                            </td>--%>
<%--                            <td><%= (handle == null ? "None" : handle) %>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <td><fmt:message key="jsp.tools.edit-item-form.modified"/>--%>
<%--                            </td>--%>
<%--                            <td><dspace:date--%>
<%--                                    date="<%= new DCDate(item.getLastModified()) %>"/>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                            &lt;%&ndash; <td class="submitFormLabel">In Collections:</td> &ndash;%&gt;--%>
<%--                        <tr>--%>
<%--                            <td><fmt:message key="jsp.tools.edit-item-form.collections"/>--%>
<%--                            </td>--%>
<%--                            <td>--%>
<%--                                <% for (int i = 0; i < collections.size(); i++) { %> <%= collections.get(i).getName() %>--%>
<%--                                <% } %>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                                &lt;%&ndash; <td class="submitFormLabel">Item page:</td> &ndash;%&gt;--%>
<%--                            <td><fmt:message key="jsp.tools.edit-item-form.itempage"/>--%>
<%--                            </td>--%>
<%--                            <td>--%>
<%--                                <% if (handle == null) { %> <em><fmt:message--%>
<%--                                    key="jsp.tools.edit-item-form.na"/>--%>
<%--                            </em> <% } else {--%>
<%--                                String url = ConfigurationManager.getProperty("dspace.url") + "/handle/" + handle; %>--%>
<%--                                <a target="_blank" href="<%= url %>"><%= url %>--%>
<%--                                </a> <% } %>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                    </table>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>

<%--        <div class="col-md-3">--%>
<%--            <div class="panel panel-default">--%>
<%--                <div class="panel-heading"><fmt:message key="jsp.actiontools"/></div>--%>
<%--                <div class="panel-body">--%>
<%--                    <%--%>
<%--                        if (!item.isWithdrawn() && bWithdraw) {--%>
<%--                    %>--%>
<%--                    <form method="post" action="<%= request.getContextPath() %>/tools/edit-item">--%>
<%--                        <input type="hidden" name="item_id" value="<%= item.getID() %>"/>--%>
<%--                        <input type="hidden" name="action" value="<%= EditItemServlet.START_WITHDRAW %>"/>--%>
<%--                            &lt;%&ndash; <input type="submit" name="submit" value="Withdraw..."> &ndash;%&gt;--%>
<%--                        <input class="btn btn-warning col-md-12" type="submit" name="submit"--%>
<%--                               value="<fmt:message key="jsp.tools.edit-item-form.withdraw-w-confirm.button"/>"/>--%>
<%--                    </form>--%>
<%--                    <%--%>
<%--                    } else if (item.isWithdrawn() && bReinstate) {--%>
<%--                    %>--%>
<%--                    <form method="post" action="<%= request.getContextPath() %>/tools/edit-item">--%>
<%--                        <input type="hidden" name="item_id" value="<%= item.getID() %>"/>--%>
<%--                        <input type="hidden" name="action" value="<%= EditItemServlet.REINSTATE %>"/>--%>
<%--                            &lt;%&ndash; <input type="submit" name="submit" value="Reinstate"> &ndash;%&gt;--%>
<%--                        <input class="btn btn-warning col-md-12" type="submit" name="submit"--%>
<%--                               value="<fmt:message key="jsp.tools.edit-item-form.reinstate.button"/>"/>--%>
<%--                    </form>--%>
<%--                    <%--%>
<%--                        }--%>
<%--                    %>--%>
<%--                    <%--%>
<%--                        if (bDelete) {--%>
<%--                    %>--%>
<%--                    <form method="post" action="<%= request.getContextPath() %>/tools/edit-item">--%>
<%--                        <input type="hidden" name="item_id" value="<%= item.getID() %>"/>--%>
<%--                        <input type="hidden" name="action" value="<%= EditItemServlet.START_DELETE %>"/>--%>
<%--                            &lt;%&ndash; <input type="submit" name="submit" value="Delete (Expunge)..."> &ndash;%&gt;--%>
<%--                        <input class="btn btn-danger col-md-12" type="submit" name="submit"--%>
<%--                               value="<fmt:message key="jsp.tools.edit-item-form.delete-w-confirm.button"/>"/>--%>
<%--                    </form>--%>
<%--                    <%--%>
<%--                        }--%>
<%--                    %>--%>
<%--                    <%--%>
<%--                        if (isItemAdmin) {--%>
<%--                    %>--%>
<%--                    <form method="post" action="<%= request.getContextPath() %>/tools/edit-item">--%>
<%--                        <input type="hidden" name="item_id" value="<%= item.getID() %>"/>--%>
<%--                        <input type="hidden" name="action" value="<%= EditItemServlet.START_MOVE_ITEM %>"/>--%>
<%--                        <input class="btn btn-default col-md-12" type="submit" name="submit"--%>
<%--                               value="<fmt:message key="jsp.tools.edit-item-form.move-item.button"/>"/>--%>
<%--                    </form>--%>
<%--                    <%--%>
<%--                        }--%>
<%--                    %>--%>
<%--                    <%--%>
<%--                        if (item.isDiscoverable() && bPrivating) {--%>
<%--                    %>--%>
<%--                    <form method="post" action="<%= request.getContextPath() %>/tools/edit-item">--%>
<%--                        <input type="hidden" name="item_id" value="<%= item.getID() %>"/>--%>
<%--                        <input type="hidden" name="action" value="<%= EditItemServlet.START_PRIVATING %>"/>--%>
<%--                        <input class="btn btn-default col-md-12" type="submit" name="submit"--%>
<%--                               value="<fmt:message key="jsp.tools.edit-item-form.privating-w-confirm.button"/>"/>--%>
<%--                    </form>--%>
<%--                    <%--%>
<%--                    } else if (!item.isDiscoverable() && bPublicize) {--%>
<%--                    %>--%>
<%--                    <form method="post" action="<%= request.getContextPath() %>/tools/edit-item">--%>
<%--                        <input type="hidden" name="item_id" value="<%= item.getID() %>"/>--%>
<%--                        <input type="hidden" name="action" value="<%= EditItemServlet.PUBLICIZE %>"/>--%>
<%--                        <input class="btn btn-default col-md-12" type="submit" name="submit"--%>
<%--                               value="<fmt:message key="jsp.tools.edit-item-form.publicize.button"/>"/>--%>
<%--                    </form>--%>
<%--                    <%--%>
<%--                        }--%>
<%--                    %>--%>

<%--                    <%--%>
<%--                        if (bPolicy) {--%>
<%--                    %>--%>
<%--                        &lt;%&ndash; ===========================================================--%>
<%--                         Edit item's policies--%>
<%--                         =========================================================== &ndash;%&gt;--%>
<%--                    <form method="post"--%>
<%--                          action="<%= request.getContextPath() %>/tools/authorize">--%>
<%--                        <input type="hidden" name="handle"--%>
<%--                               value="<%= ConfigurationManager.getProperty("handle.prefix") %>"/>--%>
<%--                        <input type="hidden" name="item_id" value="<%= item.getID() %>"/>--%>
<%--                            &lt;%&ndash; <input type="submit" name="submit_item_select" value="Edit..."> &ndash;%&gt;--%>
<%--                        <input class="btn btn-default col-md-12" type="submit"--%>
<%--                               name="submit_item_select"--%>
<%--                               value="<fmt:message key="jsp.tools.edit-item-form.item" />"/>--%>
<%--                    </form>--%>
<%--                    <%--%>
<%--                        }--%>
<%--                    %>--%>
<%--                    <%--%>
<%--                        if (isItemAdmin) {--%>
<%--                    %>--%>
<%--                        &lt;%&ndash; ===========================================================--%>
<%--                             Curate Item--%>
<%--                             =========================================================== &ndash;%&gt;--%>
<%--                    <form method="post"--%>
<%--                          action="<%= request.getContextPath() %>/tools/curate">--%>
<%--                        <input type="hidden" name="item_id" value="<%= item.getID() %>"/>--%>
<%--                        <input class="btn btn-default col-md-12" type="submit"--%>
<%--                               name="submit_item_select"--%>
<%--                               value="<fmt:message key="jsp.tools.edit-item-form.form.button.curate"/>"/>--%>
<%--                    </form>--%>
<%--                    <%--%>
<%--                        }--%>
<%--                    %>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>


    <%

        if (item.isWithdrawn()) {
    %>
    <%-- <p align="center"><strong>This item was withdrawn from DSpace</strong></p> --%>
    <p class="alert alert-warning"><fmt:message key="jsp.tools.edit-item-form.msg"/></p>
    <%
        }
    %>
    <form id="edit_metadata" name="edit_metadata" class="edit-metadata" method="post"
          action="<%= request.getContextPath() %>/tools/edit-item">

        <%
            MetadataAuthorityService mam = ContentAuthorityServiceFactory.getInstance().getMetadataAuthorityService();
            ChoiceAuthorityService cam = ContentAuthorityServiceFactory.getInstance().getChoiceAuthorityService();
            String row = "even";
            String collectionName = item.getOwningCollection().getName();
            List<MetadataValue> metadataValueList = ContentServiceFactory.getInstance().getItemService().getMetadata(item, Item.ANY, Item.ANY, Item.ANY, Item.ANY);
            List<FieldInputForm> fieldInputFormList = FieldInputFormXMLConvert.getListOfFieldInputForm(collectionName);
            FieldInputFormUtils fieldInputFormUtils = new FieldInputFormUtils(fieldInputFormList, metadataValueList);
            Map<String, Integer> dcCounter = new HashMap<String, Integer>();

        %>

            <%--        by Jesiel--%>

        <c:forEach items="<%= fieldInputFormList %>" var="fieldInputForm" varStatus="loop">
            <%
                FieldInputForm xmlField = ((FieldInputForm) pageContext.getAttribute("fieldInputForm"));
                MetadataValue  metadata = fieldInputFormUtils.getFieldFromMetadataByKeys(xmlField.getSchema(),
                        xmlField.getElement(), xmlField.getQualifier());

                String sequenceNumber = "0";
                // Keep a count of the number of values of each element+qualifier
                // key is "element" or "element_qualifier" (String)
                // values are Integers - number of values that element/qualifier so far
                String key = metadata != null ? metadata.getMetadataField().toString() : xmlField.getKey();

                Integer count = dcCounter.get(key);
                if (count == null) {
                    count = 0;
                }

                // Increment counter in map
                dcCounter.put(key, count + 1);

                // We will use two digits to represent the counter number in the parameter names.
                // This means a string sort can be used to put things in the correct order even
                // if there are >= 10 values for a particular element/qualifier.  Increase this to
                // 3 digits if there are ever >= 100 for a single element/qualifer! :)
                sequenceNumber = String.valueOf(count);

                while (sequenceNumber.length() < 2) {
                    sequenceNumber = "0" + sequenceNumber;
                }
//                }
            %>
            <c:set var="metadataValue" scope="session" value="<%= metadata != null ? metadata.getValue().trim() : null  %>"/>

            <c:choose>
                <c:when test="${fieldInputForm != null && fieldInputForm.simpleVocabulary != null}">
                    <%
                        VocabularyConverter vocabularyConverter = new VocabularyConverter();
                        List<String> vocabularies = vocabularyConverter.getListOfVocabularies(xmlField.getSimpleVocabulary());
                    %>
                    <div class="form-group">
                        <label for="value_<%= key %>_<%= sequenceNumber %>">
                                ${fieldInputForm.label}
                        </label>                       
                        <select ${fieldInputForm.required != null ? 'required' : ''} class="" multiple id="value_<%= key %>_<%= sequenceNumber %>"
                                name="value_<%= key %>_<%= sequenceNumber %>">
                            <c:forEach items="<%= vocabularies %>" var="option">
                                <option ${option.equalsIgnoreCase(metadataValue) ? 'selected' : ''} value="${option}">${option} </option>
                            </c:forEach>
                        </select>
                        <span>${fieldInputForm.hint}</span>
                    </div>
                    <script>
                        new SlimSelect({
                            select: "#value_<%= key %>_<%= sequenceNumber %>"
                        })
                    </script>
                </c:when>
                <c:when test="${fieldInputForm != null && fieldInputForm.simpleInputType != null}">
                    <div class="form-group">
                        <label for="value_<%= key %>_<%= sequenceNumber %>">
                            ${fieldInputForm.label}
                        </label>                                              
                        <input ${fieldInputForm.required != null ? 'required' : ''} class="form-control" id="value_<%= key %>_<%= sequenceNumber %>" type="text"
                               name="value_<%= key %>_<%= sequenceNumber %>" value="${metadataValue}"
                        />
                        <span>${fieldInputForm.hint}</span>
                    </div>
                </c:when>
                <c:when test="${fieldInputForm != null && fieldInputForm.complextInputType != null}">
                    <div class="form-group">
                        <label for="value_<%= key %>_<%= sequenceNumber %>">
                                ${fieldInputForm.label}
                        </label>                                                
                        <select ${fieldInputForm.required != null ? 'required' : ''} class="form-control" id="value_<%= key %>_<%= sequenceNumber %>"
                                name="value_<%= key %>_<%= sequenceNumber %>">
                            <c:forEach items="${fieldInputForm.complextInputType.entrySet()}" var="option">
                                <option ${option.value.equalsIgnoreCase(metadataValue) ? 'selected' : ''} value="${option.value}">${option.key} </option>
                            </c:forEach>
                        </select>
                        <span>${fieldInputForm.hint}</span>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="form-group">
                        <label for="value_<%= key %>_<%= sequenceNumber %>">
                           ${fieldInputForm.label}
                        </label>
                                                
                        <textarea ${fieldInputForm.required != null ? 'required' : ''} id="value_<%= key %>_<%= sequenceNumber %>" class="form-control"
                                  name="value_<%= key %>_<%= sequenceNumber %>"
                                  rows="3">${metadataValue}</textarea>
                                  <span>${fieldInputForm.hint}</span>                                  
                    </div>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        

        <div class="btn-group">
            <%
                if (bCreateBits) {
            %>
<%--            <input class="btn btn-success col-md-2" type="submit" name="submit_addbitstream"--%>
<%--                   value="<fmt:message key="jsp.tools.edit-item-form.addbit.button"/>"/>--%>
            <% }
                if (breOrderBitstreams) {
            %>
<%--            <input class="hidden" type="submit" value="<fmt:message key="jsp.tools.edit-item-form.order-update"/>"--%>
<%--                   name="submit_update_order" style="visibility: hidden;">--%>
            <%
                }

                if (ConfigurationManager.getBooleanProperty("webui.submit.enable-cc") && bccLicense) {
                    String s;
                    List<Bundle> ccBundle = ContentServiceFactory.getInstance().getItemService().getBundles(item, "CC-LICENSE");
                    s = ccBundle.size() > 0 ? LocaleSupport.getLocalizedMessage(pageContext, "jsp.tools.edit-item-form.replacecc.button") : LocaleSupport.getLocalizedMessage(pageContext, "jsp.tools.edit-item-form.addcc.button");
            %>
            <input class="btn btn-success col-md-3" type="submit" name="submit_addcc" value="<%= s %>"/>
            <input type="hidden" name="handle" value="<%= ConfigurationManager.getProperty("handle.prefix") %>"/>
            <input type="hidden" name="item_id" value="<%= item.getID() %>"/>

            <%
                }
            %>


            <input type="hidden" name="item_id" value="<%= item.getID() %>"/>
            <input type="hidden" name="action" value="<%= EditItemServlet.UPDATE_ITEM %>"/>

                <%-- <input type="submit" name="submit" value="Update" /> --%>
            <input class="button-main" type="submit" name="submit"
                   value="<fmt:message key="jsp.tools.general.update"/>"/>
                <%-- <input type="submit" name="submit_cancel" value="Cancel" /> --%>
            <a href="<%=request.getContextPath() + "/handle/" + item.getHandle()%>" class="button-main-outline">
                <fmt:message key="jsp.tools.general.cancel"/>
            </a>
        </div>
    </form>
</dspace:layout>
