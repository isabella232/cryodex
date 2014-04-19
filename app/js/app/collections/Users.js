Syme.Collections.Users = Backbone.Collection.extend({
  
  model: Syme.Models.User,
  
  initialize: function (spaceId) {
    
    this.spaceId = spaceId;
    
    
  },
  
  url: function () {
    
    return '/spaces/' + this.spaceId + '/users';
    
  }
  
});