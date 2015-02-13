package achievements
{
	import achievements.events.AchievementEvent;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import ui.BaseView;
	import ui.Vec2i;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class AchievementPopupManager extends Sprite 
	{
		[Embed(source = "assets/achievement.jpg")]
		static private const DummyAchievementImg:Class;
		
		private var api:IDotaAPI;
		private var numSlots:int = 3;
		private var activePopups:Vector.<AchievementPopup>;
		private var queuedPopups:Vector.<AchievementPopup>;
		
		public function AchievementPopupManager() 
		{
			super();
			
			activePopups = new Vector.<AchievementPopup>();
			queuedPopups = new Vector.<AchievementPopup>();
			
			// Event listeners
			AchievementDatabase.instance.addEventListener( AchievementEvent.ACHIEVED, _onAchieved );
			
			// Test
			var devButton:Sprite = new Sprite();
		//	addChild( devButton );
			var g:Graphics = devButton.graphics;
			g.beginFill( 0xFFFFFF );
			g.drawRect( 0, 0, 50, 50 );
			g.endFill();
			devButton.addEventListener( MouseEvent.CLICK, function ( evt:MouseEvent ):void
			{
				testPopup();
			} );
		}
		
		private function _onAchieved( e:AchievementEvent ):void 
		{
			var iconView:BaseView = e.info.icon;
			iconView.viewSize = new Vec2i( 64, 64 );
			_queueAchievementPopup( new AchievementPopup( "#Ach_PopupTitle", e.info.name, iconView ) );
		}
		
		public function testPopup():void
		{
			_queueAchievementPopup( new AchievementPopup( "Testing the popup!", "F in Chemistry", new DummyAchievementImg() ) );
		}
		
		private function _onAchievementUnlocked( eventData:Object ):void 
		{
			var achievementID:int	= eventData.achievementID;
			var playerID:int		= eventData.playerID;
			
			if ( api.localPlayerID != playerID )
			{
				// It's not me.
				return;
			}
			
			// Grab localized text
			var achievementName:String = "#ACHIEVEMENT_" + achievementID + "_NAME";
			var achievementDesc:String = "#ACHIEVEMENT_" + achievementID + "_DESCRIPTION";
			
			// Load the icon
			var achievementIcon:DisplayObject = Utils.LoadTexture( "images/achievements/" + achievementID + "_on.png" );
			
			// Queue the popup
			_queueAchievementPopup( new AchievementPopup( "#Ach_PopupTitle", achievementName, achievementIcon ) );
		}
		
		private function _queueAchievementPopup( newPopup:AchievementPopup ):void
		{
			addChildAt( newPopup, 0 );
			if ( activePopups.length > 0 )
			{
				activePopups[activePopups.length - 1].nextPopup = newPopup;
			}
			activePopups.push( newPopup );
			newPopup.x = stage.stageWidth - newPopup.width;
			newPopup.animate( function ():void
			{
				activePopups.shift();
			} );
		}
	}

}