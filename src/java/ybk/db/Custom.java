/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ybk.db;

import java.util.Date;
import java.sql.ResultSet;
import java.util.ArrayList;
import ybk.util.NNString;

/**
 *
 * @author yongbam
 */
public class Custom {
    // Construct
    public Custom()
    {
        Key = new Key_();
        Content = new Content_();
        
        AccountList = new ArrayList();
        Account_ acc = new Account_();
        AccountList.add(acc);
        
    }
    // Query of save custom, not insert modified time cuz it is now created, not modified
    public String insertSaveCustom()
    {
        java.util.Date jDate = new java.util.Date();
        java.sql.Date sqlDate1;
        java.sql.Date sqlDate2;
        if(Content.CONTRACT_PERIOD_S==null)
            sqlDate1 = new java.sql.Date(jDate.getTime());
        else
            sqlDate1= new java.sql.Date(Content.CONTRACT_PERIOD_S.getTime());
        if(Content.CONTRACT_PERIOD_E==null)
            sqlDate2 = new java.sql.Date(jDate.getTime());
        else
            sqlDate2= new java.sql.Date(Content.CONTRACT_PERIOD_E.getTime());
        
        return
                "INSERT INTO custom( BUSI_NUM,CUSTOM,SHORT,CEO,CHARGE_PERSON,"+
                "BUSI_CONDITION,ITEM,"+
                "POST_NUM,ADDR1,ADDR2,TEL,FAX,"+
                "HOMEPAGE,CO_YN,FOREIGN_YN,TAX_YN,"+
                "COUNTRY_ENG,COUNTRY_KOR,SPECIAL_RELATION,TRADE_STOP,"+ 
                "CONTRACT_PERIOD_S,CONTRACT_PERIOD_E,REGI_INFO_MAN,REGI_INFO_DATE,MODI_INFO_MAN) "+ 
                "VALUES("+
                Key.BUSI_NUM.get(1)+","+Key.CUSTOM.get(1)+","+Content.SHORT.get(1)+","+Content.CEO.get(1)+","+Content.CHARGE_PERSON.get(1)+","+
                Content.BUSI_CONDITION.get(1)+","+Content.ITEM.get(1)+","+
                Content.POST_NUM.get(1)+","+Content.ADDR1.get(1)+","+Content.ADDR2.get(1)+","+Content.TEL.get(1)+","+Content.FAX.get(1)+","+
                Content.HOMEPAGE.get(1)+","+Content.CO_YN.toString()+","+Content.FOREIGN_YN.toString()+","+Content.TAX_YN.toString()+","+
                Content.COUNTRY_ENG.get(1)+","+Content.COUNTRY_KOR.get(1)+","+Content.SPECIAL_RELATION.toString()+","+Content.TRADE_STOP.toString()+
                ",'"+sqlDate1.toString()+"','"+sqlDate2.toString()+"',"+
                Content.REGI_INFO_MAN.get(1)+","+"CURRENT_TIMESTAMP()"+","+Content.MODI_INFO_MAN.get(1)+");";
    }
    // Query of save custom, not update created time cuz it is update
    public String updateSaveCustom(String previous_BusinessNumber)
    {
        NNString bn = new NNString(previous_BusinessNumber);
        return updateSaveCustom(bn);
    }
    // Query of save custom, not update created time cuz it is update
    public String updateSaveCustom(NNString previous_BusinessNumber)
    {
        Key.BEFORE_BUSI_NUM = previous_BusinessNumber;
        java.util.Date jDate = new java.util.Date();
        java.sql.Date sqlDate1;
        java.sql.Date sqlDate2;
        if(Content.CONTRACT_PERIOD_S==null)
            sqlDate1 = new java.sql.Date(jDate.getTime());
        else
            sqlDate1= new java.sql.Date(Content.CONTRACT_PERIOD_S.getTime());
        if(Content.CONTRACT_PERIOD_E==null)
            sqlDate2 = new java.sql.Date(jDate.getTime());
        else
            sqlDate2= new java.sql.Date(Content.CONTRACT_PERIOD_E.getTime());
        
        return 
                "UPDATE custom SET BUSI_NUM="+Key.BUSI_NUM.get(1)+
                ", CUSTOM="+Key.CUSTOM.get(1)+", SHORT="+Content.SHORT.get(1)+", CEO="+Content.CEO.get(1)+
                ", CHARGE_PERSON="+Content.CHARGE_PERSON.get(1)+
                ", BUSI_CONDITION="+Content.BUSI_CONDITION.get(1)+", ITEM="+Content.ITEM.get(1)+
                ", POST_NUM="+Content.POST_NUM.get(1)+", ADDR1="+Content.ADDR1.get(1)+", ADDR2="+Content.ADDR2.get(1)+
                ", TEL="+Content.TEL.get(1)+", FAX="+Content.FAX.get(1)+
                ", HOMEPAGE="+Content.HOMEPAGE.get(1)+
                ", CO_YN="+Content.CO_YN.toString()+", FOREIGN_YN="+Content.FOREIGN_YN.toString()+", TAX_YN="+Content.TAX_YN.toString()+
                ", COUNTRY_ENG="+Content.COUNTRY_ENG.get(1)+
                ", COUNTRY_KOR="+Content.COUNTRY_KOR.get(1)+
                ", SPECIAL_RELATION="+Content.SPECIAL_RELATION.toString()+
                ", TRADE_STOP="+Content.TRADE_STOP.toString()+
                ", CONTRACT_PERIOD_S='"+sqlDate1.toString()+
                "', CONTRACT_PERIOD_S='"+sqlDate2.toString()+
                "', REGI_INFO_MAN="+Content.REGI_INFO_MAN.get(1)+
                ", MODI_INFO_MAN="+Content.MODI_INFO_MAN.get(1)+
                ", MODI_INFO_DATE=CURRENT_TIMESTAMP() "+
                " WHERE BUSI_NUM="+Key.BEFORE_BUSI_NUM.get(1)+";";
    
    }
    // Private key
    public class Key_
    {   
        public NNString BUSI_NUM;
        public NNString CUSTOM;
        public NNString BEFORE_BUSI_NUM;
        
