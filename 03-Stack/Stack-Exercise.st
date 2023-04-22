!classDefinition: #OOStackTest category: 'Stack-Exercise'!
TestCase subclass: #OOStackTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:30'!
test01StackShouldBeEmptyWhenCreated

	| stack |
	
	stack := OOStack new.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:29:55'!
test02PushAddElementsToTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	
	self deny: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:01'!
test03PopRemovesElementsFromTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:09'!
test04PopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	stack push: pushedObject.
	
	self assert: stack pop = pushedObject! !

!OOStackTest methodsFor: 'test' stamp: 'NR 9/16/2021 17:40:17'!
test05StackBehavesLIFO

	| stack firstPushedObject secondPushedObject |
	
	stack := OOStack new.
	firstPushedObject := 'firstSomething'.
	secondPushedObject := 'secondSomething'.
	
	stack push: firstPushedObject.
	stack push: secondPushedObject.
	
	self assert: stack pop = secondPushedObject.
	self assert: stack pop = firstPushedObject.
	self assert: stack isEmpty 
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:20'!
test06TopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack top = pushedObject.
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:24'!
test07TopDoesNotRemoveObjectFromStack

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack size = 1.
	stack top.
	self assert: stack size = 1.
	! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:26'!
test08CanNotPopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:31'!
test09CanNotPopWhenThereAreNoObjectsInTheStackAndTheStackHadObjects

	| stack  |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:44'!
test10CanNotTopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack top ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !


!classDefinition: #SentenceFinderByPrefixTest category: 'Stack-Exercise'!
TestCase subclass: #SentenceFinderByPrefixTest
	instanceVariableNames: 'stack prefix sentenceFinder actualResult expectedResult'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefixTest methodsFor: 'as yet unclassified' stamp: 'SF 4/22/2023 18:13:49'!
setUp

	sentenceFinder := SentenceFinderByPrefix new.! !

!SentenceFinderByPrefixTest methodsFor: 'as yet unclassified' stamp: 'SF 4/22/2023 18:13:57'!
test00EmptyStackReturnsEmptyCollection
	
	prefix := 'test'.
	stack := OOStack new.
	
	actualResult := sentenceFinder selectElementsFromStack: stack withPrefix: prefix.
	expectedResult := OrderedCollection new.
	
	self assert: actualResult = expectedResult.
	! !

!SentenceFinderByPrefixTest methodsFor: 'as yet unclassified' stamp: 'JPL 4/22/2023 18:57:34'!
test01PrefixCannotBeEmpty
	
	prefix := ''.
	stack := OOStack new.
	self 
		should: [sentenceFinder selectElementsFromStack: stack withPrefix: prefix.]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: SentenceFinderByPrefix emptyPrefixErrorDescription].
	! !

!SentenceFinderByPrefixTest methodsFor: 'as yet unclassified' stamp: 'SF 4/22/2023 18:34:47'!
test02PrefixCannotHaveWhitespace
	
	prefix := 'aa bb'.
	stack := OOStack new.
	self 
		should: [sentenceFinder selectElementsFromStack: stack withPrefix: prefix.]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: SentenceFinderByPrefix prefixContainsWhitespaceErrorDescription].
	! !

!SentenceFinderByPrefixTest methodsFor: 'as yet unclassified' stamp: 'SF 4/22/2023 18:17:28'!
test03PrefixIsCaseSensitive

	prefix := 'di'.
	
	stack := OOStack new.
	stack push: 'discord'.
	stack push: 'Dije'.
	stack push: 'dije'.
	
	actualResult := sentenceFinder selectElementsFromStack: stack withPrefix: prefix.
	
	expectedResult := OrderedCollection new.
	expectedResult add: 'discord'.
	expectedResult add: 'dije'.
	
	self assert: actualResult = expectedResult.
	! !

!SentenceFinderByPrefixTest methodsFor: 'as yet unclassified' stamp: 'JPL 4/22/2023 19:07:33'!
test04AllMatchesOfNonEmptyPrefixAreFound
	
	prefix := 'ho'.
	
	stack := OOStack new.
	stack push: 'horario'.
	stack push: 'hola'.
	stack push: 'hijo'.
	stack push: 'ho'.
	stack push: 'h'.
	
	actualResult := sentenceFinder selectElementsFromStack: stack withPrefix: prefix.
	
	expectedResult := OrderedCollection new.
	expectedResult add: 'horario'.
	expectedResult add: 'hola'.
	expectedResult add: 'ho'.
	
	self assert: actualResult = expectedResult.
	! !

