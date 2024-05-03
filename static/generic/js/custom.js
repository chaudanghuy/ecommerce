var container = $('.book-a-table form').length > 0 ? $('.book-a-table form').parent() : "body";
$(function () {
    $('#datepicker').datepicker({
        format: 'yyyy-mm-dd',
        container: container,
        todayHighlight: true,
        autoclose: true,
        orientation: 'top'
    });

    $('#timePicker').timepicker({
        timeFormat: 'H:mm',
        interval: 30,
        minTime: '17:00',
        maxTime: '22:00',
        defaultTime: '17:00',
        startTime: '17:00',
        dynamic: false,
        dropdown: true,
        scrollbar: true
    });

    var myModalEl = document.getElementById('reservationModal')
    myModalEl.addEventListener('hidden.bs.modal', function (event) {
        setTimeout(function () {
            window.location.reload();
        }, 3000);
    })
});

(function () {
    emailjs.init({
        publicKey: "x1TPhBZ7O-mNk2z3V",
    });
})();

$('#sendMessage').on('click', function (e) {
    e.preventDefault();


    var name = $('#name').val().trim();
    var email = $('#email').val().trim();

    if (name === '') {
        $('.error-message').text('Please input your name').show();
        return;
    } else {
        $('.error-message').hide();
    }

    var re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;

    if (!re.test(email)) {
        $('.error-message').text('Please input your email').show();
        return;
    } else {
        $('.error-message').hide();
    }


    var message = $('#message').val().trim();

    if (message === '') {
        $('.error-message').text('Please input message').show();
        return;
    } else {
        $('.error-message').hide();
    }


    var subject = $('#subject').val().trim();

    if (subject === '') {
        $('.error-message').text('Please input subject').show();
        return;
    } else {
        $('.error-message').hide();
    }


    // code fragment
    var data = {
        service_id: 'service_uamr1nu',
        template_id: 'template_bjf15c5',
        user_id: 'x1TPhBZ7O-mNk2z3V',
        template_params: {
            'from_name': $('#name').val(),
            'to_name': 'Administrator',
            'subject': $('#subject').val(),
            'message': $('#message').val(),
            'reply_to': $('#email').val()
        }
    };

    $.ajax('https://api.emailjs.com/api/v1.0/email/send', {
        type: 'POST',
        data: JSON.stringify(data),
        contentType: 'application/json'
    }).done(function () {
        $('.sent-message').text('Your mail is sent!').show();
    }).fail(function (error) {
        $('.error-message').text('Oops... ' + JSON.stringify(error)).show();
    });
});

$('#booking-btn').on('click', function (e) {
    e.preventDefault();
    var fullname = $('input[name=fullname]').val().trim();
    if (fullname === '') {
        $('.error-message').text('Please input your full name').show();
        return;
    }

    var emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    var phonePattern = /^\(?\d{3}\)?[-\s]?\d{3}[-\s]?\d{4}$/;

    var email = $('input[name=email]').val().trim();
    if (!emailPattern.test(email)) {
        $('.error-message').text('Please input valid email').show();
        return;
    }

    var phone = $('input[name=phone]').val().trim();
    if (!phonePattern.test(phone)) {
        $('.error-message').text('Please input valid phone number').show();
        return;
    }

    var booking_date = $('input[name=booking_date]').val().trim();
    var booking_time = $('input[name=booking_time]').val().trim();
    if (booking_date === '') {
        $('.error-message').text('Please select booking date').show();
        return;
    } else if (booking_time === '') {
        $('.error-message').text('Please select booking time').show();
        return;
    } else {
        $('.error-message').hide();
    }

    var total_customer = $('input[name=total_customer]').val().trim();
    if (total_customer === '' || isNaN(total_customer) || Number(total_customer) <= 0) {
        $('.error-message').text('Please input valid total customer').show();
        return;
    } else {
        $('.error-message').hide();
    }

    var special_requests = $('textarea[name=special_requests]').val().trim();
    if (special_requests === '') {
        special_requests = "None";
    }

    $('.loading').show();
    $.ajax({
        url: '/api/book-table',
        type: 'POST',
        data: {
            fullname: fullname,
            email: email,
            phone: phone,
            booking_date: booking_date,
            booking_time: booking_time,
            total_customer: total_customer,
            special_requests: special_requests
        },
        success: function (response) {

            $('.loading').hide();
            $('.error-message').hide();
            $('.sent-message').text(response.message).show();

            $('#checking-booking-hour').html(response.booking_datetime)
            $('#reservationModal').modal('show');

            // code fragment
            var data = {
                service_id: 'service_uamr1nu',
                template_id: 'template_9fw95h4',
                user_id: 'x1TPhBZ7O-mNk2z3V',
                template_params: {
                    'booking_reference': response.booking_reference,
                    'booking_date': response.booking_date,
                    'booking_time': response.booking_time,
                    'num_guests': response.num_guests,
                    'special_requests': response.special_requests,
                    'reply_to': response.reply_to
                }
            };

            $.ajax('https://api.emailjs.com/api/v1.0/email/send', {
                type: 'POST',
                data: JSON.stringify(data),
                contentType: 'application/json'
            }).done(function () {
                // $('.sent-message').text('Your mail is sent!').show();
            }).fail(function (error) {
                // $('.error-message').text('Oops... ' + JSON.stringify(error)).show();
            });
        },
        error: function (xhr, errmsg, err) {
            $('.loading').hide();
            $('.sent-message').hide();
            $('.error-message').text(xhr.responseText).show();
        }
    });
});