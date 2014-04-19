Syme.Models.Message = Backbone.Model.extend({
  
  url: function () {
    
    return '/spaces/' + this.get('spaceId') +
            (this.id ? '/messages/' + this.id : '/messages');
  
  }
  
});