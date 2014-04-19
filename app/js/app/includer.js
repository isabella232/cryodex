//= require ./router
//= require_tree ./models
//= require_tree ./collections
//= require_tree ./views

$(document).ready(function() {

  Syme.Router = new Syme.Router;
  $('span[data-utip]').utip();

});

$(document).on('click', function (e) {
  if (Syme.Router.Popover instanceof Syme.Views.Popover)
    Syme.Router.Popover.empty();
})