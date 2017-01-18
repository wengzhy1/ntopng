local host_pools_utils = require 'host_pools_utils'

local messages = {ntopng="Add ntopng User", captive_portal="Add Captive Portal User"}

local add_user_msg = messages["ntopng"]
local captive_portal_user = false
if is_bridge_iface then
   if _GET["captive_portal_users"] ~= nil then
      add_user_msg = messages["captive_portal"]
      captive_portal_user = true
   end
end


print [[
<div id="add_user_dialog" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="add_user_dialog_label" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
  <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
  <h3 id="add_user_dialog_label">]]print(add_user_msg)print[[</h3>
</div>

<div class="modal-body">

  <div id="add_user_alert_placeholder"></div>

<script>
  add_user_alert = function() {}
  add_user_alert.error =   function(message) { $('#add_user_alert_placeholder').html('<div class="alert alert-danger"><button type="button" class="close" data-dismiss="alert">x</button>' + message + '</div>');
 }
  add_user_alert.success = function(message) { $('#add_user_alert_placeholder').html('<div class="alert alert-success"><button type="button" class="close" data-dismiss="alert">x</button>' + message + '</div>'); }

</script>

 <form data-toggle="validator" id="form_add_user" class="form-horizontal" method="post" action="add_user.lua" >
			   ]]
print('<input id="csrf" name="csrf" type="hidden" value="'..ntop.getRandomCSRFValue()..'" />\n')
print [[

<div class="row">
  <div class='col-md-6'>
    <div class="form-group has-feedback">
      <label class="form-label">Username</label>
      <div class="controls">
        <input id="username_input" type="text" name="username" value="" class="form-control" pattern="^[\w]{1,}$" required>
      </div>
    </div>
  </div>

  <div class='col-md-6'>
    <div class="form-group has-feedback">
      <label class="form-label">Full Name</label>
      <div class="controls">
        <input id="full_name_input" type="text" name="full_name" value="" class="form-control">
      </div>
    </div>
  </div>
</div>

<div class="row">
  <div class='col-md-6'>
    <div class="form-group has-feedback">
      <label class="form-label">Password</label>
      <div class="input-group"><span class="input-group-addon"><i class="fa fa-lock"></i></span>
        <input id="password_input" type="password" name="password" value="" class="form-control"  pattern="^[\w\$\\!\/\(\)=\?\^\*@_\-\u0000-\u00ff]{1,}" required>
      </div>
    </div>
  </div>

  <div class='col-md-6'>
    <div class="form-group has-feedback">
      <label class="form-label">Confirm Password</label>
      <div class="input-group"><span class="input-group-addon"><i class="fa fa-lock"></i></span>
        <input id="confirm_password_input" type="password" name="confirm_password" value="" class="form-control" pattern="^[\w\$\\!\/\(\)=\?\^\*@_\-\u0000-\u00ff]{1,}" required>
      </div>
    </div>
  </div>
</div>

]]

if captive_portal_user == false then
   print[[
<div class="row">
  <div class='col-md-6'>
    <div class="form-group has-feedback">
      <label class="form-label">User Role</label>
      <div class="controls">
        <select id="host_role_select" name="host_role" class="form-control">
          <option value="standard">Non Privileged User</option>
          <option value="administrator">Administrator</option>
        </select>
      </div>
    </div>
  </div>

  <div class='col-md-6'>
    <div class="form-group has-feedback">
      <label class="form-label">Allowed Interface</label>
      <select name="allowed_interface" id="allowed_interface" class="form-control">
        <option value="">Any Interface</option>
]]

   for _, interface_name in pairsByValues(interface.getIfNames(), asc) do
      print('<option value="'..getInterfaceId(interface_name)..'"> '..interface_name..'</option>')
   end
   print[[
      </select>
    </div>
  </div>
</div>

<div class="form-group has-feedback">
  <label class="form-label">Allowed Networks</label>
  <div class="input-group"><span class="input-group-addon"><span class="glyphicon glyphicon-tasks"></span></span>
    <input id="allowed_networks_input" type="text" name="allowed_networks" value="" class="form-control">
  </div>
  <small>Comma separated list of networks this user can view. Example: 192.168.1.0/24,172.16.0.0/16</small>
</div>]]

