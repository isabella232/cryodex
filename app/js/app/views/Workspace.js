Syme.Views.Workspace = Backbone.View.extend({

  tagName: 'div',

  className: 'workspace',

  events: {
    'keypress textarea': 'createMessage',
    'heightChange #container-bottom': 'adjustHeight'
  },

  initialize: function () {

    this.workspaceId = this.model.id;

    bouncefix.add('nobounce');

  },

  createMessage: function (e) {

    var _this = this;

    if (e.which != 13) return;

    e.preventDefault();

    var content = e.target.value;

    var message = new Syme.Models.Message({
      content: content, spaceId: this.workspaceId
    });

    var _this = this;

    message.save({}, {

      success: function () {

        _this.Messages.add(message);
        _this.scrollDown();

      },

      error: function () {
        Syme.Router.error('Could not save message');
      }

    });

    $(e.target).val('');

  },

  scrollDown: function () {

    var cont = this.$('#container-bottom').get(0),
        isScrolledDown = (cont.scrollHeight - cont.scrollTop > cont.offsetHeight + 20);

    if (isScrolledDown)
      cont.scrollTop = cont.scrollHeight + 100;

  },

  render: function () {

    var _this = this;

    this.$el.html(this.template());

    this.model.fetch({
      success: function () {

        _this
          .renderMembersInfo()
          .renderFilesInfo()
          .renderSpaceInfo()
          .renderMessages();
      },

      error: function () {
        Syme.Router.error('Could not fetch space');
      }
    });

    // $('a.message-permalink').copyUtil(
    //   function() { return 'hello';                },
    //   function() { $(this).addClass('active');    },
    //   function() { $(this).removeClass('active'); }
    // );

  },

  renderMembersInfo: function () {

    //alert(this.model.get('admin_id'));
    console.log(this.model.attributes);

    var admin = new Syme.Models.User({
      id: this.model.get('admin_id') });

    var _this = this;

    admin.fetch({
      success: function () {

        console.log(admin.attributes);

        _this.MembersInfo = new Syme.Views.MembersInfo({
          el: $('#membersinfo'),
          model: admin
        });

        _this.MembersInfo.render();

      },
      error: function () {
        Syme.Router.error('Could not fetch admin');
      }
    });


    return this;

  },

  renderFilesInfo: function () {

    this.FilesInfo = new Syme.Views.FilesInfo({
      el: $('#filesinfo')
    });

    this.FilesInfo.workspaceId = this.workspaceId;

    this.FilesInfo.render();

    return this;

  },

  renderSpaceInfo: function () {

    this.SpaceInfo = new Syme.Views.SpaceInfo({
      el: $('#space-first-message'),
      model: this.model
    });

    this.SpaceInfo.render();

    return this;

  },

  renderMessages: function () {

    var messagesCollection = new Syme.Collections.Messages(this.workspaceId);

    messagesCollection.fetch({

      success: function () {

        var cont = $('#container-bottom').get(0);
        cont.scrollTop = cont.scrollHeight + 100;

      },

      error: function () {

       Syme.Router.error('Could not fetch messages collection');

      }

    });

    var messagesView = new Backbone.CollectionView( {
        el : $( "#messages" ),
        modelView : Syme.Views.Message,
        collection : messagesCollection
    } );

    messagesView.render();

    this.Messages = messagesCollection;

    return this;

  },

  adjustHeight: function (e) {

    var topEl = $('#space-info').get(0);

    var newTop = topEl.offsetTop + topEl.offsetHeight;
    $(e.target).css('top', newTop);

  },

  adjustBottomContainerHeight: function() {
    $('#container-bottom').trigger('heightChange');
  }

});