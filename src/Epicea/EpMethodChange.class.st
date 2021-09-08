"
I represent a change in the method dictionary of a class or a trait.
"
Class {
	#name : #EpMethodChange,
	#superclass : #EpCodeChange,
	#instVars : [
		'protocol',
		'selector',
		'sourceCode',
		'methodClassName',
		'packageName',
		'isMeta'
	],
	#category : #'Epicea-Model'
}

{ #category : #accessing }
EpMethodChange >> affectedPackageName [

	^ packageName
]

{ #category : #accessing }
EpMethodChange >> behaviorAffectedName [

	^ methodClassName
]

{ #category : #testing }
EpMethodChange >> doesOverride: aCodeChange [

	^ aCodeChange isEpMethodChange and: [
		aCodeChange behaviorAffectedName = self behaviorAffectedName and: [ 
		aCodeChange methodAffectedSelector = self methodAffectedSelector ] ]
]

{ #category : #initialization }
EpMethodChange >> initializeSelector: aSelector sourceCode: aSourceCode methodClassName: aClassName isMeta: aBoolean packageName: aPackageName protocol: aProtocol [

	self initialize.

	selector := aSelector.
	sourceCode := aSourceCode.
	methodClassName := aClassName.
	isMeta := aBoolean.
	packageName := aPackageName.
	protocol := aProtocol
]

{ #category : #testing }
EpMethodChange >> isEpMethodChange [

	^ true
]

{ #category : #accessing }
EpMethodChange >> methodAffectedIsMeta [

	^ isMeta
]

{ #category : #accessing }
EpMethodChange >> methodAffectedSelector [

	^ selector
]

{ #category : #printing }
EpMethodChange >> printOn: aStream [

	super printOn: aStream.

	aStream 
		nextPut: $(;
		nextPutAll: self behaviorAffectedName;
		nextPutAll: '>>';
		nextPutAll: self methodAffectedSelector;
		nextPut: $)
]
