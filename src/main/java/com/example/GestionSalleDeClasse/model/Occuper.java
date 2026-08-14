package com.example.GestionSalleDeClasse.model;

import jakarta.persistence.*;

import java.time.LocalDate;

@Entity
@Table(name = "occuper")
@IdClass(OccuperId.class)
public class Occuper {

    @Id
    @Column(name = "code_prof", nullable = false)
    private String codeProf;

    @Id
    @Column(name = "code_salle", nullable = false)
    private String codeSalle;

    @Id
    @Column(nullable = false)
    private LocalDate date;

    // Constructeur vide obligatoire pour JPA
    public Occuper() {
    }

    // Constructeur
    public Occuper(String codeProf, String codeSalle, LocalDate date) {
        this.codeProf = codeProf;
        this.codeSalle = codeSalle;
        this.date = date;
    }

    // Getters

    public String getCodeProf() {
        return codeProf;
    }

    public String getCodeSalle() {
        return codeSalle;
    }

    public LocalDate getDate() {
        return date;
    }

    // Setters

    public void setCodeProf(String codeProf) {
        this.codeProf = codeProf;
    }

    public void setCodeSalle(String codeSalle) {
        this.codeSalle = codeSalle;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }
}