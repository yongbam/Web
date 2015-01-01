/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ybk.util;

/**
 *
 * @author yongbam
 */
public class Compare {
    public int getMostBigNumber(int ... numbers)
    {
        int mostBigNumber = 0;
        for(int number : numbers)
        {
            if(number>mostBigNumber)
                mostBigNumber = number;
        }
        return mostBigNumber;
    }
    
}
