var container = $('.book-a-table form').length > 0 ? $('.book-a-table form').parent() : "body";
var basket = [];

$(function() {
    if ($('.product-list').length > 0) {
        buildProductListHtmlFromBasket();
    }

    if ($('#order-a-table').length > 0) {
        var basket = JSON.parse(localStorage.getItem('basket'));
        if (!basket || Object.keys(basket).length === 0) {
            window.location.href = '/order';
        }
    }

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
    myModalEl.addEventListener('hidden.bs.modal', function(event) {
        setTimeout(function() {
            window.location.reload();
        }, 3000);
    });

    $('#pickup-date').datepicker({
        format: 'yyyy-mm-dd',
        container: container,
        todayHighlight: true,
        autoclose: true,
        orientation: 'top'
    });

    // Listen for modal close event
    $('#order-success-modal').on('hidden.bs.modal', function(e) {
        // Clear session storage for basket
        localStorage.removeItem('basket');
        window.location.href = '/';
    });
});

(function() {
    emailjs.init({
        publicKey: "x1TPhBZ7O-mNk2z3V",
    });
})();

$('#sendMessage').on('click', function(e) {
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
    }).done(function() {
        $('.sent-message').text('Your mail is sent!').show();
    }).fail(function(error) {
        $('.error-message').text('Oops... ' + JSON.stringify(error)).show();
    });
});

$('#booking-btn').on('click', function(e) {
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
    if (phone === '') {
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

    if (total_customer > 10) {
        $('#noticeModal').modal('show');
        return;
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
        success: function(response) {

            $('.loading').hide();
            $('.error-message').hide();
            $('.sent-message').text(response.message).show();

            $('#checking-booking-hour').html(response.booking_enddattime)
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
            }).done(function() {
                // $('.sent-message').text('Your mail is sent!').show();
            }).fail(function(error) {
                // $('.error-message').text('Oops... ' + JSON.stringify(error)).show();
            });
        },
        error: function(xhr, errmsg, err) {
            $('.loading').hide();
            $('.sent-message').hide();
            $('.error-message').text(xhr.responseText).show();
        }
    });
});

$('#order-delivery-method').on('change', function() {
    var value = $(this).val();
    if (value === 'delivery-order') {
        $('#delivery-method').removeClass('d-none');
        $('#pickup-method').addClass('d-none');
    } else if (value === 'pickup-order') {
        $('#delivery-method').addClass('d-none');
        $('#pickup-method').removeClass('d-none');
    }
});

$('.add-to-basket').on('click', function(e) {
    var foodId = $(this).data('food-id');
    var basket = JSON.parse(localStorage.getItem('basket')) || {};
    if (!basket.hasOwnProperty(foodId)) {
        basket[foodId] = {
            total: 1,
            price: $(this).data('food-price'),
            name: $(this).data('food-name'),
            image: $(this).data('food-image')
        };
    } else {
        basket[foodId] = {
            total: basket[foodId].total + 1,
            price: $(this).data('food-price'),
            name: $(this).data('food-name'),
            image: $(this).data('food-image')
        };
    }

    $('.basket-food').each(function() {
        var el = $(this);
        var foodIdFromElement = el.data('food-id');
        if (foodIdFromElement === foodId) {
            el.val(basket[foodId].total);
        }
    });

    localStorage.setItem('basket', JSON.stringify(basket));
    updateBasketTotal();
});

$('.reduce-to-basket').on('click', function(e) {
    var foodId = $(this).data('food-id');
    var basket = JSON.parse(localStorage.getItem('basket')) || {};
    let basketValue = basket[foodId];
    if (basket.hasOwnProperty(foodId)) {
        if (basket[foodId].total > 1) {
            basketValue = basket[foodId] - 1
            basket[foodId] = {
                total: basketValue,
                price: $(this).data('food-price'),
                name: $(this).data('food-name'),
                image: $(this).data('food-image')
            };
        } else {
            basketValue = 0;
            delete basket[foodId];
        }
    }

    $('.basket-food').each(function() {
        var el = $(this);
        var foodIdFromElement = el.data('food-id');
        if (foodIdFromElement === foodId) {
            el.val(basketValue);
        }
    });
    localStorage.setItem('basket', JSON.stringify(basket));
    updateBasketTotal();
});

