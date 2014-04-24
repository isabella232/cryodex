/* APPLICATION */

$(document).ready(function () {

  setTimeout(function () {
    $('#hero-signup-form input[type="email"]').focus();
  }, 500);
  
  $('#features').on('click', function () {
    mixpanel.track('click_menu_1', {});
  });
  
  $('#blog').on('click', function () {
    mixpanel.track('click_menu_2', {});
  });
  
  $('#contact').on('click', function () {
    mixpanel.track('click_menu_3', {});
  });
  
  $('#signup').on('click', function () {
    mixpanel.track('click_navbar_button', {});
  });
  
  $('#hero-signup-button').on('click', function () {
    $('#hero-signup-form').submit();
    mixpanel.track('click_hero_button', {});
  });
  
  $('#request-info').on('click', function () {
    mixpanel.track('click_page_button', {});
  });
  
  $('#plan1').on('click', function () {
    mixpanel.track('click_plan_1', {});
  });
  
  $('#plan2').on('click', function () {
    mixpanel.track('click_plan_2', {});
  });
  
  $('#plan3').on('click', function () {
    mixpanel.track('click_plan_3', {});
  });
  
  $('#hero-signup-form, #form-subscribe, #form-contact').on('submit', function (e) {
    
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
          name.val(''); msg.val(''); title.val('');
        }
        
        email.val('');
        
        $('#thank-you-modal').modal();

      },
      
      error: function () {
        
        $('#error-modal').modal();
        
      }
      
    });
    
  });
  
  $('.signup-same-page').on('click', function (e) {
    e.preventDefault();
    e.stopPropagation();
  });
  
});
