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
import java.util.Properties;
 
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
 
public class SendMailViaGmail {
    private final String username = "Animouys@gmail.com";
    private final String password = "asky33780";
    
    private void SendMail(Session session, String to, String subject, String memo) throws RuntimeException
    {
        try
        {
            /*
            Transport transport = session.getTransport("smtps");
            transport.connect(
                    "smtp.gmail.com", 
                    465, 
                    username, password);
            */
        
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress("Animouys@gmail.com"));
            message.setRecipients(Message.RecipientType.TO,
                    InternetAddress.parse(to));
            message.setSubject(subject);
            message.setText(memo);
            Transport.send(message);
/*
            transport.sendMessage(message, message.getAllRecipients());
            transport.close();
  */          
            System.out.println("Done");
        } 
        catch (MessagingException e) 
        {
            throw new RuntimeException(e);
        }
    }
    
    public boolean UseSSL(String from, String to, String subject, String memo) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.socketFactory.port", "465");
        props.put("mail.smtp.socketFactory.class",
                        "javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.port", "465");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        Session session;
        session = Session.getDefaultInstance(props,
            new javax.mail.Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication("username","password");
                }});
        
        try
        {
            SendMail(session, to, subject, memo);
            return true;
        }
        catch(RuntimeException e)
        {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean UseTLS(String from, String to, String subject, String memo) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
 
        Session session;
        session = Session.getInstance(props,
            new javax.mail.Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }});
        
        try
        {
            SendMail(session, to, subject, memo);
            return true;
        }
        catch(RuntimeException e)
        {
            e.printStackTrace();
            return false;
        }
    }
}
