!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'empty books editorial'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'errors' stamp: 'SF 6/8/2023 18:05:47'!
raiseErrorIfBookIsInvalid: aBookISBN

	(editorial includes: aBookISBN) ifFalse: [
		self error: self class InvalidBookErrorMessage 
		]! !

!Cart methodsFor: 'errors' stamp: 'SF 6/6/2023 17:14:17'!
raiseErrorIfQuantityIsNotPositive: aQuantity

	(aQuantity <= 0) ifTrue: [ self error: self class NotPositiveAmountOfBooksErrorDescription ]! !


!Cart methodsFor: 'initialization' stamp: 'SF 6/8/2023 18:17:07'!
of: anEditorial

	editorial := anEditorial.
	books := Bag new.! !


!Cart methodsFor: 'accessing' stamp: 'SF 6/6/2023 16:38:16'!
isEmpty

	^ books isEmpty ! !

!Cart methodsFor: 'accessing' stamp: 'SF 6/6/2023 16:37:08'!
listBooks

	^ books! !


!Cart methodsFor: 'adding' stamp: 'SF 6/8/2023 18:16:01'!
add: aQuantity copiesOfBook: aBookISBN

	self raiseErrorIfQuantityIsNotPositive: aQuantity.
	self raiseErrorIfBookIsInvalid: aBookISBN.
	books add: aBookISBN withOccurrences: aQuantity.! !

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
!classDefinition: #CartTests category: 'TusLibros-Tests'!
TestCase subclass: #CartTests
	instanceVariableNames: 'catalog1 catalog2'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Tests'!

!CartTests methodsFor: 'tests' stamp: 'SF 6/8/2023 18:14:39'!
setUp

	catalog1 := Bag with: 1234.
	catalog2 := Bag with: 1234 with: 5678.! !

!CartTests methodsFor: 'tests' stamp: 'SF 6/8/2023 18:06:17'!
test01NewCartIsEmpty

	self assert: (Cart new of: catalog1) isEmpty! !

!CartTests methodsFor: 'tests' stamp: 'SF 6/8/2023 18:06:17'!
test02CartWithABookIsNotEmpty

	| aCart |
	
	aCart := Cart new of: catalog1.
	aCart add: 1 copiesOfBook: 1234.
	
	self deny: aCart isEmpty
	! !

!CartTests methodsFor: 'tests' stamp: 'SF 6/8/2023 18:16:11'!
test03CanListAllCartsBooks

	| aCart |
	
	aCart := Cart new of: catalog2.
	aCart add: 1 copiesOfBook: 1234.
	aCart add: 1 copiesOfBook: 5678.
	
	self assert: (Bag with: 1234 with: 5678)
		equals: aCart listBooks
	! !

!CartTests methodsFor: 'tests' stamp: 'SF 6/8/2023 18:06:17'!
test04AddingAnInvalidBookToCartThrowsInvalidBookError

	| aCart |
	
	aCart := Cart new of: catalog1.
	
	self should: [ aCart add: 1 copiesOfBook: 5678 ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cart InvalidBookErrorMessage
			]! !

!CartTests methodsFor: 'tests' stamp: 'SF 6/8/2023 18:17:21'!
test05CanAddMultipleCopiesOfTheSameBookAtOnce

	| aCart |
	
	aCart := Cart new of: catalog1.
	aCart add: 3 copiesOfBook: 1234.
	
	self assert: (Bag with: 1234 with: 1234 with: 1234)
		equals: aCart listBooks
	! !

!CartTests methodsFor: 'tests' stamp: 'SF 6/8/2023 18:06:17'!
test06AddingNegativeAmountOfBooksThrowsNegativeAmountOfBooksError

	| aCart |
	
	aCart := Cart new of: catalog1.
	
	self should: [ aCart add: 0 copiesOfBook: 1234 ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cart NotPositiveAmountOfBooksErrorDescription
			]! !
