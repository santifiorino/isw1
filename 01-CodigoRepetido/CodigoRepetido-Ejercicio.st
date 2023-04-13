!classDefinition: #CantSuspend category: 'CodigoRepetido-Ejercicio'!
Error subclass: #CantSuspend
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #NotFound category: 'CodigoRepetido-Ejercicio'!
Error subclass: #NotFound
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #CustomerBookTest category: 'CodigoRepetido-Ejercicio'!
TestCase subclass: #CustomerBookTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBookTest methodsFor: 'testing' stamp: 'JPL 4/13/2023 01:09:22'!
test01AddingCustomerShouldNotTakeMoreThan50Milliseconds

	| customerBook|
	
	customerBook := CustomerBook new.
	
	self executeClosureWithTimeLimit:  [customerBook addCustomerNamed: 'John Lennon'.] 
		executionTimeLimitInMilliseconds: 50.! !

!CustomerBookTest methodsFor: 'testing' stamp: 'JPL 4/13/2023 01:09:18'!
test02RemovingCustomerShouldNotTakeMoreThan100Milliseconds

	| customerBook |
	
	customerBook := self createCustomerBookWithCustomer: 'Paul McCartney'.
	
	self executeClosureWithTimeLimit: [customerBook removeCustomerNamed: 'Paul McCartney'.] 
		executionTimeLimitInMilliseconds: 100.
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'JPL 4/13/2023 01:19:50'!
test03CanNotAddACustomerWithEmptyName 

	| customerBook |
			
	customerBook := CustomerBook new.
	
	self assertInvalidClosureThrowsAnError: [customerBook addCustomerNamed: ''.]
		errorThatMustOccur: Error
		closureToExecuteOnError: [ :anError | self assert: anError messageText = CustomerBook customerCanNotBeEmptyErrorMessage.			self assert: customerBook isEmpty ]! !

!CustomerBookTest methodsFor: 'testing' stamp: 'JPL 4/13/2023 01:19:50'!
test04CanNotRemoveAnInvalidCustomer

	| customerBook |
			
	customerBook := self createCustomerBookWithCustomer: 'John Lennon' .
	self assertInvalidClosureThrowsAnError: [ customerBook removeCustomerNamed: 'Paul McCartney'.]
		errorThatMustOccur: NotFound
		closureToExecuteOnError: [ self assertCustomerIsSoleCustomer: customerBook customer: 'John Lennon']
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'SF 4/11/2023 18:39:20'!
test05SuspendingACustomerShouldNotRemoveItFromCustomerBook

	| customerBook |
	
	customerBook := self createCustomerBookWithCustomer: 'Paul McCartney'.
	customerBook suspendCustomerNamed: 'Paul McCartney'.
	
	self assertLengthsOfCustomerListsForCustomerBook: customerBook
		activeCustomerLength: 0
		suspendedCustomerLength:  1
		totalCustomerLength: 1.
	self assert: (customerBook  includesCustomerNamed: 'Paul McCartney').
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'SF 4/11/2023 18:39:59'!
test06RemovingASuspendedCustomerShouldRemoveItFromCustomerBook

	| customerBook |
	
	customerBook := self createCustomerBookWithCustomer: 'Paul McCartney' .
	customerBook suspendCustomerNamed: 'Paul McCartney'.
	customerBook removeCustomerNamed: 'Paul McCartney'.
	
	self assertLengthsOfCustomerListsForCustomerBook: customerBook
		activeCustomerLength: 0
		suspendedCustomerLength: 0
		totalCustomerLength: 0.
	self deny: (customerBook includesCustomerNamed: 'Paul McCartney').! !

