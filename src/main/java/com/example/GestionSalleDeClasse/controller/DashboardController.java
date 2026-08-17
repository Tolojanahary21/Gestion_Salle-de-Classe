package com.example.GestionSalleDeClasse.controller;

import com.example.GestionSalleDeClasse.model.Occuper;
import com.example.GestionSalleDeClasse.model.Prof;
import com.example.GestionSalleDeClasse.model.Salle;
import com.example.GestionSalleDeClasse.service.OccuperService;
import com.example.GestionSalleDeClasse.service.ProfService;
import com.example.GestionSalleDeClasse.service.SalleService;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
public class DashboardController {

    private final ProfService profService;
    private final SalleService salleService;
    private final OccuperService occuperService;

    public DashboardController(
            ProfService profService,
            SalleService salleService,
            OccuperService occuperService
    ) {
        this.profService = profService;
        this.salleService = salleService;
        this.occuperService = occuperService;
    }

    @GetMapping("/")
    public String dashboard(Model model) {

        // =========================================================
        // 1. RECUPERATION DES DONNEES REELLES
        // =========================================================

        List<Prof> professeurs = profService.getAllProf();
        List<Salle> salles = salleService.getAllSalles();
        List<Occuper> occupations = occuperService.getTousLesOccuper();

        // =========================================================
        // 2. STATISTIQUES
        // =========================================================

        long totalProfesseurs = professeurs.size();
        long totalSalles = salles.size();
        long totalOccupations = occupations.size();

        LocalDate aujourdHui = LocalDate.now();

        /*
         * Une salle est considérée comme occupée aujourd'hui
         * lorsqu'elle possède une occupation dont la date correspond
         * à la date actuelle.
         */
        long sallesOccupees = occupations.stream()
                .filter(occupation ->
                        aujourdHui.equals(occupation.getDate())
                )
                .map(Occuper::getCodeSalle)
                .distinct()
                .count();

        long sallesDisponibles = Math.max(
                totalSalles - sallesOccupees,
                0
        );

        // =========================================================
        // 3. FORMATAGE DE LA DATE DU HEADER
        // =========================================================

        DateTimeFormatter dateFormatter =
                DateTimeFormatter.ofPattern(
                        "dd MMMM yyyy",
                        Locale.FRENCH
                );

        String dateAffichee =
                aujourdHui.format(dateFormatter);

        // =========================================================
        // 4. MAPS POUR RETROUVER PROFESSEURS ET SALLES
        // =========================================================

        Map<String, Prof> professeursParCode =
                professeurs.stream()
                        .collect(Collectors.toMap(
                                Prof::getCodeProf,
                                prof -> prof
                        ));

        Map<String, Salle> sallesParCode =
                salles.stream()
                        .collect(Collectors.toMap(
                                Salle::getCodeSalle,
                                salle -> salle
                        ));

        // =========================================================
        // 5. OCCUPATIONS RECENTES
        // =========================================================

        /*
         * On trie les occupations par date décroissante
         * afin d'afficher les plus récentes en premier.
         */
        List<Occuper> occupationsTriees =
                occupations.stream()
                        .sorted(
                                Comparator.comparing(
                                        Occuper::getDate
                                ).reversed()
                        )
                        .limit(8)
                        .toList();

        List<Map<String, Object>> occupationsRecentes =
                new ArrayList<>();

        DateTimeFormatter dateOccupationFormatter =
                DateTimeFormatter.ofPattern(
                        "dd/MM/yyyy"
                );

        for (Occuper occupation : occupationsTriees) {

            Prof prof =
                    professeursParCode.get(
                            occupation.getCodeProf()
                    );

            Salle salle =
                    sallesParCode.get(
                            occupation.getCodeSalle()
                    );

            Map<String, Object> ligne =
                    new HashMap<>();

            // Code professeur
            ligne.put(
                    "codeProf",
                    occupation.getCodeProf()
            );

            // Nom du professeur
            if (prof != null) {

                String nomComplet =
                        prof.getNom();

                if (prof.getPrenom() != null
                        && !prof.getPrenom().isBlank()) {

                    nomComplet +=
                            " " + prof.getPrenom();
                }

                ligne.put(
                        "professeur",
                        nomComplet
                );

            } else {

                ligne.put(
                        "professeur",
                        occupation.getCodeProf()
                );
            }

            // Code salle
            ligne.put(
                    "codeSalle",
                    occupation.getCodeSalle()
            );

            // Désignation de la salle
            if (salle != null) {

                ligne.put(
                        "salle",
                        salle.getDesignation()
                );

            } else {

                ligne.put(
                        "salle",
                        occupation.getCodeSalle()
                );
            }

            // Date
            ligne.put(
                    "date",
                    occupation
                            .getDate()
                            .format(dateOccupationFormatter)
            );

            // Statut calculé
            String statut;

            if (occupation.getDate().isEqual(aujourdHui)) {

                statut = "Occupée";

            } else if (occupation.getDate().isAfter(aujourdHui)) {

                statut = "Planifiée";

            } else {

                statut = "Terminée";
            }

            ligne.put(
                    "statut",
                    statut
            );

            occupationsRecentes.add(ligne);
        }

        // =========================================================
        // 6. ETAT DES SALLES
        // =========================================================

        /*
         * On récupère les codes des salles occupées aujourd'hui.
         */
        List<String> codesSallesOccupeesAujourdHui =
                occupations.stream()
                        .filter(occupation ->
                                aujourdHui.equals(
                                        occupation.getDate()
                                )
                        )
                        .map(Occuper::getCodeSalle)
                        .distinct()
                        .toList();

        /*
         * Liste destinée à la JSP.
         */
        List<Map<String, Object>> etatSalles =
                new ArrayList<>();

        for (Salle salle : salles) {

            boolean occupee =
                    codesSallesOccupeesAujourdHui
                            .contains(
                                    salle.getCodeSalle()
                            );

            Map<String, Object> ligne =
                    new HashMap<>();

            ligne.put(
                    "codeSalle",
                    salle.getCodeSalle()
            );

            ligne.put(
                    "designation",
                    salle.getDesignation()
            );

            ligne.put(
                    "occupee",
                    occupee
            );

            ligne.put(
                    "statut",
                    occupee
                            ? "Occupée"
                            : "Disponible"
            );

            etatSalles.add(ligne);
        }

        // =========================================================
        // 7. DONNEES ENVOYEES A LA JSP
        // =========================================================

        model.addAttribute(
                "totalProfesseurs",
                totalProfesseurs
        );

        model.addAttribute(
                "totalSalles",
                totalSalles
        );

        model.addAttribute(
                "totalOccupations",
                totalOccupations
        );

        model.addAttribute(
                "sallesOccupees",
                sallesOccupees
        );

        model.addAttribute(
                "sallesDisponibles",
                sallesDisponibles
        );

        model.addAttribute(
                "dateAffichee",
                dateAffichee
        );

        model.addAttribute(
                "occupationsRecentes",
                occupationsRecentes
        );

        model.addAttribute(
                "etatSalles",
                etatSalles
        );

        return "dashboard";
    }
}