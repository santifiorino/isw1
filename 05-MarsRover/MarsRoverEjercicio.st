!classDefinition: #MarsRoverTest category: 'MarsRoverEjercicio'!
TestCase subclass: #MarsRoverTest
	instanceVariableNames: 'norte sur este oeste'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverEjercicio'!

!MarsRoverTest methodsFor: 'setUp/tearDown' stamp: 'JPL 5/15/2023 13:54:21'!
setUp
	
	norte := Norte new.
	sur := Sur new.
	este := Este new.
	oeste := Oeste new.	! !


!MarsRoverTest methodsFor: 'assertions' stamp: 'JPL 5/15/2023 13:51:29'!
assert: unRover isAt: unaCoordenada facing: unaDireccionCardinal
	
	self assert: unaCoordenada equals: unRover posicion.
	self assert: unaDireccionCardinal class equals: unRover orientacion class.! !

!MarsRoverTest methodsFor: 'assertions' stamp: 'JPL 5/15/2023 14:11:38'!
assertThat: aClosureToRun failsWithErrorDescription: anErrorDescription

	self should: aClosureToRun
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = anErrorDescription ].
! !


!MarsRoverTest methodsFor: 'creation' stamp: 'JPL 5/15/2023 14:19:00'!
crearRoverEnOrigenApuntandoAlNorte

	^MarsRover new at: 0@0 facing: norte.
	
	! !


!MarsRoverTest methodsFor: 'testing' stamp: 'JPL 5/15/2023 13:54:49'!
test01roverEsCreadoEnUnaPosicionYApuntandoAUnaDireccion

	|rover|
	
	rover := self crearRoverEnOrigenApuntandoAlNorte .

	self assert: rover isAt: 0@0 facing: norte.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'JPL 5/15/2023 13:54:53'!
test02avanzarRoverLoDesplazaUnaUnidadHaciaAdelante

	
	|rover|
	
	rover := self crearRoverEnOrigenApuntandoAlNorte .
	
	rover avanzar.
	
	self assert: rover isAt: 0@1 facing: norte.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'JPL 5/15/2023 13:55:00'!
test03retrocederRoverLoDesplazaUnaUnidadHaciaAtras

	
	|rover|
	
	rover := self crearRoverEnOrigenApuntandoAlNorte .
	
	rover retroceder.
	
	self assert: rover isAt: 0@-1 facing: norte.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'JPL 5/15/2023 13:55:03'!
test04rotarRoverALaDerechaLoRota90GradosALaDerecha

	
	|rover|
	
	rover := self crearRoverEnOrigenApuntandoAlNorte .
	
	rover rotarALaDerecha.
	
	self assert: rover isAt: 0@0 facing: este.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'JPL 5/15/2023 13:55:06'!
test05rotarRoverALaIzquierdaLoRota90GradosALaDerecha

	
	|rover|
	
	rover := self crearRoverEnOrigenApuntandoAlNorte .
	
	rover rotarALaIzquierda.
	
	self assert: rover isAt: 0@0 facing: oeste.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'JPL 5/15/2023 14:21:58'!
test06avanzarRoverNVecesLoDesplazaHaciaAdelanteNVeces
	
	|rover|
	
	rover := self crearRoverEnOrigenApuntandoAlNorte .
	
	2 timesRepeat: [rover avanzar].
	
	self assert: rover isAt: 0@2 facing: norte.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'JPL 5/15/2023 14:22:08'!
test07retrocederRoverNVecesLoDesplazaHaciaAtrasNVeces

	| rover|
	rover := self crearRoverEnOrigenApuntandoAlNorte .
	
	2 timesRepeat: [rover retroceder].
	
	self assert: rover isAt: 0 @ -2 facing: norte.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'JPL 5/15/2023 14:22:19'!
test08rotarElRoverALaDerechaNVecesLoRota90GradosALaDerechaNVeces
	
	| rover|
	rover := self crearRoverEnOrigenApuntandoAlNorte .
	
	2 timesRepeat: [rover rotarALaDerecha].
	
	self assert: rover isAt: 0 @ 0 facing: sur.
	
	! !

