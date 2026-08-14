package com.example.GestionSalleDeClasse.model;
import jakarta.persistence.*;

@Entity
@Table(name = "salle")
public class Salle {
    @Id 
    @Column(name = "code_salle",nullable = false,unique = true)
    private String codeSalle;

    @Column(nullable = false)
    private String designation;
    
    public Salle() {
    }

    //Constructeur
    public Salle(String codeSalle,String designation){
        this.codeSalle=codeSalle;
        this.designation=designation;
    }
    //Getters
    public String getCodeSalle(){
        return codeSalle;
    }
    public String getDesignation(){
        return designation;
    }
    //Stters
    public void setCodeSalle(String codeSalle){
        this.codeSalle= codeSalle;
    }
    public void setDesignation(String designation){
        this.designation= designation;
    }
}
