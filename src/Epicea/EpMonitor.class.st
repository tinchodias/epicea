"
I am a system monitor.

I subscribe to the system announcer to translate announcements to Epicea events (ie. subclasses of EpEvent), and record them into a log.
"
Class {
	#name : #EpMonitor,
	#superclass : #Object,
	#instVars : [
		'systemAnnouncer',
		'log',
		'entryReferenceByEvent',
		'jobAnnouncer',
		'announcer',
		'debugMode'
	],
	#classInstVars : [
		'current'
	],
	#category : #'Epicea-Monitor'
}

{ #category : #accessing }
EpMonitor class >> current [

	current ifNil: [
		current := self new ].
	
	^ current 
	
]

{ #category : #accessing }
EpMonitor class >> current: aMonitor [

	current := aMonitor
]

{ #category : #enabling }
EpMonitor class >> disableDuring: aBlock [
	"Disable the default monitor during the execution of a block"
	
	self current disableDuring: aBlock
]

{ #category : #testing }
EpMonitor class >> hasCurrent [
	"Answer if there is an instance of this class that is #current (without creating the instance if one not already exists)."

	^ current isNotNil
]

{ #category : #'class initialization' }
EpMonitor class >> initialize [
	SessionManager default registerToolClassNamed: self name
]

{ #category : #accessing }
EpMonitor class >> logsDirectory [
	self flag: #pharoFixMe.	"The base locator could have a wrong fileSystem"
	^ self current sessionStore baseLocator asFileReference
]

{ #category : #'instance creation' }
EpMonitor class >> new [

	^ self newWithLog: EpLog newWithSessionStore
]

{ #category : #'instance creation' }
EpMonitor class >> newWithLog: aLog [

	^ self basicNew 
		initializeWithLog: aLog;
		yourself
]

{ #category : #initialization }
EpMonitor class >> reset [
	"
	self reset
	"

	self hasCurrent ifTrue: [ 
		self current disable.
		self current: nil ]
]

{ #category : #initialization }
EpMonitor class >> restart [
	"
	self restart
	"

	self reset.
	self current enable.
]

{ #category : #'system startup' }
EpMonitor class >> shutDown: isImageQuitting [
	(isImageQuitting not
		and: [ self hasCurrent
		and: [ self current isEnabled ] ])
			ifTrue: [
				self current sessionSnapshot.
				self current sessionStore flush. ]
]

{ #category : #private }
EpMonitor >> addEvent: anEvent [ 

	self addEvent: anEvent newEntryDo: [ :newEntry | ]
]

{ #category : #private }
EpMonitor >> addEvent: anEvent newEntryDo: aBlock [

	self 
		addEvent: anEvent
		newEntryDo: aBlock
		triggerReference: self currentTriggerReference
]

{ #category : #private }
EpMonitor >> addEvent: anEvent newEntryDo: aBlock triggerReference: triggerReference [

	| newEntry |
	newEntry := log 
		addEntryWith: anEvent
		tags: [ :tags |
			triggerReference isNull ifFalse: [
				tags 
					at: EpLog triggererReferenceKey
					put: triggerReference ].
			
			tags at: EpLog authorKey put: self author.
			tags at: EpLog timeKey put: self time ].
		
	aBlock value: newEntry.
]

{ #category : #private }
EpMonitor >> announceMonitorStateUpdated [

	self announcer announce: EpMonitorStateUpdated new.
]

{ #category : #accessing }
EpMonitor >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #private }
EpMonitor >> author [
	^ Author uniqueInstance 
		ifUnknownAuthorUse: 'Unknown' 
		during: [ Author uniqueInstance fullName ]

]

{ #category : #accessing }
EpMonitor >> basicLog [
	"Answer a new EpLog with a OmFileStore (not a OmSessionStore as #log)."

	^ EpLog newWithStore: self sessionStore store
]

{ #category : #'announcement handling' }
EpMonitor >> behaviorAdded: aClassAddedAnnouncement [

	self handleAnyErrorDuring: [ 
		| eventClass |
		eventClass := aClassAddedAnnouncement classAffected isTrait
			              ifTrue: [ EpTraitAddition ]
			              ifFalse: [ EpClassAddition ].

		self addEvent: (eventClass newFromInstalledClass:
				 aClassAddedAnnouncement classAffected) ]
]

{ #category : #'announcement handling' }
EpMonitor >> behaviorModified: aClassModifiedAnnouncement [

	self handleAnyErrorDuring: [
		| event |
		event := aClassModifiedAnnouncement classAffected isTrait
			ifTrue: [ self traitModified: aClassModifiedAnnouncement ]
			ifFalse: [ self classModified: aClassModifiedAnnouncement ].

		event hasChanges ifTrue: [ self addEvent: event ]
	]
]

{ #category : #'announcement handling' }
EpMonitor >> behaviorRemoved: aClassRemovedAnnouncement [
	"Register both class and trait removals. Perform several workarounds that are needed because
	the announcement occurs after class is renamed to AnObsolete and removed from package."

	self handleAnyErrorDuring: [
		| aClass eventClass instanceDefinitionSource classDefinitionSource |

		aClass := aClassRemovedAnnouncement classRemoved.
		instanceDefinitionSource := aClass definition.
		classDefinitionSource := aClass classSide definition.

		"Fix class name (remove AnObsolete prefix)"
		instanceDefinitionSource
			copyReplaceAll: aClass name printString
			with: aClass originalName printString.

		"Fix class name in the metaclass"
		classDefinitionSource
			copyReplaceAll: aClass name
			with: aClass originalName.

		"Fix package name (category in old times)"
		instanceDefinitionSource
			copyReplaceAll: 'package: ', 'Unclassified' printString
			with: 'package: ', aClassRemovedAnnouncement categoryName printString.

		"Artificially generate method removals since system doesn't announce them."
		(aClass methods, aClass classSide methods) do: [:each |
			self
				behaviorRemovedImpliesMethodRemoved: each
				defaultPackageName: aClassRemovedAnnouncement packageAffected name ].

		eventClass := aClassRemovedAnnouncement classAffected isTrait
			ifTrue:  [ EpTraitRemoval ]
			ifFalse: [ EpClassRemoval ].

		self addEvent: (eventClass
			name: aClass originalName
			superclassName: aClass superclass asString "Note it's 'nil' for ProtoObject"
			category: aClassRemovedAnnouncement categoryName
			package: aClassRemovedAnnouncement packageAffected name
			comment: aClass organization classComment
			sharedPools: aClass sharedPoolNames
			definitionSource: instanceDefinitionSource
			traitCompositionSource: aClass traitCompositionString
			instanceVariables: aClass instVarNames
			classDefinitionSource: classDefinitionSource
			classTraitCompositionSource: aClass classSide traitCompositionString
			classInstanceVariables: aClass classSide instVarNames
			classVariables: aClass classVarNames) ]

]

{ #category : #'announcement handling' }
EpMonitor >> behaviorRemovedImpliesMethodRemoved: aMethodInAnObsoleteBehavior defaultPackageName: aSymbol [

	| packageName |
	packageName := (RPackageOrganizer default
                packageForProtocol: aMethodInAnObsoleteBehavior protocol
                inClass: aMethodInAnObsoleteBehavior methodClass) name.

	"If the method is local (belongs to the class being removed) then
	the package was wrong and we fix it."
	packageName = RPackage defaultPackageName ifTrue: [ 
		packageName := aSymbol ].

	self addEvent: 
		(EpMethodRemoval
			 selector: aMethodInAnObsoleteBehavior selector
			 sourceCode: aMethodInAnObsoleteBehavior sourceCode
			 methodClassName:
				 aMethodInAnObsoleteBehavior methodClass originalName
			 isMeta: aMethodInAnObsoleteBehavior methodClass isMeta
			 packageName: packageName
			 protocol: aMethodInAnObsoleteBehavior protocol)
]

{ #category : #'announcement handling' }
EpMonitor >> categoryAdded: aCategoryAdded [

	self handleAnyErrorDuring: [
		self addEvent: (EpCategoryAddition named: aCategoryAdded categoryName) ]
]

{ #category : #'announcement handling' }
EpMonitor >> categoryRemoved: aPackageCategoryRemoved [

	self handleAnyErrorDuring:[
		self addEvent: (EpCategoryRemoval named: aPackageCategoryRemoved categoryName) ]
]

{ #category : #'announcement handling' }
EpMonitor >> categoryRenamed: aCategoryRenamed [

	self handleAnyErrorDuring: [
		self addEvent: (EpCategoryRename
			oldName: aCategoryRenamed oldCategoryName
			newName: aCategoryRenamed newCategoryName) ]
]

{ #category : #'announcement handling' }
EpMonitor >> classCommented: anAnnouncement [

	self addEvent: (EpBehaviorCommentChange newWith: anAnnouncement)
]

{ #category : #'announcement handling' }
EpMonitor >> classModified: aClassModifiedAnnouncement [

	^ EpClassModification
		oldClass: aClassModifiedAnnouncement oldClassDefinition
		newClass: aClassModifiedAnnouncement newClassDefinition
]

{ #category : #'announcement handling' }
EpMonitor >> classRecategorized: aClassRecategorizedAnnouncement [

	self handleAnyErrorDuring: [
		aClassRecategorizedAnnouncement newCategory = aClassRecategorizedAnnouncement oldCategory
			ifTrue: [ ^ self ].
			
		self addEvent: (EpBehaviorCategoryChange
			oldCategory: aClassRecategorizedAnnouncement oldCategory
			newCategory: aClassRecategorizedAnnouncement newCategory
			class: aClassRecategorizedAnnouncement classAffected)]
]

{ #category : #'announcement handling' }
EpMonitor >> classRenamed: aClassRenamed [

	self handleAnyErrorDuring: [
		self addEvent: (EpBehaviorNameChange
			oldName: aClassRenamed oldName
			newName: aClassRenamed  newName
			class: aClassRenamed classAffected) ]
]

{ #category : #private }
EpMonitor >> currentTriggerReference [

	Job current 	
		ifNil: [ ^ log nullReference ]
		ifNotNil: [ :currentJob |
			currentJob 
				lookup: [ :job | 
					entryReferenceByEvent at: job 
						ifPresent: [ :reference | ^ reference ] 
						ifAbsent: [ false ] ]
				ifNone: [ ^ log nullReference ].
			].
]

{ #category : #accessing }
EpMonitor >> debugMode [
	^ debugMode ifNil: [ false ]
]

{ #category : #accessing }
EpMonitor >> debugMode: aBoolean [
	debugMode := aBoolean
]

{ #category : #enabling }
EpMonitor >> disable [

	self sessionStore flush.

	{ systemAnnouncer. jobAnnouncer }
		do: [ :each | each ifNotNil: [ :a | a unsubscribe: self ] ].

	self announceMonitorStateUpdated.

]

{ #category : #enabling }
EpMonitor >> disableDuring: aBlock [
	"Disable all logging during the execution of a block.
	
	Example:
		EpMonitor current disableDuring: [ self generateApplicationTemplate ]"

	| currentStatus |
	currentStatus := self isEnabled.
	self disable.
	[ aBlock value ]
		ensure: [ self enabled: currentStatus ]
]

{ #category : #enabling }
EpMonitor >> enable [
	"Enable monitoring IDE announcements."
	
	self isEnabled ifFalse: [ 			
		self subscribeToSystemAnnouncer.
		self subscribeToJobAnnouncer. ].

	self announceMonitorStateUpdated.

]

{ #category : #enabling }
EpMonitor >> enabled: aBoolean [

	aBoolean 
		ifTrue: [ self enable ]
		ifFalse: [ self disable ]
]

{ #category : #private }
EpMonitor >> handleAnyErrorDuring: aBlock [

	aBlock on: Error do: [:error | self handleError: error ]
]

{ #category : #private }
EpMonitor >> handleError: error [

	self debugMode 
		ifTrue: [ error pass ]
		ifFalse: [ 'EpMonitor could not log a change. You can enable debugging with "EpMonitor current debugMode: true".' traceCr ]
]

{ #category : #initialization }
EpMonitor >> initializeWithLog: aLog [

	self initialize.

	log := aLog.
	systemAnnouncer := SystemAnnouncer uniqueInstance.
	jobAnnouncer := Job jobAnnouncer.
	
	entryReferenceByEvent := IdentityDictionary new.
]

{ #category : #testing }
EpMonitor >> isEnabled [
	^ systemAnnouncer hasSubscriber: self
]

{ #category : #'announcement handling' }
EpMonitor >> jobEnded: aJobEnd [

	| aJob |
	aJob := aJobEnd job.

	"We only care in these cases"
	aJob owner isEpiceaInterestingJobOwner ifFalse: [ ^ self ].

	entryReferenceByEvent
		removeKey: aJob
		ifAbsent: [ "Should not happen, but we do not care :)" ]
]

{ #category : #'announcement handling' }
EpMonitor >> jobStarted: aJobStart [

	| aJob |
	aJob := aJobStart job.

	"We only care in these cases"
	aJob owner isEpiceaInterestingJobOwner ifFalse: [ ^ self ].

	self 
		addEvent: aJob owner asEpiceaEvent 
		newEntryDo: [ :newEntry |
			entryReferenceByEvent
				at: aJob
				put: (log referenceTo: newEntry) ]
]

{ #category : #accessing }
EpMonitor >> log [
	^ log
]

{ #category : #'announcement handling' }
EpMonitor >> logEntryCommented: aCommentModification [

	self addEvent: aCommentModification
]

{ #category : #'announcement handling' }
EpMonitor >> methodAdded: aMethodAddedAnnouncement [

	self handleAnyErrorDuring: [ 
		| method event |
		method := aMethodAddedAnnouncement methodAffected.
		event := EpMethodAddition newFromInstalledCompiledMethod: method.

		self addEvent: event ]
]

{ #category : #'announcement handling' }
EpMonitor >> methodModified: aMethodModifiedAnnouncement [

	self handleAnyErrorDuring: [
		| method event |

		"Skip log if no change"
		(aMethodModifiedAnnouncement oldMethod sourceCode = aMethodModifiedAnnouncement newMethod sourceCode 
			and: [ aMethodModifiedAnnouncement oldProtocol = aMethodModifiedAnnouncement newProtocol ])
			ifTrue: [ ^self ].

		method := aMethodModifiedAnnouncement methodAffected.
		event := EpMethodModification
			         selector: method selector
			         newSourceCode: aMethodModifiedAnnouncement newMethod sourceCode
						oldSourceCode: aMethodModifiedAnnouncement oldMethod sourceCode
			         methodClassName: method methodClass name
			         isMeta: method methodClass isMeta
			         packageName: method epiceaPackageName
						newProtocol: aMethodModifiedAnnouncement newProtocol
						oldProtocol: aMethodModifiedAnnouncement oldProtocol.

		self addEvent: event ]

]

{ #category : #'announcement handling' }
EpMonitor >> methodRecategorized: aMethodRecategorized [

	self handleAnyErrorDuring: [
		| method |
		"Workaround: When a trait is removed from the trait composition, 
		then this announcement is wrongly announced."
		aMethodRecategorized methodRecategorized ifNil: [ ^ self ].

		method := aMethodRecategorized methodRecategorized.	

		self addEvent:
			(EpMethodModification
					selector: method selector
		         newSourceCode: method sourceCode
					oldSourceCode: method sourceCode
		         methodClassName: method methodClass name
		         isMeta: method methodClass isMeta
		         packageName: method epiceaPackageName
					newProtocol: aMethodRecategorized newProtocol
					oldProtocol: aMethodRecategorized oldProtocol) ]
]

{ #category : #'announcement handling' }
EpMonitor >> methodRemoved: aMethodRemovedAnnouncement [
	"Note: At this moment, RPackage already unregistered the method, so we have to workaround protocol and package."

	self handleAnyErrorDuring: [ 
		| method event packageName |
		method := aMethodRemovedAnnouncement methodAffected.

		packageName := (RPackageOrganizer default 
			packageForProtocol: aMethodRemovedAnnouncement protocol 
			inClass: method methodClass) name.

		event := EpMethodRemoval
			         selector: method selector
			         sourceCode: method sourceCode
			         methodClassName: method methodClass name
			         isMeta: method methodClass isMeta
			         packageName: packageName
			         protocol: aMethodRemovedAnnouncement protocol.

		self addEvent: event ]

]

{ #category : #'announcement handling' }
EpMonitor >> protocolAdded: aProtocolAdded [

	self handleAnyErrorDuring: [
		self addEvent: 
			(EpProtocolAddition 
				behavior: aProtocolAdded classAffected
				protocol: aProtocolAdded protocol)]
]

{ #category : #'announcement handling' }
EpMonitor >> protocolRemoved: aProtocolRemoved [ 

	"Skip an irrelevant case"
	aProtocolRemoved protocol = Protocol unclassified ifTrue: [ ^self ].

	self handleAnyErrorDuring: [
		self addEvent: 
			(EpProtocolRemoval
				behavior: aProtocolRemoved classAffected
				protocol: aProtocolRemoved protocol)]
]

{ #category : #'announcement handling' }
EpMonitor >> sessionEnd [
	self addEvent: EpSessionEnd new
]

{ #category : #'announcement handling' }
EpMonitor >> sessionSnapshot [
	self addEvent: EpSessionSnapshot new
]

{ #category : #'announcement handling' }
EpMonitor >> sessionStart [
	self addEvent: EpSessionStart new
]

{ #category : #accessing }
EpMonitor >> sessionStore [

	^ self log store
]

{ #category : #private }
EpMonitor >> subscribeToJobAnnouncer [

	{	JobStart -> #jobStarted:.
		JobEnd -> #jobEnded:.
	} do: [ :pair |
		jobAnnouncer
			when: pair key 
			send: pair value 
			to: self ].

]

{ #category : #private }
EpMonitor >> subscribeToSystemAnnouncer [

	{	CategoryAdded -> #categoryAdded:. 
		CategoryRemoved -> #categoryRemoved:.
		CategoryRenamed -> #categoryRenamed:.
		ClassAdded-> #behaviorAdded:.
		ClassRemoved->#behaviorRemoved:.
		MethodAdded -> #methodAdded:.
		MethodRemoved -> #methodRemoved:.
		ProtocolAdded -> #protocolAdded:.
		ProtocolRemoved -> #protocolRemoved:.
		ClassModifiedClassDefinition -> #behaviorModified:.
		MethodModified -> #methodModified:.
		ClassRecategorized -> #classRecategorized:.
		ClassRenamed -> #classRenamed:.
		ClassCommented -> #classCommented:.
		MethodRecategorized -> #methodRecategorized:.
		
	} do: [ :pair |
		systemAnnouncer weak
			when: pair key 
			send: pair value 
			to: self ].

]

{ #category : #private }
EpMonitor >> time [
	^ DateAndTime now
]

{ #category : #'announcement handling' }
EpMonitor >> traitModified: aClassModifiedClassDefinitionAnnouncement [

	^ EpTraitModification
		oldTrait: aClassModifiedClassDefinitionAnnouncement oldClassDefinition
		newTrait: aClassModifiedClassDefinitionAnnouncement newClassDefinition
]

{ #category : #accessing }
EpMonitor >> writingDeferDuration [

	^ self sessionStore writingDeferDuration
]

{ #category : #accessing }
EpMonitor >> writingDeferDuration: aDuration [

	^ self sessionStore writingDeferDuration: aDuration
]
