package com.example.GestionSalleDeClasse.model;

import java.io.Serializable;
import java.time.LocalDate;
import java.util.Objects;

public class OccuperId implements Serializable {

    private String codeProf;
    private String codeSalle;
    private LocalDate date;

    public OccuperId() {
    }

    public OccuperId(String codeProf, String codeSalle, LocalDate date) {
        this.codeProf = codeProf;
        this.codeSalle = codeSalle;
        this.date = date;
    }

    public String getCodeProf() {
        return codeProf;
    }

    public void setCodeProf(String codeProf) {
        this.codeProf = codeProf;
    }

    public String getCodeSalle() {
        return codeSalle;
    }

    public void setCodeSalle(String codeSalle) {
        this.codeSalle = codeSalle;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;

        if (!(o instanceof OccuperId)) return false;

        OccuperId that = (OccuperId) o;

        return Objects.equals(codeProf, that.codeProf)
                && Objects.equals(codeSalle, that.codeSalle)
                && Objects.equals(date, that.date);
    }

    @Override
    public int hashCode() {
        return Objects.hash(codeProf, codeSalle, date);
    }
}