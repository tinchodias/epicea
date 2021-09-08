"
I represent the creation of a trait.
"
Class {
	#name : #EpTraitAddition,
	#superclass : #EpTmpSingleTraitChange,
	#category : #'Epicea-Model'
}

{ #category : #'instance creation' }
EpTraitAddition class >> trait: aTrait [

	^ self basicNew
		initializeWithTrait: aTrait;
		yourself 
]

{ #category : #visitor }
EpTraitAddition >> accept: aVisitor [

	^ aVisitor visitTraitAddition: self 
]

{ #category : #operations }
EpTraitAddition >> inverse [
	
	^ self copyAsInstanceOf: EpTraitRemoval
]
