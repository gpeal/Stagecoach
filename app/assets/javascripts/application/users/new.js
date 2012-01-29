//null means the user hasn't entered anything in that field yet
var validName = null;
var validEmail = null;

$(document).ready(function() {  
  
  $("#user_email").bind('keyup blur input', function() {
    validEmail = validateEmail();
    validateButton();
    if (validEmail) {
      makeFieldGreen($(this));
      $('#users-signup-form-email-help').css('display', '');
      $('#users-signup-form-email-help').hide();
    }
    else {
      $('#users-signup-form-email-help').show();
      $('#users-signup-form-email-help').css('display', 'inline');
      makeFieldRed($(this));
    }
  });

 $("#user_name").bind('keyup blur input', function() {
    validName = validateName();
    validateButton();
    if (validName) {
      $('#users-signup-form-name-help').css('display', '');
      $('#users-signup-form-name-help').hide();
      makeFieldGreen($(this));
    }
    else {
       makeFieldRed($(this));
      $('#users-signup-form-name-help').show();
      $('#users-signup-form-name-help').css('display', 'inline');
    }
  });

  $("#users-signup-form-form").submit(function() {
      //if the user hasn't entered a field, the button will not be colored
      //indicate that they are not done yet by making the button red
      if($(document.forms["users-signup-form-form"]["commit"]).hasClass("btn")) {
        $(document.forms["users-signup-form-form"]["commit"]).removeClass().addClass("btn danger");
        if(validName == null) {
          makeFieldRed($(document.forms["users-signup-form-form"]["user[name]"]));
          $('#users-signup-form-name-help').show();
          $('#users-signup-form-name-help').css('display', 'block !important');
        }
        if(validEmail == null) {
          $('#users-signup-form-email-help').show();
          $('#users-signup-form-email-help').css('display', 'block !important');
          makeFieldRed($(document.forms["users-signup-form-form"]["user[email]"]));
        }
      }
        
      return $(document.forms["users-signup-form-form"]["commit"]).hasClass("btn success");
  });
});

function validateEmail() {
  var re = /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i;
  return re.test($(document.forms["users-signup-form-form"]["user[email]"]).val()) && $(document.forms["users-signup-form-form"]["user[email]"]).val() != '';
}

function validateName() {
  return $(document.forms["users-signup-form-form"]["user[name]"]).val().length != '';
}

function validateButton() {
  if(validateEmail() && validateName() && validName != null && validEmail != null) {
    $(document.forms["users-signup-form-form"]["commit"]).removeClass().addClass("btn success");
  }
  else {
    $(document.forms["users-signup-form-form"]["commit"]).removeClass().addClass("btn danger");
  }
}

function makeFieldRed(field) {
  //If the form validation fails, what was the input object becomes field_with_errors with a child input
  //This creates an extra parent between the field and the clearfix object
  if($(field).parent().hasClass('field_with_errors')) {
    $(field).parent().parent().parent().removeClass().addClass('clearfix error');
  }
  else {
    $(field).parent().parent().removeClass().addClass('clearfix error');
  }
}

function makeFieldGreen(field) {
  //If the form validation fails, what was the input object becomes field_with_errors with a child input
  //This creates an extra parent between the field and the clearfix object
  if($(field).parent().hasClass('field_with_errors')) {
    $(field).parent().parent().parent().removeClass().addClass('clearfix success');
  }
  else {
    $(field).parent().parent().removeClass().addClass('clearfix success');
  }
}
