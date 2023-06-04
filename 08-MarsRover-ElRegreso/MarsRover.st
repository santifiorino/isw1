!classDefinition: #MarsRover category: 'MarsRover-WithHeading'!
Object subclass: #MarsRover
	instanceVariableNames: 'position head proxy'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRover methodsFor: 'exceptions' stamp: 'HAW 6/30/2018 19:48:45'!
invalidCommandErrorDescription
	
	^'Invalid command'! !

!MarsRover methodsFor: 'exceptions' stamp: 'HAW 6/30/2018 19:50:26'!
signalInvalidCommand
	
	self error: self invalidCommandErrorDescription ! !


!MarsRover methodsFor: 'initialization' stamp: 'SF 6/4/2023 19:37:10'!
initializeAt: aPosition heading: aHeadingType
	position := aPosition.
	proxy := MarsRoverObserverProxy new initialize.
	head := aHeadingType for: self.! !


!MarsRover methodsFor: 'heading' stamp: 'SF 6/4/2023 17:35:08'!
headEast
	head := MarsRoverHeadingEast for: self.! !

!MarsRover methodsFor: 'heading' stamp: 'SF 6/4/2023 17:35:11'!
headNorth
	head := MarsRoverHeadingNorth for: self.! !

!MarsRover methodsFor: 'heading' stamp: 'SF 6/4/2023 17:35:15'!
headSouth
	head := MarsRoverHeadingSouth for: self.! !

!MarsRover methodsFor: 'heading' stamp: 'SF 6/4/2023 17:35:18'!
headWest
	head := MarsRoverHeadingWest for: self.! !

!MarsRover methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	head rotateLeft! !

!MarsRover methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	head rotateRight! !


!MarsRover methodsFor: 'testing' stamp: 'HAW 10/7/2021 20:16:32'!
isAt: aPosition heading: aHeadingType

	^position = aPosition and: [ head isHeading: aHeadingType ]! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:16:51'!
isBackwardCommand: aCommand

	^aCommand = $b! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:16:19'!
isForwardCommand: aCommand

	^aCommand = $f ! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:17:51'!
isRotateLeftCommand: aCommand

	^aCommand = $l! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:17:21'!
isRotateRightCommand: aCommand

	^aCommand = $r! !


!MarsRover methodsFor: 'moving' stamp: 'SF 6/4/2023 17:35:24'!
moveBackward
	head moveBackward.
	! !

!MarsRover methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:15:01'!
moveEast
	
	position := position + (1@0)! !

!MarsRover methodsFor: 'moving' stamp: 'SF 6/4/2023 17:35:28'!
moveForward
	head moveForward! !

!MarsRover methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:13:12'!
moveNorth
	
	position := position + (0@1)! !

!MarsRover methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:13:34'!
moveSouth
	
	position := position + (0@-1)! !

!MarsRover methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:15:32'!
moveWest
	
	position := position + (-1@0)! !


!MarsRover methodsFor: 'command processing' stamp: 'HAW 6/30/2018 19:48:26'!
process: aSequenceOfCommands

	aSequenceOfCommands do: [:aCommand | self processCommand: aCommand ]
! !

!MarsRover methodsFor: 'command processing' stamp: 'SF 6/4/2023 18:08:48'!
processCommand: aCommand
	(self isForwardCommand: aCommand) ifTrue: [
		self moveForward.
		^ proxy positionModifiedTo: position.
	].
	(self isBackwardCommand: aCommand) ifTrue: [
		self moveBackward.
		^ proxy positionModifiedTo: position.
	].
	(self isRotateRightCommand: aCommand) ifTrue: [
		self rotateRight.
		^ proxy directionModifiedTo: head.
	].
	(self isRotateLeftCommand: aCommand) ifTrue: [
		self rotateLeft.
		^ proxy directionModifiedTo: head.
	].
	self signalInvalidCommand.! !


!MarsRover methodsFor: 'observers' stamp: 'SF 6/4/2023 18:36:18'!
addObserver: aMarsRoverObserver thatObserves: aCollectionOfAttributes

	proxy addObserver: aMarsRoverObserver thatObserves: aCollectionOfAttributes
	
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRover-WithHeading'!
MarsRover class
	instanceVariableNames: 'headings'!

