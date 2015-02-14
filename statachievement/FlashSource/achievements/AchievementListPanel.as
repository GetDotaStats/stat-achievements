package achievements 
{
	import achievements.events.AchievementEvent;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import ui.BaseView;
	import ui.events.UIViewEvent;
	import ui.GridView;
	import ui.LabelButton;
	import ui.ProgressBar;
	import ui.SegmentedControl;
	import ui.TableView;
	import ui.TabView;
	import ui.Vec2i;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class AchievementListPanel extends BaseView 
	{
		static private const HEADER_HEIGHT:int = 120 - 8;
		static private const FOOTER_HEIGHT:int = 15;
		static private const SCOPE_BAR_HEIGHT:int = 34;
		
		private var _tabView:TabView;
		private var _scopeButtonsView:SegmentedControl;
		private var _tabButtonsView:SegmentedControl;
		
		private var _availableListView:TableView;
		private var _earnedListView:TableView;
		private var _allListView:TableView;
		private var _availableGridView:GridView;
		private var _earnedGridView:GridView;
		private var _allGridView:GridView;
		
		private var _availableGroupAry:Array = new Array();
		private var _earnedGroupAry:Array = new Array();
		private var _recentlyEarnedGroupAry:Array = new Array();
		private var _allGroupViews:Array = new Array();
		
		private var _scopeAllButton:ScopeRadioButton;
		private var _scopeUnlockedButton:ScopeRadioButton;
		private var _scopeAvailableButton:ScopeRadioButton;
		
		public function AchievementListPanel() 
		{
			super();
			
			viewSize = new Vec2i( 400, 640 );
			
			x = 100;
			y = 50;
			
			backgroundAlpha = 0;
			
			// Header
			addChild( new windowTopClass() );
			
		/*	var leftIconPanel:BaseView = new BaseView();
			addSubview( leftIconPanel );
			leftIconPanel.setViewRect( 0, 11, 32, 48 );
			leftIconPanel.backgroundColor = 0x3399FF;
			
			var leftIcon:Bitmap = new achievementIconClass();
			leftIconPanel.addChild( leftIcon );
			leftIcon.smoothing = true;
			leftIcon.width = 26;
			leftIcon.height = 26;
			leftIcon.x = ( leftIconPanel.viewWidth - leftIcon.width ) / 2;
			leftIcon.y = ( leftIconPanel.viewHeight - leftIcon.height ) / 2;
			leftIcon.alpha = 0.7;
			*/
			var achievementLabel:TextField = Utils.CreateLabel( "#addon_game_name", FontType.TextFontBold, function ( format:TextFormat ):void
			{
				format.size = 16;
				format.color = 0x82d9d9;
			} );
			achievementLabel.filters = [ new GlowFilter( 0x00AAFF, 0.5 ) ];
			addChild( achievementLabel );
			achievementLabel.autoSize = TextFieldAutoSize.LEFT;
			achievementLabel.x = 88;
			achievementLabel.y = 17;
			
			var progress:ProgressBar = new OverallProgressBar();
			progress.x = 89;
			progress.y = 45;
			addSubview( progress );
			progress.backgroundColor = 0x222222;
			progress.value = 40;
			
			var countLabel:TextField = Utils.CreateLabel( "23/40", FontType.TextFont, function ( format:TextFormat ):void
			{
				format.size = 28;
				format.color = 0x333333;
				format.align = TextFormatAlign.CENTER;
			} );
		//	addChild( countLabel );
			countLabel.autoSize = TextFieldAutoSize.CENTER;
			countLabel.x = 345 - 50;
			countLabel.y = 35 - countLabel.textHeight / 2;
			countLabel.width = 100;
			
			// Scope bar
			var scopeBar:BaseView = new BaseView();
			addSubview( scopeBar );
			
			scopeBar.y = HEADER_HEIGHT - SCOPE_BAR_HEIGHT;
			scopeBar.viewWidth = viewWidth;
			scopeBar.viewHeight = SCOPE_BAR_HEIGHT;
			scopeBar.backgroundColor = 0x3399FF;
			scopeBar.backgroundAlpha = 0;
			
			scopeBar.filters = [ new DropShadowFilter( 4, 90, 0, 0.75, 0, 8 ) ];
			
			var scopeBarBg:Bitmap = new tabBarBgClass();
			scopeBar.addChild( scopeBarBg );
			
			_scopeButtonsView = new SegmentedControl();
			_scopeButtonsView.backgroundAlpha = 0;
			scopeBar.addSubview( _scopeButtonsView );
			_scopeButtonsView.x = 0;
			_scopeButtonsView.y = ( SCOPE_BAR_HEIGHT - 34 ) / 2;
			
			var createScopeButton:Function = function ( text:String ):ScopeRadioButton
			{
				var scopeButton:ScopeRadioButton = new ScopeRadioButton( text );
				scopeButton.viewWidth = 100;
				scopeButton.viewHeight = 34;
				
				_scopeButtonsView.addSubview( scopeButton );
				
				return scopeButton;
			};
			
			_scopeAllButton = createScopeButton( "#Ach_ScopeAll" );
			_scopeUnlockedButton = createScopeButton( "#Ach_ScopeEarned" );
			_scopeAvailableButton = createScopeButton( "#Ach_ScopeAvailable" );
			
			_scopeButtonsView.updateLayout();
			
			scopeBarBg.x = _scopeButtonsView.viewWidth;
			scopeBarBg.y = _scopeButtonsView.y + 5;
			scopeBarBg.width = scopeBar.viewWidth - scopeBarBg.x;
			
			_tabButtonsView = new SegmentedControl();
			scopeBar.addSubview( _tabButtonsView );
			
			var tabButtonSize:int = 28;
			_tabButtonsView.y = ( SCOPE_BAR_HEIGHT - tabButtonSize ) / 2;
			_tabButtonsView.margin = 3;
			_tabButtonsView.backgroundAlpha = 0;
			
			_tabButtonsView.addSubview( new ViewTypeButton( ViewTypeButton.VIEW_TYPE_LIST ) );
			_tabButtonsView.addSubview( new ViewTypeButton( ViewTypeButton.VIEW_TYPE_GRID ) );
			
			_tabButtonsView.updateLayout();
			_tabButtonsView.x = scopeBar.viewWidth - _tabButtonsView.viewWidth - 8;
			_tabButtonsView.y = _scopeButtonsView.y + 7;
			
			// Create tabbed views
			_tabView = new TabView();
			addSubview( _tabView );
			
			_tabView.y = HEADER_HEIGHT;
			_tabView.viewWidth = viewWidth;
			_tabView.viewHeight = viewHeight - HEADER_HEIGHT - FOOTER_HEIGHT;
			
			//
			// Tabs
			//
			var createListView:Function = function ( groupViewClass:Class, incAvailableGroup:Boolean, incAchievedGroup:Boolean ):TableView
			{
				var view:TableView = new TableView();
				view.rowHeight = -1;
				view.backgroundColor = 0x202020;
				view.scrollBar = new CustomScrollBar();
				_tabView.addSubview( view );
				
				view.contentView.backgroundAlpha = 0;
				
				// Order of groups
				//  1. Recently achieved
				//  2. available
				//  3. achieved
				var group:*;
				if ( incAchievedGroup )
				{
					group = new groupViewClass( "#Ach_GroupRecentlyEarned" );
					view.addCell( group );
					_recentlyEarnedGroupAry.push( group );
					_allGroupViews.push( group );
				}
				if ( incAvailableGroup )
				{
					group = new groupViewClass( "#Ach_GroupAvailable" );
					view.addCell( group );
					_availableGroupAry.push( group );
					_allGroupViews.push( group );
				}
				if ( incAchievedGroup )
				{
					group = new groupViewClass( "#Ach_GroupEarned" );
					view.addCell( group );
					_earnedGroupAry.push( group );
					_allGroupViews.push( group );
				}
				
				return view;
			};
			
			_allListView = createListView( ListGroupView, true, true );			// 0
			_earnedListView = createListView( ListGroupView, false, true );		// 1
			_availableListView = createListView( ListGroupView, true, false );	// 2
			_allGridView = createListView( GridGroupView, true, true );			// 3
			_earnedGridView = createListView( GridGroupView, false, true );		// 4
			_availableGridView = createListView( GridGroupView, true, false );	// 5
			
			_tabView.updateLayout();	// Update viewWidth of the group views
			
			// Event listener for changing active tab
			_scopeButtonsView.addEventListener( UIViewEvent.CHANGED_SELECTED, changeActiveTab );
			_tabButtonsView.addEventListener( UIViewEvent.CHANGED_SELECTED, changeActiveTab );
		
			// Depth
			swapChildren( scopeBar, _tabView );
			
			// Event listeners
			Utils.Log( "AchListPanel : Registering event listeners." );
			AchievementDatabase.instance.addEventListener( AchievementEvent.LOADED, _onLoadedAchievementDatabase );
			AchievementDatabase.instance.addEventListener( AchievementEvent.ACHIEVED, _onAchieved );
			
			addEventListener( MouseEvent.MOUSE_DOWN, _onMouseDown );
			
			// TEST
		//	AchievementDatabase.instance.dev_generateDummyAchievements();
			
			_tabView.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				//trace("what's this?");
			});
		}
		
		private function _onMouseDown(e:MouseEvent):void 
		{
			//trace( "x = " + x + ", y = " + y );
			//trace( "stageX = " + e.stageX + ", stageY = " + e.stageY );
			
			// Check area
			var area:Rectangle = new Rectangle( 0, 0, viewWidth, HEADER_HEIGHT - SCOPE_BAR_HEIGHT );
			if ( area.containsPoint( globalToLocal( new Point( e.stageX, e.stageY ) ) ) )
			{
				startDrag();
				
				stage.addEventListener( MouseEvent.MOUSE_UP, function ( e:MouseEvent ):void
				{
					e.currentTarget.removeEventListener( e.type, arguments.callee );
					stopDrag();
				} );
			}
		}
		
		private function changeActiveTab(e:UIViewEvent):void 
		{
			_tabView.currentIndex = _scopeButtonsView.selectedIndex + _tabButtonsView.selectedIndex * 3;
		}
		
		private function _onLoadedAchievementDatabase(e:AchievementEvent):void 
		{
			try
			{
				Utils.Log( "AchievementListPanel#_onLoadedAchievementDatabase" );
				
				var groupView:IAchievementGroupView;
				
				// Reset
				for each ( groupView in _allGroupViews )
				{
					groupView.removeAllAchievements();
				}
				
				Utils.Log( "Achievement group viees have been reset." );
				
				// Add all achievements loaded
				for each ( var info:AchievementInfo in AchievementDatabase.instance.achievementAry )
				{
					if ( info.isAchieved )
					{
						for each ( groupView in _earnedGroupAry )
						{
							groupView.addAchievement( info );
						}
					}
					else
					{
						for each ( groupView in _availableGroupAry )
						{
							groupView.addAchievement( info );
						}
					}
				}
				
				Utils.Log( "Layouts of achievement views are being updated." );
				updateTableLayouts();
			} catch ( e:Error ) {
				Utils.LogError( e );
			}
		}
		
		private function _onAchieved(e:AchievementEvent):void 
		{
			if ( AchievementDatabase.instance.isLoading ) return;
			
			var groupView:IAchievementGroupView;
			
			// Remove from the available list
			for each ( groupView in _availableGroupAry )
			{
				groupView.removeAchievement( e.info );
			}
			
			// Add to the earned list
			for each ( groupView in _earnedGroupAry )
			{
				groupView.addAchievement( e.info );
			}
			for each ( groupView in _recentlyEarnedGroupAry )
			{
				groupView.addAchievement( e.info );
			}
			
			updateTableLayouts();
		}
		
		private function updateTableLayouts():void 
		{
			for each ( var groupView:IAchievementGroupView in _allGroupViews )
			{
				groupView.updateLayout();
			}
			
			_availableListView.contentView.setDirty();
			_earnedListView.contentView.setDirty();
			_allListView.contentView.setDirty();
			_availableGridView.contentView.setDirty();
			_earnedGridView.contentView.setDirty();
			_allGridView.contentView.setDirty();
		}
		
		[Embed(source = "assets/Window_Top.png")]
		static private const windowTopClass:Class;
		
		[Embed(source = "assets/achievement.png")]
		static private const achievementIconClass:Class;
		
		[Embed(source = "assets/listView.png")]
		static private const listViewIconClass:Class;
		
		[Embed(source = "assets/gridView.png")]
		static private const gridViewIconClass:Class;
		
		[Embed(source = "assets/TabBar_Bg.png")]
		static private const tabBarBgClass:Class;
		
	}

}