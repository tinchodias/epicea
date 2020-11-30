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
		do: [
			spec
				baseline: 'Hiedra'
				with: [
					spec
						repository: 'github://tinchodias/hiedra:v3.0.1/src';
						loads: 'default' ].
			spec
				package: 'Ombu';
				package: 'Ombu-Tests' with: [ spec requires: #(Ombu) ];
				package: 'Epicea' with: [ spec requires: #(Ombu) ];
				package: 'EpiceaBrowsers' with: [ spec requires: #(Epicea Hiedra) ];
				package: 'Epicea-Tests' with: [ spec requires: #(Epicea) ];
				package: 'EpiceaBrowsers-Tests'
					with: [ spec requires: #('EpiceaBrowsers' 'Epicea-Tests') ].
			spec
				group: 'core' with: #(Ombu Epicea EpiceaBrowsers);
				group: 'core+tests' with: #('Ombu-Tests' 'Epicea-Tests' 'EpiceaBrowsers-Tests');
				group: 'default' with: #('core+tests') ]

]
