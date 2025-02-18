Class {
	#name : #GtCoderNavigationPackagesTagsClassesModel,
	#superclass : #GtCoderNavigationModel,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'packages',
		'coder'
	],
	#category : #'GToolkit-Coder-Navigation - Model'
}

{ #category : #'instance creation' }
GtCoderNavigationPackagesTagsClassesModel class >> fromPackages: aCollectionOfPackages [
	^ self new initializeWithPackages: aCollectionOfPackages
]

{ #category : #announcer }
GtCoderNavigationPackagesTagsClassesModel >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #asserting }
GtCoderNavigationPackagesTagsClassesModel >> assertCoder: aCoder [
	self 
		assert: [ aCoder isNotNil ]
		description: [ 'Coder must be non-nil' ].
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesModel >> classModificationApplied: anAnnouncement [
	(self packagesToShow includes: anAnnouncement packageAffected) ifFalse: [ ^ self ].
	self announcer announce: (GtCoderNavigationClassModified new 
		coder: coder;
		package: anAnnouncement packageAffected;
		tag: anAnnouncement classTagAffected;
		theClass: anAnnouncement classAffected)
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesModel >> classRenamed: aClassRenamed [
	(self packagesToShow includes: aClassRenamed packageAffected) ifFalse: [ ^ self ].
	self announcer announce: (GtCoderNavigationClassRenamed new 
		coder: coder;
		package: aClassRenamed packageAffected;
		tag: aClassRenamed classTagAffected;
		theClass: aClassRenamed classRenamed;
		oldName: aClassRenamed oldName;
		newName: aClassRenamed newName)
]

{ #category : #'api - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> classesToShow [
	<return: #Collection of: #Class>

	self hasSelectedPackage
		ifFalse: [ ^ #() ].
		
	^ self hasSelectedTag
		ifTrue: [ self selectedTag classes ]
		ifFalse: [ self selectedPackage definedClasses ]
]

{ #category : #'private - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> coder: aCoder [
	coder == aCoder ifTrue: [ ^ self ].
	coder ifNotNil: [ :oldCoder | 
		oldCoder announcer unsubscribe: self ].
	
	coder := aCoder.
	
	"forward coder announcements"
	aCoder announcer weak
		when: Announcement
		send: #onCoderAnnouncement:
		to: self
]

{ #category : #'api - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> coderDo: aBlock [
	coder ifNotNil: aBlock
]

{ #category : #'api - testing' }
GtCoderNavigationPackagesTagsClassesModel >> hasSelectedClass [
	<return: #Boolean>
	^ self selectedClass notNil
]

{ #category : #'api - testing' }
GtCoderNavigationPackagesTagsClassesModel >> hasSelectedPackage [
	<return: #Boolean>
	^ self selectedPackage notNil
]

{ #category : #'api - testing' }
GtCoderNavigationPackagesTagsClassesModel >> hasSelectedTag [
	<return: #Boolean>
	^ self selectedTag notNil
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesModel >> initialize [
	super initialize.
	self coder: GtPackagesCoder new
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesModel >> initializeWithPackages: aCollectionOfRPackage [
	packages := aCollectionOfRPackage.
	
	
]

{ #category : #'private - notifying' }
GtCoderNavigationPackagesTagsClassesModel >> notifyClassSelected: aClass package: anRPackage tag: anRPackageTag [
	self
		announce:
			(GtCoderNavigationClassSelected new
				coder: coder;
				package: anRPackage;
				tag: anRPackageTag;
				theClass: aClass)
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTagsClassesModel >> notifyCoderSelected [
	self announce: (GtCoderNavigationPackagesSelected new coder: coder)
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTagsClassesModel >> notifyMethodProtocolSelected: aMethodProtocol source: aSource [
	coder withMethodProtocol: aMethodProtocol source: aSource
]

{ #category : #'private - notifying' }
GtCoderNavigationPackagesTagsClassesModel >> notifyMethodSelected: aMethod [
	coder withSelectedMethod: aMethod
]

{ #category : #'private - notifying' }
GtCoderNavigationPackagesTagsClassesModel >> notifyPackageSelected: anRPackage [
	self
		announce:
			(GtCoderNavigationPackageSelected new
				coder: coder;
				package: anRPackage)
]

{ #category : #'private - notifying' }
GtCoderNavigationPackagesTagsClassesModel >> notifyTagSelected: anRPackageTag package: anRPackage [
	self
		announce:
			(GtCoderNavigationPackageTagSelected new
				coder: coder;
				package: anRPackage;
				tag: anRPackageTag)
]

{ #category : #'private - announcement handling' }
GtCoderNavigationPackagesTagsClassesModel >> onCoderAnnouncement: anAnnouncement [
	self announcer announce: anAnnouncement
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesModel >> packageRegistered: aRPackageRegistered [
	(self packagesToShow includes: aRPackageRegistered package) ifFalse: [ ^ self ].
	self announcer announce: (GtCoderNavigationPackageRegistered new 
		coder: coder;
		package: aRPackageRegistered package)
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesModel >> packageRenamed: aRPackageRenamed [
	(self packagesToShow includes: aRPackageRenamed package) ifFalse: [ ^ self ].
	self announcer announce: (GtCoderNavigationPackageRenamed new 
		coder: coder;
		package: aRPackageRenamed package;
		oldName: aRPackageRenamed oldName;
		newName: aRPackageRenamed newName)
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesModel >> packageTagAdded: aClassTagAdded [
	(self packagesToShow includes: aClassTagAdded package) ifFalse: [ ^ self ].
	self announcer announce: (GtCoderNavigationPackageTagAdded new 
		coder: coder;
		package: aClassTagAdded package;
		tag: aClassTagAdded tag)
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesModel >> packageTagRemoved: aClassTagRemoved [
	(self packagesToShow includes: aClassTagRemoved package) ifFalse: [ ^ self ].
	self announcer announce: (GtCoderNavigationPackageTagRemoved new 
		coder: coder;
		package: aClassTagRemoved package;
		tag: aClassTagRemoved tag)
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesModel >> packageUnregistered: aRPackageUnregistered [
	self announcer announce: (GtCoderNavigationPackageUnregistered new 
		coder: coder;
		package: aRPackageUnregistered package)
]

{ #category : #'api - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> packagesToShow [
	<return: #Collection of: #RPackage>
	^ packages ifNil: [ RPackageOrganizer default packages ]
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTagsClassesModel >> selectClass: aClass [
	| aCoder |
	(self showPackage: aClass package)
		ifFalse: [ ^ self ].
	(coder isForClass and: [ coder theClass = aClass ])
		ifTrue: [ ^ self ].
	aCoder := GtBehaviorCoder forClass: aClass.
	self assertCoder: aCoder.
	self coder: aCoder.
	self
		notifyClassSelected: aClass
		package: aClass package
		tag: (aClass package classTagForClass: aClass)
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTagsClassesModel >> selectCoder: aCoder [
	aCoder isForPackage
		ifTrue: [ (coder isForPackage and: [ aCoder package = coder package ])
				ifTrue: [ ^ self ].
			self assertCoder: aCoder.
			self coder: aCoder.
			^ self notifyPackageSelected: coder package ].
	aCoder isForPackageTag
		ifTrue:
			[ (coder isForPackageTag and: [ aCoder packageTag = coder packageTag ])
				ifTrue: [ ^ self ].
			self assertCoder: aCoder.
			self coder: aCoder.
			^ self notifyTagSelected: coder packageTag package: coder package ].
	aCoder isForClass
		ifTrue: [ (coder isForClass and: [ aCoder theClass = coder theClass ])
				ifTrue: [ ^ self ].
			self assertCoder: aCoder.
			self coder: aCoder.
			^ self
				notifyClassSelected: coder theClass
				package: coder package
				tag: coder packageTag ].
	self assertCoder: aCoder.
	self coder: aCoder.
	self notifyCoderSelected
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTagsClassesModel >> selectMethod: aMethod [
	self selectClass: aMethod methodClass instanceSide.
	self notifyMethodSelected: aMethod
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTagsClassesModel >> selectMethodProtocol: aMethodProtocol source: aSource [
	self notifyMethodProtocolSelected: aMethodProtocol source: aSource
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTagsClassesModel >> selectPackage: anRPackage [
	| aCoder |
	(self showPackage: anRPackage)
		ifFalse: [ ^ self ].
	(coder isForPackage and: [ coder package = anRPackage ])
		ifTrue: [ ^ self ].
	aCoder := (coder isForPackageTag and: [ coder package = anRPackage ])
		ifTrue: [ coder packageCoder ]
		ifFalse: [ GtPackageCoder forPackage: anRPackage ].
	self assertCoder: aCoder.
	self coder: aCoder.
	self notifyPackageSelected: anRPackage
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTagsClassesModel >> selectPackageTag: aRPackageTag [
	| packageCoder aCoder |
	(self showPackage: aRPackageTag package)
		ifFalse: [ ^ self ].
	(coder isForPackageTag
		and: [ coder package = aRPackageTag package
				and: [ coder packageTag = aRPackageTag ] ])
		ifTrue: [ ^ self ].
	packageCoder := ((coder isForPackage
		and: [ coder package = aRPackageTag package ])
		ifTrue: [ coder ])
		ifNil: [ GtPackageCoder forPackage: aRPackageTag package ].
	aCoder := packageCoder packageTagCoderFor: aRPackageTag.
	self assertCoder: aCoder.
	self coder: aCoder.
	self notifyTagSelected: aRPackageTag package: aRPackageTag package
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTagsClassesModel >> selectTag: anRPackageTag [
	| aCoder |
	(self showPackage: anRPackageTag package)
		ifFalse: [ ^ self ].
	(coder isForPackageTag and: [ coder packageTag = anRPackageTag ])
		ifTrue: [ ^ self ].
	aCoder := ((coder isForPackage
		and: [ coder package = anRPackageTag package ])
		ifTrue: [ coder packageTagCoderFor: anRPackageTag ])
		ifNil: [ GtPackageTagCoder forPackageTag: anRPackageTag ].
	self assertCoder: aCoder.
	self coder: aCoder.
	self notifyTagSelected: anRPackageTag package: anRPackageTag package
]

{ #category : #'api - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> selectedClass [
	<return: #Class>
	^ coder theClass
]

{ #category : #'api - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> selectedClassDo: aBlock [
	self selectedClass ifNotNil: aBlock
]

{ #category : #'api - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> selectedPackage [
	<return: #RPackage>
	^ coder package
]

{ #category : #'api - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> selectedPackageDo: aBlock [
	self selectedPackage ifNotNil: aBlock
]

{ #category : #'api - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> selectedTag [
	<return: #RPackageTag>
	^ coder packageTag
]

{ #category : #'api - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> selectedTagDo: aBlock [
	self selectedTag ifNotNil: aBlock
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTagsClassesModel >> showPackage: anRPackage [
	^ packages isNil or: [ packages includes: anRPackage ]
]

{ #category : #'api - subscriptions' }
GtCoderNavigationPackagesTagsClassesModel >> subscribeToSystem [
	SystemAnnouncer uniqueInstance weak
		when: RPackageRegistered send: #packageRegistered: to: self;
		when: RPackageUnregistered send: #packageUnregistered: to: self;
		when: RPackageRenamed send: #packageRenamed: to: self;
		when: ClassTagAdded send: #packageTagAdded: to: self;
		when: ClassTagRemoved send: #packageTagRemoved: to: self;
		when: ClassRenamed send: #classRenamed: to: self;
		when: ClassModificationApplied send: #classModificationApplied: to: self
]

{ #category : #'api - subscriptions' }
GtCoderNavigationPackagesTagsClassesModel >> unsubscribeFromSystem [
	SystemAnnouncer uniqueInstance unsubscribe: self
]
