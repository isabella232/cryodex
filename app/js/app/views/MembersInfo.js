Syme.Views.MembersInfo = Backbone.View.extend({

  tagName: 'div',

  className: 'membersinfo',

  events: {
    'click a#users-add-button' :  'showSelectizeBox'
  },
  
  render: function () {

    this.workspaceId = Syme.Router.View.workspaceId;

    this.$el.html(this.template(this.model.attributes));

    this.createSelectize()
        .renderMembers();

  },

  renderMembers: function () {

    var _this = this;
    
    var membersCollection = new Syme.Collections.Members(this.workspaceId);
    
    membersCollection.fetch({
      success: Syme.Router.View.adjustBottomContainerHeight
    });

    membersCollection.on('add', Syme.Router.View.adjustBottomContainerHeight);
    membersCollection.on('remove', Syme.Router.View.adjustBottomContainerHeight);
    
    var membersCollectionView = new Backbone.CollectionView( {
      el : $( "#members" ),
      modelView : Syme.Views.Member,
      collection : membersCollection,
      selectable: false,
      visibleModelsFilter: function (user) {
        return user.get('email') != _this.model.get('email');
      }
    });
    
    membersCollectionView.render();

    this.Members = membersCollection;
    
    return this;

  },

  createSelectize: function () {

    var people = Syme.Router.User.get('contacts');

    var REGEX_EMAIL = '([a-z0-9!#$%&\'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&\'*+/=?^_`{|}~-]+)*@' +
                      '(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)';

    var $selectize = $('#users-add').selectize({

        plugins: ['remove_button'],
        delimiter: ',',
        persist: false,

        maxItems: null,
        valueField: 'email',
        labelField: 'name',
        searchField: ['name', 'email'],

        options: people,

        render: {
          item: function(person, escape) {
            return '<div data-person="' + escape(JSON.stringify(person)) + '">' +
                (person.name ? '<span class="name">' + escape(person.name) + '</span>' : '') +
            '</div>';
          },

          option: function(item, escape) {
            var label = item.name || item.email;
            var caption = item.name ? item.email : null;
            return '<div>' +
               '<img src="' + Gravatar.getAvatarUrl(item.email, 20) + '" width="20" height="20" />' +
                '<span class="label">' + escape(label) + '</span>&nbsp;&nbsp;' +
                (caption ? '<span class="caption">&lt;' + escape(caption) + '&gt;</span>' : '') +
            '</div>';
          }
        },

        create: function(input) {
          if ((new RegExp('^' + REGEX_EMAIL + '$', 'i')).test(input)) {
            return {email: input};
          }

          var match = input.match(new RegExp('^([^<]*)\<' + REGEX_EMAIL + '\>$', 'i'));
          if (match) {
            return {
              email : match[2],
              name  : $.trim(match[1])
            };
          }
          alert('Invalid email address.');
          return false;
        }
    });

    // Add instance reference to view
    // Syme.Router.View.MembersInfo.selectize
    this.selectize = $selectize.get(0).selectize;

    this.selectize.on('item_add', this.addMember);

    var $input = this.$('.selectize-input input');
    
    $input.on('blur', function () {
      
      $input.parent().parent().css({ display: 'none' });
      
      Syme.Router.View.adjustBottomContainerHeight();
      
      // Hide add button
      $('#users-add-button').css({ display: 'initial' });
      
    });
    
    return this;

  },

  addMember: function(email, $el) {
      
    var _this = Syme.Router.View.MembersInfo;
    var person = $el.data('person');
    
    var member = new Syme.Models.Member({
        email: person.email,
        name: person.name ? person.name : person.email,
        spaceId: _this.workspaceId
    });
    
    member.removeFromSelectize();
    
    member.save({}, {
      success: function (member) {
        _this.Members.add(member);
      },
      error: function () {
        Syme.Router.error('Could not add member');
      }
    });

  },

  showSelectizeBox: function () {

    // Show and focus on selectize
    $('.selectize-control').css({ display: 'block' });
    
    Syme.Router.View.MembersInfo.selectize.focus();
    
    Syme.Router.View.adjustBottomContainerHeight();
    
    this.$('.selectize-input').focus();
    
    // Hide add button
    $('#users-add-button').css({ display: 'none' });
    
  }
  
});