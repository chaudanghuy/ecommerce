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
        minTime: '10',
        maxTime: '22:00',
        defaultTime: '11',
        startTime: '10:00',
        dynamic: false,
        dropdown: true,
        scrollbar: true
    });
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
            'message':  $('#message').val(),
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
})