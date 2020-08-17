import ShoppingCart from './shoppingcart.js';

// A reference to Stripe.js initialized with your real test publishable API key.
var stripe = Stripe("pk_test_51GvaDaLTDDKKwjCcXOK5n086No6K8pqJlYaZuq5JJNfa51ahKZBmDU5nMa3TJIEkXfpKmjy66sIK6TWoazK9ORXm00tBy6WWNG");


// Disable the button until we have Stripe set up on the page
document.querySelector("button").disabled = true;
let token = document.querySelector('input[name="_csrf"]').value;

const productList = document.getElementById("product-list");
let cart = [];
let cart_id = -1;
let cart_total = 0;


window.addEventListener('load', function () {

    let shoppingcart = new ShoppingCart(cart);
    if (sessionStorage.getItem("shoppingCart") != null) {
        shoppingcart.loadCart();
        shoppingcart.printCart();
    }
    loadUI(shoppingcart);

    let order = {
        'items' : shoppingcart.cart,
    };

    fetch("/process-order", {

        method: "POST",
        headers: {
            "Content-Type": "application/json",
            'X-CSRF-Token': token
        },
        body: JSON.stringify(order)
    })
        .then(function (result) {
            return result.json();
        })
        .then(function (data) {

            cart_id = data.cartId;
            cart_total = data.totalPayment;

            let elements = stripe.elements();
            let style = {
                base: {
                    color: "#32325d",
                    fontFamily: 'Arial, sans-serif',
                    fontSmoothing: "antialiased",
                    fontSize: "16px",
                    "::placeholder": {
                        color: "#32325d"
                    }
                },
                invalid: {
                    fontFamily: 'Arial, sans-serif',
                    color: "#fa755a",
                    iconColor: "#fa755a"
                }
            };

            var card = elements.create("card", {style: style});

            // Stripe injects an iframe into the DOM
            card.mount("#card-element");

            card.on("change", function (event) {
                // Disable the Pay button if there are no card details in the Element
                document.querySelector("button").disabled = event.empty;
                document.querySelector("#card-errors").textContent = event.error ? event.error.message : "";
            });

            let paymentform = document.getElementById("payment-form");

            paymentform.addEventListener("submit", function (event) {
                event.preventDefault();
                if (paymentform.checkValidity() === false) {
                    event.stopPropagation();
                }
                paymentform.classList.add('was-validated');

                if (paymentform.checkValidity() === true) {
                    // Complete payment when the submit button is clicked
                    payWithCard(stripe, card, data.clientSecret);

                }
            });
        });

}, false);

function loadUI(shoppingcart) {
    let result = "";
    shoppingcart.cart.forEach(product => {
        result += `
            <li class="list-group-item d-flex justify-content-between lh-condensed">
                <div>
                    <h6 class="my-0">${product.name} (${product.count})</h6>
                </div>
                <span class="text-muted">$${product.price * product.count}</span>
        <!--            <span class="text-muted">${product.count}</span>-->
        
            </li>
        `;
    });
    result += `
        <li class="list-group-item d-flex justify-content-between">
            <span>Total (USD)</span>
            <strong>$${shoppingcart.totalCart()}</strong>
        </li>
    `;
    productList.innerHTML = result;
}



// Calls stripe.confirmCardPayment
// If the card requires authentication Stripe shows a pop-up modal to
// prompt the user to enter authentication details without leaving your page.
var payWithCard = function (stripe, card, clientSecret) {
    loading(true);
    stripe
        .confirmCardPayment(clientSecret, {
            payment_method: {
                card: card
            }
        })

        .then(function (result) {
            if (result.error) {
                // Show error to your customer
                showError(result.error.message);
            } else {
                // The payment succeeded!
                orderComplete(result.paymentIntent.id);

                let order = {
                    'payment_intent' : result.paymentIntent.id,
                    'cart_id' : cart_id,
                    'cart_total' : cart_total,
                };
                fetch("/complete-order", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                        'X-CSRF-Token': token
                    },
                    body: JSON.stringify(order)
                })
                    .then(r => {
                        console.log(r);
                        window.location = "/thankyou";
                    });

                // setTimeout(function() {
                //     window.location = "/thankyou";
                // }, (1 * 1000));
            }
        });
};

/* ------- UI helpers ------- */

// Shows a success message when the payment is complete
var orderComplete = function (paymentIntentId) {
    loading(false);
    // document
    //     .querySelector(".result-message a")
    //     .setAttribute(
    //         "href",
    //         "https://dashboard.stripe.com/test/payments/" + paymentIntentId
    //     );
    document.querySelector(".result-message").classList.remove("hidden");
    document.querySelector("button").disabled = true;
};

// Show the customer the error from Stripe if their card fails to charge
var showError = function (errorMsgText) {
    loading(false);
    var errorMsg = document.querySelector("#card-errors");
    errorMsg.textContent = errorMsgText;
    setTimeout(function () {
        errorMsg.textContent = "";
    }, 4000);
};

// Show a spinner on payment submission
var loading = function (isLoading) {
    if (isLoading) {
        // Disable the button and show a spinner
        document.querySelector("button").disabled = true;
        document.querySelector("#spinner").classList.remove("hidden");
        document.querySelector("#button-text").classList.add("hidden");
    } else {
        document.querySelector("button").disabled = false;
        document.querySelector("#spinner").classList.add("hidden");
        document.querySelector("#button-text").classList.remove("hidden");
    }
};

