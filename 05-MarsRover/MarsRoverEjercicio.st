!classDefinition: #MarsRoverTest category: 'MarsRoverEjercicio'!
TestCase subclass: #MarsRoverTest
	instanceVariableNames: 'norte sur este oeste'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverEjercicio'!

!MarsRoverTest methodsFor: 'testing' stamp: 'SF 5/14/2023 16:33:43'!
test01roverEsCreadoEnUnaPosicionYApuntandoAUnaDireccion
	
	| rover|
	rover := self crearRoverEnElOrigenApuntandoAlNorte.
	
	self assert: rover isAt: 0 @ 0 facing: norte.
	! !

!MarsRoverTest methodsFor: 'testing' stamp: 'SF 5/14/2023 16:33:49'!
test02avanzarRoverLoDesplazaUnaUnidadHaciaAdelante

	| rover|
	rover := self crearRoverEnElOrigenApuntandoAlNorte.
	rover avanzar.
	self assert: rover isAt: 0 @ 1 facing: norte.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'SF 5/14/2023 16:33:54'!
test03retrocederRoverLoDesplazaUnaUnidadHaciaAtras

	| rover|
	rover := self crearRoverEnElOrigenApuntandoAlNorte.
	rover retroceder.
	self assert: rover isAt: 0 @ -1 facing: norte.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'SF 5/14/2023 16:33:57'!
test04rotarRoverALaDerechaLoRota90GradosALaDerecha

	| rover|
	rover := self crearRoverEnElOrigenApuntandoAlNorte.
	rover rotarALaDerecha.
	self assert: rover isAt: 0 @ 0 facing: este.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'SF 5/14/2023 16:34:02'!
test05rotarRoverALaIzquierdaLoRota90GradosALaIzquierda

	| rover|
	rover := self crearRoverEnElOrigenApuntandoAlNorte.
	rover rotarALaIzquierda.
	self assert: rover isAt: 0 @ 0 facing: oeste.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'SF 5/14/2023 16:34:06'!
test06avanzarRoverMultiplesVecesLoDesplazaHaciaAdelanteMultiplesVeces

	| rover|
	rover := self crearRoverEnElOrigenApuntandoAlNorte.
	rover avanzar.
	rover avanzar.
	
	self assert: rover isAt: 0 @ 2 facing: norte.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'SF 5/14/2023 16:34:10'!
test07retrocederRoverMultiplesVecesLoDesplazaHaciaAtrasMultiplesVeces

	| rover|
	rover := self crearRoverEnElOrigenApuntandoAlNorte.
	rover retroceder.
	rover retroceder.
	
	self assert: rover isAt: 0 @ -2 facing: norte.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'SF 5/14/2023 16:34:13'!
test08rotarElRoverALaDerechaMultiplesVecesLoRota90GradosALaDerechaMultiplesVeces
	
	| rover|
	rover := self crearRoverEnElOrigenApuntandoAlNorte.
	rover rotarALaDerecha.
	rover rotarALaDerecha.
	self assert: rover isAt: 0 @ 0 facing: sur.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'SF 5/14/2023 16:34:19'!
test09rotarElRoverALaIzquierdaMultiplesVecesLoRota90GradosALaIzquierdaMultiplesVeces
	| rover|
	rover := self crearRoverEnElOrigenApuntandoAlNorte.
	
	rover rotarALaIzquierda.
	rover rotarALaIzquierda.
	self assert: rover isAt: 0 @ 0 facing: sur.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'SF 5/14/2023 16:34:23'!
test10rotarElRoverYAvanzarLoDesplazaHaciaAdelanteEnSuNuevaDireccion

	| rover|
	rover := self crearRoverEnElOrigenApuntandoAlNorte.
	rover rotarALaDerecha.
	rover avanzar.
	
	self assert: rover isAt: 1 @ 0 facing: este.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'SF 5/14/2023 16:34:26'!
test11elRoverNoHaceNadaDadaUnaListaVacia
	| rover|
	rover := self crearRoverEnElOrigenApuntandoAlNorte.
	rover ejecutarComandos: ''.
	self assert: rover isAt: 0 @ 0 facing: norte.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'SF 5/14/2023 16:34:31'!
test12elRoverEjecutaElComandoDeUnaListaDeLongitudUno
	| rover|
	rover := self crearRoverEnElOrigenApuntandoAlNorte.
	rover ejecutarComandos: 'f'.
	self assert: rover isAt: 0 @ 1 facing: norte.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'SF 5/14/2023 16:34:35'!
test13elRoverEjecutaTodosLosComandosDeUnaLista
	| rover|
	rover := self crearRoverEnElOrigenApuntandoAlNorte.
	rover ejecutarComandos: 'ffrrllbb'.
	self assert: rover isAt: 0 @ 0 facing: norte.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'SF 5/14/2023 16:34:38'!
test14comandoInvalidoAbortaLaEjecucionYLevantaUnError
	| rover|
	rover := self crearRoverEnElOrigenApuntandoAlNorte.
	self should: [rover ejecutarComandos: 'ffrrOllbb']
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = MarsRover comandoInvalidoErrorDescription ].
		
	self assert: rover isAt: 0 @ 2 facing: sur.! !


!MarsRoverTest methodsFor: 'creation' stamp: 'SF 5/14/2023 16:32:55'!
crearRoverEnElOrigenApuntandoAlNorte

	^MarsRover new at: 0 @ 0 facing: norte.

	! !


!MarsRoverTest methodsFor: 'assertions' stamp: 'SF 5/14/2023 16:30:13'!
assert: unRover isAt: unaCoordenada facing: unaDireccionCardinal
	self assert: unaCoordenada equals: unRover posicion.
	self assert: unaDireccionCardinal class equals: unRover facing class.! !


