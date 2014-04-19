Syme.Views.User = Backbone.View.extend({

  tagName: 'li',

  className: 'user',

  events: {},

  initialize: function() {
    this.listenTo(this.model, "change", this.render);
  }

});