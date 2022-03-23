package by.morozov.its.repository;

import by.morozov.its.entity.Specialty;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface SpecialtyRepository extends JpaRepository<Specialty, Integer> {

    Optional<Specialty> findByName(String name);
}
