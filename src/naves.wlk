class Nave{ //Clase abstracta por tener al menos un método abstracto
	var property velocidad = 0
	
	method aumentarVelocidad(aumento){
		velocidad = 300000.min(velocidad + aumento)	
	}
	
	method propulsar(){
		self.aumentarVelocidad(20000)
	}
	
	method preparar(){
		self.aumentarVelocidad(15000)
	}
	
	//Método abstracto, esto se define no poniendo cuerpo {}
	//Ya no se puede isntanciar una Nave!
	method recibirAmenaza()
	
	//Template Method, o método plantilla	
	method encontrarEnemigo(){ //A = B + C
		self.recibirAmenaza() //B
		self.propulsar() //C
	}
}

class NaveDeCarga inherits Nave{
	var property carga = 0
	const maxCarga = 100000
	const maxVelocidad = 100000

	method sobrecargada() = carga > maxCarga

	method excedidaDeVelocidad() = velocidad > maxVelocidad

	override method recibirAmenaza() {
		carga = 0
	}
}

class NaveDeResiduosRadiactivos inherits NaveDeCarga{
	var sellado = false
	
	method sellado(){
		return sellado
	}
		
	method sellarAlVacio(){
		sellado = true
		velocidad = 0
	}
	
	override method recibirAmenaza() {
		self.sellarAlVacio()
	}
	
	override method preparar(){
		self.sellarAlVacio()
		super()
	}
}

class NaveDePasajeros inherits Nave{
	var property alarma = false
	const cantidadDePasajeros = 0

	method tripulacion() = cantidadDePasajeros + 4

	method velocidadMaximaLegal() = 300000 / self.tripulacion() - if (cantidadDePasajeros > 100) 200 else 0

	method estaEnPeligro() = velocidad > self.velocidadMaximaLegal() or alarma

	override method recibirAmenaza() {
		alarma = true
	}
}

class NaveDeCombate inherits Nave{
	var property modo = reposo
	var armasDesplegadas = false
	const property mensajesEmitidos = []

	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}
	
	method armasDesplegadas(){
		return armasDesplegadas
	}
	
	method activarArmas(){
		armasDesplegadas = true
	}
	
	method ultimoMensaje() = mensajesEmitidos.last()

	method estaInvisible() = modo.invisible(self)

	override method recibirAmenaza() {
		modo.recibirAmenaza(self)
	}
	
	override method preparar(){
		super()
		modo.preparar(self)		
	}
}

object reposo {

	method invisible(nave) = nave.velocidad() < 10000

	method preparar(nave){
		nave.emitirMensaje("Saliendo en misión")
		nave.modo(ataque)
	}
	
	method recibirAmenaza(nave) {
		nave.emitirMensaje("¡RETIRADA!")
	}

}

object ataque {

	method preparar(nave){
		nave.emitirMensaje("Volviendo a la base")
	}
	
	method invisible(nave) = not nave.armasDesplegadas()

	method recibirAmenaza(nave) {
		nave.emitirMensaje("Enemigo encontrado")
		nave.activarArmas()
	}
}

