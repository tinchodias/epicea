"
I'm a simple log of objects in ombu files. 

My objective is serving as example of use of the Ombu project.

I use OmSessionStore and OmFileStore as backend to save and load logged objects.

Read the comments of the key methods of my API: 
- #nextPut: 
- #contents
- #contentAt:
- #flush

"
Class {
	#name : #OmLogExample,
	#superclass : #Object,
	#instVars : [
		'sessionStore'
	],
	#classInstVars : [
		'default'
	],
	#category : #'Ombu-Examples'
}

{ #category : #accessing }
OmLogExample class >> default [
	^ default
		ifNil: [ default := self newOnDirectory: self defaultDirectory ]
]

{ #category : #accessing }
OmLogExample class >> defaultDirectory [
	^ FileLocator workingDirectory / 'ombuDB'
]

{ #category : #'instance creation' }
OmLogExample class >> new [
	^ self shouldNotImplement
]

{ #category : #'instance creation' }
OmLogExample class >> newOnDirectory: aDirectoryFileReference [
	^ self basicNew
		initializeOnDirectory: aDirectoryFileReference;
		yourself
]

{ #category : #accessing }
OmLogExample class >> resetDefault [
	default := nil
]

{ #category : #'file internals' }
OmLogExample >> allOmStoresDo: aBlock [
	"Evaluate aBlock with all #oldOmbuFiles (see it's comment) and
	with the current session store."
	
	self oldOmbuFiles do: [ :each |
		aBlock value: ((OmFileStore
			named: each asFileReference basenameWithoutExtension
			inDirectory: self directory)
			refresh;
			yourself) ].
	aBlock value: sessionStore.

]

{ #category : #accessing }
OmLogExample >> contentAt: aOmReference [

	^ self
		  contentAt: aOmReference
		  ifPresent: [ :result | result ]
		  ifAbsent: [ NotFound signalFor: aOmReference ]
]

{ #category : #accessing }
OmLogExample >> contentAt: aOmReference ifPresent: presentBlock ifAbsent: absentBlock [
	"Look for a content using aOmReference, and evaluate either the
	first block closure if present or the second otherwise.
	
	The aOmReference should be a value answered by #nextPut:.
	"
	
	self allOmStoresDo: [ :each |
		each
			entryFor: aOmReference
			ifPresent: [ :anEntry | ^ presentBlock cull: anEntry content ]
			ifAbsent: [ "Maybe in next..." ] ].

	^ absentBlock value

]

{ #category : #accessing }
OmLogExample >> contents [
	"Answer an Array with all logged objects. The order of the objects is
	the same as the evaluation order in #allEventsDo:."

	^ Array streamContents: [ :stream | 
		self contentsDo: [ :anExEvent |
			stream nextPut: anExEvent ] ]
]

{ #category : #accessing }
OmLogExample >> contentsDo: aBlock [
	"Evaluate aBlock on every logged object in my #directory.
	Their order is:
	- first, by order of creation time of the container session file (i.e. each ombu file);
	- second, by logging time on its file.
	"
	
	self allOmStoresDo: [ :fileStore |
		fileStore entries do: [ :entry |
			aBlock value: entry content ] ]
]

{ #category : #accessing }
OmLogExample >> directory [

	^ sessionStore directory
]

{ #category : #'file internals' }
OmLogExample >> flush [
	"Flush to disk any content buffered by the OmSessionStore."

	sessionStore flush
]

{ #category : #initialization }
OmLogExample >> initializeOnDirectory: aDirectoryFileReference [

	self initialize.
	aDirectoryFileReference ensureCreateDirectory.
	sessionStore := OmSessionStore newWithBaseLocator: aDirectoryFileReference.
]

{ #category : #accessing }
OmLogExample >> nextPut: anObject [
	"Append anObject to the current session log. Note that writing
	to the session file is not immediate. See #flush.
	
	Answer a OmReference that servers as an identifier. See #contentAt:.
	"

	| newEntry |
	newEntry := OmEntry content: anObject.
	sessionStore newEntry: newEntry.
	
	^ newEntry tagAt: OmStore selfReferenceKey
]

{ #category : #'file internals' }
OmLogExample >> oldOmbuFiles [
	"Answer a list of FileReferences instances. One for each session
	(i.e. each ombu file)	in my #directory, except the one that is
	currently open. The files are sorted by their creation time."

	^ ((self directory entries
		select: [ :each | each basename endsWith: OmFileStore defaultFileSuffix ]
		thenCollect: [ :each | each asFileReference ])
		reject: [ :each | each = sessionStore writingFileReference ])
		sorted: [ :a :b | a creationTime < b creationTime ]
]

{ #category : #'file internals' }
OmLogExample >> resetSessionStore [
	"Emulate the image save, quit, and reopen."

	self flush.
	sessionStore resetWithNextStoreName
]
