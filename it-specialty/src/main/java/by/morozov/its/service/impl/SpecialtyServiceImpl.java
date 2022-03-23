package by.morozov.its.service.impl;

import by.morozov.its.entity.Specialty;
import by.morozov.its.exception.SpecialtyNotFoundException;
import by.morozov.its.repository.SpecialtyRepository;
import by.morozov.its.service.SpecialtyService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class SpecialtyServiceImpl implements SpecialtyService {

    private final SpecialtyRepository specialtyRepository;

    @Override
    public Specialty getSpecialtyByName(String name) {
        return specialtyRepository.findByName(name)
                .orElseThrow(() -> new SpecialtyNotFoundException("no specialty found"));
    }
}
