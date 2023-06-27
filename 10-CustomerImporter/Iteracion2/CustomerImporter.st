!classDefinition: #ImportTest category: 'CustomerImporter'!
TestCase subclass: #ImportTest
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'tests' stamp: 'p 6/26/2023 21:03:08'!
assert: aClosure raises: expectedError

	^ self should: aClosure
		  raise: Error
		  withExceptionDo: [ :anError |
			  self assert: expectedError
			        equals: anError messageText.
			  ]! !

!ImportTest methodsFor: 'tests' stamp: 'p 6/26/2023 20:44:18'!
test01Import

	CustomerImporter valueFrom: self validImportData into: session.

	self assertImportedRightNumberOfCustomers.
	self assertPepeSanchezWasImportedCorrecty.
	self assertJuanPerezWasImportedCorrectly ! !

!ImportTest methodsFor: 'tests' stamp: 'p 6/26/2023 21:10:45'!
test02Empty

	self assert: [ CustomerImporter valueFrom: self emptyImportData into: session ]
	       raises: CustomerImporter emptyStreamErrorDescription.
	
! !

!ImportTest methodsFor: 'tests' stamp: 'p 6/26/2023 21:37:54'!
test03notEnoughOrMoreCustomerFields

	self assert: [ CustomerImporter valueFrom: self importDataWithNotEnoughCustomerFields into: session. ]
	       raises: CustomerImporter notEnoughFieldsErrorDescription.
! !

!ImportTest methodsFor: 'tests' stamp: 'p 6/26/2023 21:37:54'!
test04notEnoughOrMoreAddressFields

	self assert: [ CustomerImporter valueFrom: self importDataWithNotEnoughAddressFields into: session. ]
	       raises: CustomerImporter notEnoughFieldsErrorDescription.! !

!ImportTest methodsFor: 'tests' stamp: 'p 6/26/2023 21:11:40'!
test05addressBeforeCustomer
	
	self assert: [ CustomerImporter valueFrom: self importDataWithAddressBeforeCustomer into: session. ]
	       raises: CustomerImporter addressBeforeCustomerErrorDescription.
! !

!ImportTest methodsFor: 'tests' stamp: 'p 6/26/2023 21:39:40'!
test06invalidEntryType
	
	self assert: [ CustomerImporter valueFrom: self importDataWithInvalidEntryType into: session. ]
	       raises: CustomerImporter invalidTypeOfEntryErrorDescription.
! !

!ImportTest methodsFor: 'tests' stamp: 'p 6/26/2023 21:21:07'!
test07adjacentCommas
	
	self assert: [ CustomerImporter valueFrom: self importDataWithAdjacentCommas into: session. ]
	       raises: CustomerImporter adjacentCommasErrorDescription.
! !

!ImportTest methodsFor: 'tests' stamp: 'p 6/26/2023 21:49:43'!
test08nilStream
	
	self assert: [ CustomerImporter valueFrom: nil into: session. ]
	       raises: CustomerImporter nilStreamErrorDescription.
! !

!ImportTest methodsFor: 'tests' stamp: 'p 6/26/2023 21:54:43'!
test09validFirstLetterButInvalidType
	
	self assert: [ CustomerImporter valueFrom: self importDataWithValidFirstLetterButInvalidType into: session. ]
	       raises: CustomerImporter invalidTypeOfEntryErrorDescription.
! !


!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:22:05'!
assertAddressOf: importedCustomer at: aStreetName hasNumber: aNumber town: aTown zipCode: aZipCode province: aProvince

	| importedAddress |

	importedAddress := importedCustomer addressAt: aStreetName ifNone: [ self fail ].
	self assert: aStreetName equals: importedAddress streetName.
	self assert: aNumber equals: importedAddress streetNumber.
	self assert: aTown equals: importedAddress town.
	self assert: aZipCode equals: importedAddress zipCode.
	self assert: aProvince equals: importedAddress province.

	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:27:57'!
