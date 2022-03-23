package by.morozov.its.global;

import by.morozov.its.exception.SpecialtyNotFoundException;
import by.morozov.its.util.ErrorMessage;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDate;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(SpecialtyNotFoundException.class)
    public ResponseEntity<ErrorMessage> specialtyExceptionHandler(SpecialtyNotFoundException e, HttpServletRequest request) {
        ErrorMessage errorMessage = new ErrorMessage();
        errorMessage.setStatus(HttpStatus.NOT_FOUND.name());
        errorMessage.setErrorMessage(e.getMessage());
        errorMessage.setDate(LocalDate.now());
        errorMessage.setPath(request.getRequestURI());

        return new ResponseEntity<>(errorMessage, HttpStatus.NOT_FOUND);
    }
}
