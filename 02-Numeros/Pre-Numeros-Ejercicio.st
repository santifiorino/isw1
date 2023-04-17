!classDefinition: #NumeroTest category: 'Numero-Exercise'!
TestCase subclass: #NumeroTest
	instanceVariableNames: 'zero one two four oneFifth oneHalf five twoFifth twoTwentyfifth fiveHalfs three eight negativeOne negativeTwo negativeOneHalf'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!NumeroTest methodsFor: 'tests' stamp: 'SF 4/17/2023 19:48:22'!
setUp

	zero := Entero with: 0.
	one := Entero with: 1.
	two := Entero with: 2.
	three := Entero with: 3.
	four := Entero with: 4.
	five := Entero with: 5.
	eight := Entero with: 8.
	negativeOne := Entero with: -1.
	negativeTwo := Entero with: -2.
	
	oneHalf := Fraccion with: one over: two.
	oneFifth := Fraccion with: one over: five.
	twoFifth := Fraccion with: two over: five.
	twoTwentyfifth := Fraccion with: two over: (Entero with: 25).
	fiveHalfs := Fraccion with: five over: two.
	negativeOneHalf := Fraccion with: negativeOne over: two
	
	! !

!NumeroTest methodsFor: 'tests' stamp: 'SF 4/17/2023 19:22:34'!
test01isCeroReturnsTrueWhenAskToZero
	self assert: zero isZero! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:09:48'!
test02isCeroReturnsFalseWhenAskToOthersButZero

	self deny: one isZero! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:09:55'!
test03isOneReturnsTrueWhenAskToOne

	self assert: one isOne! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:10:04'!
test04isOneReturnsFalseWhenAskToOtherThanOne

	self deny: zero isOne! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:10:14'!
test05EnteroAddsWithEnteroCorrectly

	self assert: one + one equals: two! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:10:25'!
test06EnteroMultipliesWithEnteroCorrectly

	self assert: two * two equals: four! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:15:37'!
test07FraccionAddsWithFraccionCorrectly
"
    La suma de fracciones es:
	 
	a/b + c/d = (a.d + c.b) / (b.d)
	 
	SI ESTAN PENSANDO EN LA REDUCCION DE FRACCIONES NO SE PREOCUPEN!!
	TODAVIA NO SE ESTA TESTEANDO ESE CASO
"
	| sevenTenths |

	sevenTenths := Numero with: (Numero with: 7) over: (Numero with: 10).

	self assert: oneFifth + oneHalf equals: sevenTenths! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:11:26'!
test08FraccionMultipliesWithFraccionCorrectly
"
    La multiplicacion de fracciones es:
	 
	(a/b) * (c/d) = (a.c) / (b.d)
"

	self assert: oneFifth * twoFifth equals: twoTwentyfifth! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:16:19'!
test09AparentFraccionesAreEqual

	self assert: oneHalf equals: (Numero with: two over: four)! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:12:46'!
test10AddingFraccionesCanReturnAnEntero

	self assert: oneHalf + oneHalf equals: one! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:26:23'!
test11MultiplyingFraccionesCanReturnAnEntero

	self assert: (twoFifth) * (fiveHalfs) equals: one! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:13:21'!
test12AFraccionCanNotBeZero

	self deny: oneHalf isZero! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:13:30'!
test13AFraccionCanNotBeOne

	self deny: oneHalf isOne! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:14:16'!
test14NegationOfEnteroIsCorrect

	self assert: two negated equals: negativeTwo.! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/24/2020 02:23:47'!
test15NegationOfFraccionIsCorrect

	self assert: oneHalf negated equals: negativeOneHalf! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:29:45'!
test16SignIsCorrectlyAssignedToFractionWithTwoNegatives

	self assert: oneHalf equals: (Numero with: negativeOne over: negativeTwo)! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:30:07'!
test17SignIsCorrectlyAssignedToFractionWithNegativeDivisor

	self assert: oneHalf negated equals: (Numero with: one over: negativeTwo)! !


!classDefinition: #Numero category: 'Numero-Exercise'!
Object subclass: #Numero
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!Numero methodsFor: 'arithmetic operations' stamp: 'SF 4/17/2023 19:34:31'!
* aMultiplier 

	self subclassResponsibility 
	! !

!Numero methodsFor: 'arithmetic operations' stamp: 'SF 4/17/2023 19:36:23'!
+ anAdder 

	self subclassResponsibility ! !

!Numero methodsFor: 'arithmetic operations' stamp: 'SF 4/17/2023 19:38:00'!
// aDivisor

	self subclassResponsibility ! !

!Numero methodsFor: 'arithmetic operations' stamp: 'SF 4/17/2023 19:39:35'!
greatestCommonDivisorWith: anEntero 
	self subclassResponsibility ! !

!Numero methodsFor: 'arithmetic operations' stamp: 'SF 4/17/2023 19:40:34'!
negated

	self subclassResponsibility ! !

