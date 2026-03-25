<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - HTML header for main home page
  --%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.util.List"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="org.dspace.app.webui.util.JSPManager" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.app.util.Util" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.core.Utils" %>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.*" %>

<%
    String title = (String) request.getAttribute("dspace.layout.title");
    String navbar = (String) request.getAttribute("dspace.layout.navbar");
    boolean locbar = ((Boolean) request.getAttribute("dspace.layout.locbar")).booleanValue();

    String siteName = ConfigurationManager.getProperty("dspace.name");
    String feedRef = (String)request.getAttribute("dspace.layout.feedref");
    boolean osLink = ConfigurationManager.getBooleanProperty("websvc.opensearch.autolink");
    String osCtx = ConfigurationManager.getProperty("websvc.opensearch.svccontext");
    String osName = ConfigurationManager.getProperty("websvc.opensearch.shortname");
    List parts = (List)request.getAttribute("dspace.layout.linkparts");
    String extraHeadData = (String)request.getAttribute("dspace.layout.head");
    String extraHeadDataLast = (String)request.getAttribute("dspace.layout.head.last");
    String dsVersion = Util.getSourceVersion();
    String generator = dsVersion == null ? "DSpace" : "DSpace "+dsVersion;
    String analyticsKey = ConfigurationManager.getProperty("jspui.google.analytics.key");
    EPerson user = (EPerson) request.getAttribute("dspace.current.user");
    Boolean admin = (Boolean) request.getAttribute("is.admin");
    boolean isAdmin = (admin == null ? false : admin.booleanValue());
    Boolean communityAdmin = (Boolean) request.getAttribute("is.communityAdmin");
    boolean isCommunityAdmin = (communityAdmin == null ? false : communityAdmin.booleanValue());
    Boolean collectionAdmin = (Boolean) request.getAttribute("is.collectionAdmin");
    boolean isCollectionAdmin = (collectionAdmin == null ? false : collectionAdmin.booleanValue());
%>

<!DOCTYPE html>
<html>
    <head>
        <title><%= siteName %>: <%= title %></title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="Generator" content="<%= generator %>" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="shortcut icon" href="<%= request.getContextPath() %>/favicon.ico" type="image/x-icon"/>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/jquery-ui/redmond/jquery-ui-1.12.1.css" type="text/css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/bootstrap/bootstrap.min.css" type="text/css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/bootstrap/bootstrap-theme.min.css" type="text/css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/bootstrap/dspace-theme.css" type="text/css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/bootstrap/dlcorp.css" type="text/css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/js/hover.css" type="text/css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/js/slidershow/jquery.bxslider.css" type="text/css" />
<%
    if (!"NONE".equals(feedRef))
    {
        for (int i = 0; i < parts.size(); i+= 3)
        {
%>
        <link rel="alternate" type="application/<%= (String)parts.get(i) %>" title="<%= (String)parts.get(i+1) %>" href="<%= request.getContextPath() %>/feed/<%= (String)parts.get(i+2) %>/<%= feedRef %>"/>
<%
        }
    }
    
    if (osLink)
    {
%>
        <link rel="search" type="application/opensearchdescription+xml" href="<%= request.getContextPath() %>/<%= osCtx %>description.xml" title="<%= osName %>"/>
<%
    }

    if (extraHeadData != null)
        { %>
<%= extraHeadData %>
<%
        }
%>
        
	<script type='text/javascript' src="<%= request.getContextPath() %>/static/js/jquery/jquery-3.4.1.min.js"></script>
	<script type='text/javascript' src='<%= request.getContextPath() %>/static/js/jquery/jquery-ui-1.12.1.min.js'></script>
    <script type='text/javascript' src='<%= request.getContextPath() %>/static/js/bootstrap/bootstrap.min.js'></script>
    <script type='text/javascript' src='<%= request.getContextPath() %>/static/js/holder.js'></script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/utils.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/choice-support.js"> </script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/js/pagilion.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/jquery.simplePagination.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/js/slidershow/jquery.bxslider.min.js"></script>
        <dspace:include page="/layout/google-analytics-snippet.jsp" />

    <%
    if (extraHeadDataLast != null)
    { %>
        <%= extraHeadDataLast %>
    <%
    }
    %>
    

