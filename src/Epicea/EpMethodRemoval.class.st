"
I represent a removal of a method in a class or a trait.
"
Class {
	#name : #EpMethodRemoval,
	#superclass : #EpMethodAddition,
	#category : #'Epicea-Model'
}

{ #category : #visitor }
EpMethodRemoval >> accept: aVisitor [

	^ aVisitor visitMethodRemoval: self 
]

{ #category : #converting }
EpMethodRemoval >> inverse [

	^ self copyAsInstanceOf: EpMethodAddition
]
