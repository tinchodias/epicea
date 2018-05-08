Extension { #name : #EpRenameClassRefactoring }

{ #category : #'*Epicea-Browsers' }
EpRenameClassRefactoring >> summaryOn: aWriteStream [
	"Write a string summarizing myself."
	
	aWriteStream 
		nextPutAll: 'Rename ';
		nextPutAll: oldName;
		nextPutAll: ' into ';
		nextPutAll: newName.
]
