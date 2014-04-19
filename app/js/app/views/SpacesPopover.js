Syme.Views.SpacesPopover = Syme.Views.Popover.extend({

  tagName: 'div',

  className: 'spaces-popover',

  initialize: function () {

    this.userId = this.model.id;
    this.listenTo(this.model, "change", this.render);

  },

  render: function () {

    this.$el.html(this.template({
      is_empty: Syme.Router.Spaces.length == 0
    }));

    this.renderSpaces();

  },

  renderSpaces: function () {

    var spacesCollectionView = new Backbone.CollectionView({
      el : $( "ul#spaces-list" ),
      modelView : Syme.Views.Space,
      collection : Syme.Router.Spaces
    });

    spacesCollectionView.render();

    return this;

  }

});