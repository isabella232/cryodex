Syme.Views.Space = Backbone.View.extend({

  tagName: 'li',

  className: 'space',

  events: {
    'mouseenter a': 'showDeleteButton',
    'mouseleave a': 'hideDeleteButton',
    'click span.delete': 'deleteSpace'
  },

  initialize: function() {
    
    this.model.attributes['is_admin'] =
      (this.model.get('admin_id') == Syme.Router.User.id);
      
    this.listenTo(this.model, "change", this.render);
    
  },
  
  render: function () {
    
    this.$el.html(this.template(this.model.attributes));
    this.setBadgeColor();
    
  },
  
  deleteSpace: function (e) {

    e.preventDefault();
    
    var confirmMessage = 'Are you sure? Type "yes" to confirm.';
    var confirm = prompt(confirmMessage);

    if (confirm != 'yes') return;
    
    Syme.Router.navigate('/', { trigger: true });
    
    this.model.destroy();
    
  },

  setBadgeColor: function () {
    
    var color = (this.model.get('notification_count') > 0 ) ?
      '#3498db' : '#96B5D7';
    
    this.$el.find('.badge').css({ 'background-color': color });
    
  },
  
  showDeleteButton: function (e) {
    var $li = $(e.target).parent();
    $('span.delete', $li).css({ display: 'inline-block' });
  },

  hideDeleteButton: function (e) {
    var $li = $(e.target).parent();
    $('span.delete', $li).css({ display: 'none' });
  }

});