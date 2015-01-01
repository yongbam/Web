/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ybk.db;

/**
 *
 * @author yongbam
 */
public class Address {
    private String postNumber;
    private String location;
    
    public String GetPostNumber()
    {
        return postNumber;
    }
    public void SetPostNumber(String input_postNumber)
    {
        postNumber=input_postNumber;
    }
    public String GetLocation()
    {
        return location;
    }
    public void SetLocation(String input_Location)
    {
        location=input_Location;
    }
}
