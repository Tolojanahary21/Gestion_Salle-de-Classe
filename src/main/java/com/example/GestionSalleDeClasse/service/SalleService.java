package com.example.GestionSalleDeClasse.service;

import com.example.GestionSalleDeClasse.model.Salle;
import com.example.GestionSalleDeClasse.repository.SalleRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class SalleService {

    private final SalleRepository salleRepository;

    public SalleService(SalleRepository salleRepository) {
        this.salleRepository = salleRepository;
    }

    // CREATE
    public Salle creerSalle(Salle salle) {
        return salleRepository.save(salle);
    }

    // READ - toutes les salles
    public List<Salle> getAllSalles() {
        return salleRepository.findAll();
    }

    // READ - une salle
    public Optional<Salle> getSalleByCode(String codeSalle) {
        return salleRepository.findById(codeSalle);
    }

    // UPDATE
    public Salle modifierSalle(String codeSalle, Salle salle) {

        Optional<Salle> salleExistante = salleRepository.findById(codeSalle);

        if (salleExistante.isPresent()) {

            Salle salleAModifier = salleExistante.get();

            salleAModifier.setDesignation(salle.getDesignation());

            return salleRepository.save(salleAModifier);
        }

        return null;
    }

    // DELETE
    public boolean supprimerSalle(String codeSalle) {

        if (salleRepository.existsById(codeSalle)) {
            salleRepository.deleteById(codeSalle);
            return true;
        }

        return false;
    }
}