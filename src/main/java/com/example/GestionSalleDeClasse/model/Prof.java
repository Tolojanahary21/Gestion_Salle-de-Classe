package com.example.GestionSalleDeClasse.model;
import jakarta.persistence.*;

@Entity
@Table(name = "prof")
public class Prof {
    @Id
    @Column(name = "code_prof",nullable = false,unique = true)
    private String codeProf;

    @Column(nullable = false)
    private String nom;

    @Column(nullable = true)
    private String prenom;

    @Column(nullable = false)
    private String grade;

    public Prof() {

    }

    public Prof(String codeProf,String nom,String prenom,String grade){
        this.codeProf= codeProf;
        this.nom= nom;
        this.prenom= prenom;
        this.grade= grade;
    }

//Getter et setters
        public String getCodeProf(){
            return codeProf;
        }

        public String getNom(){
            return nom;
        }

        public String getPrenom(){
            return prenom;
        }

        public String getGrade(){
            return grade;
        }
//Setters
        public void setCodeProf(String codeProf){
            this.codeProf = codeProf;
        }

        public void setNom(String nom){
            this.nom = nom;
        }

        public void setPrenom(String prenom){
            this.prenom = prenom;
        }

        public void setGrade(String grade){
            this.grade = grade;
        }
}
