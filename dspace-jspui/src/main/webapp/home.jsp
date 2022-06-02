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
<%@ page import="org.dspace.content.service.CollectionService" %>
<%@page import="org.dspace.handle.HandleServiceImpl" %>
<%@ page import="org.dspace.handle.factory.HandleServiceFactory" %>
<%@ page import="org.dspace.handle.service.HandleService" %>


<%! public static final String REVISTAS = "123456789/2";
	public static final String PORTAL_DE_PERIODICOS = "123456789/2669";
%><%
    List<Community> communities = (List<Community>) request.getAttribute("communities");

    Locale sessionLocale = UIUtil.getSessionLocale(request);
    Config.set(request.getSession(), Config.FMT_LOCALE, sessionLocale);
    NewsService newsService = CoreServiceFactory.getInstance().getNewsService();
    String topNews = newsService.readNewsFile(LocaleSupport.getLocalizedMessage(pageContext, "news-top.html"));
    String sideNews = newsService.readNewsFile(LocaleSupport.getLocalizedMessage(pageContext, "news-side.html"));

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
	HandleService handleService = HandleServiceFactory.getInstance().getHandleService();
	Map<String, List<FacetResult>> facetsRoot = (Map<String, List<FacetResult>>) request.getAttribute("discovery.fresults");

%>

<dspace:layout locbar="off" titlekey="jsp.home.title" feedData="<%= feedData %>">

<!-- detalhe globo -->
<div class="content-home">
	<div class="d-flex a-center">
		<div class="col">
			<h1>Miguilim</h1>
			<h2>Diretório das revistas <br> científicas eletrônicas brasileiras</h2>
			<div class="total">
				<p>
					<span onclick="location.href = '<%= request.getContextPath() %>/handle/123456789/2'" style="cursor:pointer">
						<%= ic.getCount(handleService.resolveToObject(UIUtil.obtainContext(request), REVISTAS)) %>
					</span>
					Revistas científicas
				</p>
				<p class="line"></p>
				<p>
					<span onclick="location.href = '<%= request.getContextPath() %>/handle/123456789/2669'" style="cursor:pointer">
						<%= ic.getCount(handleService.resolveToObject(UIUtil.obtainContext(request), PORTAL_DE_PERIODICOS)) %>
					</span>Portais de revistas
				</p>
			</div>
		</div>
		<div class="col globe">
			<img class="globe" src="image/globe.svg">
		</div>
	</div>

	<!-- buscar -->
	<div class="search-home">
		<form method="get" action="<%= request.getContextPath() %>/simple-search" class="form-home">
			<a class="link-search" href="<%= request.getContextPath() %>/simple-search"><fmt:message key="jsp.layout.navbar-default.advanced"/></a>
			<input type="text" name="query" id="tequery"  class="field-search" placeholder="<fmt:message key="jsp.layout.navbar-default.search"/>">
			<input type="submit" class="button-main" value="Buscar">
		</form>
	</div>
</div>

<!-- random news -->
<div class="content-news">
	<a class="arrow left" id="carousel-left">
		<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
		<path fill-rule="evenodd" clip-rule="evenodd" d="M15.7071 5.29289C16.0976 5.68342 16.0976 6.31658 15.7071 6.70711L10.4142 12L15.7071 17.2929C16.0976 17.6834 16.0976 18.3166 15.7071 18.7071C15.3166 19.0976 14.6834 19.0976 14.2929 18.7071L8.29289 12.7071C7.90237 12.3166 7.90237 11.6834 8.29289 11.2929L14.2929 5.29289C14.6834 4.90237 15.3166 4.90237 15.7071 5.29289Z" fill="#6A6A6A"/>
		</svg>
	</a>
	<div class="card">
		<%
			boolean first = true;
			int iteratorRecent = 0;
			for (Item item : submissions.getRecentSubmissions())
			{
				iteratorRecent++;
				String displayTitle = itemService.getMetadataFirstValue(item, "dc", "title", null, Item.ANY);
				if (displayTitle == null)
				{
					displayTitle = "Untitled";
				}
				String publisher = itemService.getMetadataFirstValue(item, "dc", "publisher", "name", Item.ANY);
				if (publisher == null)
				{
					publisher = "";
				}
		%>

		<div style="cursor:pointer" onclick="location.href = '<%= request.getContextPath() %>/handle/<%= item.getHandle() %>'"  carousel="<%= iteratorRecent %>" <%= iteratorRecent > 1 ? "class=\"d-hide\"" : ""%>>
			<h2><%= displayTitle %></h2>
			<p><%= publisher %></p>
		</div>

		<%
			}
		%>

	</div>
	<a class="arrow right" id="carousel-right">
		<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
		<path fill-rule="evenodd" clip-rule="evenodd" d="M15.7071 5.29289C16.0976 5.68342 16.0976 6.31658 15.7071 6.70711L10.4142 12L15.7071 17.2929C16.0976 17.6834 16.0976 18.3166 15.7071 18.7071C15.3166 19.0976 14.6834 19.0976 14.2929 18.7071L8.29289 12.7071C7.90237 12.3166 7.90237 11.6834 8.29289 11.2929L14.2929 5.29289C14.6834 4.90237 15.3166 4.90237 15.7071 5.29289Z" fill="#6A6A6A"/>
		</svg>
	</a>	
