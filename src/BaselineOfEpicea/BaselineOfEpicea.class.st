Class {
	#name : #BaselineOfEpicea,
	#superclass : #BaselineOf,
	#category : 'BaselineOfEpicea'
}

{ #category : #baseline }
BaselineOfEpicea >> baseline: spec [
	<baseline>
	spec
		for: #pharo
		do: [ 
            spec project: 'Hiedra' with: [ 
            	spec 
		            baseline: 'Hiedra' 
		            with: [ 
			            spec
				            repository: 'github://tinchodias/hiedra:master';
              				loads: 'default' ]
            ].

            spec 
                package: 'Ombu';
                package: 'OmbuTests' with: [
                    spec requires: #(Ombu) ];
                package: 'Epicea' with: [
                    spec requires: #(Ombu) ];
                package: 'EpiceaBrowsers' with: [
                    spec requires: #(Epicea Hiedra) ];
                package: 'EpiceaTests' with: [
                    spec requires: #(Epicea) ];
                package: 'EpiceaBrowsersTests' with: [
                    spec requires: #(EpiceaBrowsers EpiceaTests) ].

            spec 
                group: 'core' with: #(Ombu Epicea EpiceaBrowsers Hiedra);
                group: 'core+tests' with: #(OmbuTests EpiceaTests EpiceaBrowsersTests);
				group: 'default' with: #('core+tests')
  			].
        ]
]