!MarsRover class methodsFor: 'instance creation' stamp: 'HAW 10/7/2021 20:10:30'!
at: aPosition heading: aHeadingType
	
	^self new initializeAt: aPosition heading: aHeadingType! !


!classDefinition: #MarsRoverHeading category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverHeading
	instanceVariableNames: 'marsRover'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeading methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight

	self subclassResponsibility ! !


!MarsRoverHeading methodsFor: 'testing' stamp: 'HAW 10/7/2021 20:15:38'!
isHeading: aHeadingType

	^self isKindOf: aHeadingType ! !


!MarsRoverHeading methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward

	self subclassResponsibility ! !


!MarsRoverHeading methodsFor: 'initialization' stamp: 'HAW 10/7/2021 20:11:59'!
initializeFor: aMarsRover 
	
	marsRover := aMarsRover.! !


!MarsRoverHeading methodsFor: 'accessing' stamp: 'SF 6/4/2023 19:38:50'!
headingDirectionString

	self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverHeading class' category: 'MarsRover-WithHeading'!
MarsRoverHeading class
	instanceVariableNames: ''!

!MarsRoverHeading class methodsFor: 'instance creation' stamp: 'HAW 10/7/2021 20:11:35'!
for: aMarsRover 
	
	^self new initializeFor: aMarsRover ! !


!classDefinition: #MarsRoverHeadingEast category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingEast
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveWest! !

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveEast! !


!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headNorth! !

!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headSouth! !


!MarsRoverHeadingEast methodsFor: 'accessing' stamp: 'SF 6/4/2023 17:44:50'!
headingDirectionString

	^ 'Este'.! !


!classDefinition: #MarsRoverHeadingNorth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingNorth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveSouth! !

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveNorth! !


!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headWest! !

!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headEast! !


!MarsRoverHeadingNorth methodsFor: 'accessing' stamp: 'SF 6/4/2023 17:44:54'!
headingDirectionString

	^ 'Norte'! !


!classDefinition: #MarsRoverHeadingSouth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingSouth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveNorth! !

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveSouth! !


!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headEast! !

!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headWest! !


!MarsRoverHeadingSouth methodsFor: 'accessing' stamp: 'SF 6/4/2023 17:44:59'!
headingDirectionString

	^ 'Sur'! !


!classDefinition: #MarsRoverHeadingWest category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingWest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward

	^marsRover moveEast! !

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveWest! !


!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headSouth! !

!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headNorth! !


!MarsRoverHeadingWest methodsFor: 'accessing' stamp: 'SF 6/4/2023 17:45:06'!
headingDirectionString

	^ 'Oeste'! !


!classDefinition: #MarsRoverObserver category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverObserver
	instanceVariableNames: 'rover observations'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverObserver methodsFor: 'initialization' stamp: 'SF 6/4/2023 18:39:24'!
of: aMarsRover thatObserves: aCollectionOfAttributes

	self subclassResponsibility ! !


!MarsRoverObserver methodsFor: 'printing' stamp: 'SF 6/4/2023 18:56:20'!
print

	self subclassResponsibility.! !


!classDefinition: #Logger category: 'MarsRover-WithHeading'!
MarsRoverObserver subclass: #Logger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!Logger methodsFor: 'updating' stamp: 'SF 6/4/2023 17:50:37'!
directionModifiedTo: newHead

	observations add: newHead headingDirectionString.! !

!Logger methodsFor: 'updating' stamp: 'SF 6/4/2023 17:50:40'!
positionModifiedTo: newPosition

	observations add: newPosition.! !


!Logger methodsFor: 'initialization' stamp: 'SF 6/4/2023 18:40:37'!
of: aMarsRover thatObserves: aCollectionOfAttributes

	observations := OrderedCollection new.
	aMarsRover addObserver: self thatObserves: aCollectionOfAttributes.! !


!Logger methodsFor: 'printing' stamp: 'SF 6/4/2023 18:56:27'!
print

	^ observations.! !


