package achievements 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class AchievementUI extends Sprite implements IDotaAPI
	{
		public var gameAPI:Object;
		public var globals:Object;
		
		private var _achievementPopupManager:AchievementPopupManager;
		private var _achievementListPanel:AchievementListPanel;
		private var _achievementToggleButton:AchievementToggleButton;
		private var _achievementDebugButtonsPanel:AchievementDebugButtonsPanel;
		
		public function AchievementUI() 
		{
			super();
			
			AchievementDatabase.initialize();
			
			addChild( _achievementListPanel = new AchievementListPanel() );
			addChild( _achievementPopupManager = new AchievementPopupManager() );
			addChild( _achievementToggleButton = new AchievementToggleButton( _achievementListPanel ) );
		//	addChild( _achievementDebugButtonsPanel = new AchievementDebugButtonsPanel() );
		}
		
		public function onLoaded( $gameAPI:Object, $globals:Object ):void
		{
			gameAPI = $gameAPI;
			globals = $globals;
			
			AchievementDatabase.instance.onLoaded( this );
			
			globals.resizeManager.AddListener( this );
			onResize( globals.resizeManager );
		}
		
		public function get database():IAchievementDatabase
		{
			return AchievementDatabase.instance;
		}
		
		public function onResize( re:* ):void
		{
			//trace( "thisScaleX = " + scaleX + ", thisScaleY = " + scaleY );
			
			var scaleRatioY:Number = re.ScreenHeight / 768;
			
			// Update position
			with ( _achievementToggleButton )
			{
				y *= scaleRatioY;
				scaleX = scaleRatioY;
				scaleY = scaleRatioY;
			}
			with ( _achievementListPanel )
			{
				scaleX = scaleRatioY;
				scaleY = scaleRatioY;
			}
		}
		
		//
		// IMPLEMENTS IDotaAPI
		//
		
		public function SubscribeToGameEvent( eventName:String, callback:Function ):void
		{
			gameAPI.SubscribeToGameEvent( eventName, callback );
		}
		
		public function SendServerCommand( command:String ):void
		{
			// command.length <= 512
			gameAPI.SendServerCommand( command );
		}
		
		public function LoadKVFile( path:String ):Object
		{
			return globals.GameInterface.LoadKVFile( path );
		}
		
		public function get gameTime():Number
		{
			return globals.Game.Time();
		}
		
		public function get localPlayerID():int
		{
			return globals.Players.GetLocalPlayer();
		}
		
		public function get isLobbyLeader():Boolean
		{
		//	return false;
			return localPlayerID == 0;
		}
		
	}

}