<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
  <script src="<%= request.getContextPath() %>/static/js/html5shiv.js"></script>
  <script src="<%= request.getContextPath() %>/static/js/respond.min.js"></script>
<![endif]-->
    </head>

    <%-- HACK: leftmargin, topmargin: for non-CSS compliant Microsoft IE browser --%>
    <%-- HACK: marginwidth, marginheight: for non-CSS compliant Netscape browser --%>
    <body class="undernavigation" style="padding-top: 0px;background-color: white;">
<a class="sr-only" href="#content">Skip navigation</a>
<header class="navbar navbar-inverse navbar-fixed-top" style="position: inherit;background-image: linear-gradient(to bottom,#efefef 0,#efefef 100%);margin-bottom: 0px;box-shadow: none;background: white;border-color: white">
    <div class="container">
        <div class="web-interface">
            <nav class="collapse navbar-collapse bs-navbar-collapse" role="navigation">
                <div class="nav navbar-nav navbar-right">
                    <ul class="nav navbar-nav navbar-right">
                        <li class="dropdown">
                            <a href="http://portal.ptit.edu.vn/" target="_blank" style="color:#333333">Cổng thông tin Thư viện</a>
                        </li>
                        <li class="dropdown" style="font-size: 25px;margin-top: 5px;">|</li>
                        <li class="dropdown">
                            <a href="#" target="_blank" style="color:#333333">Sitemap</a>
                        </li>
                        <li class="dropdown">
                            <ul style="display: inline-flex;padding-left: 0px;">
                                <li style="list-style-type: none;margin-top: 12px;padding-right: 3px;">
                                    <a onclick="javascript:document.repost.locale.value='vi';document.repost.submit();" href="<%= request.getContextPath() %>/?locale=vi">
                                        <img src="<%= request.getContextPath() %>/img/vi.png" alt="VI" />
                                    </a>
                                </li>
                                <li style="list-style-type: none;margin-top: 12px;padding-right: 3px;">
                                    <a onclick="javascript:document.repost.locale.value='en';document.repost.submit();" href="<%= request.getContextPath() %>/?locale=en">
                                        <img src="<%= request.getContextPath() %>/img/en.png" alt="EN" />
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </div>
                <div class="nav navbar-nav navbar-right">
                    <ul class="nav navbar-nav navbar-right"></ul>
                </div>
            </nav>
        </div>
        <div class="mobile-interface">
            <nav class="navbar-collapse bs-navbar-collapse" role="navigation" style="border-color: #efefef;height: 60px;">
                <div class="nav navbar-nav navbar-right">
                    <ul class="nav navbar-nav navbar-right" style="display: -webkit-box;">
                        <li class="dropdown">
                            <a href="http://portal.ptit.edu.vn/" target="_blank" style="color:#333333">Cổng thông tin Thư viện</a>
                        </li>
                        <li class="dropdown" style="font-size: 25px;">|</li>
                        <li class="dropdown">
                            <a href="#" target="_blank" style="color:#333333">Sitemap</a>
                        </li>
                        <li class="dropdown">
                            <ul style="display: inline-flex;padding-left: 0px;">
                                <li style="list-style-type: none;margin-top: 8px;padding-right: 3px;">
                                    <a onclick="javascript:document.repost.locale.value='vi';document.repost.submit();" href="<%= request.getContextPath() %>/?locale=vi">
                                        <img src="<%= request.getContextPath() %>/img/vi.png" alt="VI" />
                                    </a>
                                </li>
                                <li style="list-style-type: none;margin-top: 8px;padding-right: 3px;">
                                    <a onclick="javascript:document.repost.locale.value='en';document.repost.submit();" href="<%= request.getContextPath() %>/?locale=en">
                                        <img src="<%= request.getContextPath() %>/img/en.png" alt="EN" />
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </div>
                <div class="nav navbar-nav navbar-right">
                    <ul class="nav navbar-nav navbar-right"></ul>
                </div>
            </nav>
        </div>
    </div>
