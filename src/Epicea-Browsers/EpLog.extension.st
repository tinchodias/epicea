Extension { #name : #EpLog }

{ #category : #'*Epicea-Browsers' }
EpLog >> browseEvents [
	"Browse all events from my head."
	
	^ EpLogBrowserModel openWithLog: self
]

{ #category : #'*Epicea-Browsers' }
EpLog >> browseVersionsOf: aMethod [
	"Browse all versions of aMethod from my head."
	
	^ (EpLogBrowserModel newWithLog: self)
			addFilter: (EpPluggableFilter isMethod: aMethod);
			refresh;
			openWithSpec
]