$('#my-cart').on('click', function() {
    window.location.href = '/order-book'
});

function updateBasketTotal() {
    var basket = JSON.parse(localStorage.getItem('basket')) || {};
    var total = 0;
    var count = 0;
    for (var foodId in basket) {
        count += basket[foodId].total
        total += basket[foodId].total * basket[foodId].price;
    }
    $('.total-basket-items').text(count);
    $('.total-basket-total').text(total.toFixed(2));

    if (count > 0) {
        $('#my-cart').removeClass('d-none');
        updateCartCount(count);
    }
}

function loadBasket() {
    var basket = JSON.parse(localStorage.getItem('basket')) || {};
    for (var foodId in basket) {
        $('.basket-food').each(function() {
            var el = $(this);
            var foodIdFromElement = el.data('food-id');
            if (foodIdFromElement === foodId) {
                el.val(basket[foodId].total);
            }
        });
    }

    updateBasketTotal();
}

$('#order-finish').on('click', function(e) {
    e.preventDefault();
    var basket = JSON.parse(localStorage.getItem('basket'));
    if (!basket) {
        window.location.href = '/order';
    }

    var deliveryMethod = 'pickup-order';

    var yourName = $('#fullname').val();
    if (!yourName) {
        $('.error-message').text('Please enter your name').show();
        return;
    }

    var email = $('#email').val();
    if (!email) {
        $('.error-message').text('Please enter your email').show();
        return;
    }
    var phone = $('#phone').val();
    if (!phone) {
        $('.error-message').text('Please enter your phone').show();
        return;
    }

    var pickupDate = $('#datepicker').val();
    if (!pickupDate) {
        $('.error-message').text('Please select pickup date').show();
        return;
    }
    var pickupTime = $('#timePicker').val();
    if (!pickupTime) {
        $('.error-message').text('Please select pickup time').show();
        return;
    }

    var specialRequest = $('#special_requests').val();
    if (!specialRequest) {
        specialRequest = "No special request";
    }

    $('.loading').show();

    $.ajax({
        url: '/api/order',
        data: {
            basket: JSON.stringify(basket),
            email: email,
            address: deliveryMethod,
            phone: phone,
            date: pickupDate,
            time: pickupTime,
            special_requests: specialRequest,
            csrfmiddlewaretoken: $('[name=csrfmiddlewaretoken]').val()
        },
        method: 'POST',
        success: function(response) {
            $('.loading').hide();
            $('.error-message').hide();
            $('.order-pickup-time').html(response.booking_time);
            loadOrderItemtoSuccessModal();
            // $('#foodModal').modal('hide');
            $('#order-success-modal').modal('show');
        },
        error: function() {
            $('.loading').hide();
            $('.error-message').hide();
            $('.error-message').text('Something went wrong. Please try again later.').show();
        },
    });
})

function loadOrderItemtoSuccessModal() {
    // Retrieve basket data from localStorage
    var basket = JSON.parse(localStorage.getItem('basket'));

    // Render order items in modal body
    if (basket) {
        var orderItemsHtml = '';
        $.each(basket, function(itemId, itemData) {
            orderItemsHtml += '<tr>';
            orderItemsHtml += '<td>' + itemData.name + '</td>';
            orderItemsHtml += '<td>' + itemData.total + '</td>';
            orderItemsHtml += '<td>' + itemData.price + '</td>';
            orderItemsHtml += '</tr>';
        });

        var total = 0;
        $.each(basket, function(itemId, itemData) {
            total += itemData.total * itemData.price;
        });
        $('#totalOrder').text(total.toFixed(2));
        $('#orderItems').html(orderItemsHtml);

        // Clear session storage for basket
        $('.basket-food').val(0);
        $('.total-basket-items').text(0);
        $('.total-basket-total').text(0);
        localStorage.removeItem('basket');
    }
}

// JavaScript for updating cart count
var cartCount = 0; // Initialize cart count

window.addEventListener('scroll', function() {
    var floatingCart = document.querySelector('.floating-cart');
    floatingCart.style.opacity = '1';
});

