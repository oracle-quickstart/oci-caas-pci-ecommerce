package com.oci.caas.pciecommerce.model;

import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class ItemRowMapper implements RowMapper<Item> {
    public Item mapRow(ResultSet resultSet, int i) throws SQLException {
        Item item = new Item();
        item.setItem_id(resultSet.getLong("item_id"));
        item.setName(resultSet.getString("name"));
        item.setStock(resultSet.getInt("stock"));
        item.setUnit_price(resultSet.getDouble("unit_price"));
        return item;
    }
}