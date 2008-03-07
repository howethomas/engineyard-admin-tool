function callRequestSent() {
	new Insertion.After('click_to_call_link', " <strong id='calling-tag'>Calling...</strong>");
	new Effect.Pulsate('calling-tag', {duration: 10});
}