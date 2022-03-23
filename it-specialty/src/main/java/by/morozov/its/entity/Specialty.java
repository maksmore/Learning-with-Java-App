package by.morozov.its.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.util.List;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Table(name = "specialty")
public class Specialty {

    @Id
    private Integer id;
    private String name;

    @OneToMany
    @JoinColumn(name = "specialty_id")
    private List<Technology> technologies;
}
