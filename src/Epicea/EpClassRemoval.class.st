"
I represent the removal of a class.
"
Class {
	#name : #EpClassRemoval,
	#superclass : #EpTmpSingleBehaviorChange,
	#category : #'Epicea-Model'
}

{ #category : #'instance creation' }
EpClassRemoval class >> class: aClassRemoved [

	^ self basicNew 
		initializeClassRemoved: aClassRemoved;
		yourself
]

{ #category : #visitor }
EpClassRemoval >> accept: aVisitor [

	^ aVisitor visitClassRemoval: self 
]

{ #category : #testing }
EpClassRemoval >> doesOverride: aCodeChange [

	^ (super doesOverride: aCodeChange) or: [
		(aCodeChange isEpBehaviorChange or: [ aCodeChange isEpMethodChange ]) and: [
		aCodeChange behaviorAffectedName = self behaviorAffectedName ]]
]
