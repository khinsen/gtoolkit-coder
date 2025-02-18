Class {
	#name : #GtCoderNavigationMethodProtocolListElement,
	#superclass : #BrSimpleList,
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #'instance creation' }
GtCoderNavigationMethodProtocolListElement class >> fromClass: aClass [
	^ self new initializeWithClass: aClass
]

{ #category : #'private - ui' }
GtCoderNavigationMethodProtocolListElement >> buildProtocolLabel: aProtocol [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude; 
		beSmallSize;
		text: aProtocol name
]

{ #category : #'private - ui' }
GtCoderNavigationMethodProtocolListElement >> buildProtocolRow: aProtocol index: aRowIndex list: aListElement [
	^ BrWidgetContainer new
		layout: BlLinearLayout horizontal;
		aptitude: BrHorizontalPaneAptitude new + (BrStyleCommonAptitude new
			default: [ :aStyle | aStyle background: BrGlamorousColors deselectedListItemColor ];
			hovered: [ :aStyle | aStyle background: BrGlamorousColors hoveredListItemColor ];
			selected: [ :aStyle | aStyle background: BrGlamorousColors selectedListItemColor ];
			pressed: [ :aStyle | aStyle background: BrGlamorousColors pressedListItemColor ];
			focused: [ :aStyle | aStyle border: (BlBorder paint: BrGlamorousColors focusedListItemBorder width: 1) ]);
		when: BlMouseDownEvent do: [ :anEvent |
			anEvent consumed: true.
			aListElement selectOne: aRowIndex dueTo: anEvent.
			aListElement requestFocus ];
		hMatchParent;
		vFitContent;
		padding: (BlInsets left: 3);
		addChild: (self buildProtocolLabel: aProtocol)
]

{ #category : #initialization }
GtCoderNavigationMethodProtocolListElement >> initialize [
	super initialize.
	
	self stencil: [ :eachProtocol :eachIndex :aListElement | self buildProtocolRow: eachProtocol index: eachIndex list: aListElement ]
]

{ #category : #initialization }
GtCoderNavigationMethodProtocolListElement >> initializeWithClass: aClass [	
	self initializeWithProtocols: aClass organization allProtocols
]

{ #category : #initialization }
GtCoderNavigationMethodProtocolListElement >> initializeWithProtocols: aCollection [	
	self items: (aCollection sorted: [ :protocolA :protocolB | protocolA name < protocolB name ])
]
