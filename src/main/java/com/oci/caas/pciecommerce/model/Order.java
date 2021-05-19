package com.oci.caas.pciecommerce.model;
import java.util.*;

public class Order {

    private long order_id;
    private long user_id;
    private long cart_id;
    private double final_order_total;
    private double tax;
    private Date ship_date;
    private String payment_intent;

    public Order(long order_id, long user_id, long cart_id, double final_order_total, double tax, Date ship_date, String payment_intent) {
        this.order_id = order_id;
        this.user_id = user_id;
        this.cart_id = cart_id;
        this.final_order_total = final_order_total;
        this.tax = tax;
        this.ship_date = ship_date;
        this.payment_intent = payment_intent;
    }

    public Order(){}

    public long getOrder_id() {
        return order_id;
    }

    public void setOrder_id(long order_id) {
        this.order_id = order_id;
    }

    public long getUser_id() {
        return user_id;
    }

    public void setUser_id(long user_id) {
        this.user_id = user_id;
    }

    public long getCart_id() {
        return cart_id;
    }

    public void setCart_id(long cart_id) {
        this.cart_id = cart_id;
    }

    public double getFinal_order_total() {
        return final_order_total;
    }

    public void setFinal_order_total(double final_order_total) {
        this.final_order_total = final_order_total;
    }

    public double getTax() {
        return tax;
    }

    public void setTax(double tax) {
        this.tax = tax;
    }

    public Date getShip_date() {
        return ship_date;
    }

    public void setShip_date(Date ship_date) {
        this.ship_date = ship_date;
    }

    public String getPayment_intent() {
        return payment_intent;
    }

    public void setPayment_intent(String payment_intent) {
        this.payment_intent = payment_intent;
    }

    @Override
    public String toString() {
        return "Order{" +
                "order_id=" + order_id +
                ", user_id=" + user_id +
                ", cart_id=" + cart_id +
                ", final_order_total=" + final_order_total +
                ", tax=" + tax +
                ", ship_date=" + ship_date +
                ", payment_intent='" + payment_intent + '\'' +
                '}';
    }

}