assertCustomerWithIdentificationType: anIdType number: anIdNumber hasFirstName: aFirstName lastName: aLastName

	| importedCustomer |

	importedCustomer := self customerWithIdentificationType: anIdType number: anIdNumber.

	self assert: aFirstName equals: importedCustomer firstName.
	self assert: aLastName equals: importedCustomer lastName.
	self assert: anIdType equals: importedCustomer identificationType.
	self assert: anIdNumber equals: importedCustomer identificationNumber.

	^importedCustomer

	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:12:18'!
assertImportedRightNumberOfCustomers

	^ self assert: 2 equals: (session selectAllOfType: Customer) size! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:45'!
assertJuanPerezWasImportedCorrectly

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'C' number: '23-25666777-9' hasFirstName: 'Juan' lastName: 'Perez'.
	self assertAddressOf: importedCustomer at: 'Alem' hasNumber: 1122 town: 'CABA' zipCode: 1001 province: 'CABA'
	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:05'!
assertPepeSanchezWasImportedCorrecty

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'D' number: '22333444' hasFirstName: 'Pepe' lastName: 'Sanchez'.
	self assertAddressOf: importedCustomer at: 'San Martin' hasNumber: 3322 town: 'Olivos' zipCode: 1636 province: 'BsAs'.
	self assertAddressOf: importedCustomer at: 'Maipu' hasNumber: 888 town: 'Florida' zipCode: 1122 province: 'Buenos Aires'.


	! !


!ImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 00:27:50'!
setUp

	session := DataBaseSession for: (Array with: Address with: Customer).
	session beginTransaction.
! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 00:28:23'!
tearDown

	session commit.
	session close.
	! !


!ImportTest methodsFor: 'customer' stamp: 'HAW 5/22/2022 18:14:22'!
customerWithIdentificationType: anIdType number: anIdNumber

	^ (session
		select: [ :aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]]
		ofType: Customer) anyOne! !


!ImportTest methodsFor: 'test data' stamp: 'p 6/26/2023 20:36:17'!
emptyImportData

	^ ReadStream on: ''! !

!ImportTest methodsFor: 'test data' stamp: 'p 6/26/2023 20:47:33'!
importDataWithAddressBeforeCustomer

	^ ReadStream on: 'A,San Martin,3322,Olivos,1636'! !

!ImportTest methodsFor: 'test data' stamp: 'p 6/26/2023 21:21:37'!
importDataWithAdjacentCommas

	^ ReadStream on: 'C,Pepe,Sanchez,D,,22333444'! !

!ImportTest methodsFor: 'test data' stamp: 'p 6/26/2023 21:39:25'!
importDataWithInvalidEntryType

	^ ReadStream on: 'X,Pepe,Sanchez,D,22333444'! !

!ImportTest methodsFor: 'test data' stamp: 'p 6/26/2023 20:46:40'!
importDataWithNotEnoughAddressFields

	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636'! !

!ImportTest methodsFor: 'test data' stamp: 'p 6/26/2023 20:37:40'!
importDataWithNotEnoughCustomerFields

	^ ReadStream on: 'C,Pepe,Sanchez,D'! !

!ImportTest methodsFor: 'test data' stamp: 'p 6/26/2023 21:54:01'!
importDataWithValidFirstLetterButInvalidType

	^ ReadStream on: 'Customer,Pepe,Sanchez,D,22333444'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 18:08:08'!
validImportData

	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !


!classDefinition: #Address category: 'CustomerImporter'!
Object subclass: #Address
	instanceVariableNames: 'id streetName streetNumber town zipCode province'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province

	^province! !

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province: aProvince

	province := aProvince
	! !


!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 17:55:46'!
isAt: aStreetName

	^streetName = aStreetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName

	^streetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName: aStreetName

	streetName := aStreetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber

	^streetNumber ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber: aStreetNumber

	streetNumber := aStreetNumber ! !


!Address methodsFor: 'twon' stamp: 'HAW 5/22/2022 00:19:29'!
town

	^town! !

!Address methodsFor: 'twon' stamp: 'HAW 5/22/2022 00:19:29'!
town: aTown

	town := aTown! !


!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode

	^zipCode! !

