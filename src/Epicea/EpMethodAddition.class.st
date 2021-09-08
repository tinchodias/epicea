"
I represent a addition of a method in a class or a trait.
"
Class {
	#name : #EpMethodAddition,
	#superclass : #EpMethodChange,
	#category : #'Epicea-Model'
}

{ #category : #'instance creation' }
EpMethodAddition class >> newFromInstalledCompiledMethod: method [

	^ self
		  selector: method selector
		  sourceCode: method sourceCode
		  methodClassName: method methodClass name
		  isMeta: method methodClass isMeta
		  packageName: method epiceaPackageName
		  protocol: method category
]

{ #category : #'instance creation' }
EpMethodAddition class >> selector: aSelector sourceCode: aSourceCode methodClassName: aClassName isMeta: aBoolean packageName: aPackageName protocol: aProtocol [

	^ self basicNew
		  initializeSelector: aSelector
		  sourceCode: aSourceCode
		  methodClassName: aClassName
		  isMeta: aBoolean
		  packageName: aPackageName
		  protocol: aProtocol;
		  yourself
]

{ #category : #visitor }
EpMethodAddition >> accept: aVisitor [

	^ aVisitor visitMethodAddition: self
]

{ #category : #copying }
EpMethodAddition >> copyAsMethodAddition [
	^ self copy
]

{ #category : #converting }
EpMethodAddition >> inverse [

	^ self copyAsInstanceOf: EpMethodRemoval
]

{ #category : #accessing }
EpMethodAddition >> methodAffectedProtocol [

	^ protocol
]

{ #category : #accessing }
EpMethodAddition >> methodAffectedSourceCode [

	^ sourceCode
]
