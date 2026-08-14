package com.example.GestionSalleDeClasse.repository;

import com.example.GestionSalleDeClasse.model.Salle;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SalleRepository extends JpaRepository<Salle, String> {

    
}
