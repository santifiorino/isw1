!classDefinition: #StreamSimulator category: 'CustomerImporter'!
UniFileStream subclass: #StreamSimulator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!StreamSimulator methodsFor: 'initialization' stamp: 'sdf 6/25/2023 16:54:26'!
initialize

	collection := OrderedCollection new.
	position := 1.! !


!StreamSimulator methodsFor: 'accessing' stamp: 'sdf 6/25/2023 16:54:40'!
nextLine

	| line |
	
	[ line := collection at: position ] on: Error do: [ ^nil ].
	position := position + 1.
	^ line.
	! !


!StreamSimulator methodsFor: 'read, write, position' stamp: 'sdf 6/25/2023 16:54:55'!
nextPutAll: lineToAdd

	collection add: lineToAdd! !


!classDefinition: #ImportTest category: 'CustomerImporter'!
TestCase subclass: #ImportTest
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'asserting' stamp: 'sdf 6/25/2023 15:57:36'!
assertAmountOfAddressesIs: amountOfAddresses

	^ self assert: amountOfAddresses equals: ((session selectAllOfType: Customer) sum: [ :customer | customer addresses size ])! !

!ImportTest methodsFor: 'asserting' stamp: 'sdf 6/25/2023 15:56:39'!
assertAmountOfCustomersIs: amountOfCustomers

	^ self assert: amountOfCustomers equals: (session selectAllOfType: Customer) size! !

!ImportTest methodsFor: 'asserting' stamp: 'sdf 6/25/2023 15:52:23'!
assertCustomer: aCustomer hasAddressAtStreet: streetName atNumber: streetNumber atTown: town withZipCode: zipCode atProvince: province

	| addresses |

	addresses := aCustomer addressesAtStreet: streetName.
	
	self assert: (addresses anySatisfy: [ :anAddress |
		(streetNumber = anAddress streetNumber) and:
		(town = anAddress town) and:
		(zipCode = anAddress zipCode) and:
		(province = anAddress province)
	]).! !

!ImportTest methodsFor: 'asserting' stamp: 'sdf 6/25/2023 15:28:24'!
assertCustomer: aCustomer hasFirstName: customerName andLastName: customerLastName andAmountOfAddresses: amountOfAddresses   

	self assert: customerName equals: aCustomer firstName.
	self assert: customerLastName equals: aCustomer lastName.
	self assert: amountOfAddresses equals: aCustomer addresses size! !

!ImportTest methodsFor: 'asserting' stamp: 'sdf 6/25/2023 16:19:25'!
assertDBHasCustomer: aCustomer

	| customerInDB |

	self assertThereIsOnlyOneCustomerWithIDType: aCustomer identificationType andIDNumber: aCustomer identificationNumber.
	
	customerInDB := self customerWithIDType: aCustomer identificationType andIDNumber: aCustomer identificationNumber.

	self assertCustomer: customerInDB hasFirstName: aCustomer firstName andLastName: aCustomer lastName andAmountOfAddresses: aCustomer amountOfAddresses.
	
	aCustomer addresses do: [ :anAddress |
		self assertCustomer: customerInDB hasAddressAtStreet: anAddress streetName atNumber: anAddress streetNumber atTown: anAddress town withZipCode: anAddress zipCode atProvince: anAddress province.	
		].! !

!ImportTest methodsFor: 'asserting' stamp: 'sdf 6/25/2023 15:37:31'!
assertThereIsOnlyOneCustomerWithIDType: idType andIDNumber: idNumber

	| customers |

	customers := self selectCustomersWithIDType: idType andIDNumber: idNumber.
	
	self assert: 1 equals: customers size.! !


!ImportTest methodsFor: 'tests' stamp: 'sdf 6/25/2023 16:55:47'!
test01Import

	self importCustomersFromStream: self streamForTest01.
	
	self assertAmountOfCustomersIs: 2.
	
	self assertAmountOfAddressesIs: 3.
	
	self assertDBHasCustomer: self pepe.
	
	self assertDBHasCustomer: self juan.! !


!ImportTest methodsFor: 'auxiliar' stamp: 'sdf 6/25/2023 15:37:52'!
customerWithIDType: idType andIDNumber: idNumber 

	| customers |

	customers := self selectCustomersWithIDType: idType andIDNumber: idNumber.
	
	^customers atRandom.! !

!ImportTest methodsFor: 'auxiliar' stamp: 'sdf 6/25/2023 16:47:57'!
importCustomersFromStream: inputStream

	(CustomerImporter forSession: session readingFrom: inputStream) value! !

!ImportTest methodsFor: 'auxiliar' stamp: 'sdf 6/25/2023 16:18:17'!
juan

	| aCustomer firstAddress |
	
	aCustomer := Customer new.
	aCustomer firstName: 'Juan'.
	aCustomer lastName: 'Perez'.
	aCustomer identificationType: 'C'.
	aCustomer identificationNumber: '23-25666777-9'.
	
	firstAddress := Address new.
	firstAddress streetName: 'Alem'.
	firstAddress streetNumber: 1122.
	firstAddress town: 'CABA'.
	firstAddress zipCode: 1001.
	firstAddress province: 'CABA'.
	
	aCustomer addAddress: firstAddress.
	
	^ aCustomer.
		! !

