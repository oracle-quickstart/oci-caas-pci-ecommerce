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
        let result = "";

        orderHistory.forEach(orders => {
            result = `
                
                <link rel="stylesheet" href="/css/purchaseHistory.css">
                        <table id="history-tab">
                        <tr>      
                            <th>${orders.order_id}</th>
                            <th>$${orders.final_order_total}</th>
                            <th>${orders.tax}</th>
                            <th>${orders.ship_date}</th>
                         </tr>
                        </table> 
                </div>
            `;
            document.getElementById("history-table").innerHTML += result;
        });

    }
}