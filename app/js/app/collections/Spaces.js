Syme.Collections.Spaces = Backbone.Collection.extend({
  
  model: Syme.Models.Space,
  
  initialize: function (userId) {
    
    this.userId = userId;
    
  },
  
  url: function () {
    
    return '/users/' + this.userId + '/spaces';
    
  }
  
});