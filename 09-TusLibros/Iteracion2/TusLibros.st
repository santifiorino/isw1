!classDefinition: #Card category: 'TusLibros'!
TestCase subclass: #Card
	instanceVariableNames: 'name number expirationDate balance'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Card methodsFor: 'validation' stamp: 'sf 6/12/2023 14:58:08'!
has16Digits
	
	
	^ (number asString size) = 16! !

!Card methodsFor: 'validation' stamp: 'SF 6/11/2023 15:11:33'!
isExpired
	
	^(expirationDate < (GregorianMonthOfYear current))
! !

!Card methodsFor: 'validation' stamp: 'sf 6/12/2023 14:51:42'!
nameHasBetween1And30Characters

	^ (name size > 0) and: (name size < 31)! !


!Card methodsFor: 'initialization' stamp: 'SF 6/11/2023 15:46:13'!
withName: anOwnersName andNumber: aCreditCardNumber andExpirationDate: anExpirationMonthofYear andBalance: aBalance

	name := anOwnersName.
	number := aCreditCardNumber.
	expirationDate := anExpirationMonthofYear.
	balance := aBalance.! !


!Card methodsFor: 'modifying' stamp: 'sf 6/12/2023 14:27:54'!
number

	^ number ! !

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
	instanceVariableNames: 'cartTest'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'tests' stamp: 'sf 6/12/2023 14:31:19'!
test01checkoutOfEmptyCartRaisesInvalidCartError

	| aCart cashier |

	aCart := cartTest createCart.
	cashier := self defaultCashier.

	self 
		should: [ cashier checkout: aCart with: self aValidCard ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = cashier InvalidCartErrorMessage.
			self assert: aCart isEmpty ].! !

!CashierTest methodsFor: 'tests' stamp: 'sf 6/12/2023 14:31:29'!
test02checkoutOfCartWithABookReturnsATicketWithItsPrice

	| aCart cashier |
	
	aCart := cartTest createCart.
	cashier := self defaultCashier.
	
	aCart add: cartTest itemSellByTheStore.
	
	self assert: (cashier checkout: aCart with: self aValidCard)
	       equals: 100! !

!CashierTest methodsFor: 'tests' stamp: 'sf 6/12/2023 14:31:37'!
test03checkoutOfCartWithABookEmptiesCart

	| aCart cashier |
	
	aCart := cartTest createCart.
	cashier := self defaultCashier.
	
	aCart add: cartTest itemSellByTheStore.
	
	cashier checkout: aCart with: self aValidCard.
	
	self assert: aCart isEmpty! !

!CashierTest methodsFor: 'tests' stamp: 'sf 6/12/2023 14:31:55'!
test04checkoutOfCartWithManyBookReturnsATicketWithTheSumOfTheirPrice

	| aCart cashier |
	
	aCart := cartTest createCart.
	cashier := self defaultCashier.
	
	aCart add: 10 of: cartTest itemSellByTheStore.
	
	self assert: 1000
	       equals: (cashier checkout: aCart with: self aValidCard)! !

!CashierTest methodsFor: 'tests' stamp: 'sf 6/12/2023 14:33:34'!
test05checkoutWithExpiredCardRaisesInvalidCardError

	| aCart cashier |

	aCart := cartTest createCart.
	cashier := self defaultCashier.
	
	aCart add: cartTest itemSellByTheStore.
	
	self assertCheckoutOf: aCart byCashier: cashier raisesInvalidCardErrorWhenUsing: self anExpiredCard.! !

!CashierTest methodsFor: 'tests' stamp: 'sf 6/12/2023 14:33:57'!
test06checkoutWithCardNumberWithInvalidFormatRaisesInvalidCardError

	| aCart cashier |

	aCart := cartTest createCart.
	cashier := self defaultCashier.
	
	aCart add: cartTest itemSellByTheStore.
	
	self assertCheckoutOf: aCart byCashier: cashier raisesInvalidCardErrorWhenUsing: self aCardWithInvalidNumber.! !

!CashierTest methodsFor: 'tests' stamp: 'sf 6/12/2023 14:34:10'!
test07checkoutWithCardWithouthEnoughBalanceRaisesInvalidCardError

	| aCart cashier |

	aCart := cartTest createCart.
	cashier := self defaultCashier.
	
	aCart add: cartTest itemSellByTheStore.
	
	self assertCheckoutOf: aCart byCashier: cashier raisesInvalidCardErrorWhenUsing: self aCardWith0Balance.! !

