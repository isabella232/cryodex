Syme.Views.Login = Backbone.View.extend({

  tagName: 'div',

  className: 'login',

  events: {},

  initialize: function () {
      
  },
  
  render: function() {
    this.$el.html(this.template());
  }

});