        public Key_()
        {
            BUSI_NUM=new NNString();
            CUSTOM=new NNString();
            BEFORE_BUSI_NUM=new NNString();
        }
        
    };
    public Key_ Key;
    
    // Conetent
    public class Content_
    {
        // Construct
        public Content_()
        {
            java.util.Date jDate = new java.util.Date();
            
            CO_YN=false;
            FOREIGN_YN=false;
            TAX_YN=false;
            SPECIAL_RELATION=false;
            TRADE_STOP=false;
            CONTRACT_PERIOD_S=new Date(jDate.getTime() );
            CONTRACT_PERIOD_E=new Date(jDate.getTime() );
            REGI_INFO_DATE=new Date(jDate.getTime() );
            MODI_INFO_DATE=new Date(jDate.getTime() );
            
            SHORT=new NNString();
            CEO=new NNString();
            CHARGE_PERSON=new NNString();
            BUSI_CONDITION=new NNString();
            ITEM=new NNString();
            POST_NUM=new NNString();
            ADDR1=new NNString();
            ADDR2=new NNString();
            TEL=new NNString();
            FAX=new NNString();
            HOMEPAGE=new NNString();
            COUNTRY_ENG=new NNString();
            COUNTRY_KOR=new NNString();
            REGI_INFO_MAN=new NNString();
            MODI_INFO_MAN=new NNString();
        }
        
        public NNString SHORT;
        public NNString CEO;
        public NNString CHARGE_PERSON;
        public NNString BUSI_CONDITION;
        public NNString ITEM;
        public NNString POST_NUM;
        public NNString ADDR1;
        public NNString ADDR2;
        public NNString TEL;
        public NNString FAX;
        public NNString HOMEPAGE;
        public NNString COUNTRY_ENG;
        public NNString COUNTRY_KOR;
        public NNString REGI_INFO_MAN;
        public NNString MODI_INFO_MAN;
        public Boolean CO_YN;
        public Boolean FOREIGN_YN;
        public Boolean TAX_YN;
        public Boolean SPECIAL_RELATION;
        public Boolean TRADE_STOP;
        public Date CONTRACT_PERIOD_S;
        public Date CONTRACT_PERIOD_E;
        public Date REGI_INFO_DATE;
        public Date MODI_INFO_DATE;
        
    };
    public Content_ Content;
    
