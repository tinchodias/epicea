Class {
	#name : #BaselineOfEpicea,
	#superclass : #BaselineOf,
	#category : #BaselineOfEpicea
}

{ #category : #baseline }
BaselineOfEpicea >> baseline: spec [
	<baseline>
	spec
		for: #pharo
		do: [ spec
				baseline: 'Hiedra'
				with: [ spec
						repository: 'github://tinchodias/hiedra:master/src';
						loads: 'default' ].
			spec
				package: 'Ombu';
				package: 'Ombu-Tests' with: [ spec requires: #(Ombu) ];
				package: 'Epicea' with: [ spec requires: #(Ombu) ];
				package: 'Epicea-Browsers' with: [ spec requires: #(Epicea Hiedra) ];
				package: 'Epicea-Tests' with: [ spec requires: #(Epicea) ];
				package: 'Epicea-Browsers-Tests'
					with: [ spec requires: #('Epicea-Browsers' 'Epicea-Tests') ].
			spec
				group: 'core' with: #(Ombu Epicea 'Epicea-Browsers');
				group: 'core+tests' with: #('Ombu-Tests' 'Epicea-Tests' 'Epicea-Browsers-Tests');
				group: 'default' with: #('core+tests') ]
]
