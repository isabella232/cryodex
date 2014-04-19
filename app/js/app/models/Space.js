Syme.Models.Space = Backbone.Model.extend({
  
  url: function () {
  
    var id = this.get('id');
    
    return id ? '/spaces/' + id : '/spaces';
    
  }
  
});