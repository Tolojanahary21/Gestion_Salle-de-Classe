package com.example.GestionSalleDeClasse.service;

import com.example.GestionSalleDeClasse.model.Occuper;
import com.example.GestionSalleDeClasse.model.OccuperId;
import com.example.GestionSalleDeClasse.repository.OccuperRepository;

import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class OccuperService {

    private final OccuperRepository occuperRepository;

    public OccuperService(OccuperRepository occuperRepository) {
        this.occuperRepository = occuperRepository;
    }

    // CREATE
    public Occuper creerOccuper(Occuper occuper) {
        return occuperRepository.save(occuper);
    }

    // READ ALL
    public List<Occuper> getTousLesOccuper() {
        return occuperRepository.findAll();
    }

    // READ ONE
    public Occuper getOccuper(
            String codeProf,
            String codeSalle,
            LocalDate date) {

        OccuperId id = new OccuperId(
                codeProf,
                codeSalle,
                date
        );

        return occuperRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException("Occupation introuvable"));
    }

    // UPDATE
    public Occuper modifierOccuper(
            String codeProf,
            String codeSalle,
            LocalDate date,
            Occuper nouvellesDonnees) {

        OccuperId id = new OccuperId(
                codeProf,
                codeSalle,
                date
        );

        Occuper occuper = occuperRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException("Occupation introuvable"));

        occuper.setDate(nouvellesDonnees.getDate());

        return occuperRepository.save(occuper);
    }

    // DELETE
    public void supprimerOccuper(
            String codeProf,
            String codeSalle,
            LocalDate date) {

        OccuperId id = new OccuperId(
                codeProf,
                codeSalle,
                date
        );

        if (!occuperRepository.existsById(id)) {
            throw new RuntimeException("Occupation introuvable");
        }

        occuperRepository.deleteById(id);
    }
}