!classDefinition: #Window category: 'MarsRover-WithHeading'!
MarsRoverObserver subclass: #Window
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!Window methodsFor: 'updating' stamp: 'SF 6/4/2023 18:55:12'!
directionModifiedTo: newHead

	observations at: 'Direction' put: 'Apuntando al ', newHead headingDirectionString.! !

!Window methodsFor: 'updating' stamp: 'SF 6/4/2023 18:55:01'!
positionModifiedTo: newPosition

	observations at: 'Position' put: newPosition.! !


!Window methodsFor: 'initialization' stamp: 'SF 6/4/2023 18:54:51'!
of: aMarsRover thatObserves: aCollectionOfAttributes

	observations := Dictionary new.
	aCollectionOfAttributes do: [ :anAttribute | observations at: anAttribute put: NullWindowEntry ].
	aMarsRover addObserver: self thatObserves: aCollectionOfAttributes.! !


!Window methodsFor: 'printing' stamp: 'SF 6/4/2023 18:58:42'!
print

	| res |
	res := OrderedCollection new.
	res addAll: observations values.
	^  res.! !


!classDefinition: #MarsRoverObserverProxy category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverObserverProxy
	instanceVariableNames: 'observers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverObserverProxy methodsFor: 'auxiliar' stamp: 'SF 6/4/2023 19:50:42'!
forEachObserversOfAttribute: anAttribute do: aClosure

	(observers includesKey: anAttribute) ifTrue: [	
		(observers at: anAttribute) do: [ :anObserver |
			aClosure value: anObserver.
			].
		].! !

!MarsRoverObserverProxy methodsFor: 'auxiliar' stamp: 'SF 6/4/2023 19:11:18'!
observersDictionaryAt: anAttribute put: anObserver
	
	(observers includesKey: anAttribute) ifFalse: [observers at: anAttribute put: OrderedCollection new].
	(observers at: anAttribute) add: anObserver.
		! !


!MarsRoverObserverProxy methodsFor: 'notifying' stamp: 'SF 6/4/2023 19:51:25'!
directionModifiedTo: newHead
	
	self forEachObserversOfAttribute: 'Direction' do: [ :anObserver | anObserver directionModifiedTo: newHead ].! !

!MarsRoverObserverProxy methodsFor: 'notifying' stamp: 'SF 6/4/2023 19:51:44'!
positionModifiedTo: newPosition

	self forEachObserversOfAttribute: 'Position' do: [ :anObserver | anObserver positionModifiedTo: newPosition ].! !


!MarsRoverObserverProxy methodsFor: 'observers' stamp: 'SF 6/4/2023 19:11:53'!
addObserver: aMarsRoverObserver thatObserves: aCollectionOfAttributes

	aCollectionOfAttributes do: [ :anAttribute |
		self observersDictionaryAt: anAttribute put: aMarsRoverObserver.
	].
		! !


!MarsRoverObserverProxy methodsFor: 'initialization' stamp: 'SF 6/4/2023 18:28:54'!
initialize

	observers := 	Dictionary new.! !


!classDefinition: #NullWindowEntry category: 'MarsRover-WithHeading'!
Object subclass: #NullWindowEntry
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!
!classDefinition: #MarsRoverLogAndWindowTest category: 'MarsRover-WithHeading-Tests'!
TestCase subclass: #MarsRoverLogAndWindowTest
	instanceVariableNames: 'directionAndPosition direction position'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading-Tests'!

!MarsRoverLogAndWindowTest methodsFor: 'as yet unclassified' stamp: 'SF 6/4/2023 19:31:34'!
newRover

	^ MarsRover at: 0@0 heading: MarsRoverHeadingNorth.! !

!MarsRoverLogAndWindowTest methodsFor: 'as yet unclassified' stamp: 'SF 6/4/2023 19:35:34'!
setUp

	directionAndPosition := OrderedCollection with: 'Direction' with: 'Position'.
	direction := OrderedCollection with: 'Direction'.
	position := OrderedCollection with: 'Position'.! !


