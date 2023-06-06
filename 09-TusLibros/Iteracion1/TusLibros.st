!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'empty books editorial'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'as yet unclassified' stamp: 'SF 6/6/2023 17:15:24'!
add: aQuantity copiesOfBook: aBookISBN

	self raiseErrorIfQuantityIsNotPositive: aQuantity.
	aQuantity timesRepeat: [ self addBook: aBookISBN ].! !

!Cart methodsFor: 'as yet unclassified' stamp: 'SF 6/6/2023 16:56:30'!
addBook: aBookISBN

	self raiseErrorIfBookIsInvalid: aBookISBN.
	books add: aBookISBN.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'SF 6/6/2023 16:38:16'!
isEmpty

	^ books isEmpty ! !

!Cart methodsFor: 'as yet unclassified' stamp: 'SF 6/6/2023 16:37:08'!
listBooks

	^ books! !

!Cart methodsFor: 'as yet unclassified' stamp: 'SF 6/6/2023 16:51:40'!
of: anEditorial

	editorial := anEditorial.
	books := OrderedCollection new.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'SF 6/6/2023 17:17:18'!
raiseErrorIfBookIsInvalid: aBookISBN

	(editorial hasRegistered: aBookISBN) ifFalse: [
		self error: self class InvalidBookErrorMessage 
		]! !

!Cart methodsFor: 'as yet unclassified' stamp: 'SF 6/6/2023 17:14:17'!
raiseErrorIfQuantityIsNotPositive: aQuantity

	(aQuantity <= 0) ifTrue: [ self error: self class NotPositiveAmountOfBooksErrorDescription ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'as yet unclassified' stamp: 'SF 6/6/2023 16:53:40'!
InvalidBookErrorMessage

	^ 'Tried to add an invalid book'! !

!Cart class methodsFor: 'as yet unclassified' stamp: 'SF 6/6/2023 17:14:38'!
NotPositiveAmountOfBooksErrorDescription

	^ 'Tried to add a not positive amount of books'! !


!classDefinition: #Editorial category: 'TusLibros'!
Object subclass: #Editorial
	instanceVariableNames: 'books'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Editorial methodsFor: 'as yet unclassified' stamp: 'SF 6/6/2023 17:01:26'!
hasRegistered: aBookISBN

	^ books includes: aBookISBN.! !

!Editorial methodsFor: 'as yet unclassified' stamp: 'SF 6/6/2023 16:50:08'!
initialize

	books := OrderedCollection new! !

!Editorial methodsFor: 'as yet unclassified' stamp: 'SF 6/6/2023 16:51:01'!
registerBook: aBookISBN

	books add: aBookISBN.! !
!classDefinition: #CartTests category: 'TusLibros-Tests'!
TestCase subclass: #CartTests
	instanceVariableNames: 'editorial1 editorial2'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Tests'!

!CartTests methodsFor: 'tests' stamp: 'SF 6/6/2023 17:02:17'!
setUp

	editorial1 := Editorial new initialize.
	editorial1 registerBook: 1234.
	editorial2 := Editorial new initialize.
	editorial2 registerBook: 1234.
	editorial2 registerBook: 5678.! !

!CartTests methodsFor: 'tests' stamp: 'SF 6/6/2023 16:59:34'!
test01NewCartIsEmpty

	self assert: (Cart new of: editorial1) isEmpty! !

!CartTests methodsFor: 'tests' stamp: 'SF 6/6/2023 17:09:03'!
test02CartWithABookIsNotEmpty

	| aCart |
	
	aCart := Cart new of: editorial1.
	aCart add: 1 copiesOfBook: 1234.
	
	self deny: aCart isEmpty
	! !

!CartTests methodsFor: 'tests' stamp: 'SF 6/6/2023 17:09:25'!
test03CanListAllCartsBooks

	| aCart |
	
	aCart := Cart new of: editorial2.
	aCart add: 1 copiesOfBook: 1234.
	aCart add: 1 copiesOfBook: 5678.
	
	self assert: (OrderedCollection with: 1234 with: 5678)
		equals: aCart listBooks
	! !

!CartTests methodsFor: 'tests' stamp: 'SF 6/6/2023 17:09:43'!
test04AddingAnInvalidBookToCartThrowsInvalidBookError

	| aCart |
	
	aCart := Cart new of: editorial1.
	
	self should: [ aCart add: 1 copiesOfBook: 5678 ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cart InvalidBookErrorMessage
			]! !

!CartTests methodsFor: 'tests' stamp: 'SF 6/6/2023 17:07:47'!
test05CanAddMultipleCopiesOfTheSameBookAtOnce

	| aCart |
	
	aCart := Cart new of: editorial1.
	aCart add: 3 copiesOfBook: 1234.
	
	self assert: (OrderedCollection with: 1234 with: 1234 with: 1234)
		equals: aCart listBooks
	! !

!CartTests methodsFor: 'tests' stamp: 'SF 6/6/2023 17:15:03'!
test06AddingNegativeAmountOfBooksThrowsNegativeAmountOfBooksError

	| aCart |
	
	aCart := Cart new of: editorial1.
	
	self should: [ aCart add: 0 copiesOfBook: 1234 ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cart NotPositiveAmountOfBooksErrorDescription
			]! !
