"
I represent a change in a code entity.
"
Class {
	#name : #EpCodeChange,
	#superclass : #EpEvent,
	#category : #'Epicea-Model'
}

{ #category : #accessing }
EpCodeChange >> affectedPackageName [

	^ self subclassResponsibility 
]

{ #category : #copying }
EpCodeChange >> copyAsInstanceOf: aClass [

	| aCopy |
	aCopy := self copy.
	aClass adoptInstance: aCopy.
	^ aCopy
]

{ #category : #testing }
EpCodeChange >> doesOverride: aCodeChange [ 

	^ self subclassResponsibility
]

{ #category : #operations }
EpCodeChange >> inverse [
	"Answer the inverse change."

	^ self subclassResponsibility
]

{ #category : #testing }
EpCodeChange >> isCodeChange [

	^ true
]
