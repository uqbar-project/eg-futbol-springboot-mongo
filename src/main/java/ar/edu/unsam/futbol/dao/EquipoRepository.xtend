package ar.edu.unsam.futbol.dao

import ar.edu.unsam.futbol.domain.Jugador
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.data.mongodb.core.MongoTemplate
import org.springframework.data.mongodb.core.aggregation.Aggregation
import org.springframework.data.mongodb.core.aggregation.AggregationResults
import org.springframework.data.mongodb.core.query.Criteria
import org.springframework.stereotype.Service

@Service
class EquipoRepository {

	@Autowired
	MongoTemplate mongoTemplate

	def jugadoresDelEquipo(String nombreEquipo) {
		val matchOperation = Aggregation.match(Criteria.where("equipo").regex(nombreEquipo, "i"))
		Aggregation.newAggregation(matchOperation, unwindJugadores, projectJugadores).query
	}

	def jugadoresPorNombre(String nombreJugador) {
		val matchOperation = Aggregation.match(Criteria.where("jugadores.nombre").regex(nombreJugador, 'i'))
		Aggregation.newAggregation(unwindJugadores, matchOperation, projectJugadores).query
	}

	def unwindJugadores() {
		Aggregation.unwind("jugadores")
	}
	
	def projectJugadores() {
		Aggregation.project("$jugadores.nombre", "$jugadores.posicion")
	}

	// extension method para ejecutar la consulta	
	def query(Aggregation aggregation) {
		val AggregationResults<Jugador> result = mongoTemplate.aggregate(aggregation, "equipos", Jugador)
		return result.mappedResults
	}
}
