package ar.edu.unsam.futbol

import ar.edu.unsam.futbol.dao.EquipoRepository
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.data.mongo.AutoConfigureDataMongo
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.junit.jupiter.SpringExtension

import static org.junit.jupiter.api.Assertions.assertEquals
import static org.junit.jupiter.api.Assertions.assertTrue
import static org.junit.jupiter.api.Assertions.assertFalse

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.DEFINED_PORT)
@AutoConfigureDataMongo
@ExtendWith(SpringExtension)
@DisplayName("Dados varios planteles con jugadores")
class EquipoRepositoryTest {
	
	@Autowired
	EquipoRepository equipoRepository
	
	public String BOCA = "boca"
	public String PALERMO = "Palermo"
	public String RIQUELME = "Riquelme"
	
	@Test
	@DisplayName("se puede buscar un jugador en base a un equipo")
	def void testRiquelmeEsJugadorDeBoca() {
		val jugadoresBoca = equipoRepository.jugadoresDelEquipo(BOCA)
		assertTrue(jugadoresBoca.contains(RIQUELME))
	}

	@Test
	@DisplayName("un jugador que no está en un equipo no aparece en el plantel")
	def void testPalermoYaNoEsJugadorDeBoca() {
		val jugadoresBoca = equipoRepository.jugadoresDelEquipo(BOCA)
		assertFalse(jugadoresBoca.contains(PALERMO))
	}
	
	@Test
	@DisplayName("se puede navegar directamente los jugadores a pesar de estar embebidos en los planteles")
	def void testHayDosJugadoresQueComienzanConCasta() {
		val jugadores = equipoRepository.jugadoresPorNombre("Casta")
		assertEquals(2, jugadores.size)
	}
	
}