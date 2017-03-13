//= require jquery
//= require jquery_ujs
//= require turbolinks
//=require lib/bootstrap.js
//=require lib/metisMenu.js
//=require lib/jquery.dataTables.js
//=require lib/dataTables.bootstrap.js
//=require lib/dataTables.responsive.js
//=require lib/sb-admin-2.js

function select_item(sel) {
  $("input:checkbox").each(function() {
    this.checked = sel(this.checked);
  })
}

function select_all() {
  select_item(function() {
    return true
  });
}

function select_none() {
  select_item(function() {
    return false
  });
}

function select_reverse() {
  select_item(function(i) {
    return !i
  });
}