    // Account of custom
    public class Account_
    {
        public NNString FACTORY=new NNString();
        public NNString TRADE_BANK=new NNString();
        public NNString ACCOUNT_NUM=new NNString();
        
    };
    public ArrayList<Account_> AccountList;
    
    // function
    public void SetCustom(ResultSet rs)
    {
        try
        {
            System.out.print("1231\n");
            Key.BUSI_NUM.set(rs.getString("BUSI_NUM"));
            Key.CUSTOM.set(rs.getString("CUSTOM"));
            Content.SHORT.set(rs.getString("SHORT"));
            Content.CEO.set(rs.getString("CEO"));
            Content.CHARGE_PERSON.set(rs.getString("CHARGE_PERSON"));
            Content.BUSI_CONDITION.set(rs.getString("BUSI_CONDITION"));
            Content.ITEM.set(rs.getString("ITEM"));
            Content.POST_NUM.set(rs.getString("POST_NUM"));
            Content.ADDR1.set(rs.getString("ADDR1"));
            Content.ADDR2.set(rs.getString("ADDR2"));
            Content.TEL.set(rs.getString("TEL"));
            Content.FAX.set(rs.getString("FAX"));
            Content.HOMEPAGE.set(rs.getString("HOMEPAGE"));
            Content.CO_YN = rs.getBoolean("CO_YN");
            Content.FOREIGN_YN=rs.getBoolean("FOREIGN_YN");
            Content.TAX_YN=rs.getBoolean("TAX_YN");
            Content.COUNTRY_ENG.set(rs.getString("COUNTRY_ENG"));
            Content.COUNTRY_KOR.set(rs.getString("COUNTRY_KOR"));
            Content.SPECIAL_RELATION=rs.getBoolean("SPECIAL_RELATION");
            Content.TRADE_STOP=rs.getBoolean("TRADE_STOP");
            Content.CONTRACT_PERIOD_S=rs.getDate("CONTRACT_PERIOD_S");
            Content.CONTRACT_PERIOD_E=rs.getDate("CONTRACT_PERIOD_E");
            Content.REGI_INFO_MAN.set(rs.getString("REGI_INFO_MAN"));
            Content.REGI_INFO_DATE=rs.getDate("REGI_INFO_DATE");
            Content.MODI_INFO_MAN.set(rs.getString("MODI_INFO_MAN"));
            Content.MODI_INFO_DATE=rs.getDate("MODI_INFO_DATE");
            
        }
        catch(Exception e)
        {
        }
        
    }
    
    public void SetAccount(NNString office_n, NNString bank_n, NNString acc_num)
    {
        Account_ acc = new Account_();
        acc.FACTORY=office_n;
        acc.TRADE_BANK=bank_n;
        acc.ACCOUNT_NUM=acc_num;
        
        AccountList.add(acc);
    }
    public void SetAccount(String office_n, String bank_n, String acc_num)
    {
        Account_ acc = new Account_();
        acc.FACTORY.set(office_n);
        acc.TRADE_BANK.set(bank_n);
        acc.ACCOUNT_NUM.set(acc_num);
        
        AccountList.add(acc);
    }
    public void SetAccount(ResultSet rs)
    {
        try
        {
            Account_ acc = new Account_();
            acc.FACTORY.set(rs.getString("FACTORY"));
            acc.TRADE_BANK.set(rs.getString("TRADE_BANK"));
            acc.ACCOUNT_NUM.set(rs.getString("ACCOUNT_NUM"));

            AccountList.add(acc);
        }
        catch(Exception e)
        {
        }
    }
}
