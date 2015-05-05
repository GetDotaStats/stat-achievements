package ui 
{
	import com.greensock.TweenLite;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import ui.events.UIViewEvent;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class ScrollView extends BaseView
	{
		private var _contentView:BaseView;
		private var _maskShape:Shape;
		private var _scrollBar:ScrollBar;
		
		private var _mouseWheelSensitivity:Number = 20;
		
		public function ScrollView() 
		{
			// Mask shape
			_maskShape = new Shape();
			addChild( _maskShape );
			_maskShape.visible = false;
			
			// Scroll bar
			scrollBar = new ScrollBar();
			
			super();
			
			// Add event listeners
			addEventListener( MouseEvent.MOUSE_WHEEL, _onMouseWheel );
		}
		
		private function _onMouseWheel(e:MouseEvent):void 
		{
			_scrollBar.value -= e.delta * _mouseWheelSensitivity;
		}
		
		private function _onChangedValueScrollBar(e:UIViewEvent):void 
		{
			_updateContentViewPosition();
		}
		
		private function _updateContentViewPosition():void 
		{
			//_contentView.y = -_scrollBar.value;
			TweenLite.killTweensOf( _contentView );
			TweenLite.to( _contentView, 0.15, { y : -_scrollBar.value } );
		}
		
		public function get contentView():BaseView 
		{
			return _contentView;
		}
		
		public function set contentView( value:BaseView ):void 
		{
			if ( _contentView )
			{
				_contentView.removeEventListener( UIViewEvent.RESIZED, _onResizedContentView );
				removeChild( _contentView );
				_contentView.mask = null;
				_maskShape.visible = false;
			}
			
			_contentView = value;
			
			if ( _contentView )
			{
				_maskShape.visible = true;
				_contentView.mask = _maskShape;
				addChildAt( _contentView, getChildIndex( _maskShape ) + 1 );
				_contentView.addEventListener( UIViewEvent.RESIZED, _onResizedContentView );
				_onResizedContentView();
			}
			///TODO :  Handle the scroll bar with null content view
		}
		
		private function _onResizedContentView( e:UIViewEvent = null ):void 
		{
			// Update the scroll bar
			_scrollBar.max = contentView.viewHeight;
		}
		
		override public function set viewWidth(value:int):void 
		{
			super.viewWidth = value;
			_scrollBar.x = value - _scrollBar.viewWidth;
		}
		
		override public function set viewHeight(value:int):void 
		{
			super.viewHeight = value;
			_scrollBar.viewHeight = value;
			_scrollBar.extent = value;
		}
		
		public function get scrollBar():ScrollBar 
		{
			return _scrollBar;
		}
		
		public function set scrollBar(value:ScrollBar):void 
		{
			if ( _scrollBar )
			{
				_scrollBar.removeEventListener( UIViewEvent.CHANGED_VALUE, _onChangedValueScrollBar );
				removeChild( _scrollBar );
			}
			
			_scrollBar = value;
			
			addChild( _scrollBar );
			_scrollBar.addEventListener( UIViewEvent.CHANGED_VALUE, _onChangedValueScrollBar );
		}
		
		override public function updateView():void 
		{
			super.updateView();
			
			// Update the mask
			var g:Graphics = _maskShape.graphics;
			g.clear();
			g.beginFill( 0xFF00FF );
			g.drawRect( 0, 0, viewWidth, viewHeight );
			g.endFill();
		}
		
	}

}