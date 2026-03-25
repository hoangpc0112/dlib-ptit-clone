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
<%@page import="org.dspace.content.service.BitstreamService"%>
<%@page import="org.dspace.core.Utils"%>
<%@page import="org.dspace.core.Constants"%>
<%@page import="org.dspace.content.Bitstream"%>
<%@page import="org.dspace.content.DSpaceObject"%>
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
<%@ page import="org.dspace.statistics.ObjectCount" %>
<%@ page import="org.dspace.statistics.factory.StatisticsServiceFactory" %>
<%@ page import="org.dspace.statistics.service.SolrLoggerService" %>
<%@ page import="org.dspace.browse.BrowseEngine" %>
<%@ page import="org.dspace.browse.BrowseInfo" %>
<%@ page import="org.dspace.browse.BrowseIndex" %>
<%@ page import="org.dspace.browse.BrowserScope" %>
<%@ page import="org.dspace.sort.SortOption" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.LinkedHashSet" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.UUID" %>

<%
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
	BitstreamService bitstreamService = ContentServiceFactory.getInstance().getBitstreamService();
    CommunityService communityService = ContentServiceFactory.getInstance().getCommunityService();
%>

<dspace:layout locbar="nolink" titlekey="jsp.home.title" feedData="<%= feedData %>">
<%
	Set<String> topAuthors = new LinkedHashSet<String>();
	ArrayList<Item> mostViewedItems = new ArrayList<Item>();
	ArrayList<Item> mostDownloadedItems = new ArrayList<Item>();
	ArrayList<String[]> authorProfileRows = new ArrayList<String[]>();

	try
	{
		SolrLoggerService solrLoggerService = StatisticsServiceFactory.getInstance().getSolrLoggerService();
		String mostViewedFilter = "statistics_type:view AND type:" + Constants.ITEM + " AND isBot:false";
		ObjectCount[] topViewed = solrLoggerService.queryFacetField("*:*", mostViewedFilter, "id", 15, false, null);
		if (topViewed != null)
		{
			for (ObjectCount count : topViewed)
			{
				try
				{
					Item item = itemService.find(UIUtil.obtainContext(request), UUID.fromString(count.getValue()));
					if (item != null)
					{
						mostViewedItems.add(item);
					}
				}
				catch (Exception ignore)
				{
				}
			}
		}

		String mostDownloadedFilter = "statistics_type:view AND type:" + Constants.BITSTREAM + " AND isBot:false AND bundleName:" + Constants.CONTENT_BUNDLE_NAME;
		ObjectCount[] topDownloaded = solrLoggerService.queryFacetField("*:*", mostDownloadedFilter, "id", 15, false, null);
		if (topDownloaded != null)
		{
			Set<UUID> seenItems = new LinkedHashSet<UUID>();
			for (ObjectCount count : topDownloaded)
			{
				try
				{
					Bitstream bitstream = bitstreamService.find(UIUtil.obtainContext(request), UUID.fromString(count.getValue()));
					if (bitstream != null)
					{
						DSpaceObject parent = bitstreamService.getParentObject(UIUtil.obtainContext(request), bitstream);
						if (parent != null && parent.getType() == Constants.ITEM)
						{
							Item item = (Item) parent;
							if (!seenItems.contains(item.getID()))
							{
								mostDownloadedItems.add(item);
								seenItems.add(item.getID());
							}
						}
					}
				}
				catch (Exception ignore)
				{
				}
			}
		}
	}
	catch (Exception ignore)
	{
	}

	if (submissions != null)
	{
		for (Item item : submissions.getRecentSubmissions())
		{
			String author = itemService.getMetadataFirstValue(item, "dc", "contributor", "author", Item.ANY);
			if (author != null && author.trim().length() > 0)
			{
				topAuthors.add(author.trim());
			}
			if (topAuthors.size() >= 5)
			{
				break;
			}
		}
	}

	try
	{
		BrowseIndex authorIndex = BrowseIndex.getBrowseIndex("author");
		if (authorIndex != null)
		{
			BrowserScope authorScope = new BrowserScope(UIUtil.obtainContext(request));
			authorScope.setBrowseIndex(authorIndex);
			authorScope.setResultsPerPage(5);
			authorScope.setOrder(SortOption.ASCENDING);
			BrowseEngine be = new BrowseEngine(UIUtil.obtainContext(request));
			BrowseInfo authorInfo = be.browseMini(authorScope);
			String[][] authorResults = authorInfo.getStringResults();
			for (int i = 0; i < authorResults.length && i < 5; i++)
			{
				authorProfileRows.add(authorResults[i]);
			}
		}
	}
	catch (Exception ignore)
	{
	}
