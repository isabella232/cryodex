Syme.Views.TopBar = Backbone.View.extend({

  tagName: 'div',

  className: 'topbar',

  events: {
    'click a.logout':               'logout',
    'click a.login':                'login',
    'click a#spaces-popover-link' : 'showSpacesPopover',
    'click a#user-actions':         'showUserActionsPopover',
    'click a[href!="#"]':           'followRouterLink'
  },

  initialize: function () {
    this.listenTo(this.model, "change", this.render);
  },

  render: function () {

    var attributes = this.model.attributes;

    if (this.inSpace) {
      attributes.space = this.space.attributes;
    }
    
    this.$el.html(this.template(attributes));

  },

  followRouterLink: function() {
    
    var link = $(e.target).attr('href');
    Syme.Router.navigate(link);
    
  },

  login: function () {
    
    Syme.Router.navigate('/login', { trigger: true });
    
  },

  showSpacesPopover: function (e) {

    e.stopPropagation();

    var $popoverContainer = $('#spaces-popover', this.$el);

    var popover = new Syme.Views.SpacesPopover({
      el: $popoverContainer,
      model: Syme.Router.User
    });

    Syme.Router.Popover = popover;

    popover.render();

  },

  showUserActionsPopover: function (e) {

    e.stopPropagation();

    var $popoverContainer = $('#user-actions-popover', this.$el);

    var popover = new Syme.Views.UserActionsPopover({
      el: $popoverContainer });

    Syme.Router.Popover = popover;

    popover.render();
  }

});