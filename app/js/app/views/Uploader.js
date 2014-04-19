Syme.Views.Uploader = Backbone.View.extend({

  tagName: 'div',

  className: 'uploader',

  events: {
    "change #choose-file":        "uploadSelectedFile",
    "click a#infographic-upload": 'showChooseFileDialog',
    "click a#explanation-upload": "showChooseFileDialog",
    "submit form":                "preventSubmit"
  },

  storeOptions: {
    adapter: 'html5-filesystem',
    name: 'syme-spaces'
  },

  initialize: function () {

    var _this = this;

    $('body')
      .unbind('drop')
      .bind('drop', function(e) {
        _this.hideDragHelper();
        _this.uploadDroppedFiles(e);
      })

      .unbind('dragenter')
      .bind('dragenter', this.showDragHelper)

      .unbind('dragover')
      .bind('dragover', this.showDragHelper)

      .unbind('dragleave')
      .bind('dragleave', this.hideDragHelper);

  },

  render: function() {

    this.$el.html(this.template());

    this.$uploader = this.$('#upload-container');

    this.initializeUploader();
    this.setUploaderCallback();

  },

  initializeUploader: function () {

    this.$uploader.fineUploaderS3({
      request: {
          endpoint: "https://fine-uploader-app.s3.amazonaws.com",
          accessKey: 'AKIAIA4O4WOKMRZJMYSQ'
      },
      signature: {
          endpoint: "/s3/file"
      },
      uploadSuccess: {
          endpoint: "/s3/file?success=true"
      },
      deleteFile: {
          enabled: true,
          endpoint: "/s3/file"
      },
      retry: {
          enableAuto: true
      },
      chunking: {
          enabled: true
      },
      resume: {
          enabled: true
      },
      validation: {
          sizeLimit: 5000000 * 10,
          itemLimit: 1
      },

      template: this.$('#qq-template'),

      formatFileName: function(filename) {
        return filename;
      },

      display: {
          fileSizeOnSubmit: true
      }

    });

  },

  setUploaderCallback: function () {

    var _this = this;

    var upload = new Syme.Models.Upload({});

    this.$uploader.on('submit', function (event) {

    });

    this.$uploader.on("complete", function(event, id, name, response) {

      $('#upload-icon-indicator').addClass('done');

      // Set URL in file link when successful
      if (response.success) {

          var serverPathToFile = response.filePath;

          var urlFragments = response.url;

          var fileUrl = urlFragments.scheme + '://' +
                        urlFragments.host + urlFragments.path
                        + '?' + urlFragments.query;

          upload.set('url', fileUrl);
          upload.set('name', response.name.replace(',', '.'));
          upload.set('size', response.size)

          setTimeout(function () {
            _this.createSpace(upload);
          }, 300);

      } else {

        Syme.Router.error('Server file verification failed');

      }

    });

    this.$uploader.on('statusChange', function(e, id, oldStatus, newStatus) {

      if(newStatus == 'submitted') {
        $('p.upload-explain, p.uvp').css({ display: 'none' });
        $('#upload-icon-indicator').css({ display: 'block' });
      }

      if(newStatus == 'canceled' || newStatus == 'deleted') {
        $('p.upload-explain, p.uvp').css({ display: 'block' });
        $('#upload-icon-indicator').css({ display: 'none' });
      }

    });

  },

  createSpace: function (upload) {

    console.info("Creating new space");

    var space = new Syme.Models.Space();
    var _this = this;

    space.save({}, {

      success: function (model, response) {

        console.info('Created new space with id ' + model.id);

        upload.set('spaceId', model.id);

        upload.save({}, {

          success: function () {

            var url = '/create/' + model.id;

            if (Syme.Router.User.id) {

              Syme.Router.navigate(url, { trigger: true })

            } else {

              Syme.Router.displayLogin();

            }


          },

          error: function () {

          }

        });

      },

      error: function () {

        Syme.Router.error('Could not create space');

      }

    });

  },

  /* Helper events */

  preventSubmit: function (e) { e.preventDefault(); },

  /* Drag and drop events */

  showDragHelper: function () {
    $('body').css({ background: '#E8F1FD' });
  },

  hideDragHelper: function () {
    $('body').css({ background: 'initial' });
  },

  /* Upload events */

  showChooseFileDialog: function () {
    $('#choose-file').trigger('click');
  },

  uploadSelectedFile: function(e){

    e.preventDefault();

    mixpanel.track('click_upload');

    var file = e.target.files[0];
    $('#upload-container').fineUploader('addFiles', file);

  },

  uploadDroppedFiles: function(e) {

    e.preventDefault();

    mixpanel.track('drop_upload');

    var file = e.originalEvent.dataTransfer.files[0];

    $('#upload-container').fineUploader('addFiles', file);
  }

});