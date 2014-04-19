Syme.Collections.Messages = Backbone.Collection.extend({
  
  model: Syme.Models.Message,
  
  initialize: function (spaceId) {
    
    this.spaceId = spaceId;
    
    
  },
  
  url: function () {
    
    return '/spaces/' + this.spaceId + '/messages';
    
  }
  
});