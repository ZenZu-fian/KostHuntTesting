/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDate;
/**
 *
 * @author Ghaisani
 */
public class Tenant extends User implements Payable {
    public Tenant(){
        super();
    }
   
    public Tenant(int id, String name, String email, String password, String phone) {
        super();
        this.setId(id);
        this.setName(name);
        this.setEmail(email);
        this.setPassword(password);
        this.setPhone(phone);
        this.setRole("Tenant");
    }
    
    public boolean mendaftarKost(double price, int roomId, String roomNumber, int tenantId) {
        
        System.out.println("Tenant " + this.getName() + " mendaftar kost dengan harga: " + price);
        return true;
    }
    
    public String mencariKost(String location, String priceRange, String address) {
        // Implementasi logika pencarian kost
        System.out.println("Mencari kost di lokasi: " + location + " dengan range harga: " + priceRange);
        return "Hasil pencarian kost";
    }
    
    public boolean review(int roomId, int tenantId, int id, String ulasan, double rating) {
        
        System.out.println("Tenant " + this.getName() + " memberikan review dengan rating: " + rating);
        return true;
    }
    
    public boolean mencariBuatPembayaran(String tanggal, String nama, String ownerName, double jumlah) {
        // pembayaran
        System.out.println("Tenant " + this.getName() + " melakukan pembayaran sebesar: " + jumlah);
        return true;
    }
    
    @Override
    public String toString() {
        return "Tenant{" +
                "id=" + getId() +
                ", name='" + getName() + '\'' +
                ", email='" + getEmail() + '\'' +
                ", phone='" + getPhone() + '\'' +
                ", role='" + getRole() + '\'' +
                '}';
    }
    
    @Override 
    public Payment pay(double amount) {
        Payment payment = new Payment();
        payment.setId((int) (Math.random() * 1000)); // contoh ID random
        payment.setTenantName(this.getName());
        payment.setAmount(amount);
        payment.setPaymentDate(LocalDate.now().toString());

        System.out.println("Tenant " + getName() + " melakukan pembayaran sebesar " + amount);
        return payment;
    }
}
