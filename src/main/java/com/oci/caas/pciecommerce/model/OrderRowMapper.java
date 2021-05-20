package com.oci.caas.pciecommerce.model;

import org.springframework.jdbc.core.RowMapper;
import java.sql.ResultSet;
import java.sql.SQLException;

public class OrderRowMapper implements RowMapper<Order> {
    
    public Order mapRow(ResultSet resultSet, int i) throws SQLException {
        Order order = new Order();
        order.setOrder_id(resultSet.getLong("order_id"));
        order.setUser_id(resultSet.getLong("user_id"));
        order.setCart_id(resultSet.getLong("cart_id"));
        order.setFinal_order_total(resultSet.getDouble("final_order_total"));
        order.setTax(resultSet.getDouble("tax"));
        order.setShip_date(resultSet.getDate("ship_date"));
        order.setPayment_intent(resultSet.getString("payment_intent"));

        return order;
    }
    
}

