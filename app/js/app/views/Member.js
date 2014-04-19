Syme.Views.Member = Backbone.View.extend({

  tagName: 'li',

  className: 'member',

  events: {
    'click a.remove': 'destroy'
  },

  initialize: function() {
    this.removeFromSelectize();
    this.listenTo(this.model, "change", this.render);
  },

  removeFromSelectize: function () {

    this.model.removeFromSelectize();

  },

  addToSelectize: function () {

    var selectize = Syme.Router.View.MembersInfo.selectize;

    selectize.addOption(this.model.attributes);
    selectize.refreshOptions(false);

  },

  destroy: function(e) {

    this.model.destroy();
    this.addToSelectize();

  }

});