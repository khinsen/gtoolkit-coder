Extension { #name : #Class }

{ #category : #'*GToolkit-Coder' }
Class >> gtInheritance [
	^ GtPharoInheritance new subclass: self; superclass: self superclass
]

{ #category : #'*GToolkit-Coder' }
Class >> gtMetaFor: aView [
	<gtView>
	^ aView explicit
		title: 'Meta';
		priority: 200;
		stencil: [ (GtBehaviorCoder forClass: self) asElement ]
]

{ #category : #'*GToolkit-Coder' }
Class >> gtTraitUsages [
	^ self traits collect: [ :each | GtPharoTraitUsage new baseBehavior: self; usedTrait: each ]
]