%>

<script type="text/javascript">
	function toggle_visibility(classname) {
		var el = document.getElementsByClassName(classname);
		$(el).each(function (i, e) {
			if (e.style.display == 'block' || e.style.display == '') {
				e.style.display = 'none';
			} else {
				e.style.display = 'block';
			}
		});
	}

	$(document).ready(function(){
		$("#browse").click(function(){
			$("#ul-browse").toggle();
		});
		$("#login").click(function(){
			$("#ul-login").toggle();
		});
	});
</script>

<div class="row">
<div class="browse-sidebar col-md-3">
	<div class="browse-rightbar">
		<div class="browse-title list-group-item row" style="border-top-right-radius:0px;">
			<a href="#" id="browse" class="browse-a"><p style="font-weight: bolder;margin-top: 4px;color: white;margin-bottom: 4px;">Duyệt theo</p></a>
		</div>
		<ul class="list-group" style="box-shadow: none;background: #dde8eb;margin-left: 10px;margin-right: 10px; height: 240px;" id="ul-browse">
			<li class="browse-cotent btn btn-default"><a style="color: #333333;" href="<%= request.getContextPath() %>/community-list">Đơn vị &amp; Bộ sưu tập</a></li>
			<li class="browse-cotent btn btn-default"><a style="color: #333333;" href="<%= request.getContextPath() %>/browse?type=dateissued">Năm xuất bản</a></li>
			<li class="browse-cotent btn btn-default"><a style="color: #333333;" href="<%= request.getContextPath() %>/browse?type=author">Tác giả</a></li>
			<li class="browse-cotent btn btn-default"><a style="color: #333333;" href="<%= request.getContextPath() %>/browse?type=title">Nhan đề</a></li>
			<li class="browse-cotent btn btn-default"><a style="color: #333333;" href="<%= request.getContextPath() %>/browse?type=subject">Chủ đề</a></li>
			<li class="browse-cotent btn btn-default"><a style="color: #333333;" href="<%= request.getContextPath() %>/browse?type=advisor">Người hướng dẫn</a></li>
		</ul>
	</div>
	<div class="browse-rightbar">
		<div class="browse-title list-group-item row" style="border-top-right-radius:0px;">
			<a href="<%= request.getContextPath() %>/browse?type=author" id="authorprofile" class="browse-a"><p style="font-weight: bolder;margin-top: 4px;color: white;margin-bottom: 4px;">Hồ sơ tác giả</p></a>
		</div>
		<div id="facets" class="facetsBox test-author-profile">
			<ul class="list-group" style="box-shadow: none;background: #dde8eb;margin-left: 10px;margin-right: 10px; height: 200px;">
