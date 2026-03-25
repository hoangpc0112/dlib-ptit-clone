<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Contact information for the DSpace site.
  --%>
  
  <%@ page contentType="text/html;charset=UTF-8" %>
  
<%@ page import="org.dspace.core.ConfigurationManager" %>
<center>
  <p><a href="<%= request.getContextPath() %>/feedback">Gửi tin nhắn cho quản trị viên <%= ConfigurationManager.getProperty("dspace.name") %>.</a></p>
</center>
