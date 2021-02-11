package ar.edu.unsam.futbol

import java.lang.RuntimeException

class UserException extends RuntimeException {
	
	new(String message) { super(message) }
}