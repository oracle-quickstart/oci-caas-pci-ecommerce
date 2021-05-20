let token = document.querySelector('input[name="_csrf"]').value
document.addEventListener("DOMContentLoaded", () => {
        const ui = new UI();
        const orderHistory = new OrderHistory();

        orderHistory.getOrderHistory().then(orderHistory => ui.displayOrderHistory(orderHistory));
})

class OrderHistory {
    async getOrderHistory() {

        try {
            let result = await fetch('/history')
                .then(response => response.json());
            console.log(result)
            console.log('result:' + JSON.stringify(result, null, 2));

            return result;
        } catch (error) {
            console.log(error);
        }

    }
}
class UI {
    displayOrderHistory(orderHistory) {

        let table = `<link rel="stylesheet" href="/css/purchaseHistory.css">
                     <thead>
                        <tr><th>Order ID</th>
                            <th>Total Price</th>
                            <th>Tax</th>
                            <th>Ship Date</th>
                            </tr>
                     </thead>
                     <tbody>`;

        orderHistory.forEach(orders => {

            table += `<tr><td><b>${orders.order_id}</b></td>`;
            table += `<td><b>$${orders.final_order_total}</b></td>`;
            table += `<td><b>${orders.tax}</b></td>`;
            table += `<td><b>${orders.ship_date}</b></td></tr>`;

        });
        table += `</tbody>`;
        document.getElementById("history-tab").innerHTML += table;
    }
}