<%
	if (!authorProfileRows.isEmpty())
	{
		for (String[] row : authorProfileRows)
		{
			String authorValue = row[0];
			String authorAuthority = row[1];
			String authorCount = row.length > 2 ? row[2] : null;
			String authorLink = request.getContextPath() + "/browse?type=author";
			if (authorAuthority != null)
			{
				authorLink += "&amp;authority=" + java.net.URLEncoder.encode(authorAuthority, "UTF-8");
			}
			else
			{
				authorLink += "&amp;value=" + java.net.URLEncoder.encode(authorValue, "UTF-8");
			}
%>
				<li class="browse-cotent btn btn-default">
					<a href="<%= authorLink %>" title="Lọc theo <%= Utils.addEntities(authorValue) %>"><%= Utils.addEntities(authorValue) %></a>
<%
			if (authorCount != null && authorCount.trim().length() > 0)
			{
%>
					(<%= authorCount %>)
<%
			}
%>
				</li>
<%
		}
	}
	else if (!topAuthors.isEmpty())
	{
		for (String author : topAuthors)
		{
			String encodedAuthor = java.net.URLEncoder.encode(author, "UTF-8");
%>
				<li class="browse-cotent btn btn-default">
					<a href="<%= request.getContextPath() %>/browse?type=author&amp;value=<%= encodedAuthor %>" title="Lọc theo <%= Utils.addEntities(author) %>"><%= Utils.addEntities(author) %></a>
				</li>
<%
		}
	}
	else
	{
%>
				<li class="browse-cotent btn btn-default">Chưa có dữ liệu</li>
<%
	}
%>
			</ul>
		</div>
	</div>
	<div id="weblink" style="width: 303px;">
		<div id="body">
			<select id="myselect" style="width:95%;" onchange="showLink(this);">
				<option value="">--- Liên kết Websites ---</option>
				<option value="http://repository.vnu.edu.vn/">Thư viện đại học quốc gia Hà Nội</option>
				<option value="http://dlib.hust.edu.vn/">Thư viện đại học bách khoa Hà Nội</option>
				<option value="http://dlib.huc.edu.vn/">Thư viện đại học văn hóa</option>
				<option value="http://thuvien.ajc.edu.vn:8080/dspace/">Thư viện học viện báo chí &amp; tuyên truyền</option>
				<option value="http://digital.lib.ueh.edu.vn/">Thư viện đại học kinh tế Hồ Chí Minh</option>
			</select>
			<script type="text/javascript">
				$(function(){
					$('#myselect').bind('change', function () {
						var url = $(this).val();
						if (url) {
							window.open(url,'_blank');
						}
						return false;
					});
				});
			</script>
		</div>
	</div>
</div>

<div class="col-md-6" style="padding-left: 0px; padding-right: 0px;">
	<div class="collections-container" style="padding-left: 0px;padding-right: 0px;margin-bottom: 30px;">
		<div class="browse-title list-group-item row" style="background: url(<%= request.getContextPath() %>/img/bar-com.png); margin-top: 10px;margin-left:0px;background-size: 101% 100%;">
			<p style="margin-top: 4px;color: white;margin-bottom: 4px;font-weight: bolder;">Các bộ sưu tập</p>
		</div>
		<a href="#" onclick="toggle_visibility('view-type')">Lựa chọn hiển thị : Dạng lưới | Dạng danh mục</a>
		<div class="col-md-12 view-type" style="padding-left: 0px;padding-right: 0px;" id="grid">
<%
	if (communities != null && communities.size() != 0)
	{
		boolean showLogos = configurationService.getBooleanProperty("jspui.home-page.logos", true);
		for (Community com : communities)
		{
			Bitstream logo = com.getLogo();
%>
			<div class="col-md-4" style="margin-top: 20px;">
				<div class="container container-com" style="background:#f2f2f2; padding: 10px;">
					<a href="<%= request.getContextPath() %>/handle/<%= com.getHandle() %>">
<%
			if (showLogos && logo != null)
			{
%>
						<img alt="Logo" class="img-responsive" src="<%= request.getContextPath() %>/retrieve/<%= logo.getID() %>" style="margin-left: auto;margin-right: auto;"/>
<%
			}
			else
			{
%>
						<img alt="Logo" class="img-responsive" src="<%= request.getContextPath() %>/image/logo.gif" style="margin-left: auto;margin-right: auto;"/>
<%
			}
%>
						<div class="overlay"><div class="text"><%= Utils.addEntities(com.getName()) %></div></div>
					</a>
				</div>
			</div>
<%
		}
	}
