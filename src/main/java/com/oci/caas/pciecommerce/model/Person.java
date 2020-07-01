package com.oci.caas.pciecommerce.model;

public class Person {
    private long personid;
    private String firstName, lastName;

    public Person(long personid, String firstName, String lastName) {
        this.personid = personid;
        this.firstName = firstName;
        this.lastName = lastName;
    }

    public Person() {

    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public long getPersonid() {
        return personid;
    }

    public void setPersonid(long personid) {
        this.personid = personid;
    }

    @Override
    public String toString() {
        return String.format(
                "Customer[personid=%d, firstName='%s', lastName='%s']",
                personid, firstName, lastName);
    }
}
