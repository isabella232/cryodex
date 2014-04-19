/* Backbone config */

Backbone.View.prototype.template = function (json) {
  return HandlebarsTemplates[this.className](json);
};

Backbone.View.prototype.render = function() {
  $(this.el).html(this.template(this.model.toJSON()));
  return this;
};

Backbone.View.prototype.empty =  function () {
  this.$el.empty();
  this.stopListening();
};

/* Handlebars config */
Handlebars.registerHelper('gravatar', function (email) {
  return Gravatar.getAvatarUrl(email, 20);
});

Handlebars.registerHelper('filesize', function (size) {
  return filesize(size);
});

Handlebars.registerHelper("debug", function() {
  console.log('Current context:', this);
});

Handlebars.registerHelper('compare', function (lvalue, operator, rvalue, options) {

  var operators, result;

  if (arguments.length < 3) {
    throw new Error("Handlerbars Helper 'compare' needs 2 parameters");
  }

  if (options === undefined) {
    options = rvalue;
    rvalue = operator;
    operator = "===";
  }

  operators = {
    '==': function (l, r) { return l == r; },
    '===': function (l, r) { return l === r; },
    '!=': function (l, r) { return l != r; },
    '!==': function (l, r) { return l !== r; },
    '<': function (l, r) { return l < r; },
    '>': function (l, r) { return l > r; },
    '<=': function (l, r) { return l <= r; },
    '>=': function (l, r) { return l >= r; },
    'typeof': function (l, r) { return typeof l == r; }
  };

  if (!operators[operator]) {
    throw new Error("Handlerbars Helper 'compare' doesn't know the operator " + operator);
  }

  result = operators[operator](lvalue, rvalue);

  if (result) {
    return options.fn(this);
  } else {
    return options.inverse(this);
  }

});


$.fn.copyUtil = function(getText, onClickCb, onBlurCb, onCopyCb) {

  // ID of the hidden input that will be appended
  var inputId = "copyutil";

  // Default callbacks
  var onClickCb = onClickCb || $.noop,
      onBlurCb  = onBlurCb || $.noop;
      onCopyCb  = onCopyCb || onBlurCb;

  this.on('click', function(){

    var el    = this;
        text  = getText.apply(el);

    // Remove previous instances
    $('#' + inputId).trigger('blur');

    // onClick callback
    onClickCb.apply(el);

    // Create hidden input
    var $hiddenInput = $('<input id="' + inputId + '" type="text">')
      .val(text)
      .css({
        position: 'absolute',
        width: '10px', height: '10px', top: '-10px', left: '-10px',
      });

    $('body').prepend($hiddenInput);

    // Focus on it
    $hiddenInput.focus().select();

    // Discard on blur
    $hiddenInput.bind('blur', function(e){
      onBlurCb.apply(el); $hiddenInput.remove();
    });

    // Delay discarding on copy to prevent bug
    $hiddenInput.bind('copy', function(){
      onCopyCb.apply(el);
      setTimeout(function(){ $hiddenInput.trigger('blur') }, 100);
    })

  });

  return this;

};