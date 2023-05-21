!classDefinition: #PortfolioTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: 'portfolioVacio cuentaCon100Pesos transaccionDepositar100 cuentaCon50Pesos transaccionDepositar50 portfolioConCuentaDe100Pesos portfolioConCuentasDe100y50Pesos'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!PortfolioTest methodsFor: 'tests' stamp: 'SF 5/20/2023 15:51:34'!
test01PortfolioWithNoAccountsHasNoBalance
	
	self assert: 0 equals: portfolioVacio balance.! !

!PortfolioTest methodsFor: 'tests' stamp: 'SF 5/20/2023 15:58:35'!
test02PortfolioWithOneAccountHasItsBalance

	self assert: 100
	equals: portfolioConCuentaDe100Pesos balance.! !

!PortfolioTest methodsFor: 'tests' stamp: 'SF 5/20/2023 15:58:28'!
test03PortfolioWithMultipleAccountsHasTheSumOfTheirBalance

	self assert: 150
	equals: portfolioConCuentasDe100y50Pesos balance.! !

!PortfolioTest methodsFor: 'tests' stamp: 'SF 5/21/2023 17:47:39'!
test04PortfolioWithAccountsAndPortfoliosHasTheSumOfTheirBalances
	
	| portfolioPadre portfolioHijo |

	portfolioPadre := Portfolio new initialize.
	portfolioHijo := Portfolio new initialize.
	portfolioPadre addAccount: cuentaCon100Pesos.
	portfolioHijo addAccount: cuentaCon50Pesos.
	portfolioPadre addAccount: portfolioHijo.

	self assert: 150 equals: (portfolioPadre balance).! !

!PortfolioTest methodsFor: 'tests' stamp: 'SF 5/20/2023 15:51:34'!
test05PortfolioWithNoAccountsHasNoTransaction
	
	self assert: portfolioVacio transactions isEmpty.! !

!PortfolioTest methodsFor: 'tests' stamp: 'SF 5/20/2023 15:58:19'!
test06PortfolioWithOneAccountHasItsTransactions
	
	self assert: (cuentaCon100Pesos transactions)
	equals: (portfolioConCuentaDe100Pesos transactions).! !

!PortfolioTest methodsFor: 'tests' stamp: 'SF 5/20/2023 16:03:18'!
test07PortfolioWithMultipleAccountsHasAllOfTheirTransactions
	
	self assert: (cuentaCon100Pesos transactions), (cuentaCon50Pesos transactions)
	equals: (portfolioConCuentasDe100y50Pesos transactions).! !

!PortfolioTest methodsFor: 'tests' stamp: 'SF 5/20/2023 16:27:18'!
test08CanFindTransactionsInAPortfolio

	self assert: (portfolioConCuentasDe100y50Pesos hasRegistered: transaccionDepositar100).
	self assert: (portfolioConCuentasDe100y50Pesos hasRegistered: transaccionDepositar50).! !

!PortfolioTest methodsFor: 'tests' stamp: 'SF 5/21/2023 17:38:07'!
test09CantAddReceptiveAccountThatIsAlreadyPresent

	self should: [ portfolioConCuentaDe100Pesos addAccount: cuentaCon100Pesos ]
	raise: Error
	withExceptionDo: [ :anError |
		self assert: anError messageText = Account triedToAddExistingAccountErrorDescription
		]
	
! !

!PortfolioTest methodsFor: 'tests' stamp: 'SF 5/21/2023 17:48:38'!
test10CantAddPortfolioWithReceptiveAccountThatIsAlreadyPresent

	| portfolioPadre portfolioHijo |

	portfolioPadre := Portfolio new initialize.
	portfolioHijo := Portfolio new initialize.
	
	portfolioPadre addAccount: cuentaCon100Pesos.
	portfolioHijo addAccount: cuentaCon100Pesos.
	
	self should: [ portfolioPadre addAccount: portfolioHijo ]
	raise: Error
	withExceptionDo: [ :anError |
		self assert: anError messageText = Account triedToAddExistingAccountErrorDescription.
		].! !


!PortfolioTest methodsFor: 'setUp/tearDown' stamp: 'SF 5/21/2023 17:46:27'!
setUp
	
	portfolioVacio := Portfolio new initialize.
	
	cuentaCon100Pesos := ReceptiveAccount new initialize.
	transaccionDepositar100 := Deposit register: 100 on: cuentaCon100Pesos.
	
	cuentaCon50Pesos := ReceptiveAccount new initialize.
	transaccionDepositar50 := Deposit register: 50 on: cuentaCon50Pesos.
	
	portfolioConCuentaDe100Pesos := Portfolio new initialize.
	portfolioConCuentaDe100Pesos addAccount: cuentaCon100Pesos.
	
	portfolioConCuentasDe100y50Pesos := Portfolio new initialize.
	portfolioConCuentasDe100y50Pesos addAccount: cuentaCon100Pesos.
	portfolioConCuentasDe100y50Pesos addAccount: cuentaCon50Pesos.
	! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'SF 5/21/2023 17:42:24'!
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


!classDefinition: #Account category: 'Portfolio-Ejercicio'!
Object subclass: #Account
	instanceVariableNames: 'parentAccount'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Account methodsFor: 'accessing' stamp: 'SF 5/20/2023 16:31:39'!
balance
	
	self subclassResponsibility ! !

!Account methodsFor: 'accessing' stamp: 'SF 5/20/2023 16:31:25'!
hasRegistered: aTransactionToLookFor
	
	self subclassResponsibility ! !

!Account methodsFor: 'accessing' stamp: 'SF 5/21/2023 16:51:43'!
parentPortfolio: aParentPortfolio

	parentAccount := aParentPortfolio ! !