!CustomerBookTest methodsFor: 'testing' stamp: 'JPL 4/13/2023 01:19:50'!
test07CanNotSuspendAnInvalidCustomer

	| customerBook |
	
	customerBook := self createCustomerBookWithCustomer: 'John Lennon'.
		
	self assertInvalidClosureThrowsAnError: [ customerBook suspendCustomerNamed: 'George Harrison'.] 
		errorThatMustOccur:  CantSuspend 
		closureToExecuteOnError: [self assertCustomerIsSoleCustomer: customerBook customer: 'John Lennon']
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'JPL 4/13/2023 01:19:50'!
test08CanNotSuspendAnAlreadySuspendedCustomer
	| customerBook |
	
	customerBook := self createCustomerBookWithCustomer: 'John Lennon' .
	customerBook suspendCustomerNamed: 'John Lennon'.
	
	self assertInvalidClosureThrowsAnError: [ customerBook suspendCustomerNamed: 'John Lennon'.] 
		errorThatMustOccur:  CantSuspend 
		closureToExecuteOnError: [		self assertCustomerIsSoleCustomer: customerBook customer: 'John Lennon' ]
! !


!CustomerBookTest methodsFor: 'auxiliary methods for testing' stamp: 'SF 4/11/2023 18:36:14'!
assertCustomerIsSoleCustomer: aCustomerBook customer: aName

	self assert: aCustomerBook numberOfCustomers = 1.
	self assert: (aCustomerBook includesCustomerNamed: aName) ! !

!CustomerBookTest methodsFor: 'auxiliary methods for testing' stamp: 'JPL 4/13/2023 01:19:50'!
assertInvalidClosureThrowsAnError: aClosure errorThatMustOccur: errorType closureToExecuteOnError: errorHandlingClosure

	
	[ aClosure value.
	self fail ]
		on: errorType
		do: [errorHandlingClosure .]! !

!CustomerBookTest methodsFor: 'auxiliary methods for testing' stamp: 'JPL 4/13/2023 01:11:30'!
assertLengthsOfCustomerListsForCustomerBook: aCustomerBook activeCustomerLength: anAmountOfActiveCustomers suspendedCustomerLength: anAmountOfSuspendedCustomers totalCustomerLength: anAmountOfTotalCustomers

	self assert: anAmountOfActiveCustomers equals: aCustomerBook numberOfActiveCustomers.
	self assert: anAmountOfSuspendedCustomers equals: aCustomerBook numberOfSuspendedCustomers.
	self assert: anAmountOfTotalCustomers equals: aCustomerBook numberOfCustomers.! !

!CustomerBookTest methodsFor: 'auxiliary methods for testing' stamp: 'N 4/10/2023 21:53:57'!
createCustomerBookWithCustomer: aCustomerName

	| customerBook |
	
	customerBook := CustomerBook new.	
	customerBook addCustomerNamed: aCustomerName.
	
	^customerBook! !

!CustomerBookTest methodsFor: 'auxiliary methods for testing' stamp: 'JPL 4/12/2023 23:29:09'!
executeClosureWithTimeLimit: closureToExecute executionTimeLimitInMilliseconds: anAmountOfMilliseconds

	|millisecondsBeforeRunning millisecondsAfterRunning |
	
	millisecondsBeforeRunning := Time millisecondClockValue * millisecond.
	closureToExecute value.
	millisecondsAfterRunning := Time millisecondClockValue * millisecond.
	
	self assert: (millisecondsAfterRunning-millisecondsBeforeRunning) < (anAmountOfMilliseconds * millisecond)! !


!classDefinition: #CustomerBook category: 'CodigoRepetido-Ejercicio'!
Object subclass: #CustomerBook
	instanceVariableNames: 'suspended active'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBook methodsFor: 'testing' stamp: 'NR 4/3/2019 10:14:26'!
includesCustomerNamed: aName

	^(active includes: aName) or: [ suspended includes: aName ]! !

!CustomerBook methodsFor: 'testing' stamp: 'NR 4/3/2019 10:14:26'!
isEmpty
	
	^active isEmpty and: [ suspended isEmpty ]! !


!CustomerBook methodsFor: 'initialization' stamp: 'NR 9/17/2020 07:23:04'!
initialize

	active := OrderedCollection new.
	suspended:= OrderedCollection new.! !


