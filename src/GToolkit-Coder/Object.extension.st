Extension { #name : #Object }

{ #category : #'*GToolkit-Coder' }
Object >> gtMetaFor: aView [
	<gtView>
	^ aView explicit
		title: 'Meta';
		priority: 200;
		stencil: [ (GtBehaviorCoder forObject: self) asElement ]
]
