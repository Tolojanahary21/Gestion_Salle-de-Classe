package com.example.GestionSalleDeClasse.controller;

import com.example.GestionSalleDeClasse.model.Prof;
import com.example.GestionSalleDeClasse.service.ProfService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.stereotype.Controller;
import java.util.List;

@Controller
@RestController
@RequestMapping("/api/profs")
public class ProfController {
    // Route vers prof
     @GetMapping("/professeur")
    public String professeur() {
        return "professeur/index";
    }

    private final ProfService profService;

    public ProfController(ProfService profService) {
        this.profService = profService;
    }

    // CREATE
    @PostMapping
    public ResponseEntity<Prof> creerProf(@RequestBody Prof prof) {

        Prof nouveauProf = profService.creerProf(prof);

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(nouveauProf);
    }

    // READ - tous
    @GetMapping
    public ResponseEntity<List<Prof>> getAllProf() {

        return ResponseEntity.ok(
                profService.getAllProf()
        );
    }

    // READ - un seul
    @GetMapping("/{codeProf}")
    public ResponseEntity<Prof> getProfById(
            @PathVariable String codeProf) {

        return profService.getProfById(codeProf)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // UPDATE
    @PutMapping("/{codeProf}")
    public ResponseEntity<Prof> modifierProf(
            @PathVariable String codeProf,
            @RequestBody Prof prof) {

        return ResponseEntity.ok(
                profService.modifierProf(codeProf, prof)
        );
    }

    // DELETE
    @DeleteMapping("/{codeProf}")
    public ResponseEntity<Void> supprimerProf(
            @PathVariable String codeProf) {

        profService.supprimerProf(codeProf);

        return ResponseEntity.noContent().build();
    }
}