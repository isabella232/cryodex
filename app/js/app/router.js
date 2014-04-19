Syme.Router = Backbone.Router.extend({

  /* ROUTES PATTERNS */

  routes: {
    '':               'root',
    'upload':         'showUploader',
    'show/:id':       'showSpace',
    'create/:id':     'createSpace',
    'login':          'displayLogin',
    'list':           'showSpaceList'
  },

  /* CONFIG */

  currentRoute: '',
  loggedIn: false,
  heartbeatInterval: 30 * 1000,

  initialize: function() {

    this.$mainContainer = $('#main');
    this.$topBarContainer = $('header');

    Backbone.history.start({ pushState: true });

  },

  navigate: function(fragment, options) {
    Backbone.Router.prototype.navigate.call(this, fragment, options);
  },
  
  
  error: function (error) {
    
    console.error(error);
    
    alert('A fatal error has occurred.');
    
  },
  
  /* ROUTES FUNCTIONS */

  root: function () {

    var _this = this;

    this.authenticate(function () {
      
      _this.displayStaticView(Syme.Views.Uploader);

    })

  },
  
  authenticate: function(callback) {

    var _this = this;

    this.User = new Syme.Models.User();

    this.displayTopBar();

    this.initializeSession(function (session) {

      if (session) {

        _this.fetchUser(session, function (user) {

          _this.startHeartbeat();
          callback(session);
          _this.startSocket();
          _this.fetchSpaces();

        });

      } else {

        callback(session);

      }

    });

  },

  startHeartbeat: function () {

    var user = this.User;

    if (this.heartbeat)
      clearInterval(this.heartbeat);

    this.heartbeat = setInterval(function () {

      console.info('Sent heartbeat to server');

      user.save();

    }, this.heartbeatInterval);

  },
  
  createSpace: function(session) {
    
    var _this = this;

    this.authenticate(function (session) {

      if (!session) return _this.displayLogin();
 
      var member = new Syme.Models.Member({ spaceId: 'current' });
      
      member.save({
        
        name: _this.User.get('name'),
        email: _this.User.get('email'),
        
      }, {
        
        success: function (model) {
          
          var url = '/show/' + model.get('spaceId');
          
          _this.navigate(url, { trigger: true });
          
        },
        
        error: function () {
          
          console.log('Could not add member to space');
          
        }
        
      });

    });
    
  },

  showUploader: function (params) {
    
    var _this = this;

    this.authenticate(function (session) {

      _this.displayStaticView(Syme.Views.Uploader);

    });

  },

  showSpace: function (workspaceId) {
    
    console.info("Router.showSpace called");

    var _this = this;

    this.authenticate(function (session) {

      if (!session) return _this.displayLogin();
      _this.displayWorkspace(workspaceId);

    });

  },

  initializeSession: function (callback) {

    this.Session = new Syme.Models.Session();

    this.Session.fetch({

      success: callback,

      error: function () {
        callback(false);
      }

    });

  },

  displayTopBar: function () {

    this.TopBar = new Syme.Views.TopBar({
      el: this.$topBarContainer,
      model: this.User
    });

    this.TopBar.render();

  },

  fetchUser: function (session, callback) {

    this.User.set('id', session.get('user_id'));
    this.User.fetch({ success: callback, error: function () {
      Syme.Router.error('Could not fetch user');
    }});

  },

  fetchSpaces: function () {

    this.Spaces = new Syme.Collections.Spaces(this.User.id);
    this.Spaces.fetch();

  },

  displayLogin: function () {

    var _this = this;

    this.authenticate(function (session) {
      _this.displayStaticView(Syme.Views.Login);
    });

  },

  displayStaticView: function (className) {

    this.TopBar.inSpace = false;
    
    this.unbindView();

    this.View = new className({ el : this.$mainContainer });
    this.View.render();

    $('body').attr('data-route', this.View.className);

  },

  displayWorkspace: function (workspaceId) {
    
    var _this = this;

    this.unbindView();

    var space = new Syme.Models.Space({ id: workspaceId });

    space.fetch({

      success: function () {

        // Update notification count
        Syme.Router.User.fetch();

        _this.TopBar.inSpace = true;
        _this.TopBar.space = space;

        _this.TopBar.render();

      },

      error: function () {

        Syme.Router.error('Could not fetch space');
        
      }

    });

    this.View = new Syme.Views.Workspace({
      el: this.$mainContainer,
      model: space
    });

    this.View.render();

    $('body').attr('data-route', 'workspace');

  },

  unbindView: function () {

    if (this.View)
      this.View.undelegateEvents();

  },
  
  startSocket: function () {

    var eshq = new ESHQ(this.User.id);

    eshq.onopen = function(e) {
      console.info('Socket started');
    };

    eshq.onmessage = function(e) {

      console.log("Message type: %s, message data: %s", e.type, e.data);

      var json = JSON.parse(e.data),
          model = json.model,
          action = json.action,
          data = JSON.parse(json.data);

      Syme.Router.Spaces.fetch();
      
      if (model == 'Message') {

        var message = new Syme.Models.Message(data);
        
        if (Syme.Router.View.workspaceId == data.spaceId &&
            Syme.Router.View.Messages.where({ id: data.id }).length == 0) {

          Syme.Router.View.Messages.add(message);
          Syme.Router.View.scrollDown();
        }


      } else if (model == 'Member') {

        var membersView = Syme.Router.View.MembersInfo;

        if (action == 'create') {

          var member = new Syme.Models.Member(data);

          if (Syme.Router.View.workspaceId == data.spaceId &&
             membersView.Members.where({ id: data.id }).length == 0) {

            membersView.Members.add(member);

          }

        } else if (action == 'delete') {

          var member = membersView.Members.where({ id: data.id })[0];

          member.destroy();

        }
      } else {

        alert('O_O !');

      }

    };

    eshq.onerror = function(e) {
       // callback called on errror
    };

  }

});