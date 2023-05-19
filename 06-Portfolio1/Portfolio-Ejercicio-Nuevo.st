!classDefinition: #PortfolioTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!PortfolioTest methodsFor: 'as yet unclassified'!
test01EmptyPortfolioHasNoBalance
	
	|portfolio|
	
	portfolio := Portfolio new initialize.

	self assert: 0 equals: portfolio balance.
	 ! !

!PortfolioTest methodsFor: 'as yet unclassified'!
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

!PortfolioTest methodsFor: 'as yet unclassified'!
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

!PortfolioTest methodsFor: 'as yet unclassified'!
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

!ReceptiveAccountTest methodsFor: 'tests'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| deposit withdraw account |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 200.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests'!
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

!AccountTransaction methodsFor: 'value'!
effectOnBalance

	self subclassResponsibility ! !

!AccountTransaction methodsFor: 'value'!
value 

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio-Ejercicio'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation'!
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

!Deposit methodsFor: 'initialization'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value'!
effectOnBalance

	^value! !

!Deposit methodsFor: 'value'!
value

	^ value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Ejercicio'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Withdraw category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Withdraw methodsFor: 'initialization'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value'!
effectOnBalance

	^value negated ! !

!Withdraw methodsFor: 'value'!
value

	^ value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Ejercicio'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Portfolio category: 'Portfolio-Ejercicio'!
Object subclass: #Portfolio
	instanceVariableNames: 'contents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Portfolio methodsFor: 'as yet unclassified'!
accounts

	^contents select: [ :element | element isKindOf: ReceptiveAccount ]! !

!Portfolio methodsFor: 'as yet unclassified'!
addAccount: anAccount

	contents  add: anAccount! !

!Portfolio methodsFor: 'as yet unclassified'!
addPortfolio: aPortfolio

	contents add: aPortfolio ! !

!Portfolio methodsFor: 'as yet unclassified'!
balance

	^contents sum: [ :element | element balance ] ifEmpty: [0]! !

!Portfolio methodsFor: 'as yet unclassified'!
hasRegistered: aTransaccion

	^contents anySatisfy: [ :element | element hasRegistered: aTransaccion ]! !

!Portfolio methodsFor: 'as yet unclassified'!
initialize

	contents := OrderedCollection new.! !

!Portfolio methodsFor: 'as yet unclassified'!
portfolios

	^contents select: [ :element | element isKindOf: Portfolio ]! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Ejercicio'!
Object subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization'!
initialize

	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance'!
balance

	^transactions sum: [ :aTransaction | aTransaction effectOnBalance ] ifEmpty: [0].! !


!ReceptiveAccount methodsFor: 'testing'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !
