!classDefinition: #Card category: 'TusLibros'!
TestCase subclass: #Card
	instanceVariableNames: 'name number expirationDate balance'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Card methodsFor: 'validation' stamp: 'SF 6/11/2023 15:50:59'!
canAfford: anAmountToPay

	^ (balance >= anAmountToPay)! !

!Card methodsFor: 'validation' stamp: 'SF 6/11/2023 15:12:20'!
has16Digits

	^ ((number log: 10) floor + 1) = 16! !

!Card methodsFor: 'validation' stamp: 'SF 6/11/2023 15:11:33'!
isExpired
	
	^(expirationDate < (GregorianMonthOfYear current))
! !


!Card methodsFor: 'initialization' stamp: 'SF 6/11/2023 15:46:13'!
withName: anOwnersName andNumber: aCreditCardNumber andExpirationDate: anExpirationMonthofYear andBalance: aBalance

	name := anOwnersName.
	number := aCreditCardNumber.
	expirationDate := anExpirationMonthofYear.
	balance := aBalance.! !


!Card methodsFor: 'modifying' stamp: 'sf 6/11/2023 16:31:30'!
substractBalanceBy: anAmountToPay

	balance := balance - anAmountToPay! !


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

!CartTest methodsFor: 'support' stamp: 'SF 6/11/2023 16:01:12'!
defaultCatalog
	
	^Dictionary newFromPairs: {'ISBN1' . 100 . 'ISBN2' . 200 . 'ISBN3' . 300}.! !

!CartTest methodsFor: 'support' stamp: 'SF 6/11/2023 16:04:34'!
itemNotSellByTheStore

	^'invalidBook'! !

!CartTest methodsFor: 'support' stamp: 'SF 6/11/2023 16:04:25'!
itemSellByTheStore

	^ 'ISBN1'! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'cartTest cashier merchantProcessor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'tests' stamp: 'sf 6/11/2023 16:54:22'!
test01checkoutOfEmptyCartRaisesInvalidCartError

	| aCart |

	aCart := cartTest createCart.

	self 
		should: [ cashier checkout: aCart with: self aValidCard ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = cashier InvalidCartErrorMessage.
			self assert: aCart isEmpty ].! !

!CashierTest methodsFor: 'tests' stamp: 'sf 6/11/2023 16:21:57'!
test02checkoutOfCartWithABookReturnsATicketWithItsPrice

	| aCart |
	
	aCart := cartTest createCart.
	aCart add: cartTest itemSellByTheStore.
	
	self assert: (cashier checkout: aCart with: self aValidCard)
	       equals: 100! !

!CashierTest methodsFor: 'tests' stamp: 'sf 6/11/2023 16:21:07'!
test03checkoutOfCartWithABookEmptiesCart

	| aCart |
	
	aCart := cartTest createCart.
	aCart add: cartTest itemSellByTheStore.
	
	cashier checkout: aCart with: self aValidCard.
	
	self assert: aCart isEmpty! !

!CashierTest methodsFor: 'tests' stamp: 'sf 6/11/2023 16:26:23'!
test04checkoutOfCartWithManyBookReturnsATicketWithTheSumOfTheirPrice

	| aCart |
	
	aCart := cartTest createCart.
	aCart add: 10 of: cartTest itemSellByTheStore.
	
	self assert: 1000
	       equals: (cashier checkout: aCart with: self aValidCard)! !

!CashierTest methodsFor: 'tests' stamp: 'sf 6/11/2023 16:52:49'!
test05checkoutWithExpiredCardRaisesInvalidCardError

	| aCart |

	aCart := cartTest createCart.
	aCart add: cartTest itemSellByTheStore.
	
	self assertCheckoutOf: aCart raisesInvalidCardErrorWhenUsing: self anExpiredCard.! !

!CashierTest methodsFor: 'tests' stamp: 'sf 6/11/2023 16:53:11'!
test06checkoutWithCardNumberWithInvalidFormatRaisesInvalidCardError

	| aCart |

	aCart := cartTest createCart.
	aCart add: cartTest itemSellByTheStore.
	
	self assertCheckoutOf: aCart raisesInvalidCardErrorWhenUsing: self aCardWithInvalidNumber.! !

!CashierTest methodsFor: 'tests' stamp: 'sf 6/11/2023 16:53:33'!
test07checkoutWithCardWithouthEnoughBalanceRaisesInvalidCardError

	| aCart |

	aCart := cartTest createCart.
	aCart add: cartTest itemSellByTheStore.
	
	self assertCheckoutOf: aCart raisesInvalidCardErrorWhenUsing: self aCardWith0Balance.! !

!CashierTest methodsFor: 'tests' stamp: 'sf 6/11/2023 16:53:51'!
test08checkoutSubstractsTheAmountToPayFromCardsBalance

	| aCart aCard|

	aCart := cartTest createCart.
	aCart add: 10 of: cartTest itemSellByTheStore.
	
	aCard := self aValidCard.
	cashier checkout: aCart with: aCard.
	
	aCart add: cartTest itemSellByTheStore.
	self assertCheckoutOf: aCart raisesInvalidCardErrorWhenUsing: aCard.! !


!CashierTest methodsFor: 'support' stamp: 'sf 6/11/2023 16:29:07'!
aCardWith0Balance

	^ Card new withName: 'Hernan'
	                    andNumber: 1234123412341234
	                    andExpirationDate: self aFutureMonthOfYear
	                    andBalance: 0! !

!CashierTest methodsFor: 'support' stamp: 'sf 6/11/2023 16:17:03'!
aCardWithInvalidNumber

	^ Card new withName: 'Hernan'
	                    andNumber: 1
	                    andExpirationDate: self aFutureMonthOfYear
	                    andBalance: 1000000! !

