!classDefinition: #AccountTest category: 'Portfolio-Solucion'!
TestCase subclass: #AccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!


!classDefinition: #PortfolioTest category: 'Portfolio-Solucion'!
AccountTest subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:16:26'!
test01BalanceOfPortfolioWithoutAccountsIsZero

	self assert: 0 equals: Portfolio new balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'NR 5/27/2021 17:36:04'!
test02BalanceOfPortfolioWithAccountsIsSumOfAccountsBalance

	| account portfolio |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: account balance equals: portfolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:23:25'!
test03BalanceOfPortfolioIsCalculatedRecursivelyOnPortfolios

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortofolio |
	
	simplePortfolioAccount := ReceptiveAccount new.
	Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	Withdraw register: 50 on: composedPortfolioAccount.
	composedPortofolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolioAccount balance + simplePortfolio balance) equals: composedPortofolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:15'!
test04PortfolioWithoutAccountsHasNoRegisteredTransaction

	self deny: (Portfolio new hasRegistered: (Deposit for: 100))! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:11'!
test05PortfolioHasRegisteredItsAccountsTransactions

	| account portfolio deposit |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: (portfolio hasRegistered: deposit)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:06'!
test06PortfolioLooksForRegisteredTransactionsRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolio hasRegistered: simplePortfolioAccountDeposit).
	self assert: (composedPortfolio hasRegistered: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:10'!
test07PortfolioHasNoTransactionWhenHasNoAccounts

	self assert: Portfolio new transactions isEmpty! !

!PortfolioTest methodsFor: 'tests' stamp: 'NR 6/22/2020 07:31:19'!
test08PortfolioTransactionsIncludesAllItsAccountsTransactions

	| account portfolio accountDeposit anotherAccount portfolioTransactions anotherAccountWithdraw |
	
	account := ReceptiveAccount new.
	accountDeposit := Deposit register: 100 on: account.
	anotherAccount := ReceptiveAccount new.
	anotherAccountWithdraw := Withdraw register: 100 on: account.
	portfolio := Portfolio with: account.
	
	portfolioTransactions := portfolio transactions.
	
	self assert: 2 equals: portfolioTransactions size.
	self assert: (portfolioTransactions includes: accountDeposit).
	self assert: (portfolioTransactions includes: anotherAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:20'!
test09PortfolioTransactionsAreCalculatedRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit composedPortfolioTransactions |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	composedPortfolioTransactions := composedPortfolio transactions.
	self assert: 2 equals: composedPortfolioTransactions size.
	self assert: (composedPortfolioTransactions includes: simplePortfolioAccountDeposit).
	self assert: (composedPortfolioTransactions includes: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:24'!
test10PortfolioCanNotIncludeTheSameAccountMoreThanOnce

	| account portfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio with: account.
	
	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: portfolio accountsSize.
			self assert: (portfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:28'!
test11PortfolioCanNotIncludeAccountOfItsPortfolios

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	composedPortfolio := Portfolio with: simplePortfolio.
	
	self 
		should: [ composedPortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: composedPortfolio accountsSize.
			self assert: (composedPortfolio accountsIncludes: simplePortfolio) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:32'!
test12PortfolioCanNotIncludeItself

	| account simplePortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	
	self 
		should: [ simplePortfolio add: simplePortfolio ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: simplePortfolio accountsSize.
			self assert: (simplePortfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:01:51'!
test13ComposedPortfolioCanNotHaveParentPortfolioAccount

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio new.
	composedPortfolio := Portfolio with: simplePortfolio.
	composedPortfolio add: account.
	
	self 
		should: [ simplePortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: simplePortfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:12:16'!
test14ComposedPortfolioCanNotHaveAccountOfAnyRootParentRecursively

	| account leftParentPortfolio leftRootParentPortfolio portfolio rightParentPortfolio rightRootParentPortfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio new.
	leftParentPortfolio := Portfolio with: portfolio .
	leftRootParentPortfolio := Portfolio with: leftParentPortfolio.
	leftRootParentPortfolio add: account.
	
	rightParentPortfolio := Portfolio with: portfolio .
	rightRootParentPortfolio := Portfolio with: rightParentPortfolio.
	rightRootParentPortfolio add: account.

	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/29/2019 16:31:18'!
test15PortfolioCanNotIncludeAnyOfTheComposedAccountOfPortfolioToAdd

	| portfolioToAdd portfolioToModify rootPortfolio sharedAccount |
	
	sharedAccount := ReceptiveAccount new.
	portfolioToModify := Portfolio new.
	rootPortfolio := Portfolio with: sharedAccount with: portfolioToModify.
	portfolioToAdd := Portfolio with: sharedAccount.
	
	self 
		should: [ portfolioToModify add: portfolioToAdd ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolioToModify accountsIsEmpty ]! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Solucion'!
AccountTest subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:48'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:54'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:02'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance .
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

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:54'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 100.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:21:24'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 100 on: account1.
		
	self assert: 1 equals: account1 transactions size .
	self assert: (account1 transactions includes: deposit1).
! !


!classDefinition: #ReportTest category: 'Portfolio-Solucion'!
TestCase subclass: #ReportTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!


!classDefinition: #AccountSummaryTest category: 'Portfolio-Solucion'!
ReportTest subclass: #AccountSummaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountSummaryTest methodsFor: 'tests' stamp: 'sf 5/31/2023 15:55:23'!
test01SummaryOfEmptyAccountOnlyShowsBalance

	| account accountSummary |
	
	account := ReceptiveAccount new.
	accountSummary := AccountSummary new ofAccount: account.
	
	self assert: (OrderedCollection with: 'Balance = 0') equals: accountSummary print
	! !

!AccountSummaryTest methodsFor: 'tests' stamp: 'sf 5/31/2023 15:55:53'!
test02SummaryOfAccountWithDepositShowsDepositAndBalance

	| account accountSummary |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	
	accountSummary := AccountSummary new ofAccount: account.
	self assert: (OrderedCollection with: 'Depósito por 100.' with: 'Balance = 100') equals: accountSummary print
	! !

!AccountSummaryTest methodsFor: 'tests' stamp: 'sf 5/31/2023 15:56:12'!
test03SummaryOfAccountWithWithdrawShowsWithdrawAndBalance

	| account accountSummary |
	
	account := ReceptiveAccount new.
	Withdraw register: 100 on: account.
	
	accountSummary := AccountSummary new ofAccount: account.
	self assert: (OrderedCollection with: 'Extracción por 100.' with: 'Balance = -100') equals: accountSummary print
	! !

!AccountSummaryTest methodsFor: 'tests' stamp: 'sf 5/31/2023 15:57:22'!
test04SummaryOfAccountWithWithdrawLegShowsWithdrawLegAndBalance

	| senderAccount receiverAccount accountSummary |
	
	senderAccount := ReceptiveAccount new.
	receiverAccount := ReceptiveAccount new.
	
	Transfer new from: senderAccount to: receiverAccount withValue: 100.
	
	accountSummary := AccountSummary new ofAccount: senderAccount.
	
	self assert: (OrderedCollection with: 'Salida por transferencia de 100.' with: 'Balance = -100') equals: accountSummary print
	! !

!AccountSummaryTest methodsFor: 'tests' stamp: 'sf 5/31/2023 15:57:40'!
test05SummaryOfAccountWithDepositLegShowsDepositLegAndBalance

	| senderAccount receiverAccount accountSummary |
	
	senderAccount := ReceptiveAccount new.
	receiverAccount := ReceptiveAccount new.
	
	Transfer new from: senderAccount to: receiverAccount withValue: 100.
	
	accountSummary := AccountSummary new ofAccount: receiverAccount.
	
	self assert: (OrderedCollection with: 'Entrada por transferencia de 100.' with: 'Balance = 100') equals: accountSummary print
	! !

!AccountSummaryTest methodsFor: 'tests' stamp: 'SF 5/31/2023 22:49:21'!
test06SummaryOfEmptyPortfolioOnlyShowsBalance
	
	| emptyPortfolio accountSummary |
	
	emptyPortfolio := Portfolio new.
	
	accountSummary := AccountSummary new ofAccount: emptyPortfolio.
	
	self assert: (OrderedCollection with: 'Balance = 0') equals: accountSummary print
	! !

!AccountSummaryTest methodsFor: 'tests' stamp: 'SF 5/31/2023 22:47:39'!
test07SummaryOfPortfolioWithAccountsShowsSummaryOfAllAccountsAndItsBalance

	| simplePortfolio simplePortfolioAccount accountSummary |

	simplePortfolioAccount := ReceptiveAccount new.
	Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	accountSummary := AccountSummary new ofAccount: simplePortfolio.
		
	self assert: (OrderedCollection with: 'Depósito por 100.' with: 'Balance = 100' with: 'Balance = 100') equals: accountSummary print
	! !


!classDefinition: #TransferNetTest category: 'Portfolio-Solucion'!
ReportTest subclass: #TransferNetTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferNetTest methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 01:19:46'!
test01TransferNetOfEmptyReceptiveAccountIsZero

	| account transfernet |
	
	account := ReceptiveAccount new.
	
	transfernet := TransferNet new ofAccount: account.
	
	self assert: 0 equals: transfernet print.! !

!TransferNetTest methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 01:19:25'!
test02TransferNetGetsAffectedByTransferTransaction

	| senderAccount receiverAccount transfernet |
	
	senderAccount := ReceptiveAccount new.
	receiverAccount := ReceptiveAccount new.
	
	Transfer new from: senderAccount to: receiverAccount withValue: 100.
	
	transfernet := TransferNet new ofAccount: senderAccount.
	
	self assert: -100 equals: transfernet print.! !

!TransferNetTest methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 01:19:19'!
test03TransferNetDoesntGetAffectedByRegularTransaction

	| senderAccount receiverAccount transfernet |
	
	senderAccount := ReceptiveAccount new.
	receiverAccount := ReceptiveAccount new.
	
	Transfer new from: senderAccount to: receiverAccount withValue: 100.
	Deposit register: 100 on: senderAccount.
	
	transfernet := TransferNet new ofAccount: senderAccount.
	
	self assert: -100 equals: transfernet print.! !

!TransferNetTest methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 01:19:58'!
test04TransferNetOfEmptyPortfolioIsZero

	| emptyPortfolio transfernet |

	emptyPortfolio := Portfolio new.
	
	transfernet := TransferNet new ofAccount: emptyPortfolio.
	
	self assert: 0 equals: transfernet print.! !

!TransferNetTest methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 01:20:23'!
test05TransferNetOfPortfolioWithAccountsAddsTheirTransferNet

	| simplePortfolio senderAccount receiverAccount transfernet |

	senderAccount := ReceptiveAccount new.
	receiverAccount := ReceptiveAccount new.
	Transfer new from: senderAccount to: receiverAccount withValue: 100.
	simplePortfolio := Portfolio with: senderAccount.
	
	transfernet := TransferNet new ofAccount: simplePortfolio.
		
	self assert: -100 equals: transfernet print! !


!classDefinition: #TreeStructureTest category: 'Portfolio-Solucion'!
ReportTest subclass: #TreeStructureTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TreeStructureTest methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 01:21:23'!
test01TreeStructureOfEmptyPortfolioOnlyShowsItsName

	| portfolio report |
	
	portfolio := Portfolio named: 'Portfolio de Juampi'.
	
	report := TreeStructure ofAccount: portfolio.	
	
	self assert: (OrderedCollection with: 'Portfolio de Juampi') equals: report print.! !

!TreeStructureTest methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 01:22:02'!
test02TreeStructureOfPortfolioWithAccountShowsPortfolioNameAndIndentedAccountName

	| portfolio account report |
	
	account := ReceptiveAccount named: 'Cuenta de Juampi'.
	
	portfolio := Portfolio named: 'Portfolio de Juampi' with: account.
	
	report := TreeStructure ofAccount: portfolio.	
	
	self assert: (OrderedCollection with: 'Portfolio de Juampi' with: '  Cuenta de Juampi') equals: report print.! !

!TreeStructureTest methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 01:25:05'!
test03TreeStructureOfPortfolioWithPortfolioAndAccountShowsAllNamesCorrectlyIntended

	| johnsAccount angiesAccount childrenPortfolio myAccount familyPortfolio report |
	
	johnsAccount := ReceptiveAccount named: 'Cuenta de Juan'.
	
	angiesAccount := ReceptiveAccount named: 'Cuenta de Angeles'.
	
	childrenPortfolio := Portfolio named: 'Portfolio de hijos' with: johnsAccount with: angiesAccount.
	
	myAccount := ReceptiveAccount named: 'Cuenta Mia'.
	
	familyPortfolio := Portfolio named: 'Portfolio de la familia' with: myAccount with: childrenPortfolio.
	
	report := TreeStructure ofAccount: familyPortfolio.
	
	self assert: (OrderedCollection with: 'Portfolio de la familia'
							     with: '  Cuenta Mia'
							     with: '  Portfolio de hijos'
							     with: '    Cuenta de Juan'
							     with: '    Cuenta de Angeles') equals: report print.! !

!TreeStructureTest methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 01:22:39'!
test04cantCreateTreeStructureOfReceptiveAccount

	|  johnsAccount  |
	
	johnsAccount := ReceptiveAccount named: 'Cuenta de Juan'.
	
	self should: [ 
		TreeStructure ofAccount: johnsAccount. 
		]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = TreeStructure triedToCreateTreeStructureOfReceptiveAccountErrorDescription
			]
	! !


!classDefinition: #TransferTest category: 'Portfolio-Solucion'!
TestCase subclass: #TransferTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferTest methodsFor: 'tests' stamp: 'SF 5/30/2023 17:37:07'!
test01ATransactionModifiesBothAccountsBalances

	| senderAccount receiverAccount |
	
	senderAccount := ReceptiveAccount new.
	receiverAccount := ReceptiveAccount new.
	
	Transfer new from: senderAccount to: 	receiverAccount withValue: 100.

	self assert: -100 equals: senderAccount balance.
	self assert: 100 equals: receiverAccount balance.! !

!TransferTest methodsFor: 'tests' stamp: 'SF 5/30/2023 17:53:34'!
test02AWithdrawalKnowsWhichTransferItsFrom

	| senderAccount receiverAccount aTransfer|
	
	senderAccount := ReceptiveAccount new.
	receiverAccount := ReceptiveAccount new.
	
	aTransfer := Transfer new from: senderAccount to: 	receiverAccount withValue: 100.

	self assert: aTransfer withdrawalLeg parentTransfer equals: aTransfer.! !

!TransferTest methodsFor: 'tests' stamp: 'SF 5/30/2023 17:53:28'!
test03ADepositKnowsWhichTransferItsFrom

	| senderAccount receiverAccount aTransfer|
	
	senderAccount := ReceptiveAccount new.
	receiverAccount := ReceptiveAccount new.
	
	aTransfer := Transfer new from: senderAccount to: 	receiverAccount withValue: 100.

	self assert: aTransfer depositLeg parentTransfer equals: aTransfer.! !

!TransferTest methodsFor: 'tests' stamp: 'SF 5/30/2023 17:52:21'!
test04TransferLegsKnowTheirValue

	| senderAccount receiverAccount aTransfer|
	
	senderAccount := ReceptiveAccount new.
	receiverAccount := ReceptiveAccount new.
	
	aTransfer := Transfer new from: senderAccount to: 	receiverAccount withValue: 100.

	self assert: aTransfer withdrawalLeg value equals: 100.
	self assert: aTransfer depositLeg value equals: 100.! !


!classDefinition: #Account category: 'Portfolio-Solucion'!
Object subclass: #Account
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Account methodsFor: 'testing' stamp: 'SF 5/31/2023 22:36:46'!
hasRegistered: aTransaction

	self subclassResponsibility ! !

!Account methodsFor: 'testing' stamp: 'SF 5/31/2023 22:36:40'!
isComposedBy: anAccount

	self subclassResponsibility ! !


!Account methodsFor: 'balance' stamp: 'SF 5/31/2023 22:36:27'!
balance

	self subclassResponsibility ! !


!Account methodsFor: 'transactions' stamp: 'SF 5/31/2023 22:36:17'!
addTransactionsTo: aCollectionOfTransactions

	self subclassResponsibility ! !

!Account methodsFor: 'transactions' stamp: 'SF 5/31/2023 22:36:21'!
transactions

	self subclassResponsibility ! !

!Account methodsFor: 'transactions' stamp: 'dsf 6/1/2023 01:12:14'!
triedToCreateTreeStructure

	self subclassResponsibility ! !


!Account methodsFor: 'composition' stamp: 'SF 5/31/2023 22:36:11'!
addedTo: aPortfolio

	self subclassResponsibility ! !

!Account methodsFor: 'composition' stamp: 'SF 5/31/2023 22:45:39'!
fillReport: aReport

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Account class' category: 'Portfolio-Solucion'!
Account class
	instanceVariableNames: ''!

!Account class methodsFor: 'as yet unclassified' stamp: 'dsf 5/31/2023 23:54:52'!
named: anAccountName

	self subclassResponsibility ! !


!classDefinition: #Portfolio category: 'Portfolio-Solucion'!
Account subclass: #Portfolio
	instanceVariableNames: 'accounts parents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Portfolio methodsFor: 'accounts management' stamp: 'SF 5/31/2023 22:37:02'!
accountsIncludes: anAccount

	^accounts includes: anAccount ! !

!Portfolio methodsFor: 'accounts management' stamp: 'SF 5/31/2023 22:37:06'!
accountsIsEmpty

	^accounts isEmpty ! !

!Portfolio methodsFor: 'accounts management' stamp: 'SF 5/31/2023 22:37:10'!
accountsSize

	^accounts size! !

!Portfolio methodsFor: 'accounts management' stamp: 'SF 5/31/2023 22:37:25'!
add: accountToAdd

	self assertCanAdd: accountToAdd.
	
	accounts add: accountToAdd.
	
	accountToAdd addedTo: self	! !

!Portfolio methodsFor: 'accounts management' stamp: 'SF 5/31/2023 22:37:41'!
rootParents

	| rootParents |
	
	rootParents := Set new.
	
	self addRootParentsTo: rootParents.
	
	^ rootParents! !


!Portfolio methodsFor: 'initialization' stamp: 'dsf 5/31/2023 23:59:18'!
initialize

	accounts := OrderedCollection new.
	parents := OrderedCollection new.! !

!Portfolio methodsFor: 'initialization' stamp: 'dsf 5/31/2023 23:56:15'!
initializeWithName: anAccountName

	name := anAccountName.

	accounts := OrderedCollection new.
	parents := OrderedCollection new.! !


!Portfolio methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:19:36'!
balance
	
	^accounts sum: [ :anAccount | anAccount balance ] ifEmpty: [ 0 ]! !

!Portfolio methodsFor: 'balance' stamp: 'dsf 6/1/2023 00:41:39'!
fillReport: aReport

	aReport addName: name.

	aReport increaseDepth.

	accounts do: [ :anAccount | anAccount fillReport: aReport ].
	
	aReport decreaseDepth.
	
	aReport addBalance: self balance.! !


!Portfolio methodsFor: 'transactions' stamp: 'SF 5/31/2023 22:38:25'!
addTransactionsTo: aCollectionOfTransactions

	accounts do: [ :anAccount | anAccount addTransactionsTo: aCollectionOfTransactions ]! !

!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:32'!
transactions
	
	| transactions |
	
	transactions := OrderedCollection new.
	accounts do: [ :anAccount | anAccount addTransactionsTo: transactions ].
	
	^transactions ! !

!Portfolio methodsFor: 'transactions' stamp: 'dsf 6/1/2023 01:12:21'!
triedToCreateTreeStructure! !


!Portfolio methodsFor: 'composition' stamp: 'SF 5/31/2023 22:39:09'!
addedTo: aPortfolio 

	parents add: aPortfolio ! !


!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:20:56'!
anyRootParentIsComposedBy: accountToAdd

	^self rootParents anySatisfy: [ :aParent | aParent isComposedBy: accountToAdd]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:28:29'!
hasRegistered: aTransaction

	^accounts anySatisfy: [ :anAccount | anAccount hasRegistered: aTransaction ]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/29/2019 16:24:54'!
isComposedBy: anAccount

	^ self = anAccount or: [ accounts anySatisfy: [ :composedAccount | (composedAccount isComposedBy: anAccount) or: [ anAccount isComposedBy: composedAccount ]]]! !


!Portfolio methodsFor: 'account management - private' stamp: 'SF 5/31/2023 22:38:10'!
addRootParentsTo: rootParents

	parents 
		ifEmpty: [ rootParents add: self ]
		ifNotEmpty: [ parents do: [ :aParent | aParent addRootParentsTo: rootParents ]]! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:20:36'!
assertCanAdd: accountToAdd

	(self anyRootParentIsComposedBy: accountToAdd) ifTrue: [ self signalCanNotAddAccount ].
! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 11:48:34'!
signalCanNotAddAccount
	
	self error: self class canNotAddAccountErrorMessage! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'Portfolio-Solucion'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:48:55'!
canNotAddAccountErrorMessage
	
	^'Can not add repeated account to a portfolio'! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'dsf 5/31/2023 23:55:15'!
named: anAccountName
	^self new initializeWithName: anAccountName.! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'dsf 5/31/2023 23:57:26'!
named: anAccountName with: anAccount
	^(self new 
		initializeWithName: anAccountName)
		add: anAccount;
		yourself! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'dsf 5/31/2023 23:57:44'!
named: anAccountName with: anAccount with: anotherAccount

	^((self new 
		initializeWithName: anAccountName)
		add: anAccount)
		add: anotherAccount;
		yourself! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:18:21'!
with: anAccount

	^self new 
		add: anAccount;
		yourself! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:23:59'!
with: anAccount with: anotherAccount

	^self new 
		add: anAccount;
		add: anotherAccount;
		yourself! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Solucion'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:35'!
initialize

	super initialize.
	transactions := OrderedCollection new.! !

!ReceptiveAccount methodsFor: 'initialization' stamp: 'dsf 5/31/2023 23:56:32'!
initializeWithName: anAccountName

	super initialize.
	
	name := anAccountName.
	
	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:52'!
addTransactionsTo: aCollectionOfTransactions

	aCollectionOfTransactions addAll: transactions ! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'dsf 6/1/2023 00:41:55'!
fillReport: aReport

	aReport addName: name.

	transactions do: [ :aTransaction | aTransaction addToReport: aReport ].
	
	aReport addBalance: self balance.! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'SF 5/31/2023 22:38:51'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:24:46'!
balance

	^transactions 
		inject: 0
		into: [ :currentBalance :transaction | transaction affectBalance: currentBalance ]! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/21/2019 18:55:56'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:54:51'!
isComposedBy: anAccount

	^self = anAccount ! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'dsf 6/1/2023 01:13:18'!
triedToCreateTreeStructure

	TreeStructure triedToCreateTreeStructureOfReceptiveAccountError.! !


!ReceptiveAccount methodsFor: 'composition' stamp: 'SF 5/31/2023 22:39:14'!
addedTo: aPortfolio
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ReceptiveAccount class' category: 'Portfolio-Solucion'!
ReceptiveAccount class
	instanceVariableNames: ''!

!ReceptiveAccount class methodsFor: 'as yet unclassified' stamp: 'dsf 5/31/2023 23:55:25'!
named: anAccountName

	^self new initializeWithName: anAccountName.! !


!classDefinition: #AccountTransaction category: 'Portfolio-Solucion'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountTransaction methodsFor: 'value' stamp: 'SF 5/31/2023 19:42:31'!
addToReport: aReport

	self subclassResponsibility ! !

!AccountTransaction methodsFor: 'value' stamp: 'SF 5/30/2023 17:50:20'!
value 

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:39'!
affectBalance: aBalance

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio-Solucion'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/21/2019 18:54:27'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio-Solucion'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'SF 5/31/2023 19:42:51'!
addToReport: aReport

	aReport addDeposit: self.! !

!Deposit methodsFor: 'value' stamp: 'SF 5/30/2023 17:50:40'!
value

	^ value! !


!Deposit methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:02'!
affectBalance: aBalance

	^aBalance + value ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Solucion'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #DepositLeg category: 'Portfolio-Solucion'!
AccountTransaction subclass: #DepositLeg
	instanceVariableNames: 'parentTransfer transaction'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!DepositLeg methodsFor: 'as yet unclassified' stamp: 'sf 5/31/2023 15:33:35'!
affectBalance: aBalance

	^aBalance + self value ! !

!DepositLeg methodsFor: 'as yet unclassified' stamp: 'sf 5/31/2023 15:32:31'!
fromTransfer: aTransfer

	parentTransfer := aTransfer.
	
! !

!DepositLeg methodsFor: 'as yet unclassified' stamp: 'SF 5/30/2023 17:53:07'!
parentTransfer

	^ parentTransfer
! !

!DepositLeg methodsFor: 'as yet unclassified' stamp: 'SF 5/30/2023 17:34:34'!
transaction

	^ transaction
! !


!DepositLeg methodsFor: 'value' stamp: 'SF 5/31/2023 19:43:06'!
addToReport: aReport

	aReport addDepositLeg: self.! !

!DepositLeg methodsFor: 'value' stamp: 'SF 5/30/2023 17:52:04'!
value

	^ parentTransfer value.
! !


!classDefinition: #Withdraw category: 'Portfolio-Solucion'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'SF 5/31/2023 19:43:21'!
addToReport: aReport

	aReport addWithdraw: self! !

!Withdraw methodsFor: 'value' stamp: 'SF 5/30/2023 17:50:47'!
value

	^ value! !


!Withdraw methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:15'!
affectBalance: aBalance

	^aBalance - value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Solucion'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #WithdrawLeg category: 'Portfolio-Solucion'!
AccountTransaction subclass: #WithdrawLeg
	instanceVariableNames: 'parentTransfer transaction'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!WithdrawLeg methodsFor: 'as yet unclassified' stamp: 'SF 5/31/2023 19:43:47'!
addToReport: aReport

	aReport addWithdrawLeg: self.! !

!WithdrawLeg methodsFor: 'as yet unclassified' stamp: 'sf 5/31/2023 15:33:48'!
affectBalance: aBalance

	^aBalance - self value! !

!WithdrawLeg methodsFor: 'as yet unclassified' stamp: 'sf 5/31/2023 15:32:24'!
fromTransfer: aTransfer

	parentTransfer := aTransfer.
	! !

!WithdrawLeg methodsFor: 'as yet unclassified' stamp: 'SF 5/30/2023 17:53:20'!
parentTransfer

	^ parentTransfer ! !

!WithdrawLeg methodsFor: 'as yet unclassified' stamp: 'SF 5/30/2023 17:52:08'!
value

	^ parentTransfer value.! !


!classDefinition: #Report category: 'Portfolio-Solucion'!
Object subclass: #Report
	instanceVariableNames: 'account report'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Report methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 00:16:53'!
addBalance: aBalanceValue! !

!Report methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 00:16:50'!
addDeposit: aDeposit! !

!Report methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 00:16:56'!
addDepositLeg: aDepositLeg! !

!Report methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 00:16:22'!
addName: anAccountName! !

!Report methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 00:17:00'!
addWithdraw: aWithdraw! !

!Report methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 00:17:04'!
addWithdrawLeg: aWithdrawLeg! !

!Report methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 00:17:58'!
decreaseDepth! !

!Report methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 00:17:54'!
increaseDepth! !

!Report methodsFor: 'as yet unclassified' stamp: 'SF 5/31/2023 19:47:57'!
ofAccount: anAccount
	account := anAccount.! !

!Report methodsFor: 'as yet unclassified' stamp: 'sf 5/31/2023 16:32:46'!
print

	self subclassResponsibility.! !


!classDefinition: #AccountSummary category: 'Portfolio-Solucion'!
Report subclass: #AccountSummary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountSummary methodsFor: 'as yet unclassified' stamp: 'SF 5/31/2023 22:48:45'!
addBalance: aBalanceValue

	report add: 'Balance = ', aBalanceValue asString.! !

!AccountSummary methodsFor: 'as yet unclassified' stamp: 'SF 5/31/2023 19:51:27'!
addDeposit: aDeposit

	report add: 'Depósito por ', aDeposit value asString, '.'.! !

!AccountSummary methodsFor: 'as yet unclassified' stamp: 'SF 5/31/2023 19:51:31'!
addDepositLeg: aDepositLeg

	report add: 'Entrada por transferencia de ', aDepositLeg value asString, '.'.! !

!AccountSummary methodsFor: 'as yet unclassified' stamp: 'SF 5/31/2023 19:51:36'!
addWithdraw: aWithdraw

	report add: 'Extracción por ', aWithdraw value asString, '.'.! !

!AccountSummary methodsFor: 'as yet unclassified' stamp: 'SF 5/31/2023 19:51:40'!
addWithdrawLeg: aWithdrawLeg

	report add: 'Salida por transferencia de ', aWithdrawLeg value asString, '.'.! !

!AccountSummary methodsFor: 'as yet unclassified' stamp: 'SF 5/31/2023 22:45:39'!
print

	report := OrderedCollection new.
	
	account fillReport: self.
	
	^report.
	! !


!classDefinition: #TransferNet category: 'Portfolio-Solucion'!
Report subclass: #TransferNet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferNet methodsFor: 'as yet unclassified' stamp: 'SF 5/31/2023 19:57:53'!
addDepositLeg: aDepositLeg

	report := report + aDepositLeg value! !

!TransferNet methodsFor: 'as yet unclassified' stamp: 'SF 5/31/2023 19:59:07'!
addWithdrawLeg: aWithdrawLeg

	report := report - aWithdrawLeg value! !

!TransferNet methodsFor: 'as yet unclassified' stamp: 'SF 5/31/2023 22:48:05'!
print

	report := 0.
	
	account fillReport: self.
	
	^report.
	! !


!classDefinition: #TreeStructure category: 'Portfolio-Solucion'!
Report subclass: #TreeStructure
	instanceVariableNames: 'depth'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TreeStructure methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 00:22:52'!
addDepthNumberOfTabsTo: anAccountName

	| tabbedName |
	
	tabbedName := anAccountName.
	depth timesRepeat: [
		tabbedName := '  ', tabbedName.
		].
	^ tabbedName.! !

!TreeStructure methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 00:21:10'!
addName: anAccountName

	report add: (self addDepthNumberOfTabsTo: anAccountName)! !

!TreeStructure methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 00:18:18'!
decreaseDepth

	depth := depth - 1! !

!TreeStructure methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 00:18:13'!
increaseDepth

	depth := depth + 1! !

!TreeStructure methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 00:17:35'!
ofAccount: anAccount

	account := anAccount.
	
	depth := 0.! !

!TreeStructure methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 00:40:59'!
print

	report := OrderedCollection new.
	
	account fillReport: self.
	
	^report.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TreeStructure class' category: 'Portfolio-Solucion'!
TreeStructure class
	instanceVariableNames: ''!

!TreeStructure class methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 01:11:50'!
ofAccount: anAccount

	anAccount triedToCreateTreeStructure.
	
	^ self new ofAccount: anAccount.! !

!TreeStructure class methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 01:13:48'!
triedToCreateTreeStructureOfReceptiveAccountError

	self error: self triedToCreateTreeStructureOfReceptiveAccountErrorDescription.! !

!TreeStructure class methodsFor: 'as yet unclassified' stamp: 'dsf 6/1/2023 01:14:33'!
triedToCreateTreeStructureOfReceptiveAccountErrorDescription

	^ 'Se intentó crear un TreeStructure de una ReceptiveAccount y sólo se puede con portfolios'
! !


!classDefinition: #Transfer category: 'Portfolio-Solucion'!
Object subclass: #Transfer
	instanceVariableNames: 'withdrawalLeg depositLeg value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Transfer methodsFor: 'as yet unclassified' stamp: 'SF 5/30/2023 17:31:26'!
depositLeg

	^ depositLeg! !

!Transfer methodsFor: 'as yet unclassified' stamp: 'SF 5/31/2023 19:43:55'!
from: aSenderAccount to: aReceiverAccount withValue: aTransferValue

	value := aTransferValue.
	withdrawalLeg := WithdrawLeg new fromTransfer: self.
	depositLeg := DepositLeg new fromTransfer: self.
	aSenderAccount register: withdrawalLeg.
	aReceiverAccount register: depositLeg.! !

!Transfer methodsFor: 'as yet unclassified' stamp: 'SF 5/30/2023 17:21:08'!
transfer

	^ self! !

!Transfer methodsFor: 'as yet unclassified' stamp: 'SF 5/30/2023 17:51:20'!
value

	^ value.! !

!Transfer methodsFor: 'as yet unclassified' stamp: 'SF 5/30/2023 17:20:43'!
withdrawalLeg

	^ withdrawalLeg! !
