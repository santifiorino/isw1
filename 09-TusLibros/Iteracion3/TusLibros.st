!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: 'testObjectsFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test01NewCartsAreCreatedEmpty

	self assert: testObjectsFactory createCart isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [ cart add: testObjectsFactory itemNotSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSellByTheStore.
	self deny: cart isEmpty ! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 0 of: testObjectsFactory itemSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 2 of: testObjectsFactory itemNotSellByTheStore  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test06CartRemembersAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSellByTheStore.
	self assert: (cart includes: testObjectsFactory itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self deny: (cart includes: testObjectsFactory itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: 2 of: testObjectsFactory itemSellByTheStore.
	self assert: (cart occurrencesOf: testObjectsFactory itemSellByTheStore) = 2! !


!CartTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 18:09'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'testObjectsFactory debitBehavior'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:50'!
test01CanNotCheckoutAnEmptyCart

	| salesBook |
	
	salesBook := OrderedCollection new.
	self 
		should: [ Cashier 
			toCheckout: testObjectsFactory createCart 
			charging: testObjectsFactory notExpiredCreditCard 
			throught: self
			on: testObjectsFactory today
			registeringOn:  salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier cartCanNotBeEmptyErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:51'!
test02CalculatedTotalIsCorrect

	| cart cashier |
	
	cart := testObjectsFactory createCart.
	cart add: 2 of: testObjectsFactory itemSellByTheStore.
	
	cashier :=  Cashier
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard 
		throught: self
		on: testObjectsFactory today 
		registeringOn: OrderedCollection new.
		
	self assert: cashier checkOut = (testObjectsFactory itemSellByTheStorePrice * 2)! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:51'!
test03CanNotCheckoutWithAnExpiredCreditCart

	| cart salesBook |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	salesBook := OrderedCollection new.
	
	self
		should: [ Cashier 
				toCheckout: cart 
				charging: testObjectsFactory expiredCreditCard 
				throught: self
				on: testObjectsFactory today
				registeringOn: salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = Cashier canNotChargeAnExpiredCreditCardErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'ARM 6/11/2023 13:50:03'!
test04CheckoutRegistersASale

	| cart cashier salesBook total |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	total := cashier checkOut.
					
	self assert: salesBook size = 1.
	self assert: salesBook first = total.! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 19:00'!
test05CashierChargesCreditCardUsingMerchantProcessor

	| cart cashier salesBook total creditCard debitedAmout debitedCreditCard  |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	debitBehavior := [ :anAmount :aCreditCard | 
		debitedAmout := anAmount.
		debitedCreditCard := aCreditCard ].
	total := cashier checkOut.
					
	self assert: debitedCreditCard = creditCard.
	self assert: debitedAmout = total.! !

!CashierTest methodsFor: 'tests' stamp: 'ARM 6/11/2023 14:10:01'!
test06CashierDoesNotSaleWhenTheCreditCardHasNoCredit

	| cart cashier salesBook creditCard |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 	debitBehavior := [ :anAmount :aCreditCard | self error: self creditCardHasNoCreditErrorMessage].
	
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	self 
		should: [cashier checkOut ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = self creditCardHasNoCreditErrorMessage.
			self assert: salesBook isEmpty ]! !


!CashierTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 19:03'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.
	debitBehavior := [ :anAmount :aCreditCard | ]! !


!CashierTest methodsFor: 'merchant processor protocol' stamp: 'ARM 6/11/2023 14:09:42'!
creditCardHasNoCreditErrorMessage
	
	^'Credit card has no credit'! !

!CashierTest methodsFor: 'merchant processor protocol' stamp: 'HernanWilkinson 6/17/2013 19:02'!
debit: anAmount from: aCreditCard 

	^debitBehavior value: anAmount value: aCreditCard ! !


!classDefinition: #RestInterfaceTest category: 'TusLibros'!
TestCase subclass: #RestInterfaceTest
	instanceVariableNames: 'testObjectsFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/22/2013 00:15'!
anotherValidBook
	
	^testObjectsFactory anotherItemSellByTheStore ! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'ARM 6/11/2023 14:12:44'!
createDefaultInterface
	
	^RestInterface
		authenticatingWith: self
		acceptingItemsOf: testObjectsFactory defaultCatalog
		merchantProcessor: self.! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/21/2013 23:49'!
invalidBook

	^testObjectsFactory itemNotSellByTheStore ! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/21/2013 23:25'!
invalidCartId
	
	"Devuelvo nil porque seguro que siempre sera un id invalido, no importa que sea el id - Hernan"
	^nil! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/21/2013 23:06'!
invalidPassword
	
	^'invalidPassword'! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/21/2013 22:30'!
invalidUser

	^'invalidUser'! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'ARM 6/11/2023 13:57:02'!
is: aUser authenticatingWith: aPassword 
	| storedPassword |
	
	storedPassword := self validUsersAndPasswords at: aUser ifAbsent: [ ^false ].
	^aPassword = storedPassword ! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/21/2013 23:43'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.
! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'ARM 6/11/2023 14:00:14'!
test01CanCreateCartWithValidUserAndPassword

	| interface cartID |
	
	interface := self createDefaultInterface.

	cartID := interface createCartFor: self validUser authenticatedWith: self validUserPassword.
	
	self assert: (interface listCartIdentifiedAs: cartID) isEmpty! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/21/2013 23:03'!
test02CanNotCreateCartWithInvalidUser

	| interface |

	interface := self createDefaultInterface.

	self
		should: [ interface createCartFor: self invalidUser authenticatedWith: self validUserPassword ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = interface invalidUserAndOrPasswordErrorDescription ]! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/21/2013 23:06'!
test03CanNotCreateCartWithInvalidPassword

	| interface |

	interface := self createDefaultInterface.

	self
		should: [ interface createCartFor: self validUser authenticatedWith: self invalidPassword ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = interface invalidUserAndOrPasswordErrorDescription ]! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/21/2013 23:15'!
test04CanAddItemsToACreatedCart

	| interface cartId |

	interface := self createDefaultInterface.

	cartId := interface createCartFor: self validUser authenticatedWith: self validUserPassword.
	self
		shouldnt: [interface add: self validBook quantity: 1 toCartIdentifiedAs: cartId]
		raise: Error - MessageNotUnderstood
		! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/21/2013 23:24'!
test05CanNotAddItemToNotCreatedCart

	| interface |

	interface := self createDefaultInterface.

	self
		should: [interface add: self validBook quantity: 1 toCartIdentifiedAs: self invalidCartId]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = interface invalidCartIdErrorDescription ]
		! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/21/2013 23:41'!
test06CanNotAddItemNotSellByTheStore

	| interface cartId |

	interface := self createDefaultInterface.

	cartId := interface createCartFor: self validUser authenticatedWith: self validUserPassword.
	self
		should: [interface add: self invalidBook quantity: 1 toCartIdentifiedAs: cartId ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = interface invalidItemErrorMessage ]
		! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/22/2013 00:05'!
test07ListCartOfAnEmptyCartReturnsAnEmptyBag

	| interface cartId |

	interface := self createDefaultInterface.

	cartId := interface createCartFor: self validUser authenticatedWith: self validUserPassword.
	self assert: (interface listCartIdentifiedAs: cartId) isEmpty 
	! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/22/2013 00:08'!
test08CanNotListCartOfInvalidCartId

	| interface |

	interface := self createDefaultInterface.

	self 
		should: [interface listCartIdentifiedAs: self invalidCartId] 
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = interface invalidCartIdErrorDescription ]
	! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/22/2013 00:15'!
test09ListCartReturnsTheRightNumberOfItems

	| interface cartId cartContent |

	interface := self createDefaultInterface.

	cartId := interface createCartFor: self validUser authenticatedWith: self validUserPassword.
	interface add: self validBook quantity: 1 toCartIdentifiedAs: cartId.
	interface add: self anotherValidBook quantity: 2 toCartIdentifiedAs: cartId.
	cartContent := interface listCartIdentifiedAs: cartId.
	
	self assert: (cartContent occurrencesOf: self validBook) = 1. 
	self assert: (cartContent occurrencesOf: self anotherValidBook) = 2
! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/22/2013 11:08'!
test10CanCheckoutACart

	| interface cartId  |

	interface := self createDefaultInterface.

	cartId := interface createCartFor: self validUser authenticatedWith: self validUserPassword.
	interface add: self validBook quantity: 1 toCartIdentifiedAs: cartId.
	self
		shouldnt: [interface 
			checkOutCartIdentifiedAs: cartId 
			withCreditCardNumbered: '1111222233334444' 
			ownedBy: 'Juan Perez' 
			expiringOn: testObjectsFactory notExpiredMonthOfYear ]
		raise: Error - MessageNotUnderstood
		
		! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/22/2013 11:10'!
test11CanNotCheckoutANotCreatedCart

	| interface |

	interface := self createDefaultInterface.

	self
		should: [interface 
			checkOutCartIdentifiedAs: self invalidCartId  
			withCreditCardNumbered: '1111222233334444' 
			ownedBy: 'Juan Perez' 
			expiringOn: testObjectsFactory notExpiredMonthOfYear ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = interface invalidCartIdErrorDescription ]
		
		! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/22/2013 11:13'!
test12CanNotCheckoutAnEmptyCart

	| interface cartId |

	interface := self createDefaultInterface.

	cartId := interface createCartFor: self validUser authenticatedWith: self validUserPassword.
	self
		should: [interface 
			checkOutCartIdentifiedAs: cartId 
			withCreditCardNumbered: '1111222233334444' 
			ownedBy: 'Juan Perez' 
			expiringOn: testObjectsFactory notExpiredMonthOfYear ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = interface cartCanNotBeEmptyErrorMessage ]
		
		! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'jp 6/12/2023 20:52:18'!
test13TimeRemainingOfNewCartIs30Minutes

	
	| interface cartID |
	
	interface := self createDefaultInterface.

	cartID := interface createCartFor: self validUser authenticatedWith: self validUserPassword.
	
	self assert: testObjectsFactory defaultCartTimeout equals: (interface timeRemainingOfCart: cartID).! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'jp 6/12/2023 20:57:29'!
test14TimeRemainingOfAllCartsDecreasesOverTime

	
	| interface cartID |
	
	interface := self createDefaultInterface.

	cartID := interface createCartFor: self validUser authenticatedWith: self validUserPassword.
	
	interface simulateTimePassageOf: 30*second.
		
	self assert: 0*second equals: (interface timeRemainingOfCart: cartID).! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'jp 6/12/2023 21:13:10'!
test15CanNotInteractWithCartAfterTimeoutExpires

	
	| interface cartID |
	
	interface := self createDefaultInterface.

	cartID := interface createCartFor: self validUser authenticatedWith: self validUserPassword.
	
	interface simulateTimePassageOf: 30*second.
		
	self
		should: [ interface add: self validBook quantity: 1 toCartIdentifiedAs: cartID ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = interface CartTimeoutErrorDescription ] .
		
	self
		should: [ interface listCartIdentifiedAs: cartID ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = interface CartTimeoutErrorDescription ] .! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'jp 6/12/2023 21:17:51'!
test16CartTimeoutResetsAfterInteraction
	
	| interface cartID |
	
	interface := self createDefaultInterface.

	cartID := interface createCartFor: self validUser authenticatedWith: self validUserPassword.
	
	interface simulateTimePassageOf: 29*second.
	
	interface add: self validBook quantity: 1 toCartIdentifiedAs: cartID .
		
	self assert: testObjectsFactory defaultCartTimeout equals: (interface timeRemainingOfCart: cartID).
	
	interface simulateTimePassageOf: 29*second.
	
	 interface listCartIdentifiedAs: cartID .
	
	self assert: testObjectsFactory defaultCartTimeout equals: (interface timeRemainingOfCart: cartID).
	! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/21/2013 23:50'!
validBook
	
	^testObjectsFactory itemSellByTheStore ! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/21/2013 22:27'!
validUser
	
	^'validUser'! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/21/2013 22:28'!
validUserPassword
	
	^'validUserPassword'! !

!RestInterfaceTest methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/21/2013 22:43'!
validUsersAndPasswords
	
	^Dictionary new
		at: self validUser put: self validUserPassword;
		yourself! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'catalog items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/21/2013 23:59'!
invalidItemErrorMessage
	
	^self class invalidItemErrorMessage ! !

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/22/2013 00:00'!
invalidQuantityErrorMessage
	
	^self class invalidQuantityErrorMessage ! !


!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:06'!
assertIsValidItem: anItem

	(catalog includesKey: anItem) ifFalse: [ self error: self invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'content' stamp: 'HernanWilkinson 6/22/2013 00:20'!
content
	
	^Bag new
		addAll: items;
		yourself ! !


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


!Cart methodsFor: 'total' stamp: 'HernanWilkinson 6/17/2013 19:09'!
total

	^ items sum: [ :anItem | catalog at: anItem ]! !


!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:44'!
add: anItem

	^ self add: 1 of: anItem ! !

!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:51'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	1 to: aQuantity do: [ :aNumber | items add: anItem ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/21/2013 23:59'!
invalidItemErrorMessage
	
	^'Item is not in catalog'! !

!Cart class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/22/2013 00:00'!
invalidQuantityErrorMessage
	
	^'Invalid number of items'! !


!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'cart salesBook merchantProcessor creditCard total'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:08'!
calculateTotal

	total := cart total.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'ARM 6/11/2023 13:49:52'!
createSale

	^ total
! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
debitTotal

	merchantProcessor debit: total from: creditCard.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
registerSale

	salesBook add: self createSale! !


!Cashier methodsFor: 'checkout' stamp: 'HernanWilkinson 6/17/2013 19:06'!
checkOut

	self calculateTotal.
	self debitTotal.
	self registerSale.

	^ total! !


!Cashier methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:53'!
initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook
	
	cart := aCart.
	creditCard := aCreditCard.
	merchantProcessor := aMerchantProcessor.
	salesBook := aSalesBook! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:22'!
assertIsNotEmpty: aCart 
	
	aCart isEmpty ifTrue: [self error: self cartCanNotBeEmptyErrorMessage ]! !

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:23'!
assertIsNotExpired: aCreditCard on: aDate
	
	(aCreditCard isExpiredOn: aDate) ifTrue: [ self error: self canNotChargeAnExpiredCreditCardErrorMessage ]! !


!Cashier class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:51'!
toCheckout: aCart charging: aCreditCard throught: aMerchantProcessor on: aDate registeringOn: aSalesBook
	
	self assertIsNotEmpty: aCart.
	self assertIsNotExpired: aCreditCard on: aDate.
	
	^self new initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook! !


!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 18:21'!
canNotChargeAnExpiredCreditCardErrorMessage
	
	^'Can not charge an expired credit card'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:56'!
cartCanNotBeEmptyErrorMessage
	
	^'Can not check out an empty cart'! !


!classDefinition: #CreditCard category: 'TusLibros'!
Object subclass: #CreditCard
	instanceVariableNames: 'expiration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 18:39'!
isExpiredOn: aDate 
	
	^expiration start < (Month month: aDate monthIndex year: aDate yearNumber) start ! !


!CreditCard methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:38'!
initializeExpiringOn: aMonth 
	
	expiration := aMonth ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:38'!
expiringOn: aMonth 
	
	^self new initializeExpiringOn: aMonth! !


!classDefinition: #RestInterface category: 'TusLibros'!
Object subclass: #RestInterface
	instanceVariableNames: 'authenticationSystem carts catalog lastId merchantProcessor salesBook timeRemainingOfCarts'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!RestInterface methodsFor: 'as yet unclassified' stamp: 'jp 6/12/2023 21:06:48'!
CartTimeoutErrorDescription

	^ 'El timeout del carrito ha expirado'! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'jp 6/12/2023 21:16:50'!
add: aBook quantity: anAmount toCartIdentifiedAs: aCartId

	| cart |
	
	
	
	cart := carts at: aCartId ifAbsent: [ self signalInvalidCartId ].
	
	self raiseErrorIfCartTimeoutHasExpired: aCartId .
	
	cart add: anAmount of: aBook .
	
	self restoreTimeoutOfCart: aCartId .! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/22/2013 11:17'!
cartCanNotBeEmptyErrorMessage
	
	^Cashier cartCanNotBeEmptyErrorMessage ! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/22/2013 11:16'!
checkOutCartIdentifiedAs: aCartId withCreditCardNumbered: aCreditCartNumber ownedBy: anOwner expiringOn: anExpirationMonthOfYear

	| cart |
	
	cart := carts at: aCartId ifAbsent: [self signalInvalidCartId ].
	
	Cashier 
		toCheckout: cart 
		charging: (CreditCard expiringOn: anExpirationMonthOfYear) 
		throught: merchantProcessor 
		on: self today 
		registeringOn: salesBook! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'jp 6/12/2023 21:00:15'!
createCartFor: aUser authenticatedWith: aPassword

	| cartId |
	
	(self is: aUser authenticatingWith: aPassword) ifFalse: [ self signalInvalidUserAndOrPassword ].
	
	cartId := self generateCartId.
	carts at: cartId put: (Cart acceptingItemsOf: catalog).
	
	timeRemainingOfCarts at: cartId put:  StoreTestObjectsFactory new defaultCartTimeout .
	
	^cartId ! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/21/2013 23:32'!
generateCartId
	
	"Recuerden que esto es un ejemplo, por lo que voy a generar ids numericos consecutivos, pero en una 
	implementacion real no deberian se numeros consecutivos ni nada que genere problemas de seguridad - Hernan"
	
	lastId := lastId + 1.
	^lastId! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'jp 6/12/2023 20:58:38'!
initializeAuthenticatingWith: anAuthenticationSystem acceptingItemsOf: aCatalog merchantProcessor: anMP

	authenticationSystem := anAuthenticationSystem.
	catalog := aCatalog.
	carts := Dictionary new.
	lastId := 0.
	merchantProcessor := anMP.
	timeRemainingOfCarts := Dictionary new.! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/21/2013 23:27'!
invalidCartIdErrorDescription
	
	^'Invalid cart id'! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/21/2013 23:59'!
invalidItemErrorMessage
	
	^Cart invalidItemErrorMessage ! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/21/2013 23:03'!
invalidUserAndOrPasswordErrorDescription
	
	^'Invalid user and/or password'! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'ARM 6/11/2023 13:54:36'!
is: aUser authenticatingWith: aPassword 
	
	^authenticationSystem is: aUser authenticatingWith: aPassword 
! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'jp 6/12/2023 21:18:26'!
listCartIdentifiedAs: aCartId

	| cart |
	
	cart := carts at: aCartId ifAbsent: [ self signalInvalidCartId ].
	
	self raiseErrorIfCartTimeoutHasExpired: aCartId .

	self restoreTimeoutOfCart: aCartId .
	
	^cart content! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'jp 6/12/2023 21:10:52'!
raiseErrorIfCartTimeoutHasExpired: aCartId

	^ ((timeRemainingOfCarts at: aCartId) <= (0*second)) ifTrue: [
		self error: self CartTimeoutErrorDescription .
		]! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'jp 6/12/2023 21:16:22'!
restoreTimeoutOfCart: aCartId

	timeRemainingOfCarts at: aCartId  put: StoreTestObjectsFactory new defaultCartTimeout .! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/21/2013 23:27'!
signalInvalidCartId
	
	self error: self invalidCartIdErrorDescription ! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/21/2013 23:02'!
signalInvalidUserAndOrPassword
	
	self error: self invalidUserAndOrPasswordErrorDescription! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'jp 6/12/2023 21:03:01'!
simulateTimePassageOf: anAmountOfTime

	timeRemainingOfCarts  keys do: [:aCartId | 
		timeRemainingOfCarts at: aCartId  put: ((timeRemainingOfCarts at: aCartId) - anAmountOfTime )].! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'jp 6/12/2023 21:03:25'!
timeRemainingOfCart: cartID

	^ timeRemainingOfCarts  at: cartID .! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/22/2013 11:17'!
today
	
	^DateAndTime now! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RestInterface class' category: 'TusLibros'!
RestInterface class
	instanceVariableNames: ''!

!RestInterface class methodsFor: 'as yet unclassified' stamp: 'ARM 6/11/2023 14:13:04'!
authenticatingWith: aValidUsersAndPasswords acceptingItemsOf: aCatalog merchantProcessor: anMP

	^self new initializeAuthenticatingWith: aValidUsersAndPasswords acceptingItemsOf: aCatalog merchantProcessor: anMP! !


!classDefinition: #StoreTestObjectsFactory category: 'TusLibros'!
Object subclass: #StoreTestObjectsFactory
	instanceVariableNames: 'today'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/22/2013 00:16'!
anotherItemSellByTheStorePrice
	
	^15! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemSellByTheStore
	
	^ 'validBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemSellByTheStorePrice
	
	^10! !


!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'HernanWilkinson 6/17/2013 18:08'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'HernanWilkinson 6/22/2013 00:16'!
defaultCatalog
	
	^ Dictionary new
		at: self itemSellByTheStore put: self itemSellByTheStorePrice;
		at: self anotherItemSellByTheStore put: self anotherItemSellByTheStorePrice;
		yourself ! !


!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/17/2013 18:37'!
expiredCreditCard
	
	^CreditCard expiringOn: (Month month: today monthIndex year: today yearNumber - 1)! !

!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/22/2013 11:06'!
notExpiredCreditCard
	
	^CreditCard expiringOn: self notExpiredMonthOfYear! !

!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/22/2013 11:06'!
notExpiredMonthOfYear

	^ Month month: today monthIndex year: today yearNumber + 1! !


!StoreTestObjectsFactory methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:37'!
initialize

	today := DateAndTime now! !


!StoreTestObjectsFactory methodsFor: 'date' stamp: 'HernanWilkinson 6/17/2013 18:37'!
today
	
	^ today! !


!StoreTestObjectsFactory methodsFor: 'as yet unclassified' stamp: 'HernanWilkinson 6/22/2013 00:16'!
anotherItemSellByTheStore
	
	^'anotherValidBook'! !

!StoreTestObjectsFactory methodsFor: 'as yet unclassified' stamp: 'jp 6/12/2023 20:53:49'!
defaultCartTimeout
	
	^ 30*second! !
