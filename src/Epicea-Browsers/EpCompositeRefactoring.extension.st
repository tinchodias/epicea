Extension { #name : #EpCompositeRefactoring }

{ #category : #'*Epicea-Browsers' }
EpCompositeRefactoring >> summaryOn: aWriteStream [
	"Write a string summarizing myself."
	
	childrenRefactorings
		do: [:each | each summaryOn: aWriteStream ]
		separatedBy: [ aWriteStream nextPutAll: ', ' ]
]
