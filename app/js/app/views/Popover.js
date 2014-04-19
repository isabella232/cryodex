Syme.Views.Popover = Backbone.View.extend({

  tagName: 'div',

  className: 'popover',

  initialize: function() {
    
    if (Syme.Router.Popover)
      Syme.Router.Popover.empty();
    
    Syme.Router.Popover = this;
    
  },

  render: function () {
    this.$el.html(this.template());
  }

});