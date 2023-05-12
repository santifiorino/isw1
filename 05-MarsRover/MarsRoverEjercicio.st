!classDefinition: #MarsRoverTest category: 'MarsRoverEjercicio'!
TestCase subclass: #MarsRoverTest
	instanceVariableNames: 'norte sur este oeste'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverEjercicio'!

!MarsRoverTest methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:53:23'!
assert: unRover isAt: unaCoordenada facing: unaDireccionCardinal

	self assert: unaCoordenada equals: unRover posicion.
	self assert: unaDireccionCardinal class equals: unRover facing class.! !

!MarsRoverTest methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:49:01'!
setUp
	
	norte := Norte new.
	sur := Sur new.
	este := Este new.
	oeste := Oeste new.	! !

!MarsRoverTest methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:50:05'!
test01
	
	| rover|
	rover := MarsRover new at: 0 @ 0 facing: norte.
	self assert: rover isAt: 0 @ 0 facing: norte.
	! !

!MarsRoverTest methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:51:16'!
test02
	
	| rover|
	rover := MarsRover new at: 0 @ 0 facing: norte.
	rover avanzar.
	self assert: rover isAt: 0 @ 1 facing: norte.! !

!MarsRoverTest methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:51:26'!
test03
	
	| rover|
	rover := MarsRover new at: 0 @ 0 facing: norte.
	rover avanzar.
	rover avanzar.
	self assert: rover isAt: 0 @ 2 facing: norte.! !

!MarsRoverTest methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:51:37'!
test04
	
	| rover|
	rover := MarsRover new at: 0 @ 0 facing: norte.
	rover rotarALaDerecha.
	self assert: rover isAt: 0 @ 0 facing: este.! !

!MarsRoverTest methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:53:38'!
test05
	
	| rover|
	rover := MarsRover new at: 0 @ 0 facing: norte.
	rover rotarALaDerecha.
	rover rotarALaDerecha.
	self assert: rover isAt: 0 @ 0 facing: sur.! !

!MarsRoverTest methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:53:47'!
test06
	
	| rover|
	rover := MarsRover new at: 0 @ 0 facing: norte.
	rover rotarALaDerecha.
	rover rotarALaDerecha.
	rover rotarALaDerecha.
	self assert: rover isAt: 0 @ 0 facing: oeste.! !

!MarsRoverTest methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:57:54'!
test07
	
	| rover|
	rover := MarsRover new at: 0 @ 0 facing: norte.
	rover rotarALaDerecha.
	rover rotarALaDerecha.
	rover rotarALaDerecha.
	rover rotarALaDerecha 
	self assert: rover isAt: 0 @ 0 facing: norte.! !

!MarsRoverTest methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:57:41'!
test08
	
	| rover|
	rover := MarsRover new at: 0 @ 0 facing: norte.
	rover rotarALaIzquierda.
	self assert: rover isAt: 0 @ 0 facing: oeste.! !


!classDefinition: #DireccionCardinal category: 'MarsRoverEjercicio'!
Object subclass: #DireccionCardinal
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverEjercicio'!

!DireccionCardinal methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:46:07'!
direccionALaDerecha

	self subclassResponsibility ! !


!classDefinition: #Este category: 'MarsRoverEjercicio'!
DireccionCardinal subclass: #Este
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverEjercicio'!

!Este methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:52:26'!
direccionALaDerecha

	^Sur new.! !

!Este methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:55:38'!
direccionALaIzquierda

	^Norte new.! !


!classDefinition: #Norte category: 'MarsRoverEjercicio'!
DireccionCardinal subclass: #Norte
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverEjercicio'!

!Norte methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:52:31'!
direccionALaDerecha

	^Este new.! !

!Norte methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:55:51'!
direccionALaIzquierda

	^Oeste new.! !


!classDefinition: #Oeste category: 'MarsRoverEjercicio'!
DireccionCardinal subclass: #Oeste
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverEjercicio'!

!Oeste methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:52:38'!
direccionALaDerecha

	^Norte new.! !

!Oeste methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:56:01'!
direccionALaIzquierda

	^Sur new.! !


!classDefinition: #Sur category: 'MarsRoverEjercicio'!
DireccionCardinal subclass: #Sur
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverEjercicio'!

!Sur methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:52:45'!
direccionALaDerecha

	^Oeste new.! !

!Sur methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:56:12'!
direccionALaIzquierda

	^Este new.! !


!classDefinition: #MarsRover category: 'MarsRoverEjercicio'!
Object subclass: #MarsRover
	instanceVariableNames: 'posicion facing'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverEjercicio'!

!MarsRover methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:35:25'!
at: unaCoordenada facing: unaDireccionCardinal

	posicion := unaCoordenada.
	facing := unaDireccionCardinal.! !

!MarsRover methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:39:39'!
avanzar

	posicion := posicion + (0 @ 1).! !

!MarsRover methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:41:57'!
facing

	^facing! !

!MarsRover methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:29:26'!
posicion

	^posicion! !

!MarsRover methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:52:05'!
rotarALaDerecha
	
	facing := facing direccionALaDerecha .! !

!MarsRover methodsFor: 'as yet unclassified' stamp: 'gfh 5/11/2023 21:55:22'!
rotarALaIzquierda
	
	facing := facing direccionALaIzquierda.! !
