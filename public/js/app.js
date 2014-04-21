/* APPLICATION */

$(document).ready(function () {

  $('#plan1').on('click', function () {
    mixpanel.track('click_plan_1', {});
  });
  
  $('#plan2').on('click', function () {
    mixpanel.track('click_plan_2', {});
  });
  
  $('#plan3').on('click', function () {
    mixpanel.track('click_plan_3', {});
  });
  
  $('#form-subscribe, #form-contact').on('submit', function (e) {
    
    e.preventDefault();
    e.stopPropagation();
    
    var name = $(this).find('input[name="name"]'),
        email = $(this).find('input[name="email"]'),
        msg = $(this).find('textarea[name="message"]'),
        title = $(this).find('input[name="title"]');
    
    $.ajax('/signup', {
      
      type: 'POST',
      
      data: {
        
        name: name.length > 0 ? name.val() : '',
        email: email.length > 0 ? email.val() : '',
        message: msg.length > 0 ? msg.val() : '',
        title: title.length > 0 ? title.val() : ''
        
      },
      
      success: function () {

        if ($('#contact-main').length > 0) {
          name.val(''); email.val('');
          msg.val(''); title.val('');
        }
        
        $('#thank-you-modal').modal();

      },
      
      error: function () {
        alert('An error has occurred.');
      }
      
    });
    
  });

  $('.signup-button').on('click', function () {
    $('#hero-signup-form').submit();
  });
  
  $('.signup-same-page').on('click', function (e) {
    e.preventDefault();
    e.stopPropagation();
    $('#hero-signup-form input').focus();
  });
  
  $('#hero-signup-form, #bottom-signup-form').on('submit', function (e) {
    e.preventDefault();
    var email = $(this).find('input').val();
    
    $.ajax('/signup', {
    
      type: 'POST',
      
      data: { email: email },
      
      success: function () {
        window.location = '/comingsoon';
      },
      
      error: function () {
        alert('Not a valid e-mail!');
      }
      
    });
    
  });
  
});