!CustomerBook methodsFor: 'customer management' stamp: 'SF 4/11/2023 18:27:05'!
addCustomerNamed: aName

	self signalIfCustomerNameEmptyOrCustomerAlreadyInBook: aName.
	
	active add: aName.! !

!CustomerBook methodsFor: 'customer management' stamp: 'SF 4/11/2023 18:16:08'!
customerInCustomerBook: aName
	
	^(active includes: aName) or: [suspended includes: aName]! !

!CustomerBook methodsFor: 'customer management' stamp: 'SF 4/11/2023 17:34:55'!
numberOfActiveCustomers
	^active size! !

!CustomerBook methodsFor: 'customer management' stamp: 'SF 4/11/2023 18:13:26'!
numberOfCustomers

	^self numberOfActiveCustomers  + self numberOfSuspendedCustomers ! !

!CustomerBook methodsFor: 'customer management' stamp: 'SF 4/11/2023 18:13:19'!
numberOfSuspendedCustomers

	^suspended size! !

!CustomerBook methodsFor: 'customer management' stamp: 'SF 4/11/2023 18:09:08'!
removeCustomerFromCollectionIfPresent: aCollection customer: aCustomer
 	
	^aCollection remove: aCustomer ifAbsent: [^nil].! !

!CustomerBook methodsFor: 'customer management' stamp: 'SF 4/11/2023 18:10:59'!
removeCustomerNamed: aName 

	|customerRemovedFromActiveCollection customerRemovedFromSuspendedCollection|
	
 	customerRemovedFromActiveCollection := self removeCustomerFromCollectionIfPresent: active customer: aName.
	customerRemovedFromActiveCollection ifNotNil: [^aName].
	customerRemovedFromSuspendedCollection  := self removeCustomerFromCollectionIfPresent: suspended customer: aName.
	customerRemovedFromSuspendedCollection  ifNotNil: [^aName].
	^ NotFound signal.
! !

!CustomerBook methodsFor: 'customer management' stamp: 'SF 4/11/2023 18:11:20'!
signalCustomerAlreadyExists 

	self error: self class customerAlreadyExistsErrorMessage! !

!CustomerBook methodsFor: 'customer management' stamp: 'SF 4/11/2023 18:11:38'!
signalCustomerNameCannotBeEmpty

	self error: self class customerCanNotBeEmptyErrorMessage ! !

!CustomerBook methodsFor: 'customer management' stamp: 'SF 4/11/2023 18:24:35'!
signalIfCustomerNameEmptyOrCustomerAlreadyInBook: aName

	aName isEmpty ifTrue: [ self signalCustomerNameCannotBeEmpty ].
	(self customerInCustomerBook: aName) ifTrue: [ self signalCustomerAlreadyExists ].! !

!CustomerBook methodsFor: 'customer management' stamp: 'SF 4/11/2023 18:33:32'!
signalIfSuspensionAttemptedOnInactiveCustomer: aName

	(active includes: aName) ifFalse: [^CantSuspend signal].

! !

!CustomerBook methodsFor: 'customer management' stamp: 'SF 4/11/2023 18:35:57'!
suspendActiveCustomer: aName

	active remove: aName.
	suspended add: aName.
! !

!CustomerBook methodsFor: 'customer management' stamp: 'SF 4/11/2023 18:35:50'!
suspendCustomerNamed: aName

	self signalIfSuspensionAttemptedOnInactiveCustomer: aName.
	self suspendActiveCustomer: aName.
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerBook class' category: 'CodigoRepetido-Ejercicio'!
CustomerBook class
	instanceVariableNames: ''!

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 4/9/2023 22:25:52'!
customerAlreadyExistsErrorMessage

	^'Customer already exists!!!!!!'! !

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 4/9/2023 22:25:56'!
customerCanNotBeEmptyErrorMessage

	^'Customer name cannot be empty!!!!!!'! !
