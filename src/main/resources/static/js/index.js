
// shopping cart modal toggle
const cartBtn = document.getElementById("cart-btn");

// insert items
const productsDOM = document.getElementById("categ-1");

// add to cart list
const showCart = document.querySelector(".show-cart");
const cartItems = document.querySelector(".total-count");

// in modal
const cartTotal = document.querySelector(".total-cart");
const checkoutBtn = document.getElementById("checkout-btn");

// clear car
const clearCartBtn = document.querySelector(".clear-cart");



const closeCartBtn = document.querySelector(".close-cart");
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
        cartItems.innerHTML = this.totalCount();

    }

    displayCart() {
        var cartArray = this.listCart();
        var output = "";

        cartArray.forEach(product => {
            output += `
            <tr>
                <td>${product.name}</td>
                <td>(${product.price})</td>
                <td>
                    <div class="input-group">
                        <button class="minus-item input-group-addon btn btn-primary" data-price="${product.price}" data-id="${product.id}" data-name="${product.name}">-</button>
                        <input type="number" class="item-count form-control" data-id="${product.id}" data-name="${product.name}" value="${product.count}">
                        <button class="plus-item btn btn-primary input-group-addon" data-id="${product.id}" data-name="${product.name}">+</button>
                    </div>
                </td>
                <td>
                    <button class="delete-item btn btn-danger" data-name="${product.name}">X</button>
                </td>
                <td>${product.total}</td>
            </tr>
            `;
        });
        showCart.innerHTML = output;
        cartTotal.innerHTML = this.totalCart();
        // $(".total-count").html(shoppingCart.totalCount());
    }

    // Remove all items from cart
    removeItemFromCartAll (name) {
        for (var item in cart) {
            if (cart[item].name === name) {
                cart.splice(item, 1);
                break;
            }
        }
        this.saveCart();
        cartItems.innerHTML = this.totalCount();

    };

    setCountForItem(name, count) {
        for (var i in cart) {
            if (cart[i].name === name) {
                cart[i].count = count;
                break;
            }
        }
    };

    clearCart () {
        cart = [];
        this.saveCart();
    };


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

    const shoppingcart = new ShoppingCart();
    const bagBtns = document.querySelectorAll(".add-to-cart");
    bagBtns.forEach(btn => {
        btn.addEventListener("click", (event) => {
            let item = event.target;
            shoppingcart.addItemToCart(item.dataset.id, item.dataset.name, item.dataset.unit_price, 1);
        });
    });


    if (sessionStorage.getItem("shoppingCart") != null) {
        shoppingcart.loadCart();
    }
    cartItems.innerHTML = shoppingcart.totalCount();

    cartBtn.addEventListener("click", () => {
        shoppingcart.displayCart(shoppingcart);
    });
    clearCartBtn.addEventListener("click", () => {
        shoppingcart.clearCart();
        cartItems.innerHTML = shoppingcart.totalCount();
    });
    checkoutBtn.addEventListener("click", () => {
        location.href = "/checkout";
    });

    showCart.addEventListener("click", (event) => {
        let item = event.target;
        let name = item.dataset.name;
        let id = item.dataset.id;

        console.log("in showcart: " + name);
        if (event.target.className.includes("delete-item")) {
            console.log("in del");
            shoppingcart.removeItemFromCartAll(name);
        }
        else if (event.target.className.includes("minus-item")) {
            console.log("in minus");
            shoppingcart.removeItemFromCart(name);
        }
        else if (event.target.className.includes("plus-item")) {
            console.log("in plus");
            let price = item.dataset.price;
            shoppingcart.addItemToCart(id, name, price, 1);
        }
        shoppingcart.displayCart();
        console.log(shoppingcart.printCart())
    });

    /*
    const deleteItem = document.querySelectorAll(".delete-item");
    deleteItem.forEach(btn => {
        btn.addEventListener("click", (event) => {
            let item = event.target;
            let name = item.dataset.name;
            shoppingcart.removeItemFromCartAll(name);
            shoppingcart.displayCart();
        });
    });

    const minusItem = document.querySelectorAll(".minus-item");
    minusItem.forEach(btn => {
        btn.addEventListener("click", (event) => {
            let item = event.target;
            let name = item.dataset.name;
            shoppingcart.removeItemFromCart(name);
            shoppingcart.displayCart();
        });
    });

    const addItem = document.querySelectorAll(".minus-item");
    addItem.forEach(btn => {
        btn.addEventListener("click", (event) => {
            let item = event.target;
            let name = item.dataset.name;
            shoppingcart.addItemToCart(name);
            shoppingcart.displayCart();
        });
    });

    const typeItem = document.querySelectorAll(".minus-item");
    typeItem.forEach(btn => {
        btn.addEventListener("click", (event) => {
            let item = event.target;
            let name = item.dataset.name;
            let count = Number(btn.value);
            shoppingcart.setCountForItem(name, count);
            shoppingcart.displayCart();
        });
    }); */

};