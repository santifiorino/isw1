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

!CustomerBookTest methodsFor: 'testing' stamp: 'N 4/10/2023 21:49:08'!
assertCustomerIsSoleCustomer: aCustomerBook customer: aName

	self assert: aCustomerBook numberOfCustomers = 1.
	self assert: (aCustomerBook includesCustomerNamed: aName) ! !

!CustomerBookTest methodsFor: 'testing' stamp: 'N 4/10/2023 21:49:31'!
assertLengthsOfCustomerListsForCustomerBook: aCustomerBook activeCustomerLength: aNumberForActiveCustomers suspendedCustomerLength: aNumberForSuspendedCustomers totalCustomerLength: aNumberForTotalCustomers

	self assert: aNumberForActiveCustomers equals: aCustomerBook numberOfActiveCustomers.
	self assert: aNumberForSuspendedCustomers equals: aCustomerBook numberOfSuspendedCustomers.
	self assert: aNumberForTotalCustomers equals: aCustomerBook numberOfCustomers.! !

!CustomerBookTest methodsFor: 'testing' stamp: 'N 4/10/2023 21:53:57'!
createCustomerBookWithCustomer: aCustomerName

	| customerBook |
	
	customerBook := CustomerBook new.	
	customerBook addCustomerNamed: aCustomerName.
	
	^customerBook! !

!CustomerBookTest methodsFor: 'testing' stamp: 'N 4/10/2023 21:20:33'!
executeClosureWithErrorHandling: aClosure errorToHandle: errorType closureToExecuteOnError: errorHandlerClosure

	
	[ aClosure value.
	self fail ]
		on: errorType
		do: [errorHandlerClosure .]! !

!CustomerBookTest methodsFor: 'testing' stamp: 'N 4/10/2023 21:09:18'!
executeClosureWithTimeLimit: closureToExecute executionTimeLimitInMilliseconds: aNumberInMilliseconds

	|millisecondsBeforeRunning millisecondsAfterRunning |
	
	millisecondsBeforeRunning := Time millisecondClockValue * millisecond.
	closureToExecute value.
	millisecondsAfterRunning := Time millisecondClockValue * millisecond.
	
	self assert: (millisecondsAfterRunning-millisecondsBeforeRunning) < (aNumberInMilliseconds * millisecond)! !

!CustomerBookTest methodsFor: 'testing' stamp: 'N 4/10/2023 21:10:54'!
test01AddingCustomerShouldNotTakeMoreThan50Milliseconds

	| customerBook|
	
	customerBook := CustomerBook new.
	
	self executeClosureWithTimeLimit:  [customerBook addCustomerNamed: 'John Lennon'.] executionTimeLimitInMilliseconds: 50.
	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'N 4/10/2023 21:54:56'!
test02RemovingCustomerShouldNotTakeMoreThan100Milliseconds

	| customerBook paulMcCartney |
	
	customerBook := CustomerBook new.
	paulMcCartney := 'Paul McCartney'.
	
	customerBook addCustomerNamed: paulMcCartney.
	
	self executeClosureWithTimeLimit: [customerBook removeCustomerNamed: paulMcCartney.] executionTimeLimitInMilliseconds: 100
	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'N 4/10/2023 21:22:01'!
test03CanNotAddACustomerWithEmptyName 

	| customerBook |
			
	customerBook := CustomerBook new.
		
	self executeClosureWithErrorHandling: [customerBook addCustomerNamed: ''.] errorToHandle: Error closureToExecuteOnError: [ :anError | 
			self assert: anError messageText = CustomerBook customerCanNotBeEmptyErrorMessage.
			self assert: customerBook isEmpty ]! !

!CustomerBookTest methodsFor: 'testing' stamp: 'N 4/10/2023 21:22:46'!
test04CanNotRemoveAnInvalidCustomer
	
	| customerBook johnLennon |
			
	customerBook := CustomerBook new.
	johnLennon := 'John Lennon'.
	customerBook addCustomerNamed: johnLennon.
		
	self executeClosureWithErrorHandling: [ customerBook removeCustomerNamed: 'Paul McCartney'.] errorToHandle: NotFound closureToExecuteOnError: [ :anError | 
			self assert: customerBook numberOfCustomers = 1.
			self assert: (customerBook includesCustomerNamed: johnLennon) ]
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'N 4/10/2023 21:50:46'!
test05SuspendingACustomerShouldNotRemoveItFromCustomerBook

	| customerBook paulMcCartney|
	
	customerBook := CustomerBook new.
	paulMcCartney := 'Paul McCartney'.
	
	customerBook addCustomerNamed: paulMcCartney.
	customerBook suspendCustomerNamed: paulMcCartney.
	
	self assertLengthsOfCustomerListsForCustomerBook: customerBook activeCustomerLength: 0 suspendedCustomerLength:  1 totalCustomerLength: 1.
	self assert: (customerBook  includesCustomerNamed: paulMcCartney).
	

	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'N 4/10/2023 21:50:41'!