!Account methodsFor: 'accessing' stamp: 'SF 5/21/2023 16:52:14'!
rootPortfolio

	(parentAccount = self) ifTrue: [ ^self ].
	^parentAccount rootPortfolio.! !

!Account methodsFor: 'accessing' stamp: 'SF 5/20/2023 16:31:35'!
transactions
	
	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Account class' category: 'Portfolio-Ejercicio'!
Account class
	instanceVariableNames: ''!

!Account class methodsFor: 'error messages' stamp: 'SF 5/21/2023 16:19:30'!
triedToAddExistingAccountErrorDescription

	^ 'La cuenta que quieres agregar ya existe.'! !


!classDefinition: #Portfolio category: 'Portfolio-Ejercicio'!
Account subclass: #Portfolio
	instanceVariableNames: 'accounts'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Portfolio methodsFor: 'initialization' stamp: 'SF 5/21/2023 16:51:43'!
initialize

	accounts := OrderedCollection new.
	parentAccount := self.! !


!Portfolio methodsFor: 'accessing' stamp: 'SF 5/20/2023 16:04:59'!
balance

	^ accounts sum: [ :account | account balance ] ifEmpty: [ 0 ]! !

!Portfolio methodsFor: 'accessing' stamp: 'SF 5/21/2023 17:36:05'!
flattenedAccounts

	^ (accounts inject: OrderedCollection new into: [ :flattenedAccounts :account |
		flattenedAccounts, account flattenedAccounts.
		]), self portfolios! !

!Portfolio methodsFor: 'accessing' stamp: 'SF 5/21/2023 16:42:57'!
hasAccount: anAccountToLookFor
	
	^accounts anySatisfy: [ :account | (account = anAccountToLookFor) | (account hasAccount: anAccountToLookFor) ]! !

!Portfolio methodsFor: 'accessing' stamp: 'SF 5/20/2023 16:26:09'!
hasRegistered: aTransactionToLookFor
	
	^accounts anySatisfy: [ :account | account hasRegistered: aTransactionToLookFor ]! !

!Portfolio methodsFor: 'accessing' stamp: 'SF 5/21/2023 17:34:01'!
portfolios

	^ accounts select: [ :anAccount | anAccount isKindOf: Portfolio ].! !

!Portfolio methodsFor: 'accessing' stamp: 'SF 5/21/2023 16:58:39'!
transactions

	^ accounts inject: OrderedCollection new into: [ :transactions :account |
		transactions, account transactions 
		]! !


!Portfolio methodsFor: 'modifying' stamp: 'SF 5/21/2023 18:02:39'!
addAccount: anAccountToAdd

	self raiseErrorIfAccountAlreadyPresent: anAccountToAdd.
	anAccountToAdd parentPortfolio: self.
	accounts add: anAccountToAdd! !


!Portfolio methodsFor: 'auxiliar' stamp: 'SF 5/21/2023 18:20:00'!
raiseErrorIfAccountAlreadyPresent: anAccountToAdd
	
	(self rootHasNoAccountFrom: anAccountToAdd flattenedAccounts)
	ifTrue: [ self error: Account triedToAddExistingAccountErrorDescription ]! !

!Portfolio methodsFor: 'auxiliar' stamp: 'SF 5/21/2023 18:19:54'!
rootHasNoAccountFrom: aCollectionOfAccounts
	
	| flattenedRoot |
	
	flattenedRoot := self rootPortfolio flattenedAccounts.

	^(flattenedRoot anySatisfy: [ :anAccount | aCollectionOfAccounts includes: anAccount ])! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Ejercicio'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'SF 5/21/2023 16:51:43'!
initialize

	transactions := OrderedCollection new.
	parentAccount := self.! !


!ReceptiveAccount methodsFor: 'accessing' stamp: 'SF 5/20/2023 15:15:37'!
balance

	^transactions sum: [ :aTransaction | aTransaction effectOnBalance ] ifEmpty: [ 0 ]! !

!ReceptiveAccount methodsFor: 'accessing' stamp: 'SF 5/21/2023 17:20:58'!
flattenedAccounts

	| res |
	res := OrderedCollection new.
	res add: self.
	^ res.! !

!ReceptiveAccount methodsFor: 'accessing' stamp: 'SF 5/21/2023 16:39:46'!
hasAccount: anAccountToLookFor

	^ self = anAccountToLookFor ! !

!ReceptiveAccount methodsFor: 'accessing' stamp: 'SF 5/20/2023 16:04:23'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction
! !

!ReceptiveAccount methodsFor: 'accessing' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'modifying' stamp: 'SF 5/20/2023 16:32:29'!
register: aTransaction

	transactions add: aTransaction
! !


!classDefinition: #AccountTransaction category: 'Portfolio-Ejercicio'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!AccountTransaction methodsFor: 'accessing' stamp: 'SF 5/20/2023 15:14:47'!
effectOnBalance

	self subclassResponsibility ! !

!AccountTransaction methodsFor: 'accessing' stamp: 'SF 5/20/2023 15:14:42'!
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

!Deposit methodsFor: 'initialization' stamp: 'SF 5/20/2023 16:04:36'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'accessing' stamp: 'SF 5/20/2023 15:15:00'!
effectOnBalance

	^ value! !

!Deposit methodsFor: 'accessing' stamp: 'SF 5/20/2023 15:14:56'!
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

!Withdraw methodsFor: 'initialization' stamp: 'SF 5/20/2023 16:04:50'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'accessing' stamp: 'SF 5/20/2023 15:15:23'!
effectOnBalance

	^ value negated! !

!Withdraw methodsFor: 'accessing' stamp: 'SF 5/20/2023 15:15:16'!
value

	^ value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Ejercicio'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !
