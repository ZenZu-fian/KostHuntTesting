/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Ghaisani
 */
public class Owner extends User {
    private String bankAccount;
    private List<Kost> listKost;
    // Constructor default
    public Owner() {
        super();
        this.setRole("Owner");
        this.listKost = new ArrayList<>();
    }
    
    // Constructor dengan parameter
    public Owner(int id, String name, String email, String password, String phone, String bankAccount) {
        super();
        this.setId(id);
        this.setName(name);
        this.setEmail(email);
        this.setPassword(password);
        this.setPhone(phone);
        this.setRole("Owner");
        this.bankAccount = bankAccount;
    }
    
    // Getter dan Setter untuk bankAccount
    public String getBankAccount() {
        return bankAccount;
    }
    
    public void setBankAccount(String bankAccount) {
        this.bankAccount = bankAccount;
    }
    
    public List<Kost> getListKost() {
        return listKost;
    }
    
     public void setListKost(List<Kost> listKost) {
        this.listKost = listKost;
    }
    
    // Method untuk menambahkan kost ke list
    public void addKost(Kost kost) {
        this.listKost.add(kost);
    }
    
    // Method untuk menghapus kost dari list
    public void removeKost(Kost kost) {
        this.listKost.remove(kost);
    }
    
    public Kost menambahkanDataKos(String emailOwner, String kostName, String kostAddress, 
                                   String kost_location, String kostDescription, 
                                   String kostType, String facilities, String price) {
        // menambahkan kost
        // insert ke database
        Kost newKost = new Kost();
        newKost.setName(kostName);
        newKost.setAddress(kostAddress);
        newKost.setLocation(kost_location);
        newKost.setDescription(kostDescription);
        newKost.setType(kostType);
        newKost.setFacilities(facilities);
        newKost.setPrice(Double.parseDouble(price));
        
        this.listKost.add(newKost);
        return newKost;
    }
 
    public void menampilkanDetailKos(int kostId) {
        // Menampilkan detail kost
        for (Kost kost : listKost) {
            if (kost.getId() == kostId) {
                System.out.println("Kost Details:");
                System.out.println("ID: " + kost.getId());
                System.out.println("Name: " + kost.getName());
                System.out.println("Address: " + kost.getAddress());
                System.out.println("Price: " + kost.getPrice());
                break;
            }
        }
    }
    
    public void menghapusDataKos(String id) {
        // menghapus kost
        int kostId = Integer.parseInt(id);
        listKost.removeIf(kost -> kost.getId() == kostId);
    }
    
    public void mengeditDataKos(String emailOwner, String kostName, String kostAddress, 
                               String kostDescription, String kostType, 
                               String facilities, String price) {
        // mengedit kost
        // update ke database
        for (Kost kost : listKost) {
            if (kost.getName().equals(kostName)) {
                kost.setAddress(kostAddress);
                kost.setDescription(kostDescription);
                kost.setType(kostType);
                kost.setFacilities(facilities);
                kost.setPrice(Double.parseDouble(price));
                break;
            }
        }
    }
    
    public void mengelolaKamar(int id, String kost_String) {
        // mengelola kamar
        System.out.println("Mengelola kamar untuk Kost ID: " + id);
    }
}