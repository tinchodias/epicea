Extension { #name : #EpPropagateRefactoring }

{ #category : #'*Epicea-Browsers' }
EpPropagateRefactoring >> summaryOn: aWriteStream [
	"Write a string summarizing myself."
	
	aWriteStream 
		nextPutAll: 'Propagate '.
		
	targetRefactoring summaryOn: aWriteStream
]