!SentenceFinderByPrefixTest methodsFor: 'as yet unclassified' stamp: 'JPL 4/22/2023 19:04:12'!
test05StackRemainsIntactAfterBeingSearched
	|stackCopy|

	prefix := 'di'.
	
	stack := OOStack new.
	stack push: 'discord'.
	stack push: 'Dije'.
	stack push: 'dije'.
	
	stackCopy := OOStack new.
	stackCopy push: 'discord'.
	stackCopy push: 'Dije'.
	stackCopy push: 'dije'.
	
	actualResult := sentenceFinder selectElementsFromStack: stack withPrefix: prefix.
	
	1 to: stack size do: [:x | self assert: stack pop = stackCopy pop ]
	! !

!SentenceFinderByPrefixTest methodsFor: 'as yet unclassified' stamp: 'JPL 4/22/2023 19:10:46'!
test06EmptyListIsReturnedIfPrefixNotFound

	prefix := 'unPrefijoNoPresente'.
	
	stack := OOStack new.
	stack push: 'discord'.
	stack push: 'Dije'.
	stack push: 'dije'.

	actualResult := sentenceFinder selectElementsFromStack: stack withPrefix: prefix.
	
	self assert: actualResult  = OrderedCollection new.! !

!SentenceFinderByPrefixTest methodsFor: 'as yet unclassified' stamp: 'JPL 4/22/2023 19:21:41'!
test07WhitespaceShouldNotCountForPrefix

	prefix := 'di'.
	
	stack := OOStack new.
	stack push: ' discord'.
	stack push: '  Dije'.
	stack push: 'dije'.

	actualResult := sentenceFinder selectElementsFromStack: stack withPrefix: prefix.
	
	expectedResult := OrderedCollection new.
	expectedResult add: 'dije'.
	
	self assert: actualResult  = expectedResult .! !

!SentenceFinderByPrefixTest methodsFor: 'as yet unclassified' stamp: 'JPL 4/22/2023 19:24:05'!
test08WordAfterWhitespaceShouldNotBeMatched

	prefix := 'di'.
	
	stack := OOStack new.
	stack push: 'hola'.
	stack push: 'te dije'.
	stack push: 'dije'.

	actualResult := sentenceFinder selectElementsFromStack: stack withPrefix: prefix.
	
	expectedResult := OrderedCollection new.
	expectedResult add: 'dije'.
	
	self assert: actualResult  = expectedResult .! !


!classDefinition: #OOStack category: 'Stack-Exercise'!
Object subclass: #OOStack
	instanceVariableNames: 'base topComponent size'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStack methodsFor: 'initialization' stamp: 'SF 4/22/2023 16:23:31'!
initialize
	
	base := OOStackBase new.
	topComponent := base.
	size := 0.
	! !


!OOStack methodsFor: 'modification' stamp: 'SF 4/22/2023 16:38:14'!
pop

	|topElement|	
	topElement := topComponent value.
	topComponent := topComponent previousComponent.
	size := size - 1.
	^topElement .
	! !

!OOStack methodsFor: 'modification' stamp: 'SF 4/22/2023 16:27:50'!
push: anObject
	
	|newElement|
	newElement := OOStackElement new initializeWithValue: anObject withPreviousComponent: topComponent.
	topComponent := newElement.
	size := size + 1.! !


!OOStack methodsFor: 'inspection' stamp: 'SF 4/22/2023 16:23:39'!
isEmpty

	^size = 0! !

!OOStack methodsFor: 'inspection' stamp: 'SF 4/22/2023 16:35:22'!
size

	^size! !

!OOStack methodsFor: 'inspection' stamp: 'SF 4/22/2023 16:38:32'!
top

	^topComponent value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStack class' category: 'Stack-Exercise'!
OOStack class
	instanceVariableNames: ''!

!OOStack class methodsFor: 'error descriptions' stamp: 'NR 9/16/2021 17:39:43'!
stackEmptyErrorDescription
	
	^ 'stack is empty!!!!!!'! !


!classDefinition: #OOStackComponent category: 'Stack-Exercise'!
Object subclass: #OOStackComponent
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackComponent methodsFor: 'inspection' stamp: 'SF 4/22/2023 16:21:19'!
previousComponent

	^self subclassResponsibility ! !

