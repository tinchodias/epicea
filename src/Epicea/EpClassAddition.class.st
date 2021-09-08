"
I represent the creation of a class.
"
Class {
	#name : #EpClassAddition,
	#superclass : #EpTmpSingleBehaviorChange,
	#category : #'Epicea-Model'
}

{ #category : #visitor }
EpClassAddition >> accept: aVisitor [

	^ aVisitor visitClassAddition: self
]

{ #category : #operations }
EpClassAddition >> inverse [
	
	^ self copyAsInstanceOf: EpClassRemoval
]