!Numero methodsFor: 'arithmetic operations' stamp: 'SF 4/17/2023 19:41:21'!
printOn: aStream

	self subclassResponsibility ! !


!Numero methodsFor: 'testing' stamp: 'SF 4/17/2023 19:26:37'!
isNegative
	self subclassResponsibility ! !

!Numero methodsFor: 'testing' stamp: 'SF 4/17/2023 19:28:02'!
isOne

	self subclassResponsibility ! !

!Numero methodsFor: 'testing' stamp: 'SF 4/17/2023 19:18:50'!
isZero
	self subclassResponsibility ! !


!Numero methodsFor: 'initialization' stamp: 'SF 4/17/2023 19:15:51'!
initializeWith: aValue
	
	self subclassResponsibility ! !

!Numero methodsFor: 'initialization' stamp: 'SF 4/17/2023 19:16:52'!
initializeWith: aNumerator over: aDenominator
	self subclassResponsibility ! !


!Numero methodsFor: 'accessing' stamp: 'SF 4/17/2023 19:31:58'!
denominator
	self subclassResponsibility ! !

!Numero methodsFor: 'accessing' stamp: 'SF 4/17/2023 19:32:39'!
integerValue

	self subclassResponsibility ! !

!Numero methodsFor: 'accessing' stamp: 'SF 4/17/2023 19:33:34'!
numerator

	self subclassResponsibility ! !


!Numero methodsFor: 'comparing' stamp: 'SF 4/17/2023 19:24:51'!
= anObject
	self subclassResponsibility ! !

!Numero methodsFor: 'comparing' stamp: 'SF 4/17/2023 19:31:04'!
hash

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Numero class' category: 'Numero-Exercise'!
Numero class
	instanceVariableNames: ''!

!Numero class methodsFor: 'error descriptions' stamp: 'NR 4/15/2021 16:49:48'!
canNotDivideByZeroErrorDescription

	^'No se puede dividir por cero!!!!!!'! !


!Numero class methodsFor: 'instance creation' stamp: 'NR 9/8/2019 20:46:40'!
with: aValue 
	
	"Esta verificacion esta puesta por si se equivocan y quieren crear un Entero pasando otra cosa que un Integer - Hernan"
	aValue isInteger ifFalse: [  self error: 'aValue debe ser anInteger' ].
	
	^self new initializeWith: aValue! !

!Numero class methodsFor: 'instance creation' stamp: 'NR 9/8/2019 23:20:40'!
with: aDividend over: aDivisor

	| greatestCommonDivisor numerator denominator |
	
	aDivisor isZero ifTrue: [ self error: self canNotDivideByZeroErrorDescription ].
	aDividend isZero ifTrue: [ ^aDividend ].
	
	aDivisor isNegative ifTrue: [ ^self with: aDividend negated over: aDivisor negated].
	
	greatestCommonDivisor := aDividend greatestCommonDivisorWith: aDivisor. 
	numerator := aDividend // greatestCommonDivisor.
	denominator := aDivisor // greatestCommonDivisor.
	
	denominator isOne ifTrue: [ ^numerator ].

	^self new initializeWith: numerator over: denominator! !


!classDefinition: #Entero category: 'Numero-Exercise'!
Numero subclass: #Entero
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!Entero methodsFor: 'testing' stamp: 'SF 4/17/2023 19:27:01'!
isNegative
	
	^value < 0! !

!Entero methodsFor: 'testing' stamp: 'SF 4/17/2023 19:28:20'!
isOne

	^value = 1! !

!Entero methodsFor: 'testing' stamp: 'SF 4/17/2023 19:19:07'!
isZero

	^value = 0! !


!Entero methodsFor: 'initialization' stamp: 'SF 4/17/2023 19:16:06'!
initializeWith: aValue
	
	value := aValue! !

!Entero methodsFor: 'initialization' stamp: 'SF 4/17/2023 19:18:09'!
initializeWith: aNumerator over: aDenominator

	self error: 'Este inicializador es para fracción'! !


!Entero methodsFor: 'comparing' stamp: 'SF 4/17/2023 19:25:36'!
= anObject

	^(anObject isKindOf: self class) and: [ value = anObject integerValue]! !

!Entero methodsFor: 'comparing' stamp: 'SF 4/17/2023 19:31:37'!
hash

	^value hash! !


!Entero methodsFor: 'arithmetic operations' stamp: 'SF 4/17/2023 19:49:56'!
* aMultiplier 

	(aMultiplier isKindOf: self class) ifTrue:	
		[ ^self class with: value * aMultiplier integerValue ].
		
	self error: 'Tipo de número no soportado'
	! !

