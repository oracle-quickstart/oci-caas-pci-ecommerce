package com.oci.caas.pciecommerce.model;

public class Item {
    private long item_id;
    private long main_category;
    private int stock;
    private double unit_price;
    private String name, description;

    public Item(long item_id, String name, int stock, double unit_price, String description, long main_category) {
        this.item_id = item_id;
        this.name = name;
        this.stock = stock;
        this.unit_price = unit_price;
        this.description = description;
        this.main_category = main_category;
    }

    public Item() {

    }

    public Item(long item_id) {
        this.item_id = item_id;
    }

    public long getItem_id() {
        return item_id;
    }

    public void setItem_id(long item_id) {
        this.item_id = item_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getUnit_price() {
        return unit_price;
    }

    public void setUnit_price(double unit_price) {
        this.unit_price = unit_price;
    }

    @Override
    public String toString() {
        return String.format(
                "Item[item_id=%d, name='%s', stock='%d', unit_price='%f']",
                item_id, name, stock, unit_price);
    }

    public long getMain_category() {
        return main_category;
    }

    public void setMain_category(long main_category) {
        this.main_category = main_category;
    }
}
