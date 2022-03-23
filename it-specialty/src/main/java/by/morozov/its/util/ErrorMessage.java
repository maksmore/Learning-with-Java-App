package by.morozov.its.util;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class ErrorMessage {

    private String status;
    private String errorMessage;
    private LocalDate date;
    private String path;
}
