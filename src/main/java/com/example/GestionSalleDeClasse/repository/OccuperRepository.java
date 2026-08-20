package com.example.GestionSalleDeClasse.repository;

import com.example.GestionSalleDeClasse.model.Occuper;
import com.example.GestionSalleDeClasse.model.OccuperId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;

@Repository
public interface OccuperRepository extends JpaRepository<Occuper, OccuperId> {
    boolean existsByCodeSalleAndDate(String codeSalle, LocalDate date);
}