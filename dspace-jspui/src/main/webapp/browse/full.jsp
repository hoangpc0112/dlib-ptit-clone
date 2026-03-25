<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Display the results of browsing a full hit list
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.browse.BrowseInfo" %>
<%@ page import="org.dspace.sort.SortOption" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.browse.BrowseIndex" %>
<%@ page import="org.dspace.browse.BrowseEngine" %>
<%@ page import="org.dspace.browse.BrowserScope" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.dspace.content.DCDate" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.sort.SortOption" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.dspace.content.factory.ContentServiceFactory" %>
<%@ page import="org.dspace.content.service.ItemService" %>
<%@ page import="org.dspace.content.Thumbnail" %>
<%@ page import="org.dspace.content.MetadataValue" %>
<%@ page import="java.util.List" %>

<%
    request.setAttribute("LanguageSwitch", "hide");

    String urlFragment = "browse";
    String layoutNavbar = "default";
    boolean withdrawn = false;
    boolean privateitems = false;

    // Is the logged in user an admin or community admin or collection admin
    Boolean admin = (Boolean)request.getAttribute("is.admin");
    boolean isAdmin = (admin == null ? false : admin.booleanValue());

    Boolean communityAdmin = (Boolean)request.getAttribute("is.communityAdmin");
    boolean isCommunityAdmin = (communityAdmin == null ? false : communityAdmin.booleanValue());

    Boolean collectionAdmin = (Boolean)request.getAttribute("is.collectionAdmin");
    boolean isCollectionAdmin = (collectionAdmin == null ? false : collectionAdmin.booleanValue());

    if (request.getAttribute("browseWithdrawn") != null)
    {
        layoutNavbar = "admin";
        urlFragment = "dspace-admin/withdrawn";
        withdrawn = true;

        if(!isAdmin && (isCommunityAdmin || isCollectionAdmin))
        {
            layoutNavbar = "community-or-collection-admin";
        }
    }
    else if (request.getAttribute("browsePrivate") != null)	
    {
        layoutNavbar = "admin";
        urlFragment = "dspace-admin/privateitems";
        privateitems = true;

        if(!isAdmin && (isCommunityAdmin || isCollectionAdmin))
        {
            layoutNavbar = "community-or-collection-admin";
        }
    }

        // First, get the browse info object
        BrowseInfo bi = (BrowseInfo) request.getAttribute("browse.info");
        BrowseIndex bix = bi.getBrowseIndex();
        SortOption so = bi.getSortOption();

        // values used by the header
        String scope = "";
        String type = "";
        String value = "";
	
        Community community = null;
        Collection collection = null;
        if (bi.inCommunity())
        {
                community = (Community) bi.getBrowseContainer();
        }
        if (bi.inCollection())
        {
                collection = (Collection) bi.getBrowseContainer();
        }
	
        if (community != null)
        {
                scope = "\"" + community.getName() + "\"";
        }
        if (collection != null)
        {
                scope = "\"" + collection.getName() + "\"";
        }
	
        type = bix.getName();
	
        // next and previous links are of the form:
        // [handle/<prefix>/<suffix>/]browse?type=<type>&sort_by=<sort_by>&order=<order>[&value=<value>][&rpp=<rpp>][&[focus=<focus>|vfocus=<vfocus>]
	
        // prepare the next and previous links
        String linkBase = request.getContextPath() + "/";
        if (collection != null)
        {
                linkBase = linkBase + "handle/" + collection.getHandle() + "/";
        }
        if (community != null)
        {
                linkBase = linkBase + "handle/" + community.getHandle() + "/";
        }
	
        String direction = (bi.isAscending() ? "ASC" : "DESC");
	
        String argument = null;
        if (bi.hasAuthority())
    {
        value = bi.getAuthority();
        argument = "authority";
    }
        else if (bi.hasValue())
        {
                value = bi.getValue();
            argument = "value";
        }

        String valueString = "";
        if (value!=null)
        {
                valueString = "&amp;" + argument + "=" + URLEncoder.encode(value, "UTF-8");
        }
	
    String sharedLink = linkBase + urlFragment + "?";

    if (bix.getName() != null)
        sharedLink += "type=" + URLEncoder.encode(bix.getName(), "UTF-8");

    sharedLink += "&amp;sort_by=" + URLEncoder.encode(Integer.toString(so.getNumber()), "UTF-8") +
                                  "&amp;order=" + URLEncoder.encode(direction, "UTF-8") +
                                  "&amp;rpp=" + URLEncoder.encode(Integer.toString(bi.getResultsPerPage()), "UTF-8") +
                                  "&amp;etal=" + URLEncoder.encode(Integer.toString(bi.getEtAl()), "UTF-8") +
                                  valueString;
	
        String next = sharedLink;
        String prev = sharedLink;
	
        if (bi.hasNextPage())
    {
        next = next + "&amp;offset=" + bi.getNextOffset();
    }
	
        if (bi.hasPrevPage())
    {
        prev = prev + "&amp;offset=" + bi.getPrevOffset();
    }
	
        // prepare a url for use by form actions
        String formaction = request.getContextPath() + "/";
        if (collection != null)
        {
                formaction = formaction + "handle/" + collection.getHandle() + "/";
        }
        if (community != null)
        {
                formaction = formaction + "handle/" + community.getHandle() + "/";
        }
        formaction = formaction + urlFragment;
	
        // prepare the known information about sorting, ordering and results per page
        String sortedBy = so.getName();
        String ascSelected = (bi.isAscending() ? "selected=\"selected\"" : "");
        String descSelected = (bi.isAscending() ? "" : "selected=\"selected\"");
        int rpp = bi.getResultsPerPage();
	
        // the message key for the type
        String typeKey;

        if (bix.isMetadataIndex())
                typeKey = "browse.type.metadata." + bix.getName();
        else if (bi.getSortOption() != null)
                typeKey = "browse.type.item." + bi.getSortOption().getName();
        else
                typeKey = "browse.type.item." + bix.getSortOption().getName();

    // Admin user or not
    Boolean admin_b = (Boolean)request.getAttribute("admin_button");
    boolean admin_button = (admin_b == null ? false : admin_b.booleanValue());

	ArrayList<String[]> authorProfileRows = new ArrayList<String[]>();
	ItemService itemService = ContentServiceFactory.getInstance().getItemService();
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

