package ui 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class ImageLoader extends BaseView 
	{
		private var _loader:Loader
		
		public function ImageLoader( path:String ) 
		{
			super();
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, function ( e:IOErrorEvent ):void { } );	// Just ignore IOError
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, _onCompleteImg );
			_loader.load( new URLRequest( path ) );
		}
		
		private function _onCompleteImg(e:Event):void 
		{
			_loader.content.width = viewWidth;
			_loader.content.height = viewHeight;
			
			var content:Bitmap = _loader.content as Bitmap;
			if ( content )
			{
				content.smoothing = true;
			}
			
			addChild( _loader );
		}
		
		override public function updateLayout():void 
		{
			super.updateLayout();
			
			if ( _loader.content )
			{
				_loader.content.width = viewWidth;
				_loader.content.height = viewHeight;
			}
		}
		
	}

}