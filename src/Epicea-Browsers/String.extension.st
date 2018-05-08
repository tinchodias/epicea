Extension { #name : #String }

{ #category : #'*Epicea-Browsers' }
String >> asInstanceSideBehaviorName [

	^ (self splitOn: Character space) first
]
