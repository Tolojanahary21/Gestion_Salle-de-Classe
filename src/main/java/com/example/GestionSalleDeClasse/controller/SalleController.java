package com.example.GestionSalleDeClasse.controller;

import com.example.GestionSalleDeClasse.model.Salle;
import com.example.GestionSalleDeClasse.service.SalleService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/salles")
public class SalleController {

    private final SalleService salleService;

    public SalleController(SalleService salleService) {
        this.salleService = salleService;
    }

    // CREATE
    @PostMapping
    public ResponseEntity<Salle> creerSalle(@RequestBody Salle salle) {

        Salle nouvelleSalle = salleService.creerSalle(salle);

        return new ResponseEntity<>(
                nouvelleSalle,
                HttpStatus.CREATED
        );
    }

    // READ - toutes les salles
    @GetMapping
    public ResponseEntity<List<Salle>> getAllSalles() {

        return ResponseEntity.ok(
                salleService.getAllSalles()
        );
    }

    // READ - une salle
    @GetMapping("/{codeSalle}")
    public ResponseEntity<Salle> getSalle(
            @PathVariable String codeSalle) {

        return salleService.getSalleByCode(codeSalle)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // UPDATE
    @PutMapping("/{codeSalle}")
    public ResponseEntity<Salle> modifierSalle(
            @PathVariable String codeSalle,
            @RequestBody Salle salle) {

        Salle salleModifiee =
                salleService.modifierSalle(codeSalle, salle);

        if (salleModifiee == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(salleModifiee);
    }

    // DELETE
    @DeleteMapping("/{codeSalle}")
    public ResponseEntity<Void> supprimerSalle(
            @PathVariable String codeSalle) {

        boolean supprime =
                salleService.supprimerSalle(codeSalle);

        if (!supprime) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.noContent().build();
    }
}