</div>

<!-- cards -->
<div class="container-cards">
	<div class="card" onclick="location.href = '<%= request.getContextPath() %>/simple-search?filterquery=Ciências+agrárias&filtername=cnpq&filtertype=equals'" >
		<div class="icon">
			<svg width="28" height="28" viewBox="0 0 28 28" fill="none" xmlns="http://www.w3.org/2000/svg">
				<path fill-rule="evenodd" clip-rule="evenodd" d="M7 23.3333C7 22.689 7.52233 22.1667 8.16667 22.1667H19.8333C20.4777 22.1667 21 22.689 21 23.3333C21 23.9777 20.4777 24.5 19.8333 24.5H8.16667C7.52233 24.5 7 23.9777 7 23.3333Z" fill="#04132A"/>
				<path fill-rule="evenodd" clip-rule="evenodd" d="M15.7751 10.6712C16.3249 11.0072 16.4982 11.7252 16.1622 12.275C15.6809 13.0627 15.5591 13.8792 15.6046 14.7933C15.6278 15.2595 15.6938 15.738 15.7754 16.2515C15.7949 16.3741 15.8157 16.5008 15.8369 16.6302C15.9011 17.0217 15.9694 17.4378 16.0185 17.8396C16.1504 18.9183 16.1867 20.1638 15.6136 21.3709C15.0299 22.6004 13.9121 23.5942 12.1495 24.3954C11.5629 24.6621 10.8712 24.4027 10.6046 23.8161C10.338 23.2295 10.5974 22.5379 11.1839 22.2712C12.6296 21.6141 13.2327 20.9455 13.5057 20.3702C13.7894 19.7727 13.8184 19.0713 13.7024 18.1229C13.6596 17.7725 13.6026 17.4249 13.5407 17.0473C13.518 16.9088 13.4946 16.7662 13.4711 16.618C13.3864 16.0856 13.3038 15.5058 13.2741 14.9093C13.2139 13.6979 13.3692 12.3706 14.1712 11.0583C14.5072 10.5085 15.2253 10.3352 15.7751 10.6712Z" fill="#04132A"/>
				<path fill-rule="evenodd" clip-rule="evenodd" d="M6.2611 10.9993C6.97053 12.6162 7.85982 13.4755 8.68842 13.8898C8.69896 13.8951 8.70941 13.9005 8.71979 13.9061C9.61789 14.3897 10.6752 14.5349 12.1656 14.3617C11.6858 13.279 11.1092 12.428 10.3971 11.9102C9.58949 11.3228 8.39505 10.8318 6.2611 10.9993ZM4.46158 8.88484C7.96212 8.25974 10.1712 8.8607 11.7695 10.0231C13.361 11.1805 14.273 13.1129 14.8735 14.9144C14.9793 15.2319 14.9437 15.5795 14.7757 15.8689C14.6078 16.1583 14.3236 16.3617 13.9955 16.4273C11.5882 16.9088 9.50662 16.9734 7.62903 15.9689C5.86462 15.08 4.42576 13.2487 3.55055 10.373C3.45345 10.054 3.49753 9.70864 3.67165 9.42421C3.84577 9.13978 4.13328 8.94346 4.46158 8.88484Z" fill="#04132A"/>
				<path fill-rule="evenodd" clip-rule="evenodd" d="M22.9942 3.84437C23.2238 4.07542 23.3463 4.39193 23.3321 4.71734C23.2061 7.61718 22.4289 9.4376 21.0082 10.8583C20.9778 10.8887 20.9457 10.9175 20.9121 10.9443C19.5049 12.07 17.6153 12.7061 15.2279 12.8317C14.9148 12.8482 14.6083 12.738 14.3774 12.526C14.1465 12.3139 14.0107 12.0179 14.0005 11.7045C13.9393 9.81941 14.4506 7.95996 15.4672 6.37121C15.5015 6.31759 15.5401 6.26686 15.5827 6.21954C16.1848 5.55059 16.9478 4.88736 18.0264 4.38281C19.0989 3.88116 20.4248 3.56371 22.1234 3.5008C22.4489 3.48875 22.7646 3.61331 22.9942 3.84437ZM17.3817 7.70961C16.8772 8.52227 16.5468 9.42605 16.4063 10.364C17.7259 10.1455 18.6941 9.71451 19.4042 9.16196C20.1108 8.43947 20.6376 7.52317 20.8762 5.95572C20.1045 6.07619 19.5006 6.26923 19.015 6.49636C18.3202 6.82137 17.8152 7.24052 17.3817 7.70961Z" fill="#04132A"/>
			</svg>		
		</div>
		<div class="text">
			<h2>Ciências agrárias</h2>
			<p><span><%= facetsRoot.get("cnpq").stream().filter(facetResult ->
					facetResult.getDisplayedValue().equalsIgnoreCase("Ciências agrárias")).findFirst().get().getCount() %></span></p>
		</div>		
	</div>
	<div class="card" onclick="location.href = '<%= request.getContextPath() %>/simple-search?filterquery=Ciências+biológicas&filtername=cnpq&filtertype=equals'" >
		<div class="icon">
			<svg width="40" height="40" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
				<path d="M9.58924 37.5999C9.06124 37.5999 8.51724 37.4559 8.05324 37.1999C7.57324 36.9439 7.17324 36.5599 6.88524 36.0959C6.59724 35.6319 6.43724 35.0879 6.40524 34.5439C6.37324 33.9999 6.50124 33.4559 6.74124 32.9599L15.0132 16.4159V3.9999C15.0132 3.1199 15.7332 2.3999 16.6132 2.3999C17.4932 2.3999 18.2132 3.1199 18.2132 3.9999V16.7999C18.2132 17.0559 18.1492 17.2959 18.0372 17.5199L9.58924 34.3999H30.0212L21.5732 17.5199C21.4612 17.2959 21.4132 17.0559 21.4132 16.7999V3.9999C21.4132 3.1199 22.1332 2.3999 23.0132 2.3999C23.8932 2.3999 24.6132 3.1199 24.6132 3.9999V16.4159L32.8852 32.9599C33.1252 33.4399 33.2372 33.9839 33.2212 34.5279C33.1892 35.0879 33.0292 35.6159 32.7412 36.0799C32.4532 36.5439 32.0372 36.9439 31.5572 37.1999C31.0932 37.4719 30.5172 37.5999 30.0052 37.5999H9.60524C9.58924 37.5999 9.58924 37.5999 9.58924 37.5999Z" fill="#04132A"/>
				<path d="M25.4123 5.5999H14.2123C13.3323 5.5999 12.6123 4.8799 12.6123 3.9999C12.6123 3.1199 13.3323 2.3999 14.2123 2.3999H25.4123C26.2923 2.3999 27.0123 3.1199 27.0123 3.9999C27.0123 4.8799 26.2923 5.5999 25.4123 5.5999Z" fill="#04132A"/>
				<path d="M27.8124 28H11.8124C10.9324 28 10.2124 27.28 10.2124 26.4C10.2124 25.52 10.9324 24.8 11.8124 24.8H27.8124C28.6924 24.8 29.4124 25.52 29.4124 26.4C29.4124 27.28 28.6924 28 27.8124 28Z" fill="#04132A"/>
			</svg>		
		</div>
		<div class="text">
			<h2>Ciências Biológicas</h2>
			<p><span><%= facetsRoot.get("cnpq").stream().filter(facetResult ->
					facetResult.getDisplayedValue().equalsIgnoreCase("Ciências biológicas")).findFirst().get().getCount() %></span></p>
		</div>		
	</div>
	<div class="card" onclick="location.href = '<%= request.getContextPath() %>/simple-search?filterquery=Ciências+da+saúde&filtername=cnpq&filtertype=equals'" >
		<div class="icon">
			<svg width="29" height="30" viewBox="0 0 29 30" fill="none" xmlns="http://www.w3.org/2000/svg">
				<path fill-rule="evenodd" clip-rule="evenodd" d="M6.12907 3.69624C7.05286 3.31266 8.04329 3.1152 9.04356 3.1152C10.0438 3.1152 11.0343 3.31266 11.958 3.69624C12.8818 4.07983 13.7208 4.642 14.4269 5.35053L14.4308 5.35449L14.5001 5.42469L14.5694 5.3545L14.5734 5.35053C15.2794 4.642 16.1184 4.07983 17.0422 3.69624C17.966 3.31266 18.9564 3.1152 19.9567 3.1152C20.957 3.1152 21.9474 3.31266 22.8712 3.69624C23.7947 4.0797 24.6334 4.64162 25.3393 5.3498C28.3615 8.3728 28.4287 13.3712 24.8476 17.0194L24.8398 17.0272L15.3398 26.5272C15.1171 26.7499 14.8151 26.875 14.5001 26.875C14.1852 26.875 13.8831 26.7499 13.6604 26.5272L4.15264 17.0194C0.5715 13.3712 0.638737 8.3728 3.66096 5.34979C4.36687 4.64161 5.2056 4.0797 6.12907 3.69624ZM9.04356 5.4902C8.35588 5.4902 7.67496 5.62595 7.03985 5.88967C6.40474 6.15338 5.82794 6.53988 5.34252 7.02699L5.34106 7.02845C3.32989 9.03961 3.08795 12.541 5.84386 15.3519L14.5001 24.0081L23.1564 15.3519C25.9123 12.541 25.6704 9.03962 23.6592 7.02845L23.6577 7.02699C23.1723 6.53988 22.5955 6.15338 21.9604 5.88967C21.3253 5.62595 20.6444 5.4902 19.9567 5.4902C19.269 5.4902 18.5881 5.62595 17.953 5.88967C17.3187 6.15304 16.7426 6.53886 16.2576 7.02507C16.2569 7.02571 16.2563 7.02635 16.2556 7.02699L15.3452 7.94926C15.1221 8.17528 14.8177 8.30251 14.5001 8.30251C14.1825 8.30251 13.8782 8.17528 13.655 7.94926L12.7446 7.02699C12.744 7.02635 12.7433 7.02571 12.7427 7.02507C12.2577 6.53886 11.6815 6.15304 11.0473 5.88967C10.4122 5.62595 9.73124 5.4902 9.04356 5.4902Z" fill="#04132A"/>
			</svg>
		</div>
		<div class="text">
			<h2>Ciências da saúde</h2>
			<p><span><%= facetsRoot.get("cnpq").stream().filter(facetResult ->
					facetResult.getDisplayedValue().equalsIgnoreCase("Ciências da saúde")).findFirst().get().getCount() %></span></p>
		</div>		
	</div>
	<div class="card" onclick="location.href = '<%= request.getContextPath() %>/simple-search?filterquery=Ciências+exatas+e+da+terra&filtername=cnpq&filtertype=equals'" >
		<div class="icon">
			<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
				<path fill-rule="evenodd" clip-rule="evenodd" d="M16.7499 15.8C16.4979 15.8 16.2563 15.9001 16.0782 16.0783C15.9 16.2564 15.7999 16.4981 15.7999 16.75V20.55C15.7999 21.0747 15.3746 21.5 14.8499 21.5C14.3252 21.5 13.8999 21.0747 13.8999 20.55V16.75C13.8999 15.9941 14.2002 15.2692 14.7346 14.7348C15.2691 14.2003 15.994 13.9 16.7499 13.9H20.5499C21.0746 13.9 21.4999 14.3253 21.4999 14.85C21.4999 15.3747 21.0746 15.8 20.5499 15.8H16.7499Z" fill="#04132A"/>
				<path fill-rule="evenodd" clip-rule="evenodd" d="M7.25005 3.45001C7.77472 3.45001 8.20005 3.87534 8.20005 4.40001V6.12088C8.34561 6.45116 8.58275 6.73415 8.88474 6.93548C9.22742 7.16394 9.63506 7.27486 10.0463 7.25154L10.1 8.20001V7.25001C10.8559 7.25001 11.5808 7.55028 12.1153 8.08476C12.6498 8.61924 12.95 9.34415 12.95 10.1C12.95 10.352 13.0501 10.5936 13.2283 10.7718C13.4065 10.9499 13.6481 11.05 13.9 11.05C14.152 11.05 14.3936 10.9499 14.5718 10.7718C14.75 10.5936 14.85 10.352 14.85 10.1C14.85 9.34415 15.1503 8.61924 15.6848 8.08476C16.2193 7.55028 16.9442 7.25001 17.7 7.25001H20.55C21.0747 7.25001 21.5 7.67534 21.5 8.20001C21.5 8.72468 21.0747 9.15001 20.55 9.15001H17.7C17.4481 9.15001 17.2065 9.2501 17.0283 9.42826C16.8501 9.60642 16.75 9.84806 16.75 10.1C16.75 10.8559 16.4498 11.5808 15.9153 12.1153C15.3808 12.6497 14.6559 12.95 13.9 12.95C13.1442 12.95 12.4193 12.6497 11.8848 12.1153C11.3503 11.5808 11.05 10.8559 11.05 10.1C11.05 9.84806 10.95 9.60642 10.7718 9.42826C10.5985 9.25493 10.365 9.15549 10.1205 9.15023C9.30944 9.18909 8.50691 8.96711 7.83081 8.51638C7.14544 8.05946 6.62709 7.39222 6.35384 6.61515C6.31824 6.5139 6.30005 6.40734 6.30005 6.30001V4.40001C6.30005 3.87534 6.72538 3.45001 7.25005 3.45001Z" fill="#04132A"/>
				<path fill-rule="evenodd" clip-rule="evenodd" d="M2.5 11.05C2.5 10.5253 2.92533 10.1 3.45 10.1H5.35C6.10587 10.1 6.83078 10.4003 7.36525 10.9348C7.89973 11.4692 8.2 12.1941 8.2 12.95V13.9C8.2 14.152 8.30009 14.3936 8.47825 14.5718C8.65641 14.7499 8.89805 14.85 9.15 14.85C9.90587 14.85 10.6308 15.1503 11.1653 15.6848C11.6997 16.2192 12 16.9441 12 17.7V21.5C12 22.0247 11.5747 22.45 11.05 22.45C10.5253 22.45 10.1 22.0247 10.1 21.5V17.7C10.1 17.4481 9.99991 17.2064 9.82175 17.0283C9.64359 16.8501 9.40196 16.75 9.15 16.75C8.39413 16.75 7.66922 16.4497 7.13475 15.9153C6.60027 15.3808 6.3 14.6559 6.3 13.9V12.95C6.3 12.6981 6.19991 12.4564 6.02175 12.2783C5.84359 12.1001 5.60196 12 5.35 12H3.45C2.92533 12 2.5 11.5747 2.5 11.05Z" fill="#04132A"/>
				<path fill-rule="evenodd" clip-rule="evenodd" d="M12.0003 3.45C7.27826 3.45 3.45029 7.27797 3.45029 12C3.45029 16.722 7.27826 20.55 12.0003 20.55C16.7223 20.55 20.5503 16.722 20.5503 12C20.5503 7.27797 16.7223 3.45 12.0003 3.45ZM1.55029 12C1.55029 6.22863 6.22892 1.55 12.0003 1.55C17.7717 1.55 22.4503 6.22863 22.4503 12C22.4503 17.7714 17.7717 22.45 12.0003 22.45C6.22892 22.45 1.55029 17.7714 1.55029 12Z" fill="#04132A"/>
			</svg>
		</div>
		<div class="text">
			<h2>Ciências exatas e da terra</h2>
			<p><span><%= facetsRoot.get("cnpq").stream().filter(facetResult ->
					facetResult.getDisplayedValue().equalsIgnoreCase("Ciências exatas e da terra")).findFirst().get().getCount() %></span></p>
		</div>
	</div>
	<div class="card" onclick="location.href = '<%= request.getContextPath() %>/simple-search?filterquery=Ciências+humanas&filtername=cnpq&filtertype=equals'" >
		<div class="icon">
			<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
				<path fill-rule="evenodd" clip-rule="evenodd" d="M10.021 5.07292C10.021 3.97985 10.9071 3.09375 12.0002 3.09375C13.0932 3.09375 13.9793 3.97985 13.9793 5.07292C13.9793 6.16598 13.0932 7.05208 12.0002 7.05208C10.9071 7.05208 10.021 6.16598 10.021 5.07292Z" fill="#04132A"/>
				<path fill-rule="evenodd" clip-rule="evenodd" d="M12.0001 12.9896C12.3749 12.9896 12.7175 13.2014 12.8852 13.5366L15.8539 19.4741C16.0983 19.9629 15.9002 20.5574 15.4114 20.8018C14.9225 21.0462 14.3281 20.8481 14.0837 20.3592L12.0001 16.1919L9.91641 20.3592C9.672 20.8481 9.07758 21.0462 8.58875 20.8018C8.09992 20.5574 7.90178 19.9629 8.14619 19.4741L11.1149 13.5366C11.2826 13.2014 11.6252 12.9896 12.0001 12.9896Z" fill="#04132A"/>
				<path fill-rule="evenodd" clip-rule="evenodd" d="M5.12356 7.72873C5.29639 7.21024 5.85681 6.93003 6.3753 7.10286L11.9999 8.97772L17.6244 7.10286C18.1429 6.93003 18.7033 7.21024 18.8762 7.72873C19.049 8.24722 18.7688 8.80764 18.2503 8.98046L12.3128 10.9596C12.1097 11.0273 11.8901 11.0273 11.6869 10.9596L5.74943 8.98046C5.23094 8.80764 4.95073 8.24722 5.12356 7.72873Z" fill="#04132A"/>
				<path fill-rule="evenodd" clip-rule="evenodd" d="M11.9998 9.03125C12.5464 9.03125 12.9894 9.4743 12.9894 10.0208V13.9792C12.9894 14.5257 12.5464 14.9688 11.9998 14.9688C11.4533 14.9688 11.0103 14.5257 11.0103 13.9792V10.0208C11.0103 9.4743 11.4533 9.03125 11.9998 9.03125Z" fill="#04132A"/>
				</svg>			
		</div>
		<div class="text">
			<h2>Ciências humanas</h2>
			<p><span><%= facetsRoot.get("cnpq").stream().filter(facetResult ->
					facetResult.getDisplayedValue().equalsIgnoreCase("Ciências humanas")).findFirst().get().getCount() %></span></p>
		</div>
	</div>	
	<div onclick="location.href = '<%= request.getContextPath() %>/simple-search?filterquery=Ciências+sociais+aplicadas&filtername=cnpq&filtertype=equals'" class="card">
		<div class="icon">
			<svg width="28" height="28" viewBox="0 0 28 28" fill="none" xmlns="http://www.w3.org/2000/svg">
				<path fill-rule="evenodd" clip-rule="evenodd" d="M4.87675 3.5C4.11644 3.5 3.50008 4.11635 3.50008 4.87666V23.1233C3.50008 23.8836 4.11644 24.5 4.87675 24.5H23.1234C23.8837 24.5 24.5001 23.8836 24.5001 23.1233V4.87666C24.5001 4.11635 23.8837 3.5 23.1234 3.5H4.87675ZM1.16675 4.87666C1.16675 2.82769 2.82777 1.16666 4.87675 1.16666H23.1234C25.1724 1.16666 26.8334 2.82769 26.8334 4.87666V23.1233C26.8334 25.1723 25.1724 26.8333 23.1234 26.8333H4.87675C2.82777 26.8333 1.16675 25.1723 1.16675 23.1233V4.87666Z" fill="#04132A"/>
				<path fill-rule="evenodd" clip-rule="evenodd" d="M8.16667 1.16666C8.811 1.16666 9.33333 1.689 9.33333 2.33333V25.6667C9.33333 26.311 8.811 26.8333 8.16667 26.8333C7.52233 26.8333 7 26.311 7 25.6667V2.33333C7 1.689 7.52233 1.16666 8.16667 1.16666Z" fill="#04132A"/>
				<path fill-rule="evenodd" clip-rule="evenodd" d="M19.8334 1.16666C20.4777 1.16666 21.0001 1.689 21.0001 2.33333V25.6667C21.0001 26.311 20.4777 26.8333 19.8334 26.8333C19.1891 26.8333 18.6667 26.311 18.6667 25.6667V2.33333C18.6667 1.689 19.1891 1.16666 19.8334 1.16666Z" fill="#04132A"/>
				<path fill-rule="evenodd" clip-rule="evenodd" d="M1.16675 14C1.16675 13.3557 1.68908 12.8333 2.33341 12.8333H25.6667C26.3111 12.8333 26.8334 13.3557 26.8334 14C26.8334 14.6443 26.3111 15.1667 25.6667 15.1667H2.33341C1.68908 15.1667 1.16675 14.6443 1.16675 14Z" fill="#04132A"/>
				<path fill-rule="evenodd" clip-rule="evenodd" d="M1.16675 8.16667C1.16675 7.52233 1.68908 7 2.33341 7H8.16675C8.81108 7 9.33342 7.52233 9.33342 8.16667C9.33342 8.811 8.81108 9.33333 8.16675 9.33333H2.33341C1.68908 9.33333 1.16675 8.811 1.16675 8.16667Z" fill="#04132A"/>
				<path fill-rule="evenodd" clip-rule="evenodd" d="M1.16675 19.8333C1.16675 19.189 1.68908 18.6667 2.33341 18.6667H8.16675C8.81108 18.6667 9.33342 19.189 9.33342 19.8333C9.33342 20.4777 8.81108 21 8.16675 21H2.33341C1.68908 21 1.16675 20.4777 1.16675 19.8333Z" fill="#04132A"/>
				<path fill-rule="evenodd" clip-rule="evenodd" d="M18.6667 19.8333C18.6667 19.189 19.1891 18.6667 19.8334 18.6667H25.6667C26.3111 18.6667 26.8334 19.189 26.8334 19.8333C26.8334 20.4777 26.3111 21 25.6667 21H19.8334C19.1891 21 18.6667 20.4777 18.6667 19.8333Z" fill="#04132A"/>
				<path fill-rule="evenodd" clip-rule="evenodd" d="M18.6667 8.16667C18.6667 7.52233 19.1891 7 19.8334 7H25.6667C26.3111 7 26.8334 7.52233 26.8334 8.16667C26.8334 8.811 26.3111 9.33333 25.6667 9.33333H19.8334C19.1891 9.33333 18.6667 8.811 18.6667 8.16667Z" fill="#04132A"/>
			</svg>
		</div>
		<div class="text">
			<h2>Ciências sociais aplicadas</h2>
			<p><span><%= facetsRoot.get("cnpq").stream().filter(facetResult ->
					facetResult.getDisplayedValue().equalsIgnoreCase("Ciências sociais aplicadas")).findFirst().get().getCount() %></span></p>
		</div>
	</div>
	<div class="card" onclick="location.href = '<%= request.getContextPath() %>/simple-search?filterquery=Engenharias&filtername=cnpq&filtertype=equals'" >
		<div class="icon">
			<svg width="22" height="22" viewBox="0 0 22 22" fill="none" xmlns="http://www.w3.org/2000/svg">
				<path fill-rule="evenodd" clip-rule="evenodd" d="M1.62706 13.3272C1.96463 12.9896 2.42246 12.8 2.89985 12.8H19.0999C19.5772 12.8 20.0351 12.9896 20.3726 13.3272C20.7102 13.6648 20.8999 14.1226 20.8999 14.6V16.4C20.8999 16.8774 20.7102 17.3352 20.3726 17.6728C20.0351 18.0104 19.5772 18.2 19.0999 18.2H2.89985C2.42247 18.2 1.96463 18.0104 1.62706 17.6728C1.2895 17.3352 1.09985 16.8774 1.09985 16.4V14.6C1.09985 14.1226 1.2895 13.6648 1.62706 13.3272ZM19.0999 14.6L2.89985 14.6V16.4L19.0999 16.4V14.6Z" fill="#04132A"/>
				<path fill-rule="evenodd" clip-rule="evenodd" d="M8.82701 3.42721C9.16458 3.08964 9.62241 2.9 10.0998 2.9H11.8998C12.3772 2.9 12.835 3.08964 13.1726 3.42721C13.5102 3.76477 13.6998 4.22261 13.6998 4.7V9.2C13.6998 9.69706 13.2969 10.1 12.7998 10.1C12.3027 10.1 11.8998 9.69706 11.8998 9.2V4.7L10.0998 4.7L10.0998 9.2C10.0998 9.69706 9.69686 10.1 9.1998 10.1C8.70275 10.1 8.2998 9.69706 8.2998 9.2V4.7C8.2998 4.22261 8.48945 3.76477 8.82701 3.42721Z" fill="#04132A"/>
				<path fill-rule="evenodd" clip-rule="evenodd" d="M9.1999 6.5C8.00643 6.5 6.86184 6.9741 6.01792 7.81802C5.17401 8.66193 4.6999 9.80652 4.6999 11V13.7C4.6999 14.1971 4.29696 14.6 3.7999 14.6C3.30285 14.6 2.8999 14.1971 2.8999 13.7V11C2.8999 9.32913 3.56365 7.7267 4.74513 6.54522C5.92661 5.36375 7.52904 4.7 9.1999 4.7V6.5Z" fill="#04132A"/>
				<path fill-rule="evenodd" clip-rule="evenodd" d="M11.8999 5.6C11.8999 5.10294 12.3028 4.7 12.7999 4.7C14.4708 4.7 16.0732 5.36375 17.2547 6.54522C18.4362 7.7267 19.0999 9.32913 19.0999 11V13.7C19.0999 14.1971 18.697 14.6 18.1999 14.6C17.7028 14.6 17.2999 14.1971 17.2999 13.7V11C17.2999 9.80652 16.8258 8.66193 15.9819 7.81802C15.138 6.9741 13.9934 6.5 12.7999 6.5C12.3028 6.5 11.8999 6.09705 11.8999 5.6Z" fill="#04132A"/>
			</svg>			
		</div>
		<div class="text">
			<h2>Engenharias</h2>
			<p><span><%= facetsRoot.get("cnpq").stream().filter(facetResult ->
					facetResult.getDisplayedValue().equalsIgnoreCase("Engenharias")).findFirst().get().getCount() %></span></p>

		</div>		
	</div>
	<div class="card" onclick="location.href = '<%= request.getContextPath() %>/simple-search?filterquery=Linguística%2C+letras+e+artes&filtername=cnpq&filtertype=equals'" >
		<div class="icon">
			<svg width="29" height="30" viewBox="0 0 29 30" fill="none" xmlns="http://www.w3.org/2000/svg">
				<path fill-rule="evenodd" clip-rule="evenodd" d="M7.96875 22.125C7.49633 22.125 7.04327 22.3127 6.70922 22.6467C6.37517 22.9808 6.1875 23.4338 6.1875 23.9063C6.1875 24.5621 5.65584 25.0938 5 25.0938C4.34416 25.0938 3.8125 24.5621 3.8125 23.9063C3.8125 22.804 4.25039 21.7468 5.02984 20.9673C5.80929 20.1879 6.86644 19.75 7.96875 19.75H24C24.6558 19.75 25.1875 20.2817 25.1875 20.9375C25.1875 21.5933 24.6558 22.125 24 22.125H7.96875Z" fill="#04132A"/>
				<path fill-rule="evenodd" clip-rule="evenodd" d="M7.96875 4.3125C7.49633 4.3125 7.04327 4.50016 6.70922 4.83421C6.37517 5.16826 6.1875 5.62133 6.1875 6.09375V23.9062C6.1875 24.3787 6.37517 24.8317 6.70922 25.1658C7.04327 25.4998 7.49633 25.6875 7.96875 25.6875H22.8125V4.3125H7.96875ZM7.96875 1.9375H24C24.6558 1.9375 25.1875 2.46916 25.1875 3.125V26.875C25.1875 27.5308 24.6558 28.0625 24 28.0625H7.96875C6.86644 28.0625 5.80929 27.6246 5.02984 26.8452C4.25039 26.0657 3.8125 25.0086 3.8125 23.9062V6.09375C3.8125 4.99144 4.25039 3.93428 5.02984 3.15483C5.80929 2.37539 6.86644 1.9375 7.96875 1.9375Z" fill="#04132A"/>
			</svg>	
		</div>
		<div class="text">
			<h2>Linguística, letras e artes</h2>
			<p><span><%= facetsRoot.get("cnpq").stream().filter(facetResult ->
					facetResult.getDisplayedValue().equalsIgnoreCase("Linguística, letras e artes")).findFirst().get().getCount() %></span></p>
		</div>
	</div>
	<div class="card" onclick="location.href = '<%= request.getContextPath() %>/simple-search?filterquery=Multidisciplinar&filtername=cnpq&filtertype=equals'" >
		<div class="icon">
			<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
				<path fill-rule="evenodd" clip-rule="evenodd" d="M11.5651 4.32485C11.8388 4.188 12.1609 4.188 12.4347 4.32485L22.1381 9.17655C22.2616 9.23513 22.3709 9.31899 22.4591 9.42146C22.6057 9.59169 22.6943 9.81327 22.6943 10.0555V15.8889C22.6943 16.4258 22.259 16.8611 21.7221 16.8611C21.1851 16.8611 20.7499 16.4258 20.7499 15.8889V11.6286L12.4347 15.7862C12.1609 15.9231 11.8388 15.9231 11.5651 15.7862L1.84285 10.9251C1.51348 10.7604 1.30542 10.4238 1.30542 10.0555C1.30542 9.6873 1.51348 9.35065 1.84285 9.18597L11.5651 4.32485ZM19.5481 10.0555L11.9999 6.28141L4.4516 10.0555L11.9999 13.8297L19.5481 10.0555Z" fill="#04132A"/>
				<path fill-rule="evenodd" clip-rule="evenodd" d="M6.16656 11.0278C6.7035 11.0278 7.13878 11.463 7.13878 12V16.4381C8.37255 17.5035 10.1528 18.0764 11.9999 18.0764C13.847 18.0764 15.6272 17.5035 16.861 16.4381V12C16.861 11.463 17.2963 11.0278 17.8332 11.0278C18.3702 11.0278 18.8055 11.463 18.8055 12V16.8611C18.8055 17.119 18.703 17.3662 18.5207 17.5486C16.8388 19.2305 14.3804 20.0208 11.9999 20.0208C9.61943 20.0208 7.16101 19.2305 5.47909 17.5486C5.29677 17.3662 5.19434 17.119 5.19434 16.8611V12C5.19434 11.463 5.62961 11.0278 6.16656 11.0278Z" fill="#04132A"/>
			</svg>			
		</div>
		<div class="text">
			<h2>Multidisciplinar</h2>
			<p><span><%= facetsRoot.get("cnpq").stream().filter(facetResult ->
					facetResult.getDisplayedValue().equalsIgnoreCase("Multidisciplinar")).findFirst().get().getCount() %></span></p>
		</div>		
	</div>
	
				
