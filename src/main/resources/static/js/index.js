
// shopping cart modal toggle
const cartBtn = document.getElementById("cart-btn");

// insert items
const productsDOM = document.getElementById("categ-1");

// add to cart list
const showCart = document.querySelector(".show-cart");
const cartItems = document.querySelector(".total-count");

// in modal
const cartTotal = document.querySelector(".total-cart");



const closeCartBtn = document.querySelector(".close-cart");
const clearCartBtn = document.querySelector(".clear-cart");
const cartDOM = document.querySelector(".cart");
const cartOverlay = document.querySelector(".cart-overlay");

const cartContent = document.querySelector(".cart-content");



//cart
let cart = [];

//getting the products
class Products {
    async getProducts() {
        try {
            let result = await fetch('/products')
                .then(response => response.json());
            console.log('result:' + JSON.stringify(result, null, 2));

            return result;
        } catch (error) {
            console.log(error);
        }
    }
}

class Categories {
    async getCategories() {
        try {
            let result = await fetch('/categories')
                .then(response => response.json());
            console.log('result:' + JSON.stringify(result, null, 2));
            return result;
        } catch (error) {
            console.log(error);
        }
    }
}

// display products
class UI {
    displayProducts(products) {
        let result = "";
        products.forEach(product => {
            result += `
                <div class="card">
                    <img class="card-img-top" src="/images/products/prod${product.item_id}.png" alt="Card image cap">
                    <div class="card-body">
                        <h5 class="card-title">${product.name}</h5>
                        <p class="card-text">Price: $${product.unit_price}</p>
                        <button type="button"
                            data-id=${product.item_id}
                            data-name=${product.name}
                            data-unit_price=${product.unit_price} 
                            class="add-to-cart btn btn-primary">Add to cart
                        </button>
                                       
                    </div>
                </div>
            `;
        });

        productsDOM.innerHTML = result;
    }
}


class Item {
    constructor(id, name, price, count) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.count = count;
    }
}

class ShoppingCart {

    // Save cart
    saveCart() {
        sessionStorage.setItem("shoppingCart", JSON.stringify(cart));
    }

    // Load cart
    loadCart() {
        if (sessionStorage.getItem("shoppingCart") != null) {
            cart = JSON.parse(sessionStorage.getItem("shoppingCart"));
        }
    }

    addItemToCart(item_id, name, price, count) {
        console.log("add to cart");
        for (var item in cart) {
            if (cart[item].name === name) {
                cart[item].count++;
                this.saveCart();
                cartItems.innerHTML = parseInt(cartItems.innerHTML) + count;
                return;
            }
        }
        var item = new Item(item_id, name, price, count);
        cart.push(item);
        this.saveCart();
        cartItems.innerHTML = parseInt(cartItems.innerHTML) + count;

    }

    totalCount () {
        var totalCount = 0;
        for (var item in cart) {
            totalCount += cart[item].count;
        }
        return totalCount;
    }

    totalCart () {
        var totalCart = 0;
        for (var item in cart) {
            totalCart += cart[item].price * cart[item].count;
        }
        return Number(totalCart.toFixed(2));
    }

    listCart() {
        var cartCopy = [];
        let i;
        for (i in cart) {
            let item = cart[i];
            let itemCopy = {};
            let p;
            for (p in item) {
                itemCopy[p] = item[p];
            }
            itemCopy.total = Number(item.price * item.count).toFixed(2);
            cartCopy.push(itemCopy);
        }
        return cartCopy;
    }

    removeItemFromCart(name) {
        for (var item in cart) {
            if (cart[item].name === name) {
                cart[item].count--;
                if (cart[item].count === 0) {
                    cart.splice(item, 1);
                }
                break;
            }
        }
        this.saveCart();
    }

    displayCart() {
        var cartArray = this.listCart();
        console.log("cart asdfaksdfjksdflajsdk ");

        var output = "";
        for (let i in cartArray) {
            output +=
                "<tr>" +
                "<td>" +
                cartArray[i].name +
                "</td>" +
                "<td>(" +
                cartArray[i].price +
                ")</td>" +
                "<td><div class='input-group'><button class='minus-item input-group-addon btn btn-primary' data-name=" +
                cartArray[i].name +
                ">-</button>" +
                "<input type='number' class='item-count form-control' data-name='" +
                cartArray[i].name +
                "' value='" +
                cartArray[i].count +
                "'>" +
                "<button class='plus-item btn btn-primary input-group-addon' data-name=" +
                cartArray[i].name +
                ">+</button></div></td>" +
                "<td><button class='delete-item btn btn-danger' data-name=" +
                cartArray[i].name +
                ">X</button></td>" +
                " = " +
                "<td>" +
                cartArray[i].total +
                "</td>" +
                "</tr>";
        }
        // $(".show-cart").html(output);
        showCart.innerHTML = output;
        cartTotal.innerHTML = this.totalCart();

        // $(".total-cart").html(shoppingCart.totalCart());
        // $(".total-count").html(shoppingCart.totalCount());
    }



    printCart () {
        console.log(cart);
    }

}

document.addEventListener("DOMContentLoaded", () => {
// window.addEventListener("load", () => {
    const ui = new UI();
    const products = new Products();
    //get all products
    products.getProducts().then(products => ui.displayProducts(products))
        .then(addEventListeners);

    fetch("/currentUser", {
        method: "GET",
        headers: {},
    }).then(
        function (result) {
            console.log('res:' +JSON.stringify(result, null, 2));
    });

});

