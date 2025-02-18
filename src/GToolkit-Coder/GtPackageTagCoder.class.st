Class {
	#name : #GtPackageTagCoder,
	#superclass : #GtCoderModel,
	#traits : 'TGtCoderTrait',
	#classTraits : 'TGtCoderTrait classTrait',
	#instVars : [
		'packageTag',
		'packageCoder',
		'classesCoder'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'instance creation' }
GtPackageTagCoder class >> forPackageTag: aPackageTag [
	^ self new
		packageTag: aPackageTag;
		yourself
]

{ #category : #'api - converting' }
GtPackageTagCoder >> asNewCoderModelWithSameSubject [
	"Return new coder model with same subject (e.g., package, class, method)"
	<return: #GtCoderModel>
	^ self class forPackageTag: self packageTag
]

{ #category : #asserting }
GtPackageTagCoder >> assertCoder: aCoder [
	self 
		assert: [ aCoder isNotNil ]
		description: [ 'Coder must be non-nil' ].
]

{ #category : #accessing }
GtPackageTagCoder >> classesCoder [
	^ classesCoder
		ifNil: [ classesCoder := GtClassesCoder new.
			packageTag notNil
				ifTrue: [ classesCoder forPackageTag: packageTag ].
			classesCoder ]
]

{ #category : #accessing }
GtPackageTagCoder >> coderForClass: aClass [
	^ packageCoder coderForClass: aClass
]

{ #category : #accessing }
GtPackageTagCoder >> coders [
	^ self classesCoder coders
]

{ #category : #ui }
GtPackageTagCoder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Package Tag';
		priority: 1;
		stencil: [ self ];
		actionButtonIcon: BrGlamorousVectorIcons inspect
			action: [ :aButton | aButton phlow spawnObject: self packageTag ]
]

{ #category : #accessing }
GtPackageTagCoder >> icon [
	^ BrGlamorousIcons packageicon asElement
]

{ #category : #testing }
GtPackageTagCoder >> isForPackageTag [
	^ true
]

{ #category : #accessing }
GtPackageTagCoder >> name [
	^ packageTag name
]

{ #category : #accessing }
GtPackageTagCoder >> package [
	^ packageTag package
]

{ #category : #accessing }
GtPackageTagCoder >> packageCoder [
	^ packageCoder ifNil: [ packageCoder := GtPackageCoder forPackage: self package ]
]

{ #category : #accessing }
GtPackageTagCoder >> packageCoder: aPackageCoder [
	self assertCoder: aPackageCoder.
	packageCoder := aPackageCoder
]

{ #category : #accessing }
GtPackageTagCoder >> packageTag [
	^ packageTag
]

{ #category : #accessing }
GtPackageTagCoder >> packageTag: anObject [
	packageTag := anObject
]

{ #category : #actions }
GtPackageTagCoder >> unload [
	self packageTag classes do: [ :each | each removeFromSystem ].
	self packageTag removeFromPackage
]