!CashierTest methodsFor: 'support' stamp: 'sf 6/11/2023 16:17:34'!
aFutureMonthOfYear

	^ (GregorianMonthOfYear current) next: 6*month! !

!CashierTest methodsFor: 'support' stamp: 'sf 6/11/2023 16:17:41'!
aPastMonthOfYear

	^ (GregorianMonthOfYear current) previous: 6*month! !

!CashierTest methodsFor: 'support' stamp: 'sf 6/11/2023 16:36:58'!
aValidCard

	^ Card new withName: 'Hernan'
	                    andNumber: 1234123412341234
	                    andExpirationDate: self aFutureMonthOfYear
	                    andBalance: 1000! !

!CashierTest methodsFor: 'support' stamp: 'sf 6/11/2023 16:18:12'!
anExpiredCard

	^ Card new withName: 'Hernan'
	                    andNumber: 1234123412341234
	                    andExpirationDate: self aPastMonthOfYear
	                    andBalance: 1000000! !

!CashierTest methodsFor: 'support' stamp: 'sf 6/11/2023 16:52:22'!
assertCheckoutOf: aCart raisesInvalidCardErrorWhenUsing: aCard

	self 
		should: [ cashier checkout: aCart with: aCard ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = cashier InvalidCardErrorMessage.
			self deny: aCart isEmpty ].! !


!CashierTest methodsFor: 'setUp/tearDown' stamp: 'sf 6/11/2023 16:19:25'!
setUp

	cartTest := CartTest new.
	merchantProcessor := MerchantProcessor new.
	cashier := Cashier new with: merchantProcessor.! !


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


!Cart methodsFor: 'assertions' stamp: 'SF 6/11/2023 16:03:32'!
assertIsValidItem: anItem

	(catalog includesKey: anItem) ifFalse: [ self error: self invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'initialization' stamp: 'SF 6/11/2023 15:58:16'!
initializeAcceptingItemsOf: aCatalog
	catalog := aCatalog.
	
	items := OrderedCollection new.! !


!Cart methodsFor: 'queries' stamp: 'sf 6/11/2023 16:26:02'!
getSubtotal

	^ items sum: [ :anItem | catalog at: anItem ]! !

!Cart methodsFor: 'queries' stamp: 'HernanWilkinson 6/17/2013 17:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !


!Cart methodsFor: 'testing' stamp: 'SF 6/11/2023 16:03:14'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'adding' stamp: 'SF 6/11/2023 16:01:30'!
add: anItem

	^ self add: 1 of: anItem ! !

!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:51'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	1 to: aQuantity do: [ :aNumber | items add: anItem ]! !


!Cart methodsFor: 'auxiliar' stamp: 'dsf 6/8/2023 20:07:20'!
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
	instanceVariableNames: 'merchantProcessor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'initialization' stamp: 'SF 6/11/2023 15:41:49'!
with: aMerchantProcessor

	merchantProcessor := aMerchantProcessor.! !


!Cashier methodsFor: 'error handling' stamp: 'dsf 6/8/2023 20:03:07'!
raiseErrorIfCartIsEmpty: aCart
	
	(aCart isEmpty) ifTrue: [
		self error: self InvalidCartErrorMessage
		]

	! !


!Cashier methodsFor: 'checkout' stamp: 'sf 6/11/2023 16:26:59'!
checkout: aCart with: aCardToPayWith

	| amountToPay |

	self raiseErrorIfCartIsEmpty: aCart.
	
	amountToPay := aCart getSubtotal.
	
	(merchantProcessor processPaymentOf: amountToPay withCard: aCardToPayWith) ifFalse: [
		self error: self InvalidCardErrorMessage 
		].
	
	aCart dumpItems.
	^ amountToPay

	! !


!Cashier methodsFor: 'error messages' stamp: 'dsf 6/8/2023 20:14:45'!
InvalidCardErrorMessage

	^ 'Tarjeta inválida'

	! !

!Cashier methodsFor: 'error messages' stamp: 'dsf 6/8/2023 19:53:12'!
InvalidCartErrorMessage

	^ 'Carrito inválido'

	! !


!classDefinition: #MerchantProcessor category: 'TusLibros'!
Object subclass: #MerchantProcessor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!MerchantProcessor methodsFor: 'payments' stamp: 'sf 6/11/2023 16:49:50'!
processPaymentOf: anAmountToPay withCard: aCardToPayWith

	(self validateCard: aCardToPayWith forPaymentOf: anAmountToPay) ifFalse: [ ^false ].
	aCardToPayWith substractBalanceBy: anAmountToPay.
	^ true.! !


!MerchantProcessor methodsFor: 'validation' stamp: 'SF 6/11/2023 15:52:16'!
checkIfCard: aCardToPayWith cantAfford: anAmountToPay

	^ (aCardToPayWith canAfford: anAmountToPay) not! !

!MerchantProcessor methodsFor: 'validation' stamp: 'SF 6/11/2023 15:34:06'!
checkIfCardIsExpired: aCardToPayWith.
	
	^ (aCardToPayWith isExpired)! !

!MerchantProcessor methodsFor: 'validation' stamp: 'SF 6/11/2023 15:53:52'!
checkIfCardNumberIsInvalid: aCardToPayWith

	^ (aCardToPayWith has16Digits) not! !

!MerchantProcessor methodsFor: 'validation' stamp: 'sf 6/11/2023 16:49:36'!
validateCard: aCardToPayWith forPaymentOf: anAmountToPay

	^ (( self checkIfCard: aCardToPayWith cantAfford: anAmountToPay ) or:
	     ( self checkIfCardIsExpired: aCardToPayWith ) or:
	     ( self checkIfCardNumberIsInvalid: aCardToPayWith )) not! !
