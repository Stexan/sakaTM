<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro|Open+Sans+Condensed:300|Raleway' rel='stylesheet' type='text/css'>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js">
</script>

<script type="text/javascript">
    var name = $('#name').val();
    var email = $("#email").val();
    var password = $("#password").val();
    $.ajax({
        type: "POST",
        url: "http://bogdanstanga.com/hacktm/v1/register",
        data: {email:email, password:password , name : name},
        dataType: "json",
        success: function (data) {
            if( data.error == false ) {
                var api = user.api_key;
                alert(" Api: " + api)
            } else {
                alert("Error");
            }
        },
        error : function(e , status_code){
            alert(e + " " + status_code);
        }
    });
</script>



      <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Responsive Bootstrap Advance Admin Template</title>

    <!-- BOOTSTRAP STYLES-->
    <link href="assets/css/bootstrap.css" rel="stylesheet" />
    <!-- FONTAWESOME STYLES-->
    <link href="assets/css/font-awesome.css" rel="stylesheet" />
    <!-- GOOGLE FONTS-->
    <link href='http://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css' />

</head>
<body style="background-color: #E2E2E2;">
    <div class="container">
        <div class="row text-center " style="padding-top:100px;">
            <div class="col-md-12">
                <img src="assets/img/logo-invoice.png" />
            </div>
        </div>
         <div class="row ">

                <div class="col-md-4 col-md-offset-4 col-sm-6 col-sm-offset-3 col-xs-10 col-xs-offset-1">

                            <div class="panel-body">
                              <form id="form" method="post">

                      <div id="namediv"><label>Name</label>
                      <input type="text" name="name" id="name" placeholder="Name"/></div>
                      <div id="emaildiv"><label>Email</label>
                      <input type="text" name="email" id="email" placeholder="Email"/></div>
                      <div id="emaildiv"><label>Password</label>
                      <input type="text" name="password" id="password" placeholder="Email"/></div>

                     </form>
          <div class="form-group">
                                            <label class="checkbox-inline">
                                                <input type="checkbox" /> Remember me
                                            </label>
                                            <span class="pull-right">
                                                   <a href="index.html" >Forget password ? </a>
                                            </span>
                                        </div>
                                        <span
                                         <button type = "button" id="btn" onclick="loadDoc()" > Register </button>
                                       </span>
                                    <hr />
                                    Not register ? <a href="index.html" >click here </a> or go to <a href="index.html">Home</a>
                                    </form>
                            </div>

                        </div>


        </div>
    </div>

</body>
</html>
