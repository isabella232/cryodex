Syme.Views.Upload = Backbone.View.extend({

  tagName: 'li',

  className: 'upload',

  initialize: function() {
    this.listenTo(this.model, "change", this.render);
  }

});