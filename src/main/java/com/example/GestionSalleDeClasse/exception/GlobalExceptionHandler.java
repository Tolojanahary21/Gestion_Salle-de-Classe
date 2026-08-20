package com.example.GestionSalleDeClasse.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.Map;

/**
 * Convertit toute exception métier en réponse JSON { "message": "..." },
 * avec le bon code HTTP. Par défaut, Spring Boot n'inclut PAS le champ
 * "message" dans le corps d'erreur (server.error.include-message=never),
 * donc sans ce gestionnaire le frontend ne recevait qu'un message générique.
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ApiException.class)
    public ResponseEntity<Map<String, String>> gererApiException(
            ApiException exception) {

        return ResponseEntity
                .status(exception.getStatus())
                .body(Map.of("message", exception.getMessage()));
    }

    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<Map<String, String>> gererRuntimeException(
            RuntimeException exception) {

        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(Map.of("message", exception.getMessage()));
    }
}