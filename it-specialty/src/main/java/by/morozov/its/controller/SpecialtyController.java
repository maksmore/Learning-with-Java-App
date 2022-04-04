package by.morozov.its.controller;

import by.morozov.its.dto.SpecialtyRequestDto;
import by.morozov.its.entity.Specialty;
import by.morozov.its.service.SpecialtyService;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("api/v1/specialty")
@AllArgsConstructor
public class SpecialtyController {

    private final SpecialtyService specialtyService;
    private static final String INFO = "It is my super mega Java application!";

    @PostMapping
    public Specialty getSpecialtyByName(@RequestBody SpecialtyRequestDto request) {
        return specialtyService.getSpecialtyByName(request.getName());
    }

    @GetMapping
    public String getInfo() {
        return INFO;
    }
}
