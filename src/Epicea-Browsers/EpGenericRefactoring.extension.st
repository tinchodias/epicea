Extension { #name : #EpGenericRefactoring }

{ #category : #'*Epicea-Browsers' }
EpGenericRefactoring >> summaryOn: aWriteStream [
	"Write a string summarizing myself."
	
	aWriteStream 
		nextPutAll: storeString
]