else -- a captive portal user is being added
   print[[
<div class="form-group has-feedback">
  <label class="form-label">Host Pool</label>
  <select name="host_pool_id" id="host_pool_id" class="form-control">
    <option value="">No host pool</option>
]]

   local pool_ids = host_pools_utils.listPools(getInterfaceId(ifname))
   for _, pool_id in pool_ids do
      print('<option value="'..pool_id..'"> '..host_pools_utils.getPoolName(getInterfaceId(ifname), pool_id)..'</option>')
   end

   print[[
  </select>

  <input id="host_role" name="host_role" type="hidden" value="captive_portal" />
  <input id="allowed_networks" name="allowed_networks" type="hidden" value="0.0.0.0/0,::/0" />
  <input id="allowed_interface" name="allowed_interface" type="hidden" value="]] print(getInterfaceId(ifname)) print[[" />
</div>
]]
end

print[[<div class="form-group has-feedback">
  <button type="submit" id="add_user_submit" class="btn btn-primary btn-block">Add New User</button>
</div>

</form>
<script>

  var frmadduser = $('#form_add_user');

  function resetAddUserForm() {
	$("#username_input").val("");
        $("#full_name_input").val("");
	$("#password_input").val("");
        $("#confirm_password_input").val("");
	$("#allowed_networks_input").val("0.0.0.0/0,::/0");	
  }

  resetAddUserForm();

  frmadduser.submit(function () {
    if(!isValid($("#username_input").val())) {
      add_user_alert.error("Username must contain only letters and numbers");
      return(false);
    }
    if($("#username_input").val().length < 5) {
      add_user_alert.error("Username too short (5 or more characters)");
      return(false);
    }

    if($("#full_name_input").val().length < 5) {
      add_user_alert.error("Full name too short (5 or more characters)");
      return(false);
    }

    if($("#password_input").val().length < 5) {
      add_user_alert.error("Password too short (5 or more characters)");
      return(false);
    }

    if($("#password_input").val() !=  $("#confirm_password_input").val()) {
      add_user_alert.error("Password don't match");
      return(false);
    }

    // escape characters to send out valid latin-1 encoded characters
    $('#password_input').val(escape($('#password_input').val()))
    $('#confirm_password_input').val(escape($('#confirm_password_input').val()))
]]

if captive_portal_user == false then
   -- network validation only for captive portal users
   print[[
    if($("#allowed_networks_input").val().length == 0) {
      add_user_alert.error("Network list not specified");
      return(false);
    } else {
      var arrayOfStrings = $("#allowed_networks_input").val().split(",");
      for (var i=0; i < arrayOfStrings.length; i++) {
        if(!is_network_mask(arrayOfStrings[i])) {
          add_user_alert.error("Invalid network list specified ("+arrayOfStrings[i]+")");
          return(false);
        }
      }
    }]]
end

local location_href = ntop.getHttpPrefix().."/lua/admin/users.lua"
if captive_portal_user then
   location_href = location_href.."?captive_portal_users=1"
end

print[[
    $.getJSON(']]  print(ntop.getHttpPrefix())  print[[/lua/admin/validate_new_user.lua?user='+$("#username_input").val()+"&networks="+$("#allowed_networks_input").val(), function(data){
      if (!data.valid) {
        add_user_alert.error(data.msg);
      } else {
        $.ajax({
          type: frmadduser.attr('method'),
          url: frmadduser.attr('action'),
          data: frmadduser.serialize(),
          success: function (data) {
          var response = jQuery.parseJSON(data);
          if (response.result == 0) {
            add_user_alert.success(response.message);
            window.location.href = ']] print(location_href) print[[';
          } else {
            add_user_alert.error(response.message);
          }
          frmadduser[0].reset();
        }
      });
     }
   });
   return false;
});
</script>

</div> <!-- modal-body -->

</div>
</div>
</div> <!-- add_user_dialog -->

		      ]]