!MarsRoverLogAndWindowTest methodsFor: 'tests' stamp: 'SF 6/4/2023 19:33:49'!
test01LoggerHasNoEntriesIfItsRoverDidntChangeState

	| rover roverLogger|
	
	rover := self newRover.
	roverLogger := Logger new of: rover thatObserves: directionAndPosition.
	
	self assert: roverLogger print isEmpty.! !

!MarsRoverLogAndWindowTest methodsFor: 'tests' stamp: 'SF 6/4/2023 19:34:04'!
test02WindowHasNullEntriesIfItsRoverDidntChangeState
	
	| rover roverWindow|
	
	rover := self newRover.
	roverWindow := Window new of: rover thatObserves: directionAndPosition.
	
	self assert: (OrderedCollection with: NullWindowEntry with: NullWindowEntry)
	 equals: roverWindow print.! !

!MarsRoverLogAndWindowTest methodsFor: 'tests' stamp: 'SF 6/4/2023 19:34:28'!
test03LoggerSavesChangesInPosition

	| rover roverLogger |
	
	rover := self newRover.
	roverLogger := Logger new of: rover thatObserves: directionAndPosition.
	rover process: 'fb'.
	
	self assert: (OrderedCollection with: 0@1 with: 0@0)
		equals: roverLogger print.! !

!MarsRoverLogAndWindowTest methodsFor: 'tests' stamp: 'SF 6/4/2023 19:34:42'!
test04WindowSavesRoversPositionAfterLastMovement

	| rover roverWindow|
	
	rover := self newRover.
	roverWindow := Window new of: rover thatObserves: directionAndPosition.
	rover process: 'fb'.
	
	self assert: (OrderedCollection with: 0@0 with: NullWindowEntry)
	 equals: roverWindow print.! !

!MarsRoverLogAndWindowTest methodsFor: 'tests' stamp: 'SF 6/4/2023 19:34:56'!
test05LoggerSavesChangesInDirection

	| rover roverLogger |
	
	rover := self newRover.
	roverLogger := Logger new of: rover thatObserves: directionAndPosition.
	rover process: 'rl'.
	
	self assert: (OrderedCollection with: 'Este' with: 'Norte')
		equals: roverLogger print.! !

!MarsRoverLogAndWindowTest methodsFor: 'tests' stamp: 'SF 6/4/2023 19:35:06'!
test06WindowSavesRoversDirectionAfterLastRotation
	
	| rover roverWindow |
	
	rover := self newRover.
	roverWindow := Window new of: rover thatObserves: directionAndPosition.
	rover process: 'rl'.
	
	self assert: (OrderedCollection with: NullWindowEntry with: 'Apuntando al Norte')
	 equals: roverWindow print.! !

!MarsRoverLogAndWindowTest methodsFor: 'tests' stamp: 'SF 6/4/2023 19:35:50'!
test07LoggerThatObservesDirectionOnlySavesDirectionChanges

	| rover roverLogger |
	
	rover := self newRover.
	roverLogger := Logger new of: rover thatObserves: direction.
	rover process: 'fbrl'.
	
	self assert: (OrderedCollection with: 'Este' with: 'Norte')
		equals: roverLogger print.! !

!MarsRoverLogAndWindowTest methodsFor: 'tests' stamp: 'SF 6/4/2023 19:36:02'!
test08LoggerThatObservesPositionOnlySavesPositionChanges

	| rover roverLogger|
	
	rover := self newRover.
	roverLogger := Logger new of: rover thatObserves: position.
	rover process: 'fbrl'.
	
	self assert: (OrderedCollection with: 0@1 with: 0@0)
		equals: roverLogger print.! !

!MarsRoverLogAndWindowTest methodsFor: 'tests' stamp: 'SF 6/4/2023 19:36:13'!
test09WindowThatObservesDirectionOnlySavesLastChangeOfDirection
	
	| rover roverWindow|
	
	rover := self newRover.
	roverWindow := Window new of: rover thatObserves: direction.
	rover process: 'fbrlfb'.
	
	self assert: (OrderedCollection with: 'Apuntando al Norte')
	 equals: roverWindow print.! !

