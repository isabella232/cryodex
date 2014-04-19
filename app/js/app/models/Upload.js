Syme.Models.Upload = Backbone.Model.extend({
  
  url: function () {
    
    return '/spaces/' + this.get('spaceId') +
            (this.id ? '/uploads/' + this.id : '/uploads');
  
  }
  
});