package com.example.GestionSalleDeClasse.controller;

import com.example.GestionSalleDeClasse.service.OccuperService;
import com.example.GestionSalleDeClasse.service.ProfService;
import com.example.GestionSalleDeClasse.service.SalleService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

    private final ProfService profService;
    private final SalleService salleService;
    private final OccuperService occuperService;

    public PageController(
            ProfService profService,
            SalleService salleService,
            OccuperService occuperService
    ) {
        this.profService = profService;
        this.salleService = salleService;
        this.occuperService = occuperService;
    }

    @GetMapping("/professeurs")
    public String professeurs(Model model) {

        model.addAttribute(
                "professeurs",
                profService.getAllProf()
        );

        return "professeurs/index";
    }

    @GetMapping("/salles")
    public String salles(Model model) {

        model.addAttribute(
                "salles",
                salleService.getAllSalles()
        );

        return "salle/index";
    }

    @GetMapping("/occupations")
    public String occupations(Model model) {

        model.addAttribute(
                "occupations",
                occuperService.getTousLesOccuper()
        );

        model.addAttribute(
                "professeurs",
                profService.getAllProf()
        );

        model.addAttribute(
                "salles",
                salleService.getAllSalles()
        );

        return "occupations/index";
    }
}