%>
		</div>

		<div class="col-md-12 view-type" id="list" style="display : none">
			<div class="list-group">
<%
	if (communities != null && communities.size() != 0)
	{
		boolean showLogos = configurationService.getBooleanProperty("jspui.home-page.logos", true);
		for (Community com : communities)
		{
			Bitstream logo = com.getLogo();
%>
				<div class="list-group-item row">
<%
			if (showLogos && logo != null)
			{
%>
					<div class="col-md-3">
						<img alt="Logo" class="img-responsive" src="<%= request.getContextPath() %>/retrieve/<%= logo.getID() %>" />
					</div>
					<div class="col-md-9">
<%
			}
			else
			{
%>
					<div class="col-md-12">
<%
			}
%>
						<h4 class="list-group-item-heading">
							<a href="<%= request.getContextPath() %>/handle/<%= com.getHandle() %>"><%= Utils.addEntities(com.getName()) %></a>
<%
			if (configurationService.getBooleanProperty("webui.strengths.show"))
			{
%>
							<span class="badge pull-right"><%= ic.getCount(com) %></span>
<%
			}
%>
						</h4>
						<p><%= communityService.getMetadata(com, "short_description") %></p>
					</div>
				</div>
<%
		}
	}
%>
			</div>
		</div>
	</div>

</div>