!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode: aZipCode

	zipCode := aZipCode! !


!classDefinition: #Customer category: 'CustomerImporter'!
Object subclass: #Customer
	instanceVariableNames: 'id firstName lastName identificationType identificationNumber addresses'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addAddress: anAddress

	addresses add: anAddress ! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 17:55:17'!
addressAt: aStreetName ifNone: aNoneBlock

	^addresses detect: [ :address | address isAt: aStreetName ] ifNone: aNoneBlock ! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addresses

	^ addresses! !


!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
firstName

	^firstName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
firstName: aName

	firstName := aName! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName

	^lastName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName: aLastName

	lastName := aLastName
! !


!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber

	^identificationNumber ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber: anIdentificationNumber

	identificationNumber := anIdentificationNumber! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType

	^identificationType ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType: anIdentificationType

	identificationType := anIdentificationType! !


!Customer methodsFor: 'initialization' stamp: 'HAW 5/22/2022 00:19:29'!
initialize

	super initialize.
	addresses := OrderedCollection new.! !


!classDefinition: #CustomerImporter category: 'CustomerImporter'!
Object subclass: #CustomerImporter
	instanceVariableNames: 'session readStream record line newCustomer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'p 6/26/2023 20:38:13'!
initializeFrom: aReadStream into: aSession

	session := aSession.
	readStream := aReadStream.! !


!CustomerImporter methodsFor: 'evaluating' stamp: 'p 6/26/2023 21:25:22'!
createRecord

	record := line findTokens: $,.
	self raiseErrorIfAdjacentCommas.
	^ record! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'p 6/26/2023 20:22:15'!
hasLinesLeft

	line := readStream nextLine.
	^ line notNil.
	! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'p 6/26/2023 20:16:48'!
importAddress

	| newAddress |
	
	newAddress := Address new.
	newCustomer addAddress: newAddress.
	newAddress streetName: record second.
	newAddress streetNumber: record third asNumber .
	newAddress town: record fourth.
	newAddress zipCode: record fifth asNumber.
	newAddress province: record sixth.! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'p 6/26/2023 20:16:34'!
importCustomer

	newCustomer := Customer new.
	newCustomer firstName: record second.
	newCustomer lastName: record third.
	newCustomer identificationType: record fourth.
	newCustomer identificationNumber: record fifth.
	session persist: newCustomer.! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'p 6/26/2023 21:41:20'!
importRecord

	(self isCustomerRecord) ifTrue: [ 
		self raiseErrorIfRecordSizeIsNot: 5.
		self importCustomer.
		^ self ].
	
	(self isAddressRecord) ifTrue: [
		self raiseErrorIfAddressFoundBeforeCustomer.
		self raiseErrorIfRecordSizeIsNot: 6. 
		self importAddress.
		^ self ].
	
	self raiseInvalidEntryTypeError.! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'p 6/26/2023 21:55:09'!
isAddressRecord

	^ (record first = 'A')! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'p 6/26/2023 21:55:13'!
isCustomerRecord

	^ (record first = 'C')! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'p 6/26/2023 21:14:54'!
raiseErrorIfAddressFoundBeforeCustomer

	newCustomer ifNil: [
		self error: self class addressBeforeCustomerErrorDescription 
		].! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'p 6/26/2023 21:26:05'!
raiseErrorIfAdjacentCommas

	^ ((line occurrencesOf: $,) = (record size - 1)) ifFalse: [
		self error: self class adjacentCommasErrorDescription
		]! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'p 6/26/2023 21:37:54'!
raiseErrorIfRecordSizeIsNot: recordSize
	
	(record size = recordSize) ifFalse: [
		self error: self class notEnoughFieldsErrorDescription.
		]
		! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'p 6/26/2023 21:40:02'!
raiseInvalidEntryTypeError

	self error: self class invalidTypeOfEntryErrorDescription.! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'p 6/26/2023 20:22:35'!
value

	[ self hasLinesLeft ] whileTrue: [
		self createRecord.
		self importRecord.
		].

	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!