</header>

<form name="repost" method="get" action="">
    <input type="hidden" name="locale" value="" />
</form>

<main id="content" role="main" style="padding-bottom: 0px;">
<div class="web-interface">
    <div class="banner">
        <div class="container">
            <div class="row">
                <a href="<%= request.getContextPath() %>/"><img src="<%= request.getContextPath() %>/img/Banner.png" style="background: transparent;margin-top: -6px;margin-left: 0px;width: 100%;margin-bottom: 0px;margin-right: 0px;padding: 0px;" alt="Banner" /></a>
                <div class="col-md-12" style="background-image: linear-gradient(to bottom,#e6e6e6 0,#fff 100%);">
                    <ul style="display: inline-flex;padding-left: 0px;margin-bottom: 0px;">
                        <li class="menu-header" style="border-right: 1px solid black;"><a href="<%= request.getContextPath() %>/" class="menu-link">TRANG CHỦ</a></li>
                        <li class="menu-header" style="border-right: 1px solid black;"><a href="<%= request.getContextPath() %>/browse?type=author" class="menu-link">DUYỆT THEO</a></li>
                        <li class="menu-header" style="border-right: 1px solid black;"><a href="<%= request.getContextPath() %>/help" class="menu-link">TRỢ GIÚP</a></li>
                        <li class="menu-header"><a href="<%= request.getContextPath() %>/feedback" class="menu-link">LIÊN HỆ</a></li>
                    </ul>
                    <ul class="navbar-right" style="padding-left: 0px;margin-bottom: 0px;">
                        <%
                            if (user != null)
                            {
                        %>
                        <li class="dropdown" style="margin-top: 3px;list-style: none;">
                            <a href="#" class="menu-link dropdown-toggle" data-toggle="dropdown"><span class="glyphicon glyphicon-user" style="color:black;"></span> Xin chào, <%= Utils.addEntities(user.getFullName()) %> <b class="caret"></b></a>
                            <ul class="dropdown-menu">
                                <li><a href="<%= request.getContextPath() %>/mydspace">Trang cá nhân</a></li>
                                <li><a href="<%= request.getContextPath() %>/subscribe">Đăng ký nhận thông báo email</a></li>
                                <li><a href="<%= request.getContextPath() %>/profile">Thông tin cá nhân</a></li>
                                <%
                                    if (isAdmin || isCommunityAdmin || isCollectionAdmin)
                                    {
                                %>
                                <li class="divider"></li>
                                <li>
                                    <a href="<%= request.getContextPath() %><%= (isAdmin ? "/dspace-admin" : "/tools") %>">Quản trị</a>
                                </li>
                                <%
                                    }
                                %>
                                <li><a href="<%= request.getContextPath() %>/logout">Đăng xuất</a></li>
                            </ul>
                        </li>
                        <%
                            }
                            else
                            {
                        %>
                        <li style="margin-top: 3px;list-style: none;">
                            <a href="<%= request.getContextPath() %>/login/password.jsp" class="menu-link"><span class="glyphicon glyphicon-user" style="color:black;"></span> Đăng nhập</a>
                        </li>
                        <%
                            }
                        %>
                    </ul>
                </div>
                <div class="col-md-12" style="background-image: linear-gradient(to bottom,#fcfcfc 0,#ededed 100%);height: 55px;border: 1px groove rgba(252, 252, 252, 0.6);">
                    <form id="search" method="get" action="<%= request.getContextPath() %>/simple-search" class="navbar-form navbar-left" style="padding-left: 0px;width:100%">
                        <input type="hidden" value="" name="location">
                        <div class="form-group" style="width: 88%;">
                            <select onchange="jsfunc1()" id="filtername" name="filtername" style="border-bottom-right-radius: 0px;border-top-right-radius: 0px;border: 2px inset;width: 10%;height: 34px;margin-top: -1px;">
                                <option value="all">Tất cả</option>
                                <option value="title">Nhan đề</option>
                                <option value="author">Tác giả</option>
                                <option value="advisor">Người hướng dẫn</option>
                                <option value="subject">Chủ đề</option>
                                <option value="dateIssued">Năm xuất bản</option>
                            </select>
                            <input type="text" id="query1" value="" name="query" class="form-control" style="border-bottom-right-radius: 0px;border-top-right-radius: 0px;border: 2px inset;width: 89%;margin-top: -2px;" placeholder="Nhập từ khóa tìm kiếm" size="80">
                            <input type="hidden" value="contains" id="filtertype1" name="filtertype" disabled>
                            <input type="hidden" class="form-control" style="border-bottom-right-radius: 0px;border-top-right-radius: 0px;border: 2px inset;width: auto;margin-top: -2px;" placeholder="Nhập từ khóa tìm kiếm" id="filterquery1" name="filterquery" size="100"/>
                            <input type="hidden" value="10" name="rpp">
                            <input type="hidden" value="score" name="sort_by">
                            <input type="hidden" value="desc" name="order">
                        </div>
                        <button type="submit" class="btn btn-danger" style="margin-left: -10px;border-bottom-left-radius: 0px;border-top-left-radius: 0px;">Tìm kiếm</button>
                    </form>
                    <script type="text/javascript">
                        function jsfunc1() {
                            if (document.getElementById('filtername').value == "all") {
                                jQuery('#search').find('#filterquery1').prop("type", "hidden");
                                jQuery('#search').find('#query1').prop("type", "text");
                            } else {
                                jQuery('#search').find('#query1').prop("type", "hidden");
                                jQuery('#search').find('#filterquery1').prop("type", "text");
                                document.getElementById("filtertype1").disabled = false;
                            }
                        }
                    </script>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="mobile-interface">
    <div class="banner">
        <div class="container">
            <div class="row">
                <a href="<%= request.getContextPath() %>/"><img src="<%= request.getContextPath() %>/img/Banner.png" style="background: transparent;margin-top: -6px;margin-left: 0px;width: 100%;margin-bottom: 0px;margin-right: 0px;padding: 0px;" alt="Banner" /></a>
                <div class="col-md-12" style="background-color: #d74d49;">
                    <ul style="display: inline-flex;padding-left: 0px;margin-bottom: 0px;width: 100%;">
                        <li style="font-size: 20px;font-weight: bolder; list-style-type:none;width:100%">
                            <a href="javascript:void(0);" class="icon" onclick="myFunction()" style="color: white;">&#9776;</a>
                            <script type="text/javascript">
                                function myFunction() {
                                    var x = document.getElementById("myTopnav");
                                    if (x.className === "topnav") {
                                        x.className += " responsive";
                                    } else {
                                        x.className = "topnav";
                                    }
                                }
                            </script>
                        </li>
                        <%
                            if (user != null)
                            {
                        %>
                        <li class="dropdown" style="margin-top: 3px; width:38%">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" style="color:#ffffff"><span class="glyphicon glyphicon-user" style="color:#fffed8;"></span> Xin chào, <%= Utils.addEntities(user.getFullName()) %> <b class="caret"></b></a>
                            <ul class="dropdown-menu">
                                <li><a href="<%= request.getContextPath() %>/mydspace">Trang cá nhân</a></li>
                                <li><a href="<%= request.getContextPath() %>/subscribe">Đăng ký nhận thông báo email</a></li>
                                <li><a href="<%= request.getContextPath() %>/profile">Thông tin cá nhân</a></li>
                                <%
                                    if (isAdmin || isCommunityAdmin || isCollectionAdmin)
                                    {
                                %>
                                <li class="divider"></li>
                                <li>
                                    <a href="<%= request.getContextPath() %><%= (isAdmin ? "/dspace-admin" : "/tools") %>">Quản trị</a>
                                </li>
                                <%
                                    }
                                %>
                                <li><a href="<%= request.getContextPath() %>/logout">Đăng xuất</a></li>
                            </ul>
                        </li>
                        <%
                            }
                            else
                            {
                        %>
                        <li style="margin-top: 3px; width:38%">
                            <a href="<%= request.getContextPath() %>/login/password.jsp" style="color:#ffffff"><span class="glyphicon glyphicon-user" style="color:#fffed8;"></span> Đăng nhập</a>
                        </li>
                        <%
                            }
                        %>
                    </ul>
                    <div class="topnav" id="myTopnav">
                        <a href="<%= request.getContextPath() %>/" style="color:#ffffff">TRANG CHỦ</a>
                        <a href="<%= request.getContextPath() %>/browse?type=author" style="color:#ffffff">DUYỆT THEO</a>
                        <a href="<%= request.getContextPath() %>/help" style="color:#ffffff">TRỢ GIÚP</a>
                        <a href="<%= request.getContextPath() %>/feedback" style="color:#ffffff">LIÊN HỆ</a>
                    </div>
                </div>
                <div class="col-md-12" style="background-image: linear-gradient(to bottom,#fcfcfc 0,#ededed 100%);height: 55px;border: 1px groove rgba(252, 252, 252, 0.6);">
                    <div class="col-md-12" style="margin-top: -9px;">
                        <form id="search" method="get" action="<%= request.getContextPath() %>/simple-search" class="navbar-form navbar-left" style="padding-left: 0px;">
                            <input type="hidden" value="" name="location">
                            <div class="form-group" style="display: inline-flex;">
                                <select onchange="jsfunc1()" id="filtername" name="filtername" style="border-bottom-right-radius: 0px;border-top-right-radius: 0px;border: 2px inset;width: auto;height: 34px;margin-top: -1px;">
                                    <option value="all">Tất cả</option>
                                    <option value="title">Nhan đề</option>
                                    <option value="author">Tác giả</option>
                                    <option value="advisor">Người hướng dẫn</option>
                                    <option value="subject">Chủ đề</option>
                                    <option value="dateIssued">Năm xuất bản</option>
                                </select>
                                <input type="text" id="query1" value="" name="query" class="form-control" style="border-bottom-right-radius: 0px;border-top-right-radius: 0px;border: 2px inset;width: auto;margin-top: -2px;" placeholder="Nhập từ khóa tìm kiếm" size="20">
                                <input type="hidden" value="contains" id="filtertype1" name="filtertype" disabled>
                                <input type="hidden" class="form-control" style="border-bottom-right-radius: 0px;border-top-right-radius: 0px;border: 2px inset;width: auto;margin-top: -2px;" placeholder="Nhập từ khóa tìm kiếm" id="filterquery1" name="filterquery" size="100"/>
                                <input type="hidden" value="10" name="rpp">
                                <input type="hidden" value="score" name="sort_by">
                                <input type="hidden" value="desc" name="order">
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
                <%-- Location bar --%>
<%
    if (locbar)
    {
%>
<div class="container" style="margin-top: 18px;padding-left: 0px;padding-right: 0px;background: white;box-shadow: 1px 1px 1px 1px #bfbfbf;">
    <dspace:include page="/layout/location-bar.jsp" />
</div>                
<%
    }
%>

<%
    if (navbar != null && !"off".equals(navbar) && !navbar.endsWith("navbar-default.jsp"))
    {
%>
<div class="container" style="margin-top: 18px;padding-left: 0px;padding-right: 0px;background: white;box-shadow: 1px 1px 1px 1px #bfbfbf;">
    <dspace:include page="<%= navbar %>" />
</div>
<%
    }
%>


        <%-- Page contents --%>
<div class="container" style="margin-top: 18px;padding-left: 0px;padding-right: 0px;background: white;box-shadow: 1px 1px 1px 1px #bfbfbf;">
<% if (request.getAttribute("dspace.layout.sidebar") != null) { %>
    <div class="row">
    <div class="col-md-9">
<% } %>	
