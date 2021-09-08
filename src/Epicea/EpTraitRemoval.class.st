"
I represent the removal of a trait.
"
Class {
	#name : #EpTraitRemoval,
	#superclass : #EpTmpSingleTraitChange,
	#category : #'Epicea-Model'
}

{ #category : #'instance creation' }
EpTraitRemoval class >> trait: aTrait [

	^ self basicNew 
		initializeWithTrait: aTrait;
		yourself
]

{ #category : #visitor }
EpTraitRemoval >> accept: aVisitor [

	^ aVisitor visitTraitRemoval: self 
]
