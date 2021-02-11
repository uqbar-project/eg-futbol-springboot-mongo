package ar.edu.unsam.futbol.controller

import ar.edu.unsam.futbol.dao.EquipoRepository
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RestController

@RestController
@CrossOrigin(origins="*")
class EquipoController {

	@Autowired
	EquipoRepository equipoRepository

	@GetMapping("/equipo/{nombreEquipo}")
	def getJugadoresDeEquipo(@PathVariable String nombreEquipo) {
		equipoRepository.jugadoresDelEquipo(nombreEquipo)
	}

	@GetMapping("/jugadores/{nombreJugador}")
	def getJugadoresPorNombre(@PathVariable String nombreJugador) {
		equipoRepository.jugadoresPorNombre(nombreJugador)
	}
}
