Class {
	#name : #GtClassesCoder,
	#superclass : #GtCodersModel,
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #accessing }
GtClassesCoder >> coderForClass: aClass [
	^ self coders
		detect: [ :each | each theClass = aClass ]
		ifNone: [ | coder |
			items add: aClass.
			coder := self newCoderFor: aClass.
			coders add: coder.
			coder ]
]

{ #category : #updating }
GtClassesCoder >> forPackage: aPackage [
	items := aPackage definedClasses
		asSortedCollection: [ :a :b | a name < b name ].
	self updateCoders
]

{ #category : #updating }
GtClassesCoder >> forPackageTag: aPackageTag [
	items := aPackageTag classes
		asSortedCollection: [ :a :b | a name < b name ].
	self updateCoders
]

{ #category : #private }
GtClassesCoder >> newCoderFor: aClass [
	| coder |
	coder := GtBehaviorCoder forClass: aClass.
	^ coder
]