<%-- OK, so here we start to develop the various components we will use in the UI --%>

<%@page import="java.util.Set"%>
<dspace:layout titlekey="browse.page-title" navbar="<%=layoutNavbar %>">

	<script type="text/javascript">
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
				authorLink += "&amp;authority=" + URLEncoder.encode(authorAuthority, "UTF-8");
			}
			else
			{
				authorLink += "&amp;value=" + URLEncoder.encode(authorValue, "UTF-8");
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
		</div>

		<div class="col-md-9">

	<%-- Build the header (careful use of spacing) --%>
	<h2>
		<fmt:message key="browse.full.header"><fmt:param value="<%= scope %>"/></fmt:message> <fmt:message key="<%= typeKey %>"/> <%= value %>
	</h2>

	<%-- Include the main navigation for all the browse pages --%>
	<%-- This first part is where we render the standard bits required by both possibly navigations --%>
	<div id="browse_navigation" class="well text-center">
	<form method="get" action="<%= formaction %>">
			<input type="hidden" name="type" value="<%= bix.getName() %>"/>
			<input type="hidden" name="sort_by" value="<%= so.getNumber() %>"/>
			<input type="hidden" name="order" value="<%= direction %>"/>
			<input type="hidden" name="rpp" value="<%= rpp %>"/>
			<input type="hidden" name="etal" value="<%= bi.getEtAl() %>" />
<%
		if (bi.hasAuthority())
		{
		%><input type="hidden" name="authority" value="<%=bi.getAuthority() %>"/><%
		}
		else if (bi.hasValue())
		{
			%><input type="hidden" name="value" value="<%= bi.getValue() %>"/><%
		}
%>
	
	<%-- If we are browsing by a date, or sorting by a date, render the date selection header --%>
<%
	if (so.isDate() || (bix.isDate() && so.isDefault()))
	{
%>
		<span><fmt:message key="browse.nav.date.jump"/></span>
		<select name="year">
	        <option selected="selected" value="-1"><fmt:message key="browse.nav.year"/></option>
<%
		int thisYear = DCDate.getCurrent().getYear();
		for (int i = thisYear; i >= 1990; i--)
		{
%>
            <option><%= i %></option>
<%
		}
%>
            <option>1985</option>
            <option>1980</option>
            <option>1975</option>
            <option>1970</option>
            <option>1960</option>
            <option>1950</option>
        </select>
        <select name="month">
            <option selected="selected" value="-1"><fmt:message key="browse.nav.month"/></option>
<%
		for (int i = 1; i <= 12; i++)
		{
%>
	         <option value="<%= i %>"><%= DCDate.getMonthName(i, UIUtil.getSessionLocale(request)) %></option>
<%
		}
%>
        </select>
        <input type="submit" class="btn btn-default" value="<fmt:message key="browse.nav.go"/>" />
        <br/>
        <label for="starts_with"><fmt:message key="browse.nav.type-year"/></label>
        <input type="text" name="starts_with" size="4" maxlength="4"/>
<%
	}
	
	// If we are not browsing by a date, render the string selection header //
	else
	{
%>	
		<span><fmt:message key="browse.nav.jump"/></span>
	                        <a class="label label-default" href="<%= sharedLink %>&amp;starts_with=0">0-9</a>
<%
	    for (char c = 'A'; c <= 'Z'; c++)
	    {
%>
	                        <a class="label label-default" href="<%= sharedLink %>&amp;starts_with=<%= c %>"><%= c %></a>
<%
	    }
%><br/>
	    					<span><fmt:message key="browse.nav.enter"/></span>
	    					<input type="text" name="starts_with"/>&nbsp;<input type="submit" class="btn btn-default" value="<fmt:message key="browse.nav.go"/>" />
<%
	}
%>
	</form>
	</div>
	<%-- End of Navigation Headers --%>

	<%-- Include a component for modifying sort by, order, results per page, and et-al limit --%>
	<div id="browse_controls" class="well text-center">
	<form method="get" action="<%= formaction %>">
		<input type="hidden" name="type" value="<%= bix.getName() %>"/>
<%
		if (bi.hasAuthority())
		{
		%><input type="hidden" name="authority" value="<%=bi.getAuthority() %>"/><%
		}
		else if (bi.hasValue())
		{
			%><input type="hidden" name="value" value="<%= bi.getValue() %>"/><%
		}
%>
<%-- The following code can be used to force the browse around the current focus.  Without
      it the browse will revert to page 1 of the results each time a change is made --%>
<%--
		if (!bi.hasItemFocus() && bi.hasFocus())
		{
			%><input type="hidden" name="vfocus" value="<%= bi.getFocus() %>"/><%
		}
--%>

<%--
		if (bi.hasItemFocus())
		{
			%><input type="hidden" name="focus" value="<%= bi.getFocusItem() %>"/><%
		}
--%>
<%
	Set<SortOption> sortOptions = SortOption.getSortOptions();
	if (sortOptions.size() > 1) // && bi.getBrowseLevel() > 0
	{
%>
		<label for="sort_by"><fmt:message key="browse.full.sort-by"/></label>
		<select name="sort_by">
<%
		for (SortOption sortBy : sortOptions)
		{
            if (sortBy.isVisible())
            {
                String selected = (sortBy.getName().equals(sortedBy) ? "selected=\"selected\"" : "");
                String mKey = "browse.sort-by." + sortBy.getName();
                %> <option value="<%= sortBy.getNumber() %>" <%= selected %>><fmt:message key="<%= mKey %>"/></option><%
            }
        }
%>
		</select>
<%
	}
%>
		<label for="order"><fmt:message key="browse.full.order"/></label>
		<select name="order">
			<option value="ASC" <%= ascSelected %>><fmt:message key="browse.order.asc" /></option>
			<option value="DESC" <%= descSelected %>><fmt:message key="browse.order.desc" /></option>
		</select>

		<label for="rpp"><fmt:message key="browse.full.rpp"/></label>
		<select name="rpp">
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

		<label for="etal"><fmt:message key="browse.full.etal" /></label>
		<select name="etal">
<%
	String unlimitedSelect = "";
	if (bi.getEtAl() == -1)
	{
		unlimitedSelect = "selected=\"selected\"";
	}
%>
			<option value="0" <%= unlimitedSelect %>><fmt:message key="browse.full.etal.unlimited"/></option>
<%
	int cfgd = ConfigurationManager.getIntProperty("webui.browse.author-limit");
	boolean insertedCurrent = false;
	boolean insertedDefault = false;
	for (int i = 0; i <= 50 ; i += 5)
	{
		// for the first one, we want 1 author, not 0
		if (i == 0)
		{
			String sel = (i + 1 == bi.getEtAl() ? "selected=\"selected\"" : "");
			%><option value="1" <%= sel %>>1</option><%
		}
		
		// if the current i is greated than that configured by the user,
		// insert the one specified in the right place in the list
		if (i > bi.getEtAl() && !insertedCurrent && bi.getEtAl() != -1 && bi.getEtAl() != 0 && bi.getEtAl() != 1)
		{
			%><option value="<%= bi.getEtAl() %>" selected="selected"><%= bi.getEtAl() %></option><%
			insertedCurrent = true;
		}
		
		// if the current i is greated than that configured by the administrator (dspace.cfg)
		// insert the one specified in the right place in the list
		if (i > cfgd && !insertedDefault && cfgd != -1 && cfgd != 0 && cfgd != 1 && bi.getEtAl() != cfgd)
		{
			%><option value="<%= cfgd %>"><%= cfgd %></option><%
			insertedDefault = true;
		}
		
		// determine if the current not-special case is selected
		String selected = (i == bi.getEtAl() ? "selected=\"selected\"" : "");
		
		// do this for all other cases than the first and the current
		if (i != 0 && i != bi.getEtAl())
		{
%>	
			<option value="<%= i %>" <%= selected %>><%= i %></option>
<%
		}
	}
%>
		</select>

		<input type="submit" class="btn btn-default" name="submit_browse" value="<fmt:message key="jsp.general.update"/>"/>

<%
    if (admin_button && !withdrawn && !privateitems)
    {
        %><input type="submit" class="btn btn-default" name="submit_export_metadata" value="<fmt:message key="jsp.general.metadataexport.button"/>" /><%
    }
%>

	</form>
	</div>
<div class="panel panel-primary">
	<%-- give us the top report on what we are looking at --%>
	<div class="panel-heading text-center">
		<fmt:message key="browse.full.range">
			<fmt:param value="<%= Integer.toString(bi.getStart()) %>"/>
			<fmt:param value="<%= Integer.toString(bi.getFinish()) %>"/>
			<fmt:param value="<%= Integer.toString(bi.getTotal()) %>"/>
		</fmt:message>

	<%--  do the top previous and next page links --%>
<% 
	if (bi.hasPrevPage())
	{
%>
	<a class="pull-left" href="<%= prev %>"><fmt:message key="browse.full.prev"/></a>&nbsp;
<%
	}
%>

<%
	if (bi.hasNextPage())
	{
%>
	&nbsp;<a class="pull-right" href="<%= next %>"><fmt:message key="browse.full.next"/></a>
<%
	}
%>
	</div>
	
	<%-- output the results using the cloned list layout --%>
	<%
		List<Item> items = bi.getResults();
		for (Item item : items)
		{
			String title = itemService.getMetadataFirstValue(item, "dc", "title", null, Item.ANY);
			if (title == null)
			{
				title = "Untitled";
			}
			String typeValue = itemService.getMetadataFirstValue(item, "dc", "type", null, Item.ANY);
			String issued = itemService.getMetadataFirstValue(item, "dc", "date", "issued", Item.ANY);
			String yearValue = null;
			if (issued != null)
			{
				try
				{
					yearValue = Integer.toString(new DCDate(issued).getYear());
				}
				catch (Exception ignore)
				{
					yearValue = issued;
				}
			}
			String abs = itemService.getMetadataFirstValue(item, "dc", "description", "abstract", Item.ANY);
			if (abs == null || abs.trim().length() == 0)
			{
				abs = "-";
			}

			List<MetadataValue> authorValues = itemService.getMetadata(item, "dc", "contributor", "author", Item.ANY);
			List<MetadataValue> advisorValues = itemService.getMetadata(item, "dc", "contributor", "advisor", Item.ANY);

			StringBuilder authors = new StringBuilder();
			for (int i = 0; i < authorValues.size(); i++)
			{
				if (i > 0)
				{
					authors.append("; ");
				}
				authors.append(authorValues.get(i).getValue());
			}

			StringBuilder advisors = new StringBuilder();
			for (int i = 0; i < advisorValues.size(); i++)
			{
				if (i > 0)
				{
					advisors.append("; ");
				}
				advisors.append(advisorValues.get(i).getValue());
			}

			Thumbnail thumbnail = null;
			try
			{
				thumbnail = itemService.getThumbnail(UIUtil.obtainContext(request), item, false);
			}
			catch (Exception ignore)
			{
			}
			String thumbUrl = (thumbnail != null && thumbnail.getThumb() != null)
					? request.getContextPath() + "/retrieve/" + thumbnail.getThumb().getID()
					: request.getContextPath() + "/image/item.png";
	%>
	<div class="browse-list row">
		<div class="col-md-3">
			<div class="browse-img">
				<li type="none" style="list-style-type: none;">
					<a href="<%= request.getContextPath() %>/handle/<%= item.getHandle() %>"><img src="<%= thumbUrl %>" class="thumbnails" alt="thumb" /></a>
				</li>
			</div>
		</div>
		<div class="col-md-9 browse-list-content">
			<div class="col-md-12 browse-type"><li type="none" style="float: left; list-style-type: none;"><em><%= Utils.addEntities(typeValue == null ? "" : typeValue) %></em></li></div><br>
			<div class="col-md-12 browse-titles"><li type="none" style="float: left; list-style-type: none;"><strong><a style="color: black;" href="<%= request.getContextPath() %>/handle/<%= item.getHandle() %>"><%= Utils.addEntities(title) %></a></strong></li></div><br>
			<div class="col-md-12 browse-author">
				Authors: <em><%= Utils.addEntities(authors.toString()) %></em>
				<% if (advisors.length() > 0) { %>; &nbsp;Advisor: <em><%= Utils.addEntities(advisors.toString()) %></em><% } %>
				<% if (yearValue != null) { %><em style="color:#8f8c8c;">&nbsp;(<em><%= Utils.addEntities(yearValue) %></em>)</em><% } %>
			</div><br>
			<div class="col-md-12 abstract"><li type="none" style="float: left; list-style-type: none;"><em><%= Utils.addEntities(abs) %></em></li></div>
		</div>
		<br>
	</div>
	<%
		}
	%>
	<%-- give us the bottom report on what we are looking at --%>
	<div class="panel-footer text-center">
		<fmt:message key="browse.full.range">
			<fmt:param value="<%= Integer.toString(bi.getStart()) %>"/>
			<fmt:param value="<%= Integer.toString(bi.getFinish()) %>"/>
			<fmt:param value="<%= Integer.toString(bi.getTotal()) %>"/>
		</fmt:message>

	<%--  do the bottom previous and next page links --%>
<% 
	if (bi.hasPrevPage())
	{
%>
	<a class="pull-left" href="<%= prev %>"><fmt:message key="browse.full.prev"/></a>&nbsp;
<%
	}
%>

<%
	if (bi.hasNextPage())
	{
%>
	&nbsp;<a class="pull-right" href="<%= next %>"><fmt:message key="browse.full.next"/></a>
<%
	}
%>
	</div>
</div>
	<%-- dump the results for debug (uncomment to enable) --%>
	<%-- 
	<!-- <%= bi.toString() %> -->
	--%>

		</div>
	</div>
</dspace:layout>