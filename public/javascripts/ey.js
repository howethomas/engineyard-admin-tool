function callRequestSent() {
	new Insertion.After('click_to_call_link', " <strong id='calling-tag'>Calling...</strong>");
	new Effect.Pulsate('calling-tag', {duration: 10});
}

function forgotPassword(url) {
  email_address = $('email').value;
  form  = $('forgot_password_form');
  
  if(email_address != "") {
    $('username_of_forgotten_password').value = email_address;
    form.submit();
  } else {
    alert("Please enter your @engineyard.com email in the textbox above!");
  }
}