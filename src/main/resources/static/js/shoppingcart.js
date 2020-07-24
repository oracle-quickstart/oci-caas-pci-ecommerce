
export default class ShoppingCart {

    constructor(cart) {
        this.cart = cart;
    }
    saveCart() {
        sessionStorage.setItem("shoppingCart", JSON.stringify(this.cart));
    }

    loadCart() {
        if (sessionStorage.getItem("shoppingCart") != null) {
            this.cart = JSON.parse(sessionStorage.getItem("shoppingCart"));
        }
    }

    addItemToCart(item_id, name, price, count) {
        let item = new Item(item_id, name, price, count);
        for (item in this.cart) {
            if (this.cart[item].name === name) {
                this.cart[item].count++;
                this.saveCart();
                cartItems.innerHTML = parseInt(cartItems.innerHTML) + count;
                return;
            }
        }
        this.cart.push(item);
        this.saveCart();
        cartItems.innerHTML = parseInt(cartItems.innerHTML) + count;
    }

    totalCount () {
        let totalCount = 0;
        for (let item in this.cart) {
            totalCount += this.cart[item].count;
        }
        return totalCount;
    }

    totalCart () {
        let totalCart = 0;
        for (let item in this.cart) {
            totalCart += this.cart[item].price * this.cart[item].count;
        }
        return Number(totalCart.toFixed(2));
    }

    listCart() {
        let cartCopy = [];
        let i;
        for (i in this.cart) {
            let item = this.cart[i];
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
        for (let item in this.cart) {
            if (this.cart[item].name === name) {
                this.cart[item].count--;
                if (this.cart[item].count === 0) {
                    this.cart.splice(item, 1);
                }
                break;
            }
        }
        this.saveCart();
    }

    printCart () {
        console.log(this.cart);
    }

}