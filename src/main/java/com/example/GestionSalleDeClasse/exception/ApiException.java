package com.example.GestionSalleDeClasse.exception;

import org.springframework.http.HttpStatus;

/**
 * Exception métier portant son propre code HTTP, pour que le message
 * d'erreur remonte tel quel jusqu'au frontend (voir GlobalExceptionHandler).
 */
public class ApiException extends RuntimeException {

    private final HttpStatus status;

    public ApiException(HttpStatus status, String message) {
        super(message);
        this.status = status;
    }

    public HttpStatus getStatus() {
        return status;
    }
}