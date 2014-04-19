Syme.Views.Message = Backbone.View.extend({

  tagName: 'li',

  className: 'message',

  events: {
    'click .icon':            'open',
    'click a.message-delete': 'deleteMessage'
  },

  initialize: function() {
    
    this.model.attributes['is_owner'] =
      (this.model.get('poster_id') == Syme.Router.User.id);
    
    this.listenTo(this.model, "change", this.render);
    
  },

  deleteMessage: function () {
    this.model.destroy();
  }

});