!ImportTest methodsFor: 'auxiliar' stamp: 'sdf 6/25/2023 16:08:51'!
pepe

	| aCustomer firstAddress secondAddress |
	
	aCustomer := Customer new.
	aCustomer firstName: 'Pepe'.
	aCustomer lastName: 'Sanchez'.
	aCustomer identificationType: 'D'.
	aCustomer identificationNumber: '22333444'.
	
	firstAddress := Address new.
	firstAddress streetName: 'San Martin'.
	firstAddress streetNumber: 3322.
	firstAddress town: 'Olivos'.
	firstAddress zipCode: 1636.
	firstAddress province: 'BsAs'.
	
	secondAddress := Address new.
	secondAddress streetName: 'Maipu'.
	secondAddress streetNumber: 888.
	secondAddress town: 'Florida'.
	secondAddress zipCode: 1122.
	secondAddress province: 'Buenos Aires'.
	
	aCustomer addAddress: firstAddress.
	aCustomer addAddress: secondAddress.
	
	^ aCustomer.
		! !

!ImportTest methodsFor: 'auxiliar' stamp: 'sdf 6/25/2023 15:38:34'!
selectCustomersWithIDType: idType andIDNumber: idNumber

	^ session select: [ :customer |
		customer identificationType = idType and:
		customer identificationNumber = idNumber
		] ofType: Customer! !

!ImportTest methodsFor: 'auxiliar' stamp: 'sdf 6/25/2023 16:50:16'!
streamForTest01

	| streamSim |
	
	streamSim := StreamSimulator new initialize.
	streamSim nextPutAll: 'C,Pepe,Sanchez,D,22333444'.
	streamSim nextPutAll: 'A,San Martin,3322,Olivos,1636,BsAs'.
	streamSim nextPutAll: 'A,Maipu,888,Florida,1122,Buenos Aires'.
	streamSim nextPutAll: 'C,Juan,Perez,C,23-25666777-9'.
	streamSim nextPutAll: 'A,Alem,1122,CABA,1001,CABA'.
	
	^ streamSim.! !


!ImportTest methodsFor: 'setUp/tearDown' stamp: 'SF 6/22/2023 20:32:27'!
setUp

	session := DataBaseSession for: (Array with: Address with: Customer).
	session beginTransaction! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'SF 6/22/2023 20:34:16'!
tearDown

	session commit.
	session close! !


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


!Address methodsFor: 'town' stamp: 'HAW 5/22/2022 00:19:29'!
town

	^town! !

!Address methodsFor: 'town' stamp: 'HAW 5/22/2022 00:19:29'!
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

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addresses

	^ addresses! !

!Customer methodsFor: 'addresses' stamp: 'SF 6/22/2023 21:36:50'!
addressesAtStreet: streetName

	^ addresses select: [ :anAddress | anAddress streetName = streetName ]! !


!Customer methodsFor: 'name' stamp: 'sdf 6/25/2023 16:12:44'!
amountOfAddresses

	^ addresses size.! !

!Customer methodsFor: 'name' stamp: 'SF 6/22/2023 21:46:10'!
firstName

	^ firstName ! !

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
	instanceVariableNames: 'session inputStream'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'sdf 6/25/2023 16:47:23'!
initializeForSession: aSession readingFrom: anInputStream

	session := aSession.
	inputStream := anInputStream.! !


!CustomerImporter methodsFor: 'evaluating' stamp: 'sdf 6/25/2023 16:47:07'!
value

	| newCustomer line |
	line := inputStream nextLine.
	[ line notNil ] whileTrue: [
		(line beginsWith: 'C') ifTrue: [ | customerData |
			customerData := line findTokens: $,.
			newCustomer := Customer new.
			newCustomer firstName: customerData second.
			newCustomer lastName: customerData third.
			newCustomer identificationType: customerData fourth.
			newCustomer identificationNumber: customerData fifth.
			session persist: newCustomer ].

		(line beginsWith: 'A') ifTrue: [ | addressData newAddress |
			addressData := line findTokens: $,.
			newAddress := Address new.
			newCustomer addAddress: newAddress.
			newAddress streetName: addressData second.
			newAddress streetNumber: addressData third asNumber.
			newAddress town: addressData fourth.
			newAddress zipCode: addressData fifth asNumber.
			newAddress province: addressData sixth ].
		line := inputStream nextLine. ].
	inputStream close.
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!

!CustomerImporter class methodsFor: 'instance creation' stamp: 'sdf 6/25/2023 16:47:07'!
forSession: aSession readingFrom: anInputStream
	^self new initializeForSession: aSession readingFrom: anInputStream! !


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
