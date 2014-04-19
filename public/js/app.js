/* APPLICATION */

$(document).ready(function () {

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
