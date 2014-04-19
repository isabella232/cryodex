Syme.Views.FilesInfo = Backbone.View.extend({

  tagName: 'div',

  className: 'filesinfo',

  events: {
    'click .file-others': 'showFileOthers'
  },

  initialize: function () {

    enquire.register("screen and (min-width: 400px)", {
      match : function() {
        console.log('Under');
      },
      unmatch : function() {
        console.log('Over');
      }
    });

  },

  render: function () {

    var _this = this;

    var uploadsCollection = new Syme.Collections.Uploads(this.workspaceId);

    uploadsCollection.fetch({

      success: function (collection) {

        console.info('Fetched uploads collection');

        var upload = collection.models[0];

        _this.$el.html(_this.template(upload.attributes));

      },

      error: function () {

        Syme.Router.error('Could not fetch upload');

      }

    });

    /*
    var uploadsView = new Backbone.CollectionView( {
        el : $( "#uploads" ),
        modelView : Syme.Views.Upload,
        collection : uploadsCollection
    } );

    uploadsView.render();*/

    return this;

  },

  showFileOthers: function () {

    var popover = new Syme.Views.Popover({ el: $('#popover') });

    popover.render();

  }

});