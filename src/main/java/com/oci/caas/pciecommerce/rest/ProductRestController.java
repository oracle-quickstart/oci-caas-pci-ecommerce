package com.oci.caas.pciecommerce.rest;

import com.oci.caas.pciecommerce.model.Category;
import com.oci.caas.pciecommerce.model.Item;
import com.oci.caas.pciecommerce.model.ItemRowMapper;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class ProductRestController {

    @Autowired
    JdbcTemplate jdbcTemplate;

    @GetMapping(value = "/products", produces = "application/json")
    public List<Item> products() {
        String query = "SELECT item_id, name, unit_price, stock, description, main_category from Item order by main_category";
        List<Item> itemList = jdbcTemplate.query(query, new ItemRowMapper());
        return itemList;
    }

    @GetMapping(value = "/categories", produces = "application/json")
    public List<Category> categories() {
        String query = "select distinct main_category, category_name from item, category " +
                "where category.category_id = item.main_category order by item.main_category";
        List<Category> categoryList = null;//jdbcTemplate.query(query, new ItemRowMapper());
        return categoryList;
    }
}
