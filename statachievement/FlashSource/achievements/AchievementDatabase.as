package achievements 
{
	import achievements.events.AchievementEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class AchievementDatabase extends EventDispatcher implements IAchievementDatabase
	{
		static private var _instance:AchievementDatabase;
		static private var s_lastInstanceID:int = 0;
		
		public var _instanceID:int;
		
		private var achievementsKV:Object;
		public var achievementAry:Array = new Array();
		
		private var _isLoading:Boolean = false;
		private var _changedAchievementMap:Array = new Array();
		
		private var _api:IDotaAPI;
		
		public function AchievementDatabase() 
		{
			_instanceID = ++s_lastInstanceID;
			
			Utils.Log( "Creating an instance of AchievementDatabase..." );
		}
		
		static public function initialize():void
		{
			_instance = new AchievementDatabase();
		}
		
		static public function get instance():AchievementDatabase
		{
			return _instance;
		}
		
		public function get numAchievements():uint
		{
			// achievementAry is a sparsed array so we can't use Array#length.
			var count:uint = 0;
			for ( var index:* in achievementAry ) count++;
			return count;
		}
		
		public function get numAchievedAchievements():uint
		{
			return achievementAry.filter( function ( ach:AchievementInfo, index:int, array:Array ):Boolean {
				if ( !ach ) return false;
				return ach.isAchieved;
			} ).length;
		}
		
		public function get isLoading():Boolean 
		{
			return _isLoading;
		}
		
		public function set isLoading(value:Boolean):void 
		{
			_isLoading = value;
		}
		
		public function setValue( achievementID:int, achievementValue:int ):void
		{
			try
			{
				// Grab the achievement
				var ach:AchievementInfo = achievementAry[achievementID];
				
				ach.currentValue = achievementValue;
			}
			catch ( e:Error )
			{
				Utils.LogError( e );
			}
		}
		
		public function getChangeList( bClearChangeList:Boolean = true ):Array
		{
			var changeList:Array = new Array();
			
			_changedAchievementMap.forEach( function ( ach:AchievementInfo, id:int, array:Array ):void
			{
				if ( !ach ) return;
				
				changeList.push( {
					achievementID : id,
					achievementValue : ach.currentValue
				} );
				
				Utils.Log( "Pushed an achievement to change list." );
			} );
			
			if ( bClearChangeList )
			{
				// Clear
				_changedAchievementMap = new Array();
			}
			
			return changeList;
		}
		
		public function dev_generateDummyAchievements():void
		{
			for ( var i:int = 0; i < 50; i++ )
			{
				var info:AchievementInfo = AchievementInfo.createDummyAchievementInfo( i % 2 > 0 );
				achievementAry.push( info );
				info.addEventListener( AchievementEvent.ACHIEVED, _onAchievementAchieved );
			}
			
			dispatchEvent( new AchievementEvent( AchievementEvent.LOADED ) );
		}
		
		public function onLoaded( api:IDotaAPI ):void
		{
			_api = api;
			
			achievementAry = new Array();
			_changedAchievementMap = new Array();
			
			// Load KV file
			achievementsKV = api.LoadKVFile( "scripts/achievements.kv" );
			
			if ( !achievementsKV )
			{
				Utils.Log( "\"achievements.kv\" not found." );
				return;
			}
			
			for ( var k:String in achievementsKV )
			{
				var v:Object = achievementsKV[k];
				var info:AchievementInfo = new AchievementInfo( int(k) );
				if ( v.count_max ) info.maxValue = int(v.count_max);
				
				Utils.Log( "Achievement ID = " + k + ", Count Max = " + info.maxValue );
				
				achievementAry[int(k)] = info;
				info.addEventListener( AchievementEvent.CHANGED_VALUE, _onAchievementChangedValue );
				info.addEventListener( AchievementEvent.ACHIEVED, _onAchievementAchieved );
			}
			
			Utils.Log( "InstanceID = " + _instanceID );
			dispatchEvent( new AchievementEvent( AchievementEvent.LOADED ) );
			Utils.Log( "Achievement Loaded Fired" );
			
			// Register game event listener
			api.SubscribeToGameEvent( "stat_ach_update_value", _onUpdateValue );
		}
		
		private function _onAchievementChangedValue( e:AchievementEvent ):void 
		{
			// Check to see if the achievement data is loading
			if ( isLoading ) return;
			
			// Push to the change list
			_changedAchievementMap[e.info.id] = e.info;
		}
		
		private function _onAchievementAchieved( e:AchievementEvent ):void 
		{
			dispatchEvent( new AchievementEvent( AchievementEvent.ACHIEVED, e.info ) );
		}
		
		private function _onUpdateValue( event:Object ):void
		{
			try
			{
				if ( event.playerID != _api.localPlayerID ) return;
				
				// Grab the achievement
				var ach:AchievementInfo = achievementAry[event.achievementID];
				
				ach.currentValue = event.value;
			}
			catch ( e:Error )
			{
				Utils.LogError( e );
			}
		}
		
	}

}