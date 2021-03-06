package ar.edu.unsam.futbol.controller

import ar.edu.unsam.futbol.dao.EquipoRepository
import io.swagger.annotations.ApiOperation
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
	@ApiOperation("Permite conocer un equipo de fútbol con sus jugadores. La búsqueda la hace por nombre que contenga, sin considerar mayúsculas o minúsculas. Por ejemplo, si escribimos 'lorenzo' considerará a 'San Lorenzo' si está cargado en el sistema.")
	def getJugadoresDeEquipo(@PathVariable String nombreEquipo) {
		equipoRepository.jugadoresDelEquipo(nombreEquipo)
	}

	@GetMapping("/jugadores/{nombreJugador}")
	@ApiOperation("Permite conocer todos los jugadores cuyo nombre contenga un valor de búsqueda, sin distinguir mayúsculas ni minúsculas. Si la búsqueda se hace por 'riq' puede traer jugadores como 'Riquelme' o 'Enrique'.")
	def getJugadoresPorNombre(@PathVariable String nombreJugador) {
		equipoRepository.jugadoresPorNombre(nombreJugador)
	}
}
