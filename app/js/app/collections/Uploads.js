Syme.Collections.Uploads = Backbone.Collection.extend({
  
  model: Syme.Models.Upload,
  
  initialize: function (spaceId) {
    
    this.spaceId = spaceId;
    
  },
  
  url: function () {
    
    return '/spaces/' + this.spaceId + '/uploads';
    
  }
  
});