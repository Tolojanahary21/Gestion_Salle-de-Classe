package com.example.GestionSalleDeClasse.controller;

import com.example.GestionSalleDeClasse.model.Occuper;
import com.example.GestionSalleDeClasse.service.OccuperService;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/occuper")
public class OccuperController {

    private final OccuperService occuperService;

    public OccuperController(OccuperService occuperService) {
        this.occuperService = occuperService;
    }

    // CREATE
    @PostMapping
    public ResponseEntity<Occuper> creerOccuper(
            @RequestBody Occuper occuper) {

        return ResponseEntity.ok(
                occuperService.creerOccuper(occuper)
        );
    }

    // READ ALL
    @GetMapping
    public ResponseEntity<List<Occuper>> getTousLesOccuper() {

        return ResponseEntity.ok(
                occuperService.getTousLesOccuper()
        );
    }

    // READ ONE
    @GetMapping("/{codeProf}/{codeSalle}/{date}")
    public ResponseEntity<Occuper> getOccuper(
            @PathVariable String codeProf,
            @PathVariable String codeSalle,
            @PathVariable LocalDate date) {

        return ResponseEntity.ok(
                occuperService.getOccuper(
                        codeProf,
                        codeSalle,
                        date
                )
        );
    }

    // UPDATE
    @PutMapping("/{codeProf}/{codeSalle}/{date}")
    public ResponseEntity<Occuper> modifierOccuper(
            @PathVariable String codeProf,
            @PathVariable String codeSalle,
            @PathVariable LocalDate date,
            @RequestBody Occuper occuper) {

        return ResponseEntity.ok(
                occuperService.modifierOccuper(
                        codeProf,
                        codeSalle,
                        date,
                        occuper
                )
        );
    }

    // DELETE
    @DeleteMapping("/{codeProf}/{codeSalle}/{date}")
    public ResponseEntity<Void> supprimerOccuper(
            @PathVariable String codeProf,
            @PathVariable String codeSalle,
            @PathVariable LocalDate date) {

        occuperService.supprimerOccuper(
                codeProf,
                codeSalle,
                date
        );

        return ResponseEntity.noContent().build();
    }
}