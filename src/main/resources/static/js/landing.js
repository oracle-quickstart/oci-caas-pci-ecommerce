//variables
const cartBtn = document.querySelector(".cart-btn");
const closeCartBtn = document.querySelector(".close-cart");
const clearCartBtn = document.querySelector(".clear-cart");
const cartDOM = document.querySelector(".cart");
const cartOverlay = document.querySelector(".cart-overlay");
const cartItems = document.querySelector(".cart-items");
const cartTotal = document.querySelector(".cart-total");
const cartContent = document.querySelector(".cart-content");
const productsDOM = document.querySelector(".products-center");

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
        console.log(products);
        let result = "";
        products.forEach(product => {
            result += `
                <article class="product" >
                    <div class="img-container">
                        <img src="/images/products/prod${product.item_id}.png" alt="product" class="product-img" />
                        <button class="bag-btn" 
                            data-id=${product.item_id}
                            data-name=${product.name}
                            data-unit_price=${product.unit_price}
                         >
                            <i class="fas fa-shopping-cart"></i>
                            add to bag
                        </button>
                    </div>
                    <h3>${product.name}</h3>
                    <h4>$${product.unit_price}</h4>
                </article>
            `;
        });
        productsDOM.innerHTML = result;
    }
}


class Item {
    constructor(name, price, count) {
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

    addItemToCart (name, price, count) {
        console.log("add to cart");
        for (var item in cart) {
            if (cart[item].name === name) {
                cart[item].count++;
                this.saveCart();
                cartItems.innerHTML = parseInt(cartItems.innerHTML) + count;
                return;
            }
        }
        var item = new Item(name, price, count);
        cart.push(item);
        this.saveCart();
        cartItems.innerHTML = parseInt(cartItems.innerHTML) + count;
    }
    listCart () {
        console.log(cart);
    }

}

document.addEventListener("DOMContentLoaded", () => {
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
    const bagBtns = document.querySelectorAll(".bag-btn");
    bagBtns.forEach(bagBtn => {
        bagBtn.addEventListener("click", (event) => {
            let item = event.target;
            shoppingcart.addItemToCart(item.dataset.name, item.dataset.unit_price, 1);
        });
    });

    cartBtn.addEventListener("click", shoppingcart.listCart);

}


