Extension { #name : #EpLog }

{ #category : #'*EpiceaBrowsers' }
EpLog >> browseEvents [
	"Browse all events from my head."
	
	^ EpLogBrowserPresenter openWithLog: self
]
