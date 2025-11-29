/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Ghaisani
 */
public class Room {
    private int id;
    private String number;
    private String type;
    private String kostName;
    private int kostId;
    private double price;
    private String status;
    private double rating;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNumber() { return number; }
    public void setNumber(String number) { this.number = number; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public int getKostId() { return kostId; }
    public void setKostId(int kostId) { this.kostId = kostId; }
    public String getKostName() { return kostName; }
    public void setKostName(String kostName) { this.kostName = kostName; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }
}
