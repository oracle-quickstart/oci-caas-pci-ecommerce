package com.oci.caas.pciecommerce.model;


import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class PersonRowMapper implements RowMapper<Person> {
    @Override
    public Person mapRow(ResultSet resultSet, int i) throws SQLException {
        Person person = new Person();

        person.setPersonid(resultSet.getLong("personid"));
        person.setFirstName(resultSet.getString("firstname"));
        person.setLastName(resultSet.getString("lastname"));
        return person;

    }
}
