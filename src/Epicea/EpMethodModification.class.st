"
I represent the modification of a method in a class or a trait. Not any modification but only a change in either the sourceCode and the protocol.

"
Class {
	#name : #EpMethodModification,
	#superclass : #EpMethodChange,
	#instVars : [
		'oldProtocol',
		'oldSourceCode'
	],
	#category : #'Epicea-Model'
}

{ #category : #'instance creation' }
EpMethodModification class >> selector: aSelector newSourceCode: theNewSourceCode oldSourceCode: theOldSourceCode methodClassName: aClassName isMeta: aBoolean packageName: aPackageName newProtocol: theNewProtocol oldProtocol: theOldProtocol [

	^ self basicNew
		  initializeSelector: aSelector
		  sourceCode: theNewSourceCode
		  methodClassName: aClassName
		  isMeta: aBoolean
		  packageName: aPackageName
		  protocol: theNewProtocol
		  oldSourceCode: theOldSourceCode
		  oldProtocol: theOldProtocol;
		  yourself
]

{ #category : #visitor }
EpMethodModification >> accept: aVisitor [

	^ aVisitor visitMethodModification: self 
]

{ #category : #copying }
EpMethodModification >> copyAsMethodAddition [

	^ EpMethodAddition
		  selector: selector
		  sourceCode: sourceCode
		  methodClassName: methodClassName
		  isMeta: isMeta
		  packageName: packageName
		  protocol: protocol
]

{ #category : #initialization }
EpMethodModification >> initializeSelector: aSelector sourceCode: theNewSourceCode methodClassName: aClassName isMeta: aBoolean packageName: aPackageName protocol: theNewProtocol oldSourceCode: theOldSourceCode oldProtocol: theOldProtocol [

	self
		initializeSelector: aSelector
		sourceCode: theNewSourceCode
		methodClassName: aClassName
		isMeta: aBoolean
		packageName: aPackageName
		protocol: theNewProtocol.

	oldSourceCode := theOldSourceCode.
	oldProtocol := theOldProtocol
]

{ #category : #operations }
EpMethodModification >> inverse [

	^ EpMethodModification
		  selector: selector
		  newSourceCode: oldSourceCode
		  oldSourceCode: sourceCode
		  methodClassName: methodClassName
		  isMeta: isMeta
		  packageName: packageName
		  newProtocol: oldProtocol
		  oldProtocol: protocol
]

{ #category : #accessing }
EpMethodModification >> newProtocol [

	^ protocol
]

{ #category : #accessing }
EpMethodModification >> newSourceCode [

	^ sourceCode
]

{ #category : #accessing }
EpMethodModification >> oldProtocol [

	^ oldProtocol
]

{ #category : #accessing }
EpMethodModification >> oldSourceCode [

	^ oldSourceCode
]