test06RemovingASuspendedCustomerShouldRemoveItFromCustomerBook

	| customerBook paulMcCartney|
	
	customerBook := CustomerBook new.
	paulMcCartney := 'Paul McCartney'.
	
	customerBook addCustomerNamed: paulMcCartney.
	customerBook suspendCustomerNamed: paulMcCartney.
	customerBook removeCustomerNamed: paulMcCartney.
	
	self assertLengthsOfCustomerListsForCustomerBook: customerBook activeCustomerLength: 0 suspendedCustomerLength: 0 totalCustomerLength: 0 .
	self deny: (customerBook includesCustomerNamed: paulMcCartney).


	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'N 4/10/2023 21:50:07'!
test07CanNotSuspendAnInvalidCustomer
	
	| customerBook johnLennon |
			
	customerBook := CustomerBook new.
	johnLennon := 'John Lennon'.
	customerBook addCustomerNamed: johnLennon.
		
	self executeClosureWithErrorHandling: [ customerBook suspendCustomerNamed: 'George Harrison'.] errorToHandle:  CantSuspend closureToExecuteOnError: [ :anError | 
			self assertCustomerIsSoleCustomer: customerBook customer: johnLennon] 
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'N 4/10/2023 21:50:35'!
test08CanNotSuspendAnAlreadySuspendedCustomer
	
	| customerBook johnLennon |
			
	customerBook := CustomerBook new.
	johnLennon := 'John Lennon'.
	customerBook addCustomerNamed: johnLennon.
	customerBook suspendCustomerNamed: johnLennon.
	
	self executeClosureWithErrorHandling: [ customerBook suspendCustomerNamed: johnLennon.] errorToHandle:  CantSuspend closureToExecuteOnError: [ :anError | 
			self assertCustomerIsSoleCustomer: customerBook customer: johnLennon ]
! !


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


!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
addCustomerNamed: aName

	aName isEmpty ifTrue: [ self signalCustomerNameCannotBeEmpty ].
	((active includes: aName) or: [suspended includes: aName]) ifTrue: [ self signalCustomerAlreadyExists ].
	
	active add: aName ! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
numberOfActiveCustomers
	
	^active size! !

!CustomerBook methodsFor: 'customer management' stamp: 'N 4/10/2023 20:37:57'!
numberOfCustomers
	
	^self numberOfActiveCustomers  + self numberOfSuspendedCustomers ! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 9/19/2018 17:36:09'!
numberOfSuspendedCustomers
	
	^suspended size! !

!CustomerBook methodsFor: 'customer management' stamp: 'N 4/10/2023 20:46:31'!
removeCustomerFromCollectionIfPresent: aCustomer collection: aCollection 

	1 to: aCollection size do: 
	[ :index |
		aCustomer = (aCollection at: index)
			ifTrue: [
				aCollection removeAt: index.
				^ aCustomer
			] 
	].! !

!CustomerBook methodsFor: 'customer management' stamp: 'N 4/10/2023 21:15:09'!
removeCustomerNamed: aName 
 
	1 to: active size do: 
	[ :index |
		aName = (active at: index)
			ifTrue: [
				active removeAt: index.
				^ aName
			] 
	].

	1 to: suspended size do: 
	[ :index |
		aName = (suspended at: index)
			ifTrue: [
				suspended removeAt: index.
				^ aName
			] 
	].
	
	^ NotFound signal.
! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:52'!
signalCustomerAlreadyExists 

	self error: self class customerAlreadyExistsErrorMessage! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:51'!
signalCustomerNameCannotBeEmpty 

	self error: self class customerCanNotBeEmptyErrorMessage ! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
suspendCustomerNamed: aName 
	
	(active includes: aName) ifFalse: [^CantSuspend signal].
	
	active remove: aName.
	
	suspended add: aName
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
