<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="com.atm.model.User" %>
<%@ page import="com.atm.util.Utils" %>
<%@ page import="com.atm.model.Semester" %>

<%
    User cu = Utils.getCurUser(request);
    if (cu.getId() == null || cu.getId() == 0) {
        request.setAttribute("msg", Utils.ERR_PLEASELOGIN);
        request.getRequestDispatcher("/error.jsp").forward(request, response);
        return;

    }
    String username = cu.getName();
    if (username.equals("")) {
        username = cu.getAcc();
    }
%>
<!DOCTYPE html>
<!-- saved from url=(0057)http://www.teachertown.cn/supervisor/teacheredit.jsp?id=3 -->
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ATM</title>
<script type="text/javascript" src="js/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.sha1.js"></script>
<script type="text/javascript" src="js/comm.js"></script>
<script type="text/javascript" src="js/common.js"></script>
<link rel="stylesheet" href="css/base.css" type="text/css" media="all">
<link rel="stylesheet" href="css/main.css" type="text/css" media="all">
<link rel="stylesheet" href="../css/public.css"/>
<link rel="stylesheet" href="../css/teach.css">

<script>
    jQuery(function () {
        $(document).ready(function () {
            initHtml();
            $('#upload-image').on('change', change_photo);
        });

        $('.account-li-last').on('click', logout);
        $('.account-li-first').on('click', function () {
            window.location.href = 'edit.jsp';
        });
        function change_photo() {
            //alert($(this).val());
            var form = $('#photo-form');
            if ($(this).val() == '') {
                return;
            }

            form.ajaxForm({
                url: '/api/photo/upload.do',
                dataType: 'json',
                success: function (msg, status) {
                    var err = msg.err;
                    if (typeof(err) == 'undefined' || err == '') {
                        //alert(msg.img);
                        $('#ifbar_photo').attr('src', msg.img);
                            $.ajax({
                                type: 'POST',
                                url: '/api/photo/cut.do',
                                data: 'img=' + $('#ifbar_photo').attr('src'),
                                dataType: 'json',
                                context: this,

                                success: function (msg, status) {
                                    var err = msg.err;
                                    if (typeof(err) == 'undefined' || err == '') {
                                        alert('success!')
                                    } else {
                                        alert(err);
                                    }
                                },
                                error: function (jqXHR, status, err) {
                                    alert(err);
                                }
                            });

                    } else {
                        alert(err);
                    }
                },
                error: function (jqXHR, status, err) {
                    alert(err);
                }
            });

            form.submit();
        }

        function logout() {
            $.ajax({
                url: '/logout.do',
                type: 'POST',
                data: '',
                dataType: 'json',
                async: false,
                success: function (msg, status) {
                    var err = msg.err;
                    if (typeof(err) == 'undefined' || err == '') {
                        window.location.href = '../../login.html';
                    } else {
                        alert(err);
                    }
                },
                error: function (jqXHR, status, err) {
                    alert(err);
                }
            });
        }
        $('#bt-svpsw').on('click', function () {
            var op = $('#old-password').val();
            var np = $('#new-password').val();
            var cnp = $('#confirm-np').val();

            if(np != cnp){
                alert('new password and confirm new password is not equal!');
                return;
            }
            op = $.sha1(op);
            np = $.sha1(np);

            $.ajax({
                url: '/changepwd.do',
                type: 'POST',
                data: 'oldpwd='+op+'&newpwd='+np,
                dataType: 'json',
                async: false,
                success: function (msg, status) {
                    var err = msg.err;
                    if (typeof(err) == 'undefined' || err == '') {
                        alert('change password successfully!');
                    } else {
                        alert(err);
                    }
                },
                error: function (jqXHR, status, err) {
                    alert(err);
                }
            });
        });
        $('#btn_save').click(function () {
            $('#if_name').val($('#if_firstname').val() + ' ' + $('#if_lastname').val());


            var url_to = '/api/user/edit.do';

            var data_to = 'utype=4&id=<%=cu.getId()%>&schid=<%=cu.getSchid()%>&clzid=<%=cu.getClzid()%>&' + $(this).closest('form').serialize();
            //alert(data_to);
            $.ajax({
                url: url_to,
                type: 'POST',
                data: data_to,
                dataType: 'json',
                async: false,
                success: function (msg, status) {
                    var err = msg.err;
                    if (typeof(err) == 'undefined' || err == '') {

                        alert('success!');


                    } else {
                        alert(err);
                    }
                },
                error: function (jqXHR, status, err) {
                    alert(err);
                }
            });

        });

        $('#btn_cancel').click(function () {

            history.back();

        });
    });

    function initHtml() {

        initTeacher();

    }

    function initTeacher() {

        var url_to = '/api/user/info.do';
        var data_to = 'utype=4&id=' +<%=cu.getId()%>;

        $.ajax({
            url: url_to,
            type: 'POST',
            data: data_to,
            dataType: 'json',
            async: false,
            success: function (msg, status) {
                var err = msg.err;
                if (typeof(err) == 'undefined' || err == '') {
                    var user = msg.user;
                    $('#ifbar_photo').attr('src', user.thumb);
                    $('#ifbar_name').text(user.name);

                    $('#if_gender').val(user.gender);
                    $('#if_firstname').val(user.firstname);
                    $('#if_lastname').val(user.lastname);
                    $('#if_acc').val(user.acc);
                    $('#if_email').val(user.email);
                    if (typeof(user.birth) != 'undefined' && user.birth != '1970-01-01') {
                        $('#if_birth').val(user.birth);
                    }
                    $('#if_phone').val(user.phone);
                    $('#if_parentphone').val(user.parentphone);
                    $('#if_address').val(user.address);
                    $('#if_parentemail').val(user.parentmail);
                } else {
                    //alert(err);
                }

                $('.i_select').iSimulateSelect({'width': 0});
            },
            error: function (jqXHR, status, err) {
                //alert(err);
            }
        });

    }
