package ar.edu.unsam.futbol.domain

import java.io.Serializable
import java.util.List
import org.bson.types.ObjectId
import org.eclipse.xtend.lib.annotations.Accessors
import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.mapping.Document
import org.springframework.data.mongodb.core.mapping.Field

@Accessors
@Document(collection = "equipos")
class Equipo implements Serializable {
	
	@Id ObjectId id
	
	@Field("equipo")
	String nombre = ""
	
	// Se puede anotar con @Reference pero Morphia se da cuenta
	List<Jugador> jugadores = newArrayList
	
}