<div class="col-md-3" style="margin-top: 10px;padding-right: 10px; padding-left: 10px;">
	<button type="button" class="btn btn-default col-md-12"><a style="color: #333333;" href="<%= request.getContextPath() %>/help"><img src="<%= request.getContextPath() %>/img/icon-user.png" alt="Hướng dẫn" />&nbsp;Hướng dẫn tìm kiếm</a></button>
	<button type="button" class="btn btn-default col-md-12" style="margin-top: 4px;"><a style="color: #333333;" href="<%= request.getContextPath() %>/feedback"><img src="<%= request.getContextPath() %>/img/icon-user.png" alt="Góp ý" />&nbsp;Hòm thư góp ý</a></button>
	<div class="web-interface">
		<div class="browse-rightbar">
			<div class="browse-title list-group-item row" style="border-top-right-radius:0px;margin-left:0px;margin-right:0px;"><a href="#" id="browse" class="browse-a"><p style="text-align: center;font-weight: bolder;margin-top: 4px;color: white;margin-bottom: 4px;">Cơ sở dữ liệu trực tuyến</p></a></div>
			<ul class="list-group" style="box-shadow: none;height: auto;margin-bottom: 10px;padding-bottom: 10px;border: 1px solid #ddd;" id="ul-browse">
				<li style="list-style-type: none; text-align: center; margin-top: 4px;"><a target="_blank" href="#"><img src="<%= request.getContextPath() %>/img/proquest.png" alt="ProQuest" /></a></li>
				<li style="list-style-type: none; text-align: center; margin-top: 4px;"><a target="_blank" href="http://db.vista.gov.vn/"><img src="<%= request.getContextPath() %>/img/CSDL.png" alt="CSDL" /></a></li>
				<li style="list-style-type: none; text-align: center; margin-top: 4px;"><a target="_blank" href="http://portal.igpublish.com/iglibrary/"><img src="<%= request.getContextPath() %>/img/tIG.png" alt="IG" /></a></li>
				<li style="list-style-type: none; text-align: center; margin-top: 4px;"><a target="_blank" href="http://journals.sagepub.com/"><img src="<%= request.getContextPath() %>/img/tSage.png" alt="Sage" /></a></li>
				<li style="list-style-type: none; text-align: center; margin-top: 4px;"><a target="_blank" href="http://ebookcentral.proquest.com/"><img src="<%= request.getContextPath() %>/img/tebook.png" alt="Ebook" /></a></li>
			</ul>
		</div>
		<div class="browse-rightbar">
			<div class="browse-title list-group-item row" style="border-top-right-radius:0px;margin-left:0px;margin-right:0px;"><a href="#" id="browse" class="browse-a"><p style="text-align:center; font-weight: bolder;margin-top: 4px;color: white;margin-bottom: 4px;">Liên kết trong Học viện</p></a></div>
			<ul class="list-group" style="box-shadow: none;height: auto;border: 1px solid #ddd;" id="ul-browse">
				<li style="list-style-type: none; text-align: center; margin-top: 4px; border-bottom: 1px solid #ddd;"><a target="_blank" href="http://portal.ptit.edu.vn/tuyensinh/"><img src="<%= request.getContextPath() %>/img/1.png" alt="Lien ket 1" /></a></li>
				<li style="list-style-type: none; text-align: center; margin-top: 4px; border-bottom: 1px solid #ddd;"><a target="_blank" href="http://portal.ptit.edu.vn/saudaihoc/"><img src="<%= request.getContextPath() %>/img/2.png" alt="Lien ket 2" /></a></li>
				<li style="list-style-type: none; text-align: center; margin-top: 4px;border-bottom: 1px solid #ddd;"><a target="_blank" href="http://daihoctuxa.ptit.edu.vn/"><img src="<%= request.getContextPath() %>/img/t3.png" alt="Lien ket 3" /></a></li>
				<li style="list-style-type: none; text-align: center; margin-top: 4px;"><a target="_blank" href="https://portal.ptit.edu.vn/"><img src="<%= request.getContextPath() %>/img/tct1.png" alt="Lien ket 4" /></a></li>
			</ul>
		</div>
		<div class="browse-rightbar">
			<div class="browse-title list-group-item row" style="border-top-right-radius:0px;margin-left:0px;margin-right:0px;"><a href="#" id="browse" class="browse-a"><p style="text-align:center; font-weight: bolder;margin-top: 4px;color: white;margin-bottom: 4px;">Liên kết các thư viện số khác</p></a></div>
			<ul class="list-group" style="box-shadow: none;height: auto;border: 1px solid #ddd;" id="ul-browse">
				<li style="list-style-type: none; text-align: center; margin-top: 4px; border-bottom: 1px solid #ddd;"><a target="_blank" href="https://repository.vnu.edu.vn/"><img src="<%= request.getContextPath() %>/img/tt3.png" alt="Lien ket thu vien 1" /></a></li>
				<li style="list-style-type: none; text-align: center; margin-top: 4px; border-bottom: 1px solid #ddd;"><a target="_blank" href="https://dlib.hust.edu.vn/"><img src="<%= request.getContextPath() %>/img/tt4.png" alt="Lien ket thu vien 2" /></a></li>
				<li style="list-style-type: none; text-align: center; margin-top: 4px; border-bottom: 1px solid #ddd;"><a target="_blank" href="http://tailieuso.udn.vn/"><img src="<%= request.getContextPath() %>/img/tt5.png" alt="Lien ket thu vien 3" /></a></li>
				<li style="list-style-type: none; text-align: center; margin-top: 4px; border-bottom: 1px solid #ddd;"><a target="_blank" href="http://thuvienso.hcmute.edu.vn/"><img src="<%= request.getContextPath() %>/img/tt6.png" alt="Lien ket thu vien 4" /></a></li>
				<li style="list-style-type: none; text-align: center; margin-top: 4px;"><a target="_blank" href="http://huc.dspace.vn/"><img src="<%= request.getContextPath() %>/img/tt7.png" alt="Lien ket thu vien 5" /></a></li>
			</ul>
		</div>
	</div>
</div>

</div>

</dspace:layout>