!MarsRoverLogAndWindowTest methodsFor: 'tests' stamp: 'SF 6/4/2023 19:36:27'!
test10WindowThatObservesPositionOnlySavesLastChangeOfPosition
	
	| rover roverWindow|
	
	rover := self newRover.
	roverWindow := Window new of: rover thatObserves: position.
	rover process: 'frlb'.
	
	self assert: (OrderedCollection with: 0@0)
	 equals: roverWindow print.! !


!classDefinition: #MarsRoverTest category: 'MarsRover-WithHeading-Tests'!
TestCase subclass: #MarsRoverTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading-Tests'!

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:21:23'!
test01DoesNotMoveWhenNoCommand

	self 
		assertIsAt: 1@2 
		heading: self north 
		afterProcessing: '' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:12'!
test02IsAtFailsForDifferentPosition

	| marsRover |
	
	marsRover := MarsRover at: 1@1 heading: self north . 
	
	self deny: (marsRover isAt: 1@2 heading: self north)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:31'!
test03IsAtFailsForDifferentHeading

	| marsRover |
	
	marsRover := MarsRover at: 1@1 heading: self north . 
	
	self deny: (marsRover isAt: 1@1 heading: self south)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:30:17'!
test04IncrementsYAfterMovingForwardWhenHeadingNorth

	self 
		assertIsAt: 1@3 
		heading: self north 
		afterProcessing: 'f' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:30:11'!
test06DecrementsYAfterMovingBackwardsWhenHeadingNorth

	self 
		assertIsAt: 1@1 
		heading: self north 
		afterProcessing: 'b' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:59'!
test07PointToEashAfterRotatingRightWhenHeadingNorth

	self 
		assertIsAt: 1@2 
		heading: self east 
		afterProcessing: 'r' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:51'!
test08PointsToWestAfterRotatingLeftWhenPointingNorth

	self 
		assertIsAt: 1@2 
		heading: self west 
		afterProcessing: 'l' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:45'!
test09DoesNotProcessInvalidCommand

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: self north.
	
	self 
		should: [ marsRover process: 'x' ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: marsRover invalidCommandErrorDescription.
			self assert: (marsRover isAt: 1@2 heading: self north) ]! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:39'!
test10CanProcessMoreThanOneCommand

	self 
		assertIsAt: 1@4 
		heading: self north 
		afterProcessing: 'ff' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:31'!
test11IncrementsXAfterMovingForwareWhenHeadingEast

	self 
		assertIsAt: 2@2 
		heading: self east 
		afterProcessing: 'f' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:19'!
test12DecrementsXAfterMovingBackwardWhenHeadingEast

	self 
		assertIsAt: 0@2 
		heading: self east 
		afterProcessing: 'b' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:14'!
test13PointsToSouthAfterRotatingRightWhenHeadingEast

		self 
		assertIsAt: 1@2 
		heading: self south 
		afterProcessing: 'r' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:05'!
test14PointsToNorthAfterRotatingLeftWhenPointingEast

		self 
		assertIsAt: 1@2 
		heading: self north 
		afterProcessing: 'l' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:00'!
test15ForwardBackwardsAndRotateRightWorkAsExpectedWhenPointingSouth

	self 
		assertIsAt: 1@1 
		heading: self west 
		afterProcessing: 'ffblrr' 
		whenStartingAt: 1@2 
		heading: self south 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:52'!
test16ForwardBackwardsAndRotateRightWorkAsExpectedWhenPointingWest

	self 
		assertIsAt: 0@2 
		heading: self north 
		afterProcessing: 'ffblrr' 
		whenStartingAt: 1@2 
		heading: self west 
! !


!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:31'!
east

	^ MarsRoverHeadingEast ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:38'!
north

	^ MarsRoverHeadingNorth ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:45'!
south

	^ MarsRoverHeadingSouth ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:54'!
west

	^ MarsRoverHeadingWest ! !


!MarsRoverTest methodsFor: 'assertions' stamp: 'HAW 10/7/2021 20:20:47'!
assertIsAt: newPosition heading: newHeadingType afterProcessing: commands whenStartingAt: startPosition heading: startHeadingType

	| marsRover |
	
	marsRover := MarsRover at: startPosition heading: startHeadingType. 
	
	marsRover process: commands.
	
	self assert: (marsRover isAt: newPosition heading: newHeadingType)! !
