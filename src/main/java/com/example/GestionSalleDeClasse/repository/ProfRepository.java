package com.example.GestionSalleDeClasse.repository;

import com.example.GestionSalleDeClasse.model.Prof;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProfRepository extends JpaRepository<Prof, String> {
}