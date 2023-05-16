!classDefinition: #PortfolioTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'JP 5/15/2023 21:44:56'!
test01EmptyPortfolioHasNoBalance
	
	|portfolio|
	
	portfolio := Portfolio new initialize.

	self assert: 0 equals: portfolio balance.
	 ! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'JP 5/15/2023 21:46:46'!
test02BalanceOfPortfolioWithAccountsIsTheSumOfTheirBalance
	
	|portfolio cuentas|
	
	cuentas := OrderedCollection new.
	cuentas add: ReceptiveAccount new initialize.
	cuentas add: ReceptiveAccount new initialize.
	
	Deposit register: 100 on: (cuentas at: 1).
	Deposit register: 10 on: (cuentas at: 2).
	
	portfolio := Portfolio new initialize.
	
	portfolio addAccount: (cuentas at: 1).
	portfolio addAccount: (cuentas at: 2).

	self assert: 110 equals: portfolio balance.
	 ! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'JP 5/15/2023 21:47:51'!
test03BalanceOfPortfolioWithAccountsAndPortfoliosIsTheSumOfTheirBalance
	
	| portfolioPadre portfolioHijo cuentaParaPadre cuentaParaHijo |
	

	cuentaParaPadre := ReceptiveAccount new initialize.
	Deposit register: 100 on: cuentaParaPadre.
	
	cuentaParaHijo := ReceptiveAccount new initialize.
	Deposit register: 50 on: cuentaParaHijo.
	
	portfolioHijo := Portfolio new initialize.
	portfolioHijo addAccount: cuentaParaHijo.
	
	portfolioPadre := Portfolio new initialize.
	portfolioPadre addAccount: cuentaParaPadre.
	portfolioPadre addPortfolio: portfolioHijo.

	self assert: 150 equals: portfolioPadre balance.
	 ! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'JP 5/15/2023 21:48:58'!
test04CanFindTransactionInAPortfolioWithTransactions
	
	|portfolio cuenta transaccion|
	
	cuenta := ReceptiveAccount new initialize.
	
	transaccion := Deposit register: 100 on: cuenta.
	
	portfolio := Portfolio new initialize.
	
	portfolio addAccount: cuenta.

	self assert: (portfolio hasRegistered: transaccion)
	 ! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:44'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:48'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:52'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:32'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:46'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 5/17/2021 17:29:53'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| deposit withdraw account |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 200.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:14:01'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 50 on: account1.
		
	self assert: 1 equals: account1 transactions size.
	self assert: (account1 transactions includes: deposit1).
! !


!classDefinition: #AccountTransaction category: 'Portfolio-Ejercicio'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!AccountTransaction methodsFor: 'value' stamp: 'JP 5/15/2023 20:04:39'!
effectOnBalance

	self subclassResponsibility ! !

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio-Ejercicio'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/17/2019 03:22:00'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'JP 5/15/2023 20:03:50'!
effectOnBalance

	^value! !

!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Ejercicio'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Withdraw category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'JP 5/15/2023 20:06:28'!
effectOnBalance

	^value negated ! !

!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Ejercicio'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Portfolio category: 'Portfolio-Ejercicio'!
Object subclass: #Portfolio
	instanceVariableNames: 'contents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Portfolio methodsFor: 'as yet unclassified' stamp: 'JP 5/15/2023 21:27:13'!
accounts

	^contents select: [ :element | element isKindOf: ReceptiveAccount ]! !

!Portfolio methodsFor: 'as yet unclassified' stamp: 'JP 5/15/2023 21:25:25'!
addAccount: anAccount

	contents  add: anAccount! !

!Portfolio methodsFor: 'as yet unclassified' stamp: 'JP 5/15/2023 21:25:31'!
addPortfolio: aPortfolio

	contents add: aPortfolio ! !

!Portfolio methodsFor: 'as yet unclassified' stamp: 'JP 5/15/2023 21:28:52'!
balance

	^contents sum: [ :element | element balance ] ifEmpty: [0]! !

!Portfolio methodsFor: 'as yet unclassified' stamp: 'JP 5/15/2023 21:40:58'!
hasRegistered: aTransaccion

	^contents anySatisfy: [ :element | element hasRegistered: aTransaccion ]! !

!Portfolio methodsFor: 'as yet unclassified' stamp: 'JP 5/15/2023 21:26:04'!
initialize

	contents := OrderedCollection new.! !

!Portfolio methodsFor: 'as yet unclassified' stamp: 'JP 5/15/2023 21:26:57'!
portfolios

	^contents select: [ :element | element isKindOf: Portfolio ]! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Ejercicio'!
Object subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'NR 10/17/2019 15:06:56'!
initialize

	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'JP 5/15/2023 20:05:35'!
balance

	^transactions sum: [ :aTransaction | aTransaction effectOnBalance ] ifEmpty: [0].! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/17/2019 03:28:43'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !
