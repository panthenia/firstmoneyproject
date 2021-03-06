<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="com.atm.model.User" %>
<%@ page import="com.atm.util.Utils" %>
<%@ page import="com.atm.model.Semester" %>

<%
    User cu = Utils.getCurUser(request);
    Semester sm = Utils.getCurSem(request);
    if (cu.getId() == null || cu.getId() == 0) {
        request.setAttribute("msg", Utils.ERR_PLEASELOGIN);
        request.getRequestDispatcher("/error.jsp").forward(request, response);
        return;

    }
    int semid;
    if (sm == null)
        semid = 0;
    else semid = sm.getId();
    String username = cu.getName();
    if (username.equals("")) {
        username = cu.getAcc();
    }
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <title>ATM</title>
    <link rel="stylesheet" href="../css/base.css"/>
    <link rel="stylesheet" href="../css/public.css"/>
    <link rel="stylesheet" href="css/atm.css"/>
    <script type="text/javascript" src="../js/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="js/public.js"></script>
    <script type="text/javascript" src="js/select.js"></script>
</head>
<body>
<p id="userid" style="display:none"><%= cu.getId() %>
</p>

<p id="semid" style="display:none"><%= semid %>
</p>

<p id="userphoto" style="display:none"><%=cu.getPhoto()%>
</p>

<p id="schid" style="display:none"><%=cu.getSchid()%>
</p>

<div class="header">
    <div class="header-nav fn-clear">
        <ul>
            <li class="hn-1">
                <span class="header-title"><img src="css/image/headr-title.png"></span> <span><img
                    src="css/image/c-1.png"/><img src="css/image/c-2.png"/>  </span>
            </li>
            <li class="hn-2" onclick="window.location.href='select.jsp'">Academic&nbsp;Time&nbsp;Management
                <div class="tools" style="width:10px"><img src="css/image/tool.jpg"/></div>
            </li>
            <li onclick="window.location.href='town.jsp'">Teachers Town</li>
        </ul>
    </div>
    <div class="town-header-sign fn-clear">
        <em>
            <%=username%>
        </em>

        <div>
            <a class="account-user">
                <img src="../css/image/user.png">
            </a>

            <div class="account-list">
                <img src="../css/image/sanjx.jpg"/>
                <ul>
                    <li class="account-li-first">
                        Profile Settings
                    </li>
                    <li class="account-li-last">
                        Logout
                    </li>

                </ul>
            </div>
        </div>
        <div>
            <img src="../css/image/infonm.png"/>
            <a>
                <div class="whatnm">
                    5
                </div>
            </a>
        </div>
        <div>
            <a>
                <img src="../css/image/tools.png"/>
            </a>
        </div>
    </div>

</div>
<div class="page-border"></div>
<div class="content">
    <div style="width: 100%;text-align: right;position: relative;">
        <a href="index.jsp" style="color: #1c5480;font-size: 18px;font-weight: 600;position: absolute;left: 0;"><img src="../css/image/goback.jpg">back</a>
        <a href="registerslist.jsp" style="color: #1c5480;font-size: 18px;font-weight: 600;position: relative;bottom: 8px;">Register</a>
        <img src="../css/image/search.jpg">
    </div>
    <div class="select-group" style="display: none">
        <div class="select-group-br"></div>
        <div class="select-group-list">
            <div class="select-group-child">
                <div class="select-group-child-img">
                    <img src="css/image/group.jpg">

                    <div class="group-img-title">
                        <h1>Drama</h1>

                        <p>7thGrade</p>
                    </div>
                    <div class="group-img-bg"></div>

                </div>
                <a class="select-group-child-button">
                    START
                </a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
