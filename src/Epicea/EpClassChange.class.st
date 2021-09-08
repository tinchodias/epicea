"
I represent a change in the definition of a class.
"
Class {
	#name : #EpClassChange,
	#superclass : #EpBehaviorChange,
	#instVars : [
		'name',
		'superclassName',
		'category',
		'comment',
		'packageName',
		'classSideDefinition',
		'instanceSideDefinition'
	],
	#category : #'Epicea-Model'
}

{ #category : #accessing }
EpClassChange >> behaviorAffectedName [
	^ name
]

{ #category : #accessing }
EpClassChange >> category [
	^ category
]

{ #category : #accessing }
EpClassChange >> classSideDefinition [
	^ classSideDefinition
]

{ #category : #accessing }
EpClassChange >> comment [
	^ comment
]

{ #category : #testing }
EpClassChange >> doesOverride: aCodeChange [

	^ aCodeChange isEpClassChange and: [
		aCodeChange behaviorAffectedName = self behaviorAffectedName ]
]

{ #category : #accessing }
EpClassChange >> fullDefinitionForInstance: theInstanceSideDefinition class: theClassSideDefinition [

	^ String streamContents: [ :stream |
		stream
			nextPutAll: theInstanceSideDefinition;
			nextPut: $.;
			cr; cr;
			nextPutAll: theClassSideDefinition ]

]

{ #category : #initialization }
EpClassChange >> initializeName: aName superclassName: aSuperclassName category: aCategory package: aPackageName comment: aComment instanceDefinition: theInstanceDefinition classDefinition: theClassDefinition [

	name := aName.
	superclassName := aSuperclassName.
	category := aCategory.
	packageName := aPackageName.
	comment := aComment.
	instanceSideDefinition := theInstanceDefinition.
	classSideDefinition := theClassDefinition
]

{ #category : #accessing }
EpClassChange >> instanceSideDefinition [
	^ instanceSideDefinition
]

{ #category : #testing }
EpClassChange >> isEpClassChange [

	^ true
]

{ #category : #accessing }
EpClassChange >> packageName [
	^ packageName
]

{ #category : #accessing }
EpClassChange >> superclassName [
	^ superclassName
]
