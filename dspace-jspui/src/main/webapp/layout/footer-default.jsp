<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Footer for home page
  --%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>

<%
    String sidebar = (String) request.getAttribute("dspace.layout.sidebar");
%>

            <%-- Right-hand side bar if appropriate --%>
<%
    if (sidebar != null)
    {
%>
	</div>
	<div class="col-md-3">
                    <%= sidebar %>
    </div>
    </div>       
<%
    }
%>
</div>
</main>
            <%-- Page footer --%>
    <footer class="navbar navbar-inverse navbar-bottom" style="background-image: linear-gradient(to bottom,#efefef 0,#efefef 100%);border-color: #efefef;box-shadow: none; margin-top:25px;border-bottom: 5px solid #d30000;background-color: #efefef;">
        <div class="container" style="padding-left: 0px;padding-right: 0px; margin-top:10px;margin-bottom: 30px;">
            <div class="row footer-row">
                <div class="col-md-9" style="padding-left:0px;">
                    <div id="designedby" class="text-muted footer-text" style="text-align: left;padding-left: 0px;color: #033333;">
                        <p style="font-size: 18px;"><b>TRUNG TAM THONG TIN THU VIEN - HOC VIEN CONG NGHE BUU CHINH VIEN THONG</b></p>
                        <div class="row footer-locations">
                            <div class="col-md-6" style="padding-left: 0px;">
                                <p class="line-footer"><b>Tru so chinh:</b></p>
                                <p>122 Hoang Quoc Viet, Q.Cau Giay, Ha Noi</p>
                                <p class="line-footer"><b>Co so dao tao tai Ha Noi</b></p>
                                <p>Km10, Duong Nguyen Trai, Q.Ha Dong, Ha Noi</p>
                            </div>
                            <div class="col-md-6" style="padding-left: 0px;">
                                <p class="line-footer"><b>Hoc vien co so tai TP Ho Chi Minh</b></p>
                                <p>11 Nguyen Dinh Chieu, P.Da Kao, Q.1 TP Ho Chi Minh</p>
                                <p class="line-footer"><b>Co so dao tao tai TP Ho Chi Minh</b></p>
                                <p>Duong Man Thien, P.Hiep Phu, Q.9 TP Ho Chi Minh</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3725.2987838802364!2d105.78523931534514!3d20.98065699479372!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3135accdcf7b0bd1%3A0xc1cf5dd00247628a!2zSOG7jWMgVmnhu4duIEPDtG5nIG5naOG7hyBCxrB1IENow61uaCBWaeG7hW4gVGjDtG5n!5e0!3m2!1sen!2s!4v1535336396347" width="100%" height="100%" frameborder="0" style="border: 1px solid gray;" allowfullscreen></iframe>
                </div>
            </div>
        </div>
    </footer>
    </body>
</html>