// Update cart count function
function updateCartCount(count) {
    var cartCountSpan = document.querySelector('.cart-count');
    cartCountSpan.textContent = count;
}

function buildProductListHtmlFromBasket() {
    var basket = JSON.parse(localStorage.getItem('basket'));
    if (!basket || Object.keys(basket).length === 0) {
        window.location.href = '/order';
    }
    var productList = $('.product-list');
    for (var foodId in basket) {
        var food = basket[foodId];
        var productHtml = `
            <div class="product-item d-flex align-items-center">
                <a href="${food.image}" data-lightbox="image-set" data-title="${food.name}">
                    <img src="${food.image}" alt="${food.name}" class="menu-img">
                </a>
                <div class="details col-md-3 col-lg-3 col-xl-3">
                    <h5>${food.name}</h5>                    
                </div>
                <div class="col-md-3 col-lg-3 col-xl-2 d-flex">
                    <div class="input-group quantity-control row basket-row">
                        <span class="input-group-btn text-center">
                        <button
                            type="button"
                            class="btn text-white btn-default btn-number add-to-basket"
                            data-type="plus"
                            data-food-image="${food.image}"
                            data-food-name="${food.name}"
                            data-food-id="${foodId}"
                            data-food-price="${food.price}">
                        <i
                            class="fa-solid fa-plus"></i>
                        </button>
                        </span>
                        <input 
                            disabled 
                            type="text" 
                            name="quant[1]" 
                            class="form-control input-number text-center basket-food" 
                            data-food-name="${food.name}"
                            data-food-image="${food.image}"
                            data-food-id="${foodId}"
                            data-food-price="${food.price}"
                            value="${food.total}" 
                            min="1" 
                            max="10"
                        >
                        <span class="input-group-btn text-center">
                        <button
                            type="button"
                            class="btn text-white btn-default btn-number reduce-to-basket"
                            data-type="minus"
                            data-food-image="${food.image}"
                            data-food-name="${food.name}"
                            data-food-id="${foodId}"
                            data-food-price="${food.price}">
                        <i
                            class="fa-solid fa-minus"></i>
                        </button>
                        </span>
                    </div>
                </div>
                <div class="price">${food.price}</div>                
            </div>`;
        productList.append(productHtml);
    }

    $('.product-list').on('click', '.add-to-basket', function(e) {
        var foodId = $(this).data('food-id');
        var basket = JSON.parse(localStorage.getItem('basket')) || {};
        if (!basket.hasOwnProperty(foodId)) {
            basket[foodId] = {
                total: 1,
                price: $(this).data('food-price'),
                name: $(this).data('food-name'),
                image: $(this).data('food-image')
            };
        } else {
            basket[foodId] = {
                total: basket[foodId].total + 1,
                price: $(this).data('food-price'),
                name: $(this).data('food-name'),
                image: $(this).data('food-image')
            };
        }

        $('.basket-food').each(function() {
            var el = $(this);
            var foodIdFromElement = el.data('food-id');
            if (foodIdFromElement === foodId) {
                el.val(basket[foodId].total);
            }
        });

        localStorage.setItem('basket', JSON.stringify(basket));
        updateBasketTotal();
    });

    $('.product-list').on('click', '.reduce-to-basket', function(e) {
        var foodId = $(this).data('food-id');
        var basket = JSON.parse(localStorage.getItem('basket')) || {};
        let basketValue = basket[foodId];
        if (basket.hasOwnProperty(foodId)) {
            if (basket[foodId].total > 1) {
                basketValue = basket[foodId] - 1
                basket[foodId] = {
                    total: basketValue,
                    price: $(this).data('food-price'),
                    name: $(this).data('food-name'),
                    image: $(this).data('food-image')
                };
            } else {
                basketValue = 0;
                delete basket[foodId];
                window.location.reload();
            }
        }

        $('.basket-food').each(function() {
            var el = $(this);
            var foodIdFromElement = el.data('food-id');
            if (foodIdFromElement === foodId) {
                el.val(basketValue);
            }
        });
        localStorage.setItem('basket', JSON.stringify(basket));
        updateBasketTotal();
    });

    updateBasketTotal();
}

loadBasket();