<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Component which displays a login form and associated information
  --%>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<table class="miscTable" align="center" width="70%">
    <tr>
        <td class="evenRowEvenCol">
           <form method="post" action="<%= request.getContextPath() %>/ldap-login">
	    <p><strong><a href="<%= request.getContextPath() %>/register">Người dùng mới? Bấm vào đây để đăng ký.</a></strong></p>
	    <p>Vui lòng nhập tên đăng nhập và mật khẩu vào biểu mẫu bên dưới.</p>
 
               <table border="0" cellpadding="5" align="center">
                    <tr>
                        <td class="standard" align="right"><strong>Tên đăng nhập <br/>hoặc địa chỉ email:</strong></td>
                        <td><input tabindex="1" type="text" name="login_netid"></td>
                    </tr>
                    <tr>
	            		<td class="standard" align="right"><strong>Mật khẩu:</strong></td>
                        <td><input tabindex="2" type="password" name="login_password"></td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
				                <input type="submit" tabindex="3" name="login_submit" value="Đăng nhập">
                        </td>
                    </tr>
                </table>
            </form>
        </td>
    </tr>
</table>