!MarsRoverTest methodsFor: 'testing' stamp: 'JPL 5/15/2023 14:22:31'!
test09rotarElRoverALaIzquierdaNVecesLoRota90GradosALaIzquierdaNVeces

	| rover|
	
	rover := self crearRoverEnOrigenApuntandoAlNorte .
	
	2 timesRepeat: [rover rotarALaIzquierda].
	
	self assert: rover isAt: 0 @ 0 facing: sur.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'JPL 5/15/2023 13:56:16'!
test10rotarElRoverYAvanzarLoDesplazaHaciaAdelanteEnSuNuevaDireccion

	| rover|
	
	rover := self crearRoverEnOrigenApuntandoAlNorte .
	
	rover rotarALaDerecha.
	
	rover avanzar.
	
	self assert: rover isAt: 1 @ 0 facing: este.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'JPL 5/15/2023 14:22:49'!
test11elRoverNoHaceNadaDadaUnaListaDeComandosVacia
	| rover|
	
	rover := self crearRoverEnOrigenApuntandoAlNorte .
	
	rover ejecutarComandos: ''.
	
	self assert: rover isAt: 0 @ 0 facing: norte.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'JPL 5/15/2023 14:05:59'!
test12elRoverEjecutaElComandoDeUnaListaDeLongitudUno
	| rover|
	rover := self crearRoverEnOrigenApuntandoAlNorte .
	
	rover ejecutarComandos: 'f'.
	
	self assert: rover isAt: 0 @ 1 facing: norte.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'JPL 5/15/2023 14:07:42'!
test13elRoverEjecutaTodosLosComandosDeUnaLista
	| rover|
	
	rover := self crearRoverEnOrigenApuntandoAlNorte .
	
	rover ejecutarComandos: 'ffrr'.
	
	self assert: rover isAt: 0 @ 2 facing: sur.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'JPL 5/15/2023 14:12:36'!
test14comandoInvalidoAbortaLaEjecucionYLevantaUnError
	| rover|
	
	rover := self crearRoverEnOrigenApuntandoAlNorte .
		
	self assertThat: [rover ejecutarComandos: 'ffrrEXPLOTAllbb'.] failsWithErrorDescription: MarsRover comandoInvalidoErrorDescription.
		
	self assert: rover isAt: 0 @ 2 facing: sur.! !


!classDefinition: #DireccionCardinal category: 'MarsRoverEjercicio'!
Object subclass: #DireccionCardinal
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverEjercicio'!

!DireccionCardinal methodsFor: 'translating' stamp: 'JPL 5/15/2023 13:56:48'!
asUnitVector
	self subclassResponsibility ! !


!DireccionCardinal methodsFor: 'inspecting' stamp: 'JPL 5/15/2023 13:46:46'!
direccionALaDerecha
	self subclassResponsibility ! !

!DireccionCardinal methodsFor: 'inspecting' stamp: 'JPL 5/15/2023 13:46:52'!
direccionALaIzquierda
	self subclassResponsibility ! !


!classDefinition: #Este category: 'MarsRoverEjercicio'!
DireccionCardinal subclass: #Este
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverEjercicio'!

!Este methodsFor: 'translating' stamp: 'JPL 5/15/2023 13:58:41'!
asUnitVector
	^ 1@0! !


!Este methodsFor: 'inspecting' stamp: 'JPL 5/15/2023 13:47:44'!
direccionALaDerecha
	^Sur new! !

!Este methodsFor: 'inspecting' stamp: 'JPL 5/15/2023 13:47:55'!
direccionALaIzquierda
	^Norte new! !


!classDefinition: #Norte category: 'MarsRoverEjercicio'!
DireccionCardinal subclass: #Norte
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverEjercicio'!

!Norte methodsFor: 'translating' stamp: 'JPL 5/15/2023 13:58:58'!
asUnitVector
	^ 0@1! !


