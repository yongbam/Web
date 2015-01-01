/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ybk.db;

import ybk.util.NNString;

/**
 *
 * @author yongbam
 */
public class CustomKey {
    private NNString BUSI_NUM;
    private NNString CUSTOM;
    
    public CustomKey()
    {
        BUSI_NUM=new NNString();
        CUSTOM=new NNString();
    }
    public String get_busi_num(){
        return BUSI_NUM.get();
    }
    public String get_custom(){
        return CUSTOM.get();
    }
    public void set_busi_num(String input_busi_num){
        BUSI_NUM.set(input_busi_num);
    }
    public void set_custom(String input_custom){
        CUSTOM.set(input_custom);
    }
    
};
