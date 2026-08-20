package com.example.GestionSalleDeClasse.service;

import com.example.GestionSalleDeClasse.model.Occuper;
import com.example.GestionSalleDeClasse.model.OccuperId;
import com.example.GestionSalleDeClasse.repository.OccuperRepository;
import com.example.GestionSalleDeClasse.exception.ApiException;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

        if (occuperRepository.existsByCodeSalleAndDate(
                occuper.getCodeSalle(),
                occuper.getDate()
        )) {
            throw new ApiException(
                    HttpStatus.CONFLICT,
                    "Cette salle est déjà occupée à cette date. "
                            + "Veuillez choisir une autre salle ou une autre date."
            );
        }

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
                .orElseThrow(() -> new ApiException(
                        HttpStatus.NOT_FOUND,
                        "Occupation introuvable."
                ));
    }

    // UPDATE
    @Transactional
    public Occuper modifierOccuper(
            String codeProf,
            String codeSalle,
            LocalDate date,
            Occuper nouvellesDonnees) {

        OccuperId ancienId = new OccuperId(
                codeProf,
                codeSalle,
                date
        );

        Occuper occuperExistant = occuperRepository.findById(ancienId)
                .orElseThrow(() -> new ApiException(
                        HttpStatus.NOT_FOUND,
                        "Occupation introuvable."
                ));

        LocalDate nouvelleDate = nouvellesDonnees.getDate();

        // La date fait partie de la clé primaire composite (codeProf, codeSalle, date).
        // On ne peut pas simplement modifier un champ d'@Id sur une entité existante :
        // JPA génère alors un INSERT (nouvelle ligne) au lieu d'un UPDATE, laissant
        // l'ancienne ligne en base. Si la date change réellement, on supprime donc
        // explicitement l'ancienne ligne avant d'enregistrer la nouvelle.
        if (!nouvelleDate.equals(date)) {

            // Vérifie qu'aucune occupation (par n'importe quel professeur) n'existe
            // déjà pour cette salle à la nouvelle date. Comme l'ancienne ligne a
            // encore l'ancienne date à ce stade, elle ne fausse pas ce contrôle.
            if (occuperRepository.existsByCodeSalleAndDate(codeSalle, nouvelleDate)) {
                throw new ApiException(
                        HttpStatus.CONFLICT,
                        "Cette salle est déjà occupée à cette date. "
                                + "Veuillez choisir une autre salle ou une autre date."
                );
            }

            occuperRepository.delete(occuperExistant);

            Occuper nouvelleOccupation = new Occuper(
                    codeProf,
                    codeSalle,
                    nouvelleDate
            );

            return occuperRepository.save(nouvelleOccupation);
        }

        // Aucun changement de date : rien à faire, on renvoie l'existant tel quel.
        return occuperExistant;
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
            throw new ApiException(
                    HttpStatus.NOT_FOUND,
                    "Occupation introuvable."
            );
        }

        occuperRepository.deleteById(id);
    }
}