!MarsRoverTest methodsFor: 'setUp/tearDown' stamp: 'gfh 5/11/2023 21:49:01'!
setUp
	
	norte := Norte new.
	sur := Sur new.
	este := Este new.
	oeste := Oeste new.	! !


!classDefinition: #DireccionCardinal category: 'MarsRoverEjercicio'!
Object subclass: #DireccionCardinal
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverEjercicio'!

!DireccionCardinal methodsFor: 'transform' stamp: 'SF 5/14/2023 16:16:05'!
asUnitVector

	self subclassResponsibility ! !


!DireccionCardinal methodsFor: 'inspecting' stamp: 'gfh 5/11/2023 21:46:07'!
direccionALaDerecha

	self subclassResponsibility ! !

!DireccionCardinal methodsFor: 'inspecting' stamp: 'SF 5/14/2023 16:15:57'!
direccionALaIzquierda

	self subclassResponsibility ! !


!classDefinition: #Este category: 'MarsRoverEjercicio'!
DireccionCardinal subclass: #Este
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverEjercicio'!

!Este methodsFor: 'transform' stamp: 'SF 5/14/2023 16:15:03'!
asUnitVector

	^1@0! !


!Este methodsFor: 'inspecting' stamp: 'gfh 5/11/2023 21:52:26'!
direccionALaDerecha

	^Sur new.! !

!Este methodsFor: 'inspecting' stamp: 'gfh 5/11/2023 21:55:38'!
direccionALaIzquierda

	^Norte new.! !


!classDefinition: #Norte category: 'MarsRoverEjercicio'!
DireccionCardinal subclass: #Norte
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverEjercicio'!

!Norte methodsFor: 'transform' stamp: 'SF 5/14/2023 16:15:17'!
asUnitVector

	^0@1! !


!Norte methodsFor: 'inspecting' stamp: 'gfh 5/11/2023 21:52:31'!
direccionALaDerecha

	^Este new.! !

!Norte methodsFor: 'inspecting' stamp: 'gfh 5/11/2023 21:55:51'!
direccionALaIzquierda

	^Oeste new.! !


!classDefinition: #Oeste category: 'MarsRoverEjercicio'!
DireccionCardinal subclass: #Oeste
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverEjercicio'!

!Oeste methodsFor: 'transform' stamp: 'SF 5/14/2023 16:15:31'!
asUnitVector

	^-1@0! !


!Oeste methodsFor: 'inspecting' stamp: 'gfh 5/11/2023 21:52:38'!
direccionALaDerecha

	^Norte new.! !

!Oeste methodsFor: 'inspecting' stamp: 'gfh 5/11/2023 21:56:01'!
direccionALaIzquierda

	^Sur new.! !


!classDefinition: #Sur category: 'MarsRoverEjercicio'!
DireccionCardinal subclass: #Sur
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverEjercicio'!

!Sur methodsFor: 'transform' stamp: 'SF 5/14/2023 16:15:41'!
asUnitVector

	^0@-1! !


!Sur methodsFor: 'inspecting' stamp: 'gfh 5/11/2023 21:52:45'!
direccionALaDerecha

	^Oeste new.! !

!Sur methodsFor: 'inspecting' stamp: 'gfh 5/11/2023 21:56:12'!
direccionALaIzquierda

	^Este new.! !


!classDefinition: #MarsRover category: 'MarsRoverEjercicio'!
Object subclass: #MarsRover
	instanceVariableNames: 'posicion facing'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverEjercicio'!

!MarsRover methodsFor: 'accessing' stamp: 'SF 5/14/2023 16:11:52'!
facing
	^facing! !

!MarsRover methodsFor: 'accessing' stamp: 'gfh 5/11/2023 21:29:26'!
posicion

	^posicion! !


!MarsRover methodsFor: 'acciones' stamp: 'SF 5/14/2023 16:16:35'!
avanzar

	posicion := posicion + facing asUnitVector.! !

!MarsRover methodsFor: 'acciones' stamp: 'SF 5/14/2023 16:16:47'!
retroceder
	posicion := posicion - facing asUnitVector.! !

!MarsRover methodsFor: 'acciones' stamp: 'gfh 5/11/2023 21:52:05'!
rotarALaDerecha
	
	facing := facing direccionALaDerecha .! !

!MarsRover methodsFor: 'acciones' stamp: 'SF 5/14/2023 16:16:53'!
rotarALaIzquierda
	facing := facing direccionALaIzquierda.! !


!MarsRover methodsFor: 'initialization' stamp: 'gfh 5/11/2023 21:35:25'!
at: unaCoordenada facing: unaDireccionCardinal

	posicion := unaCoordenada.
	facing := unaDireccionCardinal.! !


!MarsRover methodsFor: 'auxiliar' stamp: 'SF 5/14/2023 16:04:54'!
esUnComandoValido: command
	
	^((command = $f) | (command = $b) | (command = $l) | (command = $r))! !


!MarsRover methodsFor: 'ejecucion de comandos' stamp: 'SF 5/14/2023 16:04:19'!
ejecutarComandos: listaDeComandos
	
	listaDeComandos do: [ :command |
		(self esUnComandoValido: command) ifFalse: [ self error: self class comandoInvalidoErrorDescription ].
		(command = $f) ifTrue: [ self avanzar ].
		(command = $b) ifTrue: [ self retroceder ].
		(command = $l) ifTrue: [ self rotarALaIzquierda ].
		(command = $r) ifTrue: [ self rotarALaDerecha ].
		].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRoverEjercicio'!
MarsRover class
	instanceVariableNames: ''!

!MarsRover class methodsFor: 'as yet unclassified' stamp: 'SF 5/14/2023 16:02:34'!
comandoInvalidoErrorDescription

	^'Comando inválido'! !
