Syme.Models.Member = Backbone.Model.extend({
  
  url: function () {
  
    var id = this.get('id'), spaceId = this.get('spaceId');
    
    return id ? '/spaces/' + spaceId + '/members/' + id :
                '/spaces/' + spaceId + '/members';
    
  },
  
  removeFromSelectize: function () {
    
    var selectize = Syme.Router.View.MembersInfo.selectize;
    var email = this.get('email');

    selectize.removeItem(email);
    selectize.removeOption(email);
    
  }
  
});