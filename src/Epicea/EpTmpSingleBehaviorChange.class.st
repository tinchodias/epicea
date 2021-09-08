Class {
	#name : #EpTmpSingleBehaviorChange,
	#superclass : #EpClassChange,
	#category : #'Epicea-Model'
}

{ #category : #'instance creation' }
EpTmpSingleBehaviorChange class >> name: aName superclassName: aSuperclassName category: aCategory package: aPackageName comment: aComment sharedPools: theSharedPools definitionSource: theInstanceDefinitionSource traitCompositionSource: theInstanceTraitCompositionSource instanceVariables: theInstanceVariableNames classDefinitionSource: theClassDefinitionSource classTraitCompositionSource: theClassTraitCompositionSource classInstanceVariables: theClassInstanceVariableNames classVariables: theClassVariableNames [

	^ self basicNew
		  initializeName: aName
		  superclassName: aSuperclassName
		  category: aCategory
		  package: aPackageName
		  comment: aComment
		  sharedPools: theSharedPools
		  definitionSource: theInstanceDefinitionSource
		  traitCompositionSource: theInstanceTraitCompositionSource
		  instanceVariables: theInstanceVariableNames
		  classDefinitionSource: theClassDefinitionSource
		  classTraitCompositionSource: theClassTraitCompositionSource
		  classInstanceVariables: theClassInstanceVariableNames
		  classVariables: theClassVariableNames;
		  yourself
]

{ #category : #'instance creation' }
EpTmpSingleBehaviorChange class >> newFromInstalledClass: aClass [

	^ self
		name: aClass name
		superclassName: aClass superclass asString "Note it's 'nil' for ProtoObject"
		category: aClass category
		package: (EpPlatform current packageNameFor: aClass)
		comment: aClass organization classComment
		sharedPools: aClass sharedPoolNames
		definitionSource: aClass definition
		traitCompositionSource: aClass traitCompositionString
		instanceVariables: aClass instVarNames
		classDefinitionSource: aClass classSide definition
		classTraitCompositionSource: aClass classSide traitCompositionString
		classInstanceVariables: aClass classSide instVarNames
		classVariables: aClass classVarNames
]

{ #category : #accessing }
EpTmpSingleBehaviorChange >> behaviorAffected [

"REMOVE --- MANY SENDERS"

	^ self halt
]

{ #category : #accessing }
EpTmpSingleBehaviorChange >> behaviorAffectedFullDefinitionSource [

	^ self
		  fullDefinitionForInstance: instanceSideDefinition
		  class: classSideDefinition
]
