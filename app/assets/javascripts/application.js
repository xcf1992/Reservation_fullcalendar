// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require moment
//= require bootstrap-datetimepicker
//= require fullcalendar
//= require jquery.qtip.js
//= require jquery.validate
//= require jquery.validate.additional-methods
//= require_tree .

function showPeriodAndFrequency(value){
    switch (value) {
        case 'Repeat':
            $('#repeat').html('Repeat Every 30 Minutes');
            $('#frequency').show();
            break;
        default:
            $('#frequency').hide();
    }
}

$(document).ready(function() {
	$('#create_event_dialog, #desc_dialog').on('submit', "#event_form", function(event) {
		var $spinner = $('.spinner');
    	event.preventDefault();
    	$.ajax({
      		type: "POST",
      		data: $(this).serialize(),
      		url: $(this).attr('action'),
      		beforeSend: show_spinner,
      		complete: hide_spinner,
      		success: refetch_events_and_close_dialog,
      		error: handle_error
    	});

    	function show_spinner() {
      		$spinner.show();
    	}

    	function hide_spinner() {
      		$spinner.hide();
    	}
  	});
});