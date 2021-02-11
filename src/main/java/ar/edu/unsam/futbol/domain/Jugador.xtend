package ar.edu.unsam.futbol.domain

import java.io.Serializable
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
// No se anota con @Document
class Jugador implements Serializable {
	
	String nombre
	String posicion
	
	new() {
		
	}
	
	new(String nombre, String posicion) {
		this.nombre = nombre
		this.posicion = posicion
	}

	override toString() {
		nombre
	}	
	
	override equals(Object otro) {
		try {
			return nombre.equals((otro as Jugador).nombre)
		} catch (ClassCastException e) {
			return false
		}
	}
	
	override hashCode() {
		nombre.hashCode
	}
	
}
