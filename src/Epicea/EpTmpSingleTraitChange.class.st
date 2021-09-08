Class {
	#name : #EpTmpSingleTraitChange,
	#superclass : #EpTmpSingleBehaviorChange,
	#category : #'Epicea-Model'
}

{ #category : #testing }
EpTmpSingleTraitChange >> doesOverride: aCodeChange [

	^ aCodeChange isEpTraitChange and: [
		aCodeChange behaviorAffectedName = self behaviorAffectedName ]
]

{ #category : #testing }
EpTmpSingleTraitChange >> isEpClassChange [

	^ false
]

{ #category : #testing }
EpTmpSingleTraitChange >> isEpTraitChange [

	^ true
]
