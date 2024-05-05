jQuery(document).ready(function () {
	jQuery("#add-event").submit(function () {
		alert("Submitted");
		var values = {};
		$.each($('#add-event').serializeArray(), function (i, field) {
			values[field.name] = field.value;
		});
		console.log(
			values
		);
	});
});

(function () {
	'use strict';

	function fetchEvents() {
		$.ajax({
			url: '/api/booking-events', // URL to fetch events data from (change it to your backend endpoint)
			type: 'GET',
			success: function (response) {

				if (Array.isArray(response.events)) {
					// Parse the response and format it according to FullCalendar's event format
					var events = response.events.map(function (eventData) {
						return {
							title: eventData.title,
							start: eventData.start, // Event start date/time
							end: eventData.end, // Event end date/time
							description: eventData.description,
							// You can include additional event properties here
						};
					});
					// Render the events on the calendar
					// ------------------------------------------------------- //
					// Calendar
					// ------------------------------------------------------ //
					jQuery(function () {
						// page is ready
						jQuery('#calendar').fullCalendar({
							themeSystem: 'bootstrap4',
							// emphasizes business hours
							businessHours: false,
							defaultView: 'month',
							// event dragging & resizing
							editable: true,
							// header
							header: {
								left: 'title',
								center: 'month,agendaWeek,agendaDay',
								right: 'today prev,next'
							},
							events: events,
							dayClick: function () {
								// jQuery('#modal-view-event-add').modal();
							},
							eventClick: function (event, jsEvent, view) {
								jQuery('.event-icon').html("<i class='fa fa-" + event.icon + "'></i>");
								jQuery('.event-title').html(event.title);
								jQuery('.event-body').html(event.description);
								jQuery('.eventUrl').attr('href', event.url);
								jQuery('#modal-view-event').modal();
							},
						})
					});
				} else {
					console.error('Response is not an array:', response);
				}
			},
			error: function (xhr, status, error) {
				// Handle errors
				console.error(error);
			}
		});
	}

	fetchEvents();
})(jQuery);