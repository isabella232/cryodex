Syme.Views.SpaceInfo = Backbone.View.extend({

  tagName: 'div',

  className: 'space-first-message',
  
  initialize: function() {
    this.listenTo(this.model, "change", this.render);
  }

});