!Entero methodsFor: 'arithmetic operations' stamp: 'SF 4/17/2023 19:49:27'!
+ anAdder 
	
	(anAdder isKindOf: self class) ifTrue:
		[ ^self class with: value + anAdder integerValue ].
	
	self error: 'Tipo de número no soportado'
	! !

!Entero methodsFor: 'arithmetic operations' stamp: 'SF 4/17/2023 19:38:40'!
// aDivisor 
	
	^self class with: value // aDivisor integerValue
! !

!Entero methodsFor: 'arithmetic operations' stamp: 'SF 4/17/2023 19:39:50'!
greatestCommonDivisorWith: anEntero 
	
	^self class with: (value gcd: anEntero integerValue)! !

!Entero methodsFor: 'arithmetic operations' stamp: 'SF 4/17/2023 19:40:49'!
negated
	
	^self * (self class with: -1)! !

!Entero methodsFor: 'arithmetic operations' stamp: 'SF 4/17/2023 19:41:36'!
printOn: aStream
	
	aStream print: value! !


!Entero methodsFor: 'accessing' stamp: 'SF 4/17/2023 19:32:15'!
denominator

	^self error: 'Los enteros no tienen denominador'! !

!Entero methodsFor: 'accessing' stamp: 'SF 4/17/2023 19:32:50'!
integerValue

	^value! !

!Entero methodsFor: 'accessing' stamp: 'SF 4/17/2023 19:33:51'!
numerator

	self error: 'Los enteros no tienen numerador'! !


!classDefinition: #Fraccion category: 'Numero-Exercise'!
Numero subclass: #Fraccion
	instanceVariableNames: 'numerator denominator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!Fraccion methodsFor: 'testing' stamp: 'SF 4/17/2023 19:27:23'!
isNegative
	
	^denominator < 0.! !

!Fraccion methodsFor: 'testing' stamp: 'SF 4/17/2023 19:28:36'!
isOne

	^false! !

!Fraccion methodsFor: 'testing' stamp: 'SF 4/17/2023 19:28:54'!
isZero

	^false! !


!Fraccion methodsFor: 'initialization' stamp: 'SF 4/17/2023 19:16:34'!
initializeWith: aValue
	
	self error: 'Este inicializador es para enteros'! !

!Fraccion methodsFor: 'initialization' stamp: 'SF 4/17/2023 19:18:21'!
initializeWith: aNumerator over: aDenominator

	"Estas precondiciones estan por si se comenten errores en la implementacion - Hernan"
	aNumerator isZero ifTrue: [ self error: 'una fraccion no puede ser cero' ].
	aDenominator isOne ifTrue: [ self error: 'una fraccion no puede tener denominador 1 porque sino es un entero' ].
	
	numerator := aNumerator.
	denominator := aDenominator ! !


!Fraccion methodsFor: 'comparing' stamp: 'SF 4/17/2023 19:26:00'!
= anObject

	^(anObject isKindOf: self class) and: [ (numerator * anObject denominator) = (denominator * anObject numerator) ]! !

!Fraccion methodsFor: 'comparing' stamp: 'SF 4/17/2023 19:31:20'!
hash

	^(numerator hash / denominator hash) hash! !


!Fraccion methodsFor: 'arithmetic operations' stamp: 'SF 4/17/2023 19:50:11'!
* aMultiplier 
		
	(aMultiplier isKindOf: self class) ifTrue:
		[ ^self class with: (numerator * aMultiplier numerator) over: (denominator * aMultiplier denominator) ].
		
	self error: 'Tipo de número no soportado'
	! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'SF 4/17/2023 19:50:18'!
+ anAdder 
	
	(anAdder isKindOf: self class) ifTrue:
		[ | newNumerator newDenominator |
		
		newNumerator := (numerator * anAdder denominator) + (denominator * anAdder numerator).
		newDenominator := denominator * anAdder denominator.
		
		^ self class with: newNumerator over: newDenominator ].
	
	self error: 'Tipo de número no soportado'
	! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'SF 4/17/2023 19:39:21'!
// aDivisor 
	
	^self error: 'Esta operacion es para números enteros'
! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'SF 4/17/2023 19:40:16'!
greatestCommonDivisorWith: anEntero 
		
	self error: 'Esta operacion es para números enteros'! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'SF 4/17/2023 19:41:05'!
negated
	
	^self class with: numerator * (self class with: -1) over: denominator! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'SF 4/17/2023 19:42:03'!
printOn: aStream
	
	aStream 
		print: numerator;
		nextPut: $/;
		print: denominator! !


!Fraccion methodsFor: 'accessing' stamp: 'SF 4/17/2023 19:32:23'!
denominator

	^denominator! !

!Fraccion methodsFor: 'accessing' stamp: 'SF 4/17/2023 19:33:17'!
integerValue

	self error: 'Este mensaje es para los enteros'! !

!Fraccion methodsFor: 'accessing' stamp: 'SF 4/17/2023 19:33:57'!
numerator

	^numerator! !
