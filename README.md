# Ejemplo Fútbol con Springboot y MongoDB

[![Build Status](https://travis-ci.com/uqbar-project/eg-futbol-springboot-mongo.svg?branch=master)](https://travis-ci.com/uqbar-project/eg-futbol-springboot-mongo)

## Objetivo

Testea el mapeo de una [aplicación de planteles de equipos de fútbol](https://github.com/uqbar-project/eg-futbol-springboot-mongo/wiki) con MongoDB. 

## Modelo

La base de datos se estructura en un documento jerárquico:

* equipo 
 * jugadores (no tienen un documento raíz sino que están embebidos dentro del equipo)

## Instalación

Antes de correr los test, tenés que instalar una base de datos [MongoDB Community Edition](https://www.mongodb.com/) y levantar el server. En Windows, [levantan el servicio mongod](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-windows/), en Linux desde una línea de comandos hacen

```bash
$ sudo service mongod start
```

En la carpeta [scripts](scripts) vas a encontrar dos archivos:

* [Script Jugadores](scripts/Script_Jugadores.js) para ejecutarlo en el shell de MongoDB (ejecutable mongo). Este script inserta datos de varios equipos de fútbol con sus jugadores.
* [Queries Jugadores](scripts/Queries_Jugadores.js) con queries de ejemplo para probar directamente en el shell.

Acá te mostramos cómo correr los scripts con [Robo 3T](https://robomongo.org/) un cliente MongoDB con algunas prestaciones gráficas:

![video](video/demo.gif)

**Los scripts deberías ejecutarlos en la base de datos "local"**. Si elegís otra base tenés que modificar el string de conexión en la clase Xtend _RepoJugadoresMongoDB_.

Luego sí, podés correr los tests del proyecto, que verifica

* que Palermo no está en el plantel de Boca del juego de datos
* que Riquelme sí está en el plantel de Boca del juego de datos
* que hay dos jugadores que comienzan con "Casta" (Castagno de Tigre y Dino Castaño de Boca)

## Las consultas

Para saber si un jugador está en un equipo, la primera consulta que queremos resolver es qué jugadores pertenecen a un equipo. El query en MongoDB es

```js
db.equipos.find({ equipo: 'Boca' })
```

Eso nos devuelve los documentos respetando la jerarquía original:

- Equipo
  - jugadores

Como nosotros queremos que nos devuelva la lista de jugadores, utilizaremos la técnica `aggregate`:

```js
db.equipos.aggregate([ 
          { $unwind: "$jugadores" }, 
          { "$match" : { "equipo" : "Boca"}},
          { $project: { "nombre" : "$jugadores.nombre", "posicion" : "$jugadores.posicion"}}, 
          { $sort: { nombre: 1 } }
   ]);
```

Aggregate recibe como parámetro un **pipeline** o una serie de transformaciones que debemos aplicar:

- [**unwind**](https://docs.mongodb.com/manual/reference/operator/aggregation/unwind/) permite deconstruir la jerarquía equipo > jugadores, como resultado obtenemos una lista "aplanada" de jugadores
- **match** permite filtrar los elementos, en este caso seleccionando el equipo de fútbol
- **project** define la lista de atributos que vamos a mostrar, parado desde jugador podemos ir hacia arriba o abajo en nuestra jerarquía. Por ejemplo si queremos traer el nombre del equipo solo basta con agregarlo al final:

```js
db.equipos.aggregate([ 
          ...
          { $project: { "nombre" : "$jugadores.nombre", "posicion" : "$jugadores.posicion", "equipo": "$equipo" }}, 
```

Eso producirá

```js
{ 
    "_id" : ObjectId("60232692edaabd1d5dddeae0"), 
    "nombre" : "Blandi, Nicolás", 
    "posicion" : "Delantero", 
    "equipo" : "Boca"
}
```

Si queremos modificar el nombre de la columna de output debemos hacer este pequeño cambio:

```js
db.equipos.aggregate([ 
          ...
          { $project: { "nombre" : "$jugadores.nombre", "posicion" : "$jugadores.posicion", "nombre_equipo": "$equipo" }}, 
```

entonces el output será

```js
{ 
    "_id" : ObjectId("60232692edaabd1d5dddeae0"), 
    "nombre" : "Blandi, Nicolás", 
    "posicion" : "Delantero", 
    "nombre_equipo" : "Boca"
}
```

## Pasando de MongoDB a Springboot

Ahora que sabemos cómo ejecutar la consulta en Mongo, el controller llamará a una clase repositorio que implementaremos nosotros, ya que la anotación `@Query` todavía no tiene soporte completo para operaciones de agregación.

```xtend
	def jugadoresDelEquipo(String nombreEquipo) {
		val matchOperation = Aggregation.match(Criteria.where("equipo").regex(nombreEquipo, "i")) // "i" es por case insensitive
		Aggregation.newAggregation(matchOperation, unwindJugadores, projectJugadores).query
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
```

Las operaciones son bastante similares, pero **atención que el orden es importante y puede ocasionar problemas en la devolución correcta de datos**:

- primero el match que filtra por nombre de equipo sin importar mayúsculas/minúsculas (porque está en el documento raíz)
- luego el unwind para aplanar la estructura a una lista de jugadores
- por último definimos los atributos que queremos mostrar
- y luego tenemos un `extension method` para transformar el pipeline de agregación en una lista de elementos para el controller, que luego serializará a json

## Búsqueda de jugadores por nombre

## Testeo de integración