function addEventListeners () {
    console.log("in add event listener");

    const shoppingcart = new ShoppingCart();
    const bagBtns = document.querySelectorAll(".add-to-cart");
    bagBtns.forEach(bagBtn => {
        bagBtn.addEventListener("click", (event) => {
            let item = event.target;
            shoppingcart.addItemToCart(item.dataset.item_id, item.dataset.name, item.dataset.unit_price, 1);
        });
    });

    cartBtn.addEventListener("click", () => {
        shoppingcart.displayCart(shoppingcart);
    });


};

/*
var shoppingCart = (function () {
    // =============================
    // Private methods and propeties
    // =============================
    cart = [];

    // Constructor
    function Item(name, price, count) {
        this.name = name;
        this.price = price;
        this.count = count;
    }

    // Save cart
    function saveCart() {
        sessionStorage.setItem("shoppingCart", JSON.stringify(cart));
    }

    // Load cart
    function loadCart() {
        cart = JSON.parse(sessionStorage.getItem("shoppingCart"));
    }
    if (sessionStorage.getItem("shoppingCart") != null) {
        loadCart();
    }

    // =============================
    // Public methods and propeties
    // =============================
    var obj = {};

    // Add to cart
    obj.addItemToCart = function (name, price, count) {
        for (var item in cart) {
            if (cart[item].name === name) {
                cart[item].count++;
                saveCart();
                return;
            }
        }
        var item = new Item(name, price, count);
        cart.push(item);
        saveCart();
    };
    // Set count from item
    obj.setCountForItem = function (name, count) {
        for (var i in cart) {
            if (cart[i].name === name) {
                cart[i].count = count;
                break;
            }
        }
    };
    // Remove item from cart
    obj.removeItemFromCart = function (name) {
        for (var item in cart) {
            if (cart[item].name === name) {
                cart[item].count--;
                if (cart[item].count === 0) {
                    cart.splice(item, 1);
                }
                break;
            }
        }
        saveCart();
    };

    // Remove all items from cart
    obj.removeItemFromCartAll = function (name) {
        for (var item in cart) {
            if (cart[item].name === name) {
                cart.splice(item, 1);
                break;
            }
        }
        saveCart();
    };

    // Clear cart
    obj.clearCart = function () {
        cart = [];
        saveCart();
    };

    // Count cart
    obj.totalCount = function () {
        var totalCount = 0;
        for (var item in cart) {
            totalCount += cart[item].count;
        }
        return totalCount;
    };

    // Total cart
    obj.totalCart = function () {
        var totalCart = 0;
        for (var item in cart) {
            totalCart += cart[item].price * cart[item].count;
        }
        return Number(totalCart.toFixed(2));
    };

    // List cart
    obj.listCart = function () {
        var cartCopy = [];
        for (i in cart) {
            item = cart[i];
            itemCopy = {};
            for (p in item) {
                itemCopy[p] = item[p];
            }
            itemCopy.total = Number(item.price * item.count).toFixed(2);
            cartCopy.push(itemCopy);
        }
        return cartCopy;
    };

    // cart : Array
    // Item : Object/Class
    // addItemToCart : Function
    // removeItemFromCart : Function
    // removeItemFromCartAll : Function
    // clearCart : Function
    // countCart : Function
    // totalCart : Function
    // listCart : Function
    // saveCart : Function
    // loadCart : Function
    return obj;
})();

// *****************************************
// Triggers / Events
// *****************************************
// Add item
$(".add-to-cart").click(function (event) {
    event.preventDefault();
    var name = $(this).data("name");
    var price = Number($(this).data("price"));
    shoppingCart.addItemToCart(name, price, 1);
    displayCart();
});

// Clear items
$(".clear-cart").click(function () {
    shoppingCart.clearCart();
    displayCart();
});

function displayCart() {
    var cartArray = shoppingCart.listCart();
    var output = "";
    for (var i in cartArray) {
        output +=
            "<tr>" +
            "<td>" +
            cartArray[i].name +
            "</td>" +
            "<td>(" +
            cartArray[i].price +
            ")</td>" +
            "<td><div class='input-group'><button class='minus-item input-group-addon btn btn-primary' data-name=" +
            cartArray[i].name +
            ">-</button>" +
            "<input type='number' class='item-count form-control' data-name='" +
            cartArray[i].name +
            "' value='" +
            cartArray[i].count +
            "'>" +
            "<button class='plus-item btn btn-primary input-group-addon' data-name=" +
            cartArray[i].name +
            ">+</button></div></td>" +
            "<td><button class='delete-item btn btn-danger' data-name=" +
            cartArray[i].name +
            ">X</button></td>" +
            " = " +
            "<td>" +
            cartArray[i].total +
            "</td>" +
            "</tr>";
    }
    $(".show-cart").html(output);
    $(".total-cart").html(shoppingCart.totalCart());
    $(".total-count").html(shoppingCart.totalCount());
}

// Delete item button

$(".show-cart").on("click", ".delete-item", function (event) {
    var name = $(this).data("name");
    shoppingCart.removeItemFromCartAll(name);
    displayCart();
});

// -1
$(".show-cart").on("click", ".minus-item", function (event) {
    var name = $(this).data("name");
    shoppingCart.removeItemFromCart(name);
    displayCart();
});
// +1
$(".show-cart").on("click", ".plus-item", function (event) {
    var name = $(this).data("name");
    shoppingCart.addItemToCart(name);
    displayCart();
});

// Item count input
$(".show-cart").on("change", ".item-count", function (event) {
    var name = $(this).data("name");
    var count = Number($(this).val());
    shoppingCart.setCountForItem(name, count);
    displayCart();
});

displayCart(); */