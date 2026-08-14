package com.example.GestionSalleDeClasse.service;

import com.example.GestionSalleDeClasse.model.Prof;
import com.example.GestionSalleDeClasse.repository.ProfRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ProfService {

    private final ProfRepository profRepository;

    public ProfService(ProfRepository profRepository) {
        this.profRepository = profRepository;
    }

    // CREATE
    public Prof creerProf(Prof prof) {
        return profRepository.save(prof);
    }

    // READ - tous les professeurs
    public List<Prof> getAllProf() {
        return profRepository.findAll();
    }

    // READ - un professeur
    public Optional<Prof> getProfById(String codeProf) {
        return profRepository.findById(codeProf);
    }

    // UPDATE
    public Prof modifierProf(String codeProf, Prof prof) {

        return profRepository.findById(codeProf)
                .map(profExistant -> {

                    profExistant.setNom(prof.getNom());
                    profExistant.setPrenom(prof.getPrenom());
                    profExistant.setGrade(prof.getGrade());

                    return profRepository.save(profExistant);
                })
                .orElseThrow(() ->
                        new RuntimeException("Professeur introuvable : " + codeProf)
                );
    }

    // DELETE
    public void supprimerProf(String codeProf) {

        if (!profRepository.existsById(codeProf)) {
            throw new RuntimeException(
                    "Professeur introuvable : " + codeProf
            );
        }

        profRepository.deleteById(codeProf);
    }
}