Extension { #name : #Behavior }

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> gtBrowse [
	^ (GtCoder forClass: self) openInPager maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> gtBrowseFrom: anElement [
	^ ((GtCoder forClass: self) 
		openInPagerFrom: anElement)
			maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> gtCoderCommentsFor: aView [
	<gtClassView>

	^ aView explicit
		title: 'Comment';
		tooltip: 'Class comment';
		priority: 30;
		disableAsync;
		stencil: [ (GtDocumenter forClass: self) ];
		actionButtonIcon: BrGlamorousVectorIcons accept 
			tooltip: 'Save document' 
			action: [ :aToggle :aTab | aTab viewContentElement save ];
		actionToggleIcon: BrGlamorousIcons edit 
			tooltip: 'Show/Hide Markups'
			activated: [ :aToggle :aTab | aTab viewContentElement showMarkup ] 
			deactivated: [ :aToggle :aTab | aTab viewContentElement hideMarkup ];
		actionButtonIcon: BrGlamorousVectorIcons remove
			tooltip: 'Decrease font size'
			action: [ :aToggle :aTab | aTab viewContentElement decreaseNormalFontSize ];
		actionButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'Increase font size'
			action: [ :aToggle :aTab | aTab viewContentElement increaseNormalFontSize ];
		actionUpdateButtonTooltip: 'Update class comment'
]

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> gtCoderExamplesFor: aView context: aDictionary [
	<gtClassView>
	| anExamplesClassName |

	anExamplesClassName := (self name , 'Examples') asSymbol.

	^ self environment
		at: anExamplesClassName
		ifPresent: [ :aClass | 
			| methodsCoder |
			methodsCoder := GtClassMethodsCoder forClass: aClass.
			aView explicit
				priority: 50;
				title: 'Related examples';
				actionButtonIcon: BrGlamorousVectorIcons add
					action: [ methodsCoder addNewCoder ];
				stencil: [ methodsCoder asElement ];
				actionButtonIcon: BrGlamorousIcons browse 
					tooltip: 'Browse ', aClass name 
					action: [ :aButton | 
						aButton phlow spawnTool: (GtClassCoderTool forClass: aClass) ] ]
		ifAbsent: [ aView empty ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> gtCoderMethodsFor: aView context: aPhlowContext [
	<gtClassView>
	| aMethodsCoderUIModel aMethodsCoder |

	aMethodsCoderUIModel := self methodsCoderFromContext: aPhlowContext.
	aMethodsCoder := aMethodsCoderUIModel coder.

	^ aView explicit
		priority: 10;
		title: 'Methods';
		disableAsync;
		actionDropdownButtonIcon: BrGlamorousVectorIcons filter
			tooltip: 'Filter'
			content: [ :element | aMethodsCoder filterDropDown: element ];
		actionButtonDo: [ :aButtonAction |
			aButtonAction
				icon: BrGlamorousVectorIcons add;
				tooltip: 'Add new method';
				action: [ aMethodsCoderUIModel addNewCoder ];
				name: GtBehaviorCoder addNewMethodButtonName ];
		actionStencil:
				[ self runAllExamplesButtonForMethodsCoder: aMethodsCoder ];
		stencil: [ aMethodsCoderUIModel asElement ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> methodsCoderFromContext: aPhlowContext [
	<return: #GtMethodsCoderViewModel>

	^ aPhlowContext
		optionAt: #behaviorCoder
		ifPresent: [ :aBehaviorCoderUIModel | aBehaviorCoderUIModel methodsCoderUIModel ]
		ifAbsentPut: [ (GtClassMethodsCoder forClass: self) asCoderUIModel ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> runAllExamplesButtonForMethodsCoder: aMethodsCoder [
	^ BrButton new
		addAptitude:
			(GtFilterRunExampleButtonFourStateIconAptitude new coder: aMethodsCoder);
		addAptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude;
		addAptitude: (GtFilterRunExampleButtonTooltipAptitude new coder: aMethodsCoder);
		icon: BrGlamorousVectorIcons play;
		label: 'Run All Examples';
		action: [ :element | aMethodsCoder exampler runExamplesFrom: element ]
]
