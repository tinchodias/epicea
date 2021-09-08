Extension { #name : #CompiledMethod }

{ #category : #'*Epicea' }
CompiledMethod >> epiceaPackageName [
	^ self package ifNotNil: [ :thePackage | thePackage name ]
]