!CustomerImporter class methodsFor: 'instance creation' stamp: 'p 6/26/2023 21:47:37'!
from: aReadStream into: aSession
	
	(aReadStream isNil) ifTrue: [ self error: self nilStreamErrorDescription ].
	(aReadStream isEmpty) ifTrue: [ self error: self emptyStreamErrorDescription ].
	^ self new initializeFrom: aReadStream into: aSession! !


!CustomerImporter class methodsFor: 'error description' stamp: 'p 6/26/2023 21:12:17'!
addressBeforeCustomerErrorDescription

	^ 'Found an address before a customer >:('.! !

!CustomerImporter class methodsFor: 'error description' stamp: 'p 6/26/2023 21:22:15'!
adjacentCommasErrorDescription

	^ 'Found line with adjacent commas >:('.! !

!CustomerImporter class methodsFor: 'error description' stamp: 'p 6/26/2023 20:59:13'!
emptyStreamErrorDescription

	^ 'Stream is empty >:('.! !

!CustomerImporter class methodsFor: 'error description' stamp: 'p 6/26/2023 21:38:31'!
invalidTypeOfEntryErrorDescription

	^ 'Found line with invalid type of entry >:('.! !

!CustomerImporter class methodsFor: 'error description' stamp: 'p 6/26/2023 21:50:24'!
nilStreamErrorDescription
	
	^ 'Stream is nil >>>:((('! !

!CustomerImporter class methodsFor: 'error description' stamp: 'p 6/26/2023 21:37:54'!
notEnoughFieldsErrorDescription

	^ 'Found line with not enough fields >:('.! !


!CustomerImporter class methodsFor: 'importing' stamp: 'HAW 5/22/2022 18:11:27'!
valueFrom: aReadStream into: aSession

	^(self from: aReadStream into: aSession) value! !


!classDefinition: #DataBaseSession category: 'CustomerImporter'!
Object subclass: #DataBaseSession
	instanceVariableNames: 'configuration tables id'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 5/22/2022 00:19:29'!
beginTransaction

	! !

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 5/22/2022 19:17:36'!
commit

	(tables at: Customer ifAbsent: [#()]) do: [ :aCustomer | self persistAddressesOf: aCustomer ]
	! !


!DataBaseSession methodsFor: 'closing' stamp: 'HAW 5/22/2022 00:19:29'!
close

	! !


!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
defineIdOf: anObject

	anObject instVarNamed: 'id' put: (self newIdFor: anObject).! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
delay

	(Delay forMilliseconds: 100) wait! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 19:29:06'!
objectsOfType: aType

	^ tables at: aType ifAbsent: [ #() ]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
persistAddressesOf: anObjectWithAddresses

	anObjectWithAddresses addresses do: [ :anAddress | self persist: anAddress ]
	! !


!DataBaseSession methodsFor: 'initialization' stamp: 'HAW 5/22/2022 00:19:29'!
initializeFor: aConfiguration

	configuration := aConfiguration.
	tables := Dictionary new.
	id := 0.! !


!DataBaseSession methodsFor: 'id' stamp: 'HAW 5/22/2022 00:19:29'!
newIdFor: anObject

	id := id + 1.
	^id! !


!DataBaseSession methodsFor: 'persistance' stamp: 'HAW 5/22/2022 00:19:29'!
persist: anObject

	| table |

	self delay.
	table := tables at: anObject class ifAbsentPut: [ Set new ].

	self defineIdOf: anObject.
	table add: anObject.

	(anObject isKindOf: Customer) ifTrue: [ self persistAddressesOf: anObject ].! !


!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 5/22/2022 19:29:06'!
select: aCondition ofType: aType

	self delay.
	^(self objectsOfType: aType) select: aCondition ! !

!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 5/22/2022 19:29:06'!
selectAllOfType: aType

	self delay.
	^(self objectsOfType: aType) copy ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DataBaseSession class' category: 'CustomerImporter'!
DataBaseSession class
	instanceVariableNames: ''!

!DataBaseSession class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 00:19:29'!
for: aConfiguration

	^self new initializeFor: aConfiguration! !