!Norte methodsFor: 'inspecting' stamp: 'JPL 5/15/2023 13:48:11'!
direccionALaDerecha
	^Este new! !

!Norte methodsFor: 'inspecting' stamp: 'JPL 5/15/2023 13:48:06'!
direccionALaIzquierda
	^Oeste new! !


!classDefinition: #Oeste category: 'MarsRoverEjercicio'!
DireccionCardinal subclass: #Oeste
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverEjercicio'!

!Oeste methodsFor: 'translating' stamp: 'JPL 5/15/2023 13:59:38'!
asUnitVector
	^ -1@0! !


!Oeste methodsFor: 'inspecting' stamp: 'JPL 5/15/2023 13:48:30'!
direccionALaDerecha
	^Norte new! !

!Oeste methodsFor: 'inspecting' stamp: 'JPL 5/15/2023 13:48:25'!
direccionALaIzquierda
	^Sur new! !


!classDefinition: #Sur category: 'MarsRoverEjercicio'!
DireccionCardinal subclass: #Sur
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverEjercicio'!

!Sur methodsFor: 'translating' stamp: 'JPL 5/15/2023 13:59:50'!
asUnitVector
	^ 0@-1! !


!Sur methodsFor: 'inspecting' stamp: 'JPL 5/15/2023 13:48:48'!
direccionALaDerecha
	^Oeste new! !

!Sur methodsFor: 'inspecting' stamp: 'JPL 5/15/2023 13:48:40'!
direccionALaIzquierda
	^Este new! !


!classDefinition: #MarsRover category: 'MarsRoverEjercicio'!
Object subclass: #MarsRover
	instanceVariableNames: 'posicion orientacion'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverEjercicio'!

!MarsRover methodsFor: 'auxiliary' stamp: 'JPL 5/15/2023 14:08:16'!
esUnComandoValido: command
	
	^((command = $f) | (command = $b) | (command = $l) | (command = $r))! !


!MarsRover methodsFor: 'initialization' stamp: 'JPL 5/15/2023 14:18:47'!
at: unaCoordenada facing: unaDireccionCardinal

	posicion := unaCoordenada .
	orientacion := unaDireccionCardinal .! !


!MarsRover methodsFor: 'modifying' stamp: 'JPL 5/15/2023 14:00:29'!
avanzar

	posicion := posicion + orientacion asUnitVector .! !

!MarsRover methodsFor: 'modifying' stamp: 'JPL 5/15/2023 14:11:14'!
ejecutarComandos: listaDeComandos
	
	listaDeComandos do: [ :command |
		
		(self esUnComandoValido: command) ifFalse: [ self error: self class comandoInvalidoErrorDescription ].
		
		(command = $f) ifTrue: [ self avanzar ].
		
		(command = $b) ifTrue: [ self retroceder ].
		
		(command = $l) ifTrue: [ self rotarALaIzquierda ].
		
		(command = $r) ifTrue: [ self rotarALaDerecha ].
		
		].! !

!MarsRover methodsFor: 'modifying' stamp: 'JPL 5/15/2023 14:01:12'!
retroceder

	posicion := posicion - orientacion asUnitVector .! !

!MarsRover methodsFor: 'modifying' stamp: 'JPL 5/15/2023 13:49:30'!
rotarALaDerecha

	orientacion := orientacion direccionALaDerecha .
	! !

!MarsRover methodsFor: 'modifying' stamp: 'JPL 5/15/2023 13:49:41'!
rotarALaIzquierda

	orientacion := orientacion direccionALaIzquierda .! !


!MarsRover methodsFor: 'inspecting' stamp: 'JPL 5/15/2023 13:24:29'!
orientacion
	^orientacion! !

!MarsRover methodsFor: 'inspecting' stamp: 'JPL 5/15/2023 13:24:19'!
posicion
	^posicion! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRoverEjercicio'!
MarsRover class
	instanceVariableNames: ''!

!MarsRover class methodsFor: 'error descriptions' stamp: 'JPL 5/15/2023 14:09:21'!
comandoInvalidoErrorDescription
	^'Comando inválido'! !