!CashierTest methodsFor: 'tests' stamp: 'sf 6/12/2023 14:38:07'!
test08checkoutSubstractsTheAmountToPayFromCardsBalance

	| aCart aCard cashier|

	aCart := cartTest createCart.
	cashier := self defaultCashier.
	
	aCart add: 10 of: cartTest itemSellByTheStore.
	aCard := self aValidCard.
	cashier checkout: aCart with: aCard.
	
	aCart add: cartTest itemSellByTheStore.
	self assertCheckoutOf: aCart byCashier: cashier raisesInvalidCardErrorWhenUsing: aCard.! !

!CashierTest methodsFor: 'tests' stamp: 'sf 6/12/2023 14:57:21'!
test09checkoutWithCardWithoutInvalidNameRaisesInvalidCardError

	| aCart cashier |

	aCart := cartTest createCart.
	cashier := self defaultCashier.
	
	aCart add: cartTest itemSellByTheStore.
	
	self assertCheckoutOf: aCart byCashier: cashier raisesInvalidCardErrorWhenUsing: self aCardWithEmptyName.
	self assertCheckoutOf: aCart byCashier: cashier raisesInvalidCardErrorWhenUsing: self aCardWithNameTooLarge.! !

!CashierTest methodsFor: 'tests' stamp: 'sf 6/12/2023 15:14:38'!
test10checkoutWithStolenCardRaisesInvalidCardError

	| aCart cashier |

	aCart := cartTest createCart.
	cashier := self defaultCashier.
	
	aCart add: cartTest itemSellByTheStore.
	
	self assertCheckoutOf: aCart byCashier: cashier raisesInvalidCardErrorWhenUsing: self aStolenCard.! !


!CashierTest methodsFor: 'support' stamp: 'sf 6/12/2023 14:37:15'!
aCardWith0Balance

	^ Card new withName: 'Hernan'
	                    andNumber: 4567456745674567
	                    andExpirationDate: self aFutureMonthOfYear
	                    andBalance: 0! !

!CashierTest methodsFor: 'support' stamp: 'sf 6/12/2023 14:56:55'!
aCardWithEmptyName

	^ Card new withName: ''
	                    andNumber: 8888999911112222
	                    andExpirationDate: self aFutureMonthOfYear
	                    andBalance: 1000000! !

!CashierTest methodsFor: 'support' stamp: 'sf 6/11/2023 16:17:03'!
aCardWithInvalidNumber

	^ Card new withName: 'Hernan'
	                    andNumber: 1
	                    andExpirationDate: self aFutureMonthOfYear
	                    andBalance: 1000000! !

!CashierTest methodsFor: 'support' stamp: 'sf 6/12/2023 14:50:38'!
aCardWithNameTooLarge

	^ Card new withName: 'QWERTYUIOPASDFGHJKLZXCVBNMQWERTYUUDSIAOGFASIYUODBTFCGAOUIYSGCFOYUISGFRNCAIUYIOASDFGHJKL'
	                    andNumber: 1111222233334444
	                    andExpirationDate: self aFutureMonthOfYear
	                    andBalance: 1000000! !

!CashierTest methodsFor: 'support' stamp: 'sf 6/12/2023 14:58:50'!
aFutureMonthOfYear

	^ (GregorianMonthOfYear current) next! !

!CashierTest methodsFor: 'support' stamp: 'sf 6/12/2023 14:58:45'!
aPastMonthOfYear

	^ (GregorianMonthOfYear current) previous! !

!CashierTest methodsFor: 'support' stamp: 'sf 6/12/2023 15:18:16'!
aStolenCard

	^ Card new withName: 'Hernan'
	                    andNumber: 7777666655554444
	                    andExpirationDate: self aFutureMonthOfYear
	                    andBalance: 1000! !

!CashierTest methodsFor: 'support' stamp: 'sf 6/11/2023 16:36:58'!
aValidCard

	^ Card new withName: 'Hernan'
	                    andNumber: 1234123412341234
	                    andExpirationDate: self aFutureMonthOfYear
	                    andBalance: 1000! !

!CashierTest methodsFor: 'support' stamp: 'sf 6/12/2023 14:38:58'!
anExpiredCard

	^ Card new withName: 'Hernan'
	                    andNumber: 6789678967896789
	                    andExpirationDate: self aPastMonthOfYear
	                    andBalance: 1000000! !

!CashierTest methodsFor: 'support' stamp: 'sf 6/12/2023 14:33:20'!
assertCheckoutOf: aCart byCashier: aCashier raisesInvalidCardErrorWhenUsing: aCard

	self 
		should: [ aCashier checkout: aCart with: aCard ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = aCashier InvalidCardErrorMessage.
			self deny: aCart isEmpty ].! !

!CashierTest methodsFor: 'support' stamp: 'sf 6/12/2023 15:15:29'!
defaultCashier

	| merchantProcessor |

	merchantProcessor := MerchantProcessor new with:
		(Dictionary newFromPairs: {self aCardWith0Balance number . OrderedCollection with: 0 with: false .
	                                               				      self aCardWithInvalidNumber number . OrderedCollection with: 100 with: false .
	                                                      self anExpiredCard number . OrderedCollection with: 100 with: false .
						              self aValidCard number . OrderedCollection with: 1000 with: false .
						              self aCardWithEmptyName number . OrderedCollection with: 100 with: false .
						              self aCardWithNameTooLarge number . OrderedCollection with: 100 with: false .
							      self aStolenCard number . OrderedCollection with: 100 with: true .}).
							
	^ Cashier new with: merchantProcessor.! !


!CashierTest methodsFor: 'setUp/tearDown' stamp: 'sf 6/12/2023 14:29:52'!
setUp

	cartTest := CartTest new.! !


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
	instanceVariableNames: 'cards'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!MerchantProcessor methodsFor: 'payments' stamp: 'sf 6/12/2023 15:10:58'!
processPaymentOf: anAmountToPay withCard: aCardToPayWith

	(self validateCard: aCardToPayWith forPaymentOf: anAmountToPay) ifFalse: [ ^false ].
	self substract: anAmountToPay fromBalanceOfCard: aCardToPayWith.
	^ true.! !

!MerchantProcessor methodsFor: 'payments' stamp: 'sf 6/12/2023 15:12:46'!
substract: anAmountToPay fromBalanceOfCard: aCardToPayWith

	^ (cards at: aCardToPayWith number) at: 1 put: (self getBalanceOf: aCardToPayWith) - anAmountToPay! !


!MerchantProcessor methodsFor: 'validation' stamp: 'sf 6/12/2023 15:07:38'!
checkIfCard: aCardToPayWith cantAfford: anAmountToPay

	^ (self getBalanceOf: aCardToPayWith) < anAmountToPay! !

!MerchantProcessor methodsFor: 'validation' stamp: 'sf 6/12/2023 14:43:24'!
checkIfCardIsExpired: aCardToPayWith
	
	^ (aCardToPayWith isExpired)! !

!MerchantProcessor methodsFor: 'validation' stamp: 'sf 6/12/2023 15:13:52'!
checkIfCardIsStolen: aCardToPayWith

	^ self getStolenStateOf: aCardToPayWith! !

!MerchantProcessor methodsFor: 'validation' stamp: 'sf 6/12/2023 14:44:24'!
checkIfCardNameHasInvalidLength: aCardToPayWith

	^ (aCardToPayWith nameHasBetween1And30Characters) not! !

!MerchantProcessor methodsFor: 'validation' stamp: 'SF 6/11/2023 15:53:52'!
checkIfCardNumberIsInvalid: aCardToPayWith

	^ (aCardToPayWith has16Digits) not! !

!MerchantProcessor methodsFor: 'validation' stamp: 'sf 6/12/2023 15:10:13'!
getBalanceOf: aCard

	^ (cards at: aCard number) at: 1! !

!MerchantProcessor methodsFor: 'validation' stamp: 'sf 6/12/2023 15:13:15'!
getStolenStateOf: aCard

	^ (cards at: aCard number) at: 2! !

!MerchantProcessor methodsFor: 'validation' stamp: 'sf 6/12/2023 15:14:12'!
validateCard: aCardToPayWith forPaymentOf: anAmountToPay

	^ (( self checkIfCard: aCardToPayWith cantAfford: anAmountToPay ) or:
	     ( self checkIfCardIsExpired: aCardToPayWith ) or:
	     ( self checkIfCardNameHasInvalidLength: aCardToPayWith) or:
	     ( self checkIfCardIsStolen: aCardToPayWith) or:
	     ( self checkIfCardNumberIsInvalid: aCardToPayWith )) not! !

!MerchantProcessor methodsFor: 'validation' stamp: 'sf 6/12/2023 15:06:44'!
with: aDictOfCardsAndTheirBalance

	cards := aDictOfCardsAndTheirBalance.! !
