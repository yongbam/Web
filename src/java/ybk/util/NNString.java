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
public class NNString {
    private String m_str;
    
    public NNString()
    {
        m_str="";
    }
    public NNString(String str)
    {
        set(str);
    }
    public Boolean equals(NNString str)
    {
        return m_str.equals(str.get() );
    }
    public String get()
    {
        return m_str;
    }
    public String get(int type)
    {
        switch(type)
        {
            case 1:
                if(m_str.length()>0)
                    return "'"+m_str+"'";
                else
                    return null;
        }
        return "";
    }
    // Same with java.lang.String.isEmpty()
    public Boolean isEmpty()
    {
        if(m_str.length()==0 || m_str.equals("null"))
            return true;
        return false;
    }
    public void set(String input_str)
    {
       if(input_str == null)
           m_str = "";
       else if(input_str.equals("null"))
           m_str="";
       else
           m_str = input_str;
    }
}