</div>

<!-- brands -->
<div class="group-brands">
	<div class="d-flex brand-space">
		<div class="col">
			<h3>Conheça o parceiro do Miguilim</h3>
			<a href="https://manuelzao.ibict.br" target="_blank"><img src="image/manuelzao.png" alt="logo do projeto manuelzao"></a>
		</div>
		<div class="col">
			<h3>Conheça também</h3>
			<a href="https://diadorim.ibict.br/" target="_blank"><img src="image/diadorim.png" alt="logo do projeto diadorim"></a>
			<a href="https://oasisbr.ibict.br/vufind/" target="_blank"><img src="image/OASISBR.png" alt="logo do projeto OASISBR"></a>
			<a href="https://www.latindex.org/latindex/" target="_blank"><img src="image/latindex.png" alt="logo do projeto latindex"></a>
			<a href="https://scielo.org/" target="_blank"><img src="image/scielo.png" alt="logo do projeto latindex"></a>
			<a href="https://www.lareferencia.info/pt/" target="_blank"><img src="image/la.png" alt="logo do projeto latindex"></a>
			<a href="https://www.rcaap.pt/" target="_blank"><img src="image/rcaap.png" alt="logo do projeto latindex"></a>
		</div>
	</div>
</div>






<div class="row">
	<%@ include file="discovery/static-tagcloud-facet.jsp" %>
</div>
</div>

</dspace:layout>


<script>
	function findSelected() {
		let selectedIndex = 1;
		document.querySelectorAll("div[carousel]").forEach(element => {
			if (!element.classList.contains("d-hide")) {
				selectedIndex = parseInt(element.getAttribute("carousel"));
			}
		});
		return selectedIndex;
	}
	document.querySelectorAll('[id*="carousel"]').forEach(element => {
		element.addEventListener("click", function(){
			let selected = findSelected();
			let next = selected + 1;

			if(this.getAttribute("id") == "carousel-left") {
				next = selected - 1;
			}

			if(next > 0 && next <= 10) {
				document.querySelector("div[carousel='" + selected + "']").classList.add("d-hide");
				document.querySelector("div[carousel='" + next + "']").classList.remove("d-hide");
			}

		});
	});


</script>
