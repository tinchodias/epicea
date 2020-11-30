"
A BVTSurveyStoreTest is a test class for testing the behavior of BVTSurveyStore
"
Class {
	#name : #OmLogExampleTest,
	#superclass : #TestCase,
	#instVars : [
		'directory',
		'log'
	],
	#category : #'Ombu-Tests'
}

{ #category : #test }
OmLogExampleTest >> directoryReference [

	^ 'example-test-db' asFileReference
]

{ #category : #test }
OmLogExampleTest >> invalidReferenceForTesting [

	^ OmReference globalName: 'x' localName: 'y'
]

{ #category : #test }
OmLogExampleTest >> newLog [

	^ OmLogExample newOnDirectory: self directoryReference
]

{ #category : #test }
OmLogExampleTest >> setUp [

	super setUp.
	log := self newLog
]

{ #category : #test }
OmLogExampleTest >> tearDown [

	log flush. "There may be some pending write operation that must
		be done before the file is deleted, to avoid an error."
	self directoryReference ensureDeleteAll.
	super tearDown
]

{ #category : #test }
OmLogExampleTest >> testContentAt [

	| aReference |
	aReference := log nextPut: '1'.

	self assert: (log contentAt: aReference) equals: '1'.

	self
		should: [ log contentAt: self invalidReferenceForTesting ]
		raise: NotFound
]

{ #category : #test }
OmLogExampleTest >> testContentAtIfPresentIfAbsent [

	| aReference result |
	aReference := log nextPut: '1'.

	result := nil.
	log
		contentAt: aReference
		ifPresent: [ result := true ]
		ifAbsent: [ result := false ].
	self assert: result.

	result := nil.
	log
		contentAt: self invalidReferenceForTesting
		ifPresent: [ result := true ]
		ifAbsent: [ result := false ].
	self deny: result
]

{ #category : #test }
OmLogExampleTest >> testContents [

	1 to: 10 do: [ :each | log nextPut: each ].

	self assert: log contents equals: (1 to: 10)
]

{ #category : #test }
OmLogExampleTest >> testDirectory [

	self assert: log directory equals: self directoryReference
]

{ #category : #test }
OmLogExampleTest >> testFlush [

	1 to: 5 do: [ :each | log nextPut: each ].
	log flush.
	6 to: 10 do: [ :each | log nextPut: each ].
	log flush.
	11 to: 15 do: [ :each | log nextPut: each ].
	log flush.
	16 to: 20 do: [ :each | log nextPut: each ].
	
	self assert: log contents equals: (1 to: 20).

]

{ #category : #test }
OmLogExampleTest >> testNextPut [

	1 to: 10 do: [ :each | log nextPut: each ].

]

{ #category : #test }
OmLogExampleTest >> testOldOmbuFiles [

	1 to: 5 do: [ :each | log nextPut: each ].
	
	"Emulate the image save, quit, and reopen."
	log resetSessionStore.
	"We know a file was created."

	6 to: 10 do: [ :each | log nextPut: each ].
	log flush. "We know another file was created"
	
	self assert: log oldOmbuFiles size equals: 1.
	self assert: log contents equals: (1 to: 10).

]