!OOStackComponent methodsFor: 'inspection' stamp: 'SF 4/22/2023 16:21:23'!
value

	^self subclassResponsibility ! !


!classDefinition: #OOStackBase category: 'Stack-Exercise'!
OOStackComponent subclass: #OOStackBase
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackBase methodsFor: 'inspection' stamp: 'SF 4/22/2023 16:20:07'!
previousComponent

	^self error: OOStack stackEmptyErrorDescription.! !

!OOStackBase methodsFor: 'inspection' stamp: 'SF 4/22/2023 16:20:54'!
value

	^self error: OOStack stackEmptyErrorDescription.! !


!classDefinition: #OOStackElement category: 'Stack-Exercise'!
OOStackComponent subclass: #OOStackElement
	instanceVariableNames: 'previous value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackElement methodsFor: 'initialization' stamp: 'SF 4/22/2023 16:34:37'!
initializeWithValue: anObjectToSetAsValue withPreviousComponent: aComponentToSetAsPrevious.
	
	value := anObjectToSetAsValue.
	previous := aComponentToSetAsPrevious.! !


!OOStackElement methodsFor: 'inspection' stamp: 'SF 4/22/2023 16:20:31'!
previousComponent

	^previous.! !

!OOStackElement methodsFor: 'inspection' stamp: 'SF 4/22/2023 16:20:49'!
value

	^value.! !


!classDefinition: #SentenceFinderByPrefix category: 'Stack-Exercise'!
Object subclass: #SentenceFinderByPrefix
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefix methodsFor: 'modification' stamp: 'SF 4/22/2023 17:40:49'!
popAllElementsFrom: aStackToPop andAddThemTo: aCollection

	1 to: aStackToPop size do: [:x |
		aCollection addFirst: aStackToPop pop.
	].! !

!SentenceFinderByPrefix methodsFor: 'modification' stamp: 'SF 4/22/2023 17:42:33'!
pushElementsFrom: aCollection toStack: aStackToPush
	
	1 to: aCollection size do: [:x |
		aStackToPush push: (aCollection at: x).
	].! !


!SentenceFinderByPrefix methodsFor: 'error handling' stamp: 'SF 4/22/2023 18:33:55'!
raiseErrorIfPrefixContainsWhitespace: aPrefix

	(aPrefix includesSubString: ' ') ifTrue: [^self error: self class prefixContainsWhitespaceErrorDescription].! !

!SentenceFinderByPrefix methodsFor: 'error handling' stamp: 'SF 4/22/2023 18:33:44'!
raiseErrorIfPrefixIsEmpty: aPrefix

	(aPrefix = '') ifTrue: [^self error: self class emptyPrefixErrorDescription].! !


!SentenceFinderByPrefix methodsFor: 'selection' stamp: 'SF 4/22/2023 17:50:31'!
selectElementsFromCollection: aCollectionToSelect withPrefix: aPrefixToCheck

	^aCollectionToSelect select: [:aStringFromCollection | aStringFromCollection value beginsWith: aPrefixToCheck].! !

!SentenceFinderByPrefix methodsFor: 'selection' stamp: 'SF 4/22/2023 18:27:50'!
selectElementsFromStack: aStackToSearch withPrefix: aPrefix

	|temporalCollection |
	
	temporalCollection := OrderedCollection new.
	
	self raiseErrorIfPrefixIsEmpty: aPrefix.
	self raiseErrorIfPrefixContainsWhitespace: aPrefix.
	self popAllElementsFrom: aStackToSearch andAddThemTo: temporalCollection.
	self pushElementsFrom: temporalCollection toStack: aStackToSearch.
	^self selectElementsFromCollection: temporalCollection withPrefix: aPrefix.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SentenceFinderByPrefix class' category: 'Stack-Exercise'!
SentenceFinderByPrefix class
	instanceVariableNames: ''!

!SentenceFinderByPrefix class methodsFor: 'as yet unclassified' stamp: 'SF 4/22/2023 18:31:36'!
emptyPrefixErrorDescription

	^'El prefijo no puede ser vacío.'! !

!SentenceFinderByPrefix class methodsFor: 'as yet unclassified' stamp: 'SF 4/22/2023 18:32:00'!
prefixContainsWhitespaceErrorDescription

	^'El prefijo no puede tener espacios en blanco.'! !
