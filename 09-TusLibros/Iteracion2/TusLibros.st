!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:08'!
test01NewCartsAreCreatedEmpty

	self assert: self createCart isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:45'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := self createCart.
	
	self 
		should: [ cart add: self itemNotSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore.
	self deny: cart isEmpty ! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := self createCart.
	
	self 
		should: [cart add: 0 of: self itemSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:45'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := self createCart.
	
	self 
		should: [cart add: 2 of: self itemNotSellByTheStore  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test06CartRemembersAddedItems

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore.
	self assert: (cart includes: self itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := self createCart.
	
	self deny: (cart includes: self itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:45'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := self createCart.
	
	cart add: 2 of: self itemSellByTheStore.
	self assert: (cart occurrencesOf: self itemSellByTheStore) = 2! !


!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:48'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:43'!
defaultCatalog
	
	^ Array with: self itemSellByTheStore! !

!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:44'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:43'!
itemSellByTheStore
	
	^ 'validBook'! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'cashier cartTest'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'as yet unclassified' stamp: 'dsf 6/8/2023 20:29:36'!
aCardWithInvalidNumber

	^ 1 @ (December, 2023)! !

!CashierTest methodsFor: 'as yet unclassified' stamp: 'dsf 6/8/2023 19:55:53'!
aValidCard

	^ (1234123412341234 @ (December, 2023))! !

!CashierTest methodsFor: 'as yet unclassified' stamp: 'dsf 6/8/2023 20:13:17'!
anExpiredCard

	^ (1234123412341234 @ (April, 2000))! !

!CashierTest methodsFor: 'as yet unclassified' stamp: 'dsf 6/8/2023 20:23:13'!
test01checkoutOfEmptyCartRaisesInvalidCartError

	| aCart |

	aCart := cartTest createCart.

	self 
		should: [ cashier checkout: aCart with: self aValidCard ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = cashier InvalidCartErrorMessage.
			self assert: aCart isEmpty ].! !

!CashierTest methodsFor: 'as yet unclassified' stamp: 'dsf 6/8/2023 20:23:30'!
test02checkoutOfCartWithABookReturnsATicket

	| aCart |
	
	aCart := cartTest createCart.
	aCart add: cartTest itemSellByTheStore.
	
	self assert: (cashier checkout: aCart with: self aValidCard)
		 equals: #Ticket! !

!CashierTest methodsFor: 'as yet unclassified' stamp: 'dsf 6/8/2023 20:23:38'!
test03checkoutOfCartWithABookEmptiesCart

	| aCart |
	
	aCart := cartTest createCart.
	aCart add: cartTest itemSellByTheStore.
	
	cashier checkout: aCart with: self aValidCard.
	
	self assert: aCart isEmpty! !

!CashierTest methodsFor: 'as yet unclassified' stamp: 'dsf 6/8/2023 20:23:44'!
test04checkoutWithExpiredCardRaisesInvalidCardError

	| aCart |

	aCart := cartTest createCart.
	aCart add: cartTest itemSellByTheStore.

	self 
		should: [ cashier checkout: aCart with: self anExpiredCard ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = cashier InvalidCardErrorMessage.
			self deny: aCart isEmpty ].! !

!CashierTest methodsFor: 'as yet unclassified' stamp: 'dsf 6/8/2023 20:29:03'!
test05checkoutWithCardNumberWithInvalidFormatRaisesInvalidCardError

	| aCart |

	aCart := cartTest createCart.
	aCart add: cartTest itemSellByTheStore.

	self 
		should: [ cashier checkout: aCart with: self aCardWithInvalidNumber ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = cashier InvalidCardErrorMessage.
			self deny: aCart isEmpty ].! !


!CashierTest methodsFor: 'setUp/tearDown' stamp: 'dsf 6/8/2023 20:23:04'!
setUp

	cartTest := CartTest new.
	cashier := Cashier new.! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'catalog items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidItemErrorMessage
	
	^'Item is not in catalog'! !

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidQuantityErrorMessage
	
	^'Invalid number of items'! !


!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidItem: anItem

	(catalog includes: anItem) ifFalse: [ self error: self invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 17:48'!
initializeAcceptingItemsOf: aCatalog

	catalog := aCatalog.
	items := OrderedCollection new.! !


!Cart methodsFor: 'queries' stamp: 'HernanWilkinson 6/17/2013 17:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !


!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:44'!
add: anItem

	^ self add: 1 of: anItem ! !

!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:51'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	1 to: aQuantity do: [ :aNumber | items add: anItem ]! !


!Cart methodsFor: 'as yet unclassified' stamp: 'dsf 6/8/2023 20:07:20'!
dumpItems

	items := OrderedCollection new.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'as yet unclassified' stamp: 'dsf 6/8/2023 20:14:45'!
InvalidCardErrorMessage

	^ 'Tarjeta inválida'

	! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'dsf 6/8/2023 19:53:12'!
InvalidCartErrorMessage

	^ 'Carrito inválido'

	! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'dsf 6/8/2023 20:34:57'!
checkout: aCart with: aCardToPayWith

	self raiseErrorIfCartIsEmpty: aCart.
	self raiseErrorIfCardIsExpired: aCardToPayWith.
	self raiseErrorIfCardNumberIsIvalid: aCardToPayWith x.
	aCart dumpItems.
	^ #Ticket

	! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'dsf 6/8/2023 20:31:12'!
has16Digits: aNumber

	^ ((aNumber log: 10) floor + 1) = 16! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'dsf 6/8/2023 20:16:42'!
raiseErrorIfCardIsExpired: aCardToPayWith.
	
	((aCardToPayWith y) < (GregorianMonthOfYear current)) ifTrue: [
		self error: self InvalidCardErrorMessage 
		]

	! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'dsf 6/8/2023 20:35:07'!
raiseErrorIfCardNumberIsIvalid: aCardToPayWith.
	
	(self has16Digits: aCardToPayWith) ifFalse: [
		self error: self InvalidCardErrorMessage
		]

	! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'dsf 6/8/2023 20:03:07'!
raiseErrorIfCartIsEmpty: aCart
	
	(aCart isEmpty) ifTrue: [
		self error: self InvalidCartErrorMessage
		]

	! !