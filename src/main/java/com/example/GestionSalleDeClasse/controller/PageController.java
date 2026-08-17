package com.example.GestionSalleDeClasse.controller;

import com.example.GestionSalleDeClasse.service.ProfService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

    private final ProfService profService;

    public PageController(ProfService profService) {
        this.profService = profService;
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
    public String salles() {
        return "salle/index";
    }

    @GetMapping("/occupations")
    public String occupations() {
        return "occupation/index";
    }
}