Syme.Collections.Members = Backbone.Collection.extend({
  
  model: Syme.Models.Member,
  
  initialize: function (spaceId) {
    
    this.spaceId = spaceId;
  
  },
  
  url: function () {
    
    return '/spaces/' + this.spaceId + '/members';
    
  }
  
});