</script>
<style type="text/css"></style>
</head>
<body>
<style>
    #uploadImg {
        font-size: 12px;
        overflow: hidden;
        position: absolute;
        top: 196px;
        left: 25px;
    }

    #upload-image {
        position: absolute;
        z-index: 100;
        margin-left: -180px;
        font-size: 60px;
        opacity: 0;
        filter: alpha(opacity=0);
        margin-top: -5px;
    }
</style>

<span id="uploadImg">
                    <form id="photo-form" method="post">
                        <input type="file" id="upload-image" size="1" name="File">
                    </form>
                        <input type="button" value="change-photo">
</span>

<div class="container">
<script type="text/javascript">
    jQuery(function () {
        $(document).ready(function () {
            initTopbarHtml();
        });
        $(".account-user").click(function () {
            $(".account-list").toggle(500);
        });
        $(".account-list").mouseleave(function () {
            $(this).hide();
        });
        $('#logout').click(function () {
            var url_to = '/logout.do';
            var data_to = '';

            $.ajax({
                url: url_to,
                type: 'POST',
                data: data_to,
                dataType: 'json',
                context: this,
                beforeSend: function (jqXHR) {
                    $(this).attr('disabled', true);
                },
                success: function (msg, status) {
                    var err = msg.err;
                    if (typeof(err) == 'undefined' || err == '') {
                        parent.location.href = '/';
                    } else {
                        alert(err);
                    }
                },
                error: function (jqXHR, status, err) {
                    alert(err);
                },
                complete: function (jqXHR, status) {
                    $(this).attr('disabled', false);
                }
            });
        });

        $('.topbar .ico-option').bind('click', function () {
            $('.topbar .option_tip').show();
        });
        $('body').bind('click', function () {
            $('.topbar .option_tip').hide();
        });
        $('.topbar .ico-option, .topbar .option_tip').bind('click', function (event) {
            event.stopPropagation();
        });
    });

    function initTopbarHtml() {
        window.setInterval(function () {
            $.ajax({
                url: '/ping.do',
                type: 'POST',
                data: '',
                dataType: 'json',
                context: this,
                success: function (msg, status) {
                    var err = msg.err;
                    if (typeof(err) == 'undefined' || err == '') {
                    } else {
                        alert(err);
                        parent.location.href = '/';
                    }
                },
                error: function (jqXHR, status, err) {
                    //alert(err);
                }
            });
        }, 300000);
    }
</script>
<div class="header">
    <div class="header-nav fn-clear">
        <ul>
            <li class="hn-1">
                <span class="header-title"><img src="css/image/headr-title.png"></span> <span><img
                    src="css/image/c-1.png"/><img src="css/image/c-2.png"/>  </span>
            </li>

        </ul>
    </div>
    <div class="town-header-sign fn-clear" style="margin-left: 780px">
        <a>
            <%=username%>
        </a>

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
<div class="main clearfix">


    <div class="cont">
        <form>
            <div class="titA">
                <h2>Student Edit</h2>

                <div class="operatebar fr">
                    <span id="btn_save"><i class="function_icon ico-save"></i>Save Profile</span>
                </div>
            </div>

            <div class="infobar">
                <img src="<%=cu.getPhoto()%>" alt="" width="45" height="45" id="ifbar_photo">
                <span class="fb" id="ifbar_name"><%=username%></span>
            </div>

            <div class="form_table">
                <input id="if_name" type="hidden" name="name">
                <table>
                    <tbody>
                    <tr>
                        <th style="width:200px;">
                            <select id="if_gender" class="i_select" name="gender" style="display: none;">
                                <option value="0" selected="">Mr.</option>
                                <option value="1">Mrs.</option>
                            </select>

                        </th>
                        <td style="width:200px;">
                            <input id="if_firstname" class="inp" type="text" name="firstname">
                        </td>
                        <td style="margin-left: 20px; width:200px;">
                            <input id="if_lastname" class="inp" type="text" name="lastname">
                        </td>
                    </tr>
                    <tr>
                        <th style="width:200px;">Account</th>
                        <td style="width:200px;"><input id="if_acc" class="inp" type="text" name="acc"></td>
                    </tr>
                    <tr>
                        <th style="width:200px;">Email Address</th>
                        <td style="width:200px;"><input id="if_email" class="inp" type="text" name="email"></td>
                    </tr>
                    <tr>
                        <th style="width:200px;">Cell Phone</th>
                        <td style="width:200px;"><input id="if_phone" class="inp" type="text" name="phone"></td>
                    </tr>
                    <tr>
                        <th style="width:200px;">Birthday</th>
                        <td style="width:200px;"><input id="if_birth" class="inp" type="text" name="birth"></td>
                    </tr>
                    <tr>
                        <th style="width:200px;">Parent Contact</th>
                        <td style="width:200px;"><input id="if_parentphone" class="inp" type="text" name="parentphone">
                        </td>
                    </tr>
                    <tr>
                        <th style="width:200px;">Parent Email</th>
                        <td style="width:200px;"><input id="if_parentemail" class="inp" type="text" name="parentmail">
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="row">Change Password
                <div class="operatebar fr">
                    <span id="bt-svpsw"><i class="function_icon ico-save"></i>Save Password</span>
                </div>
            </div>
            <div class="form_table">
                <table>
                    <tbody>
                    <tr>
                        <th style="width:200px;">Old Password</th>
                        <td style="width:200px;"><input id="old-password" class="inp" type="password"></td>
                    </tr>
                    <tr>
                        <th style="width:200px;">New Password</th>
                        <td style="width:200px;"><input id="new-password" class="inp" type="password"></td>
                    </tr>
                    <tr>
                        <th style="width:200px;">Confirm New Password</th>
                        <td style="width:200px;"><input id="confirm-np" class="inp" type="password"></td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="row pb10">
                <strong class="toc" id="btn_cancel"><i class="function_icon ico-cancel"></i>Back</strong>
            </div>
        </form>
    </div>
</div>
</div>


</body>
</html>