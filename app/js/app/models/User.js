Syme.Models.User = Backbone.Model.extend({
  
  url: function () {
  
    var id = this.get('id');
    
    return id ? '/users/' + id : '/users';
    
  }
  
});