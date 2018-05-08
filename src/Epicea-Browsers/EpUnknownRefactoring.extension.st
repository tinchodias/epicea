Extension { #name : #EpUnknownRefactoring }

{ #category : #'*Epicea-Browsers' }
EpUnknownRefactoring >> summaryOn: aWriteStream [
	"Write a string summarizing myself."
	
	aWriteStream 
		nextPutAll: printString
]
