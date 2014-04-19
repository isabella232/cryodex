Syme.Views.UserActionsPopover = Syme.Views.Popover.extend({

  className: 'popover-user-actions',

  events: {
    'click #logout': 'logout'
  },

  logout: function (e) {

    e.stopPropagation();
    
    Syme.Router.Session.destroy();

    setTimeout(function () {
      Syme.Router.navigate('/', { trigger: true });
      // Force page refresh
      Backbone.history.loadUrl();
    }, 300);

  }


});