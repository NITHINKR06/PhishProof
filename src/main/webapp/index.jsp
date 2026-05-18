<%@ page contentType="text/html;charset=UTF-8" %>
<%-- Root redirect: send to login if not authenticated, else to dashboard --%>
<%
    Object user = session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
    } else {
        com.phishproof.model.User u = (com.phishproof.model.User) user;
        if (u.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/user/inbox");
        }
    }
%>
