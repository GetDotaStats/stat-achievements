package ui 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import ui.events.UIViewEvent;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class BaseView extends Sprite 
	{
		private var _viewWidth:int;
		private var _viewHeight:int;
		private var _backgroundColor:uint = 0xDDDDDD;
		private var _backgroundAlpha:Number = 1.0;
		
		private var _isSelected:Boolean;
		
		private var _subviews:Vector.<BaseView> = new Vector.<BaseView>();
		private var _superview:BaseView;
		
		public function BaseView() 
		{
			super();
			
			setDirty();
			
			viewSize = new Vec2i( 50, 50 );
		}
		
		public function addSubview( subview:BaseView ):void
		{
			if ( subview.superview )
			{
				throw new UIViewError( "The subview has been attached already to superview." );
			}
			
			_subviews.push( subview );
			subview._superview = this;
			addChild( subview );
			setDirty();
		}
		
		public function removeSubview( subview:BaseView ):void
		{
			if ( subview.superview != this )
			{
				throw new UIViewError( "The subview has wrong superview." );
			}
			
			removeChild( subview );
			subview._superview = null;
			_subviews.splice( _subviews.indexOf( subview ), 1 );
			setDirty();
		}
		
		public function removeAllSubviews():void
		{
			var removeList:Vector.<BaseView> = subviews.concat();
			for each ( var subview:BaseView in removeList )
			{
				removeSubview( subview );
			}
		}
		
		public function removeFromSuperview():void
		{
			if ( !superview )
			{
				throw new UIViewError( "The view has no superview" );
			}
			
			superview.removeSubview( this );
		}
		
		public function get viewSize():Vec2i
		{
			return new Vec2i( _viewWidth, _viewHeight );
		}
		
		public function set viewSize( value:Vec2i ):void
		{
			viewWidth = value.x;
			viewHeight = value.y;
		}
		
		public function get viewWidth():int 
		{
			return _viewWidth;
		}
		
		public function set viewWidth(value:int):void 
		{
			if ( _viewWidth == value ) return;
			
			_viewWidth = value;
			_fireResizedEvent();
			setDirty();
		}
		
		public function get viewHeight():int 
		{
			return _viewHeight;
		}
		
		public function set viewHeight(value:int):void 
		{
			if ( _viewHeight == value ) return;
			
			_viewHeight = value;
			_fireResizedEvent();
			setDirty();
		}
		
		public function get halfViewWidth():int
		{
			return _viewWidth / 2;
		}
		
		public function get halfViewHeight():int
		{
			return _viewHeight / 2;
		}
		
		public function setViewRect( x:Number, y:Number, width:Number, height:Number ):void 
		{
			this.x = x;
			this.y = y;
			viewWidth = width;
			viewHeight = height;
		}
		
		public function get subviews():Vector.<BaseView> 
		{
			return _subviews;
		}
		
		public function get superview():BaseView 
		{
			return _superview;
		}
		
		public function get backgroundColor():uint 
		{
			return _backgroundColor;
		}
		
		public function set backgroundColor(value:uint):void 
		{
			if ( _backgroundColor == value ) return;
			_backgroundColor = value;
			setDirty();
		}
		
		public function get backgroundAlpha():Number 
		{
			return _backgroundAlpha;
		}
		
		public function set backgroundAlpha(value:Number):void 
		{
			if ( _backgroundAlpha == value ) return;
			_backgroundAlpha = value;
			setDirty();
		}
		
		public function get isSelected():Boolean 
		{
			return _isSelected;
		}
		
		public function set isSelected(value:Boolean):void 
		{
			if ( _isSelected == value ) return;
			_isSelected = value;
			setDirty();
		}
		
		public function setDirty():void
		{
			UIManager.setDirty( this );
		}
		
		public function updateView():void
		{
			updateLayout();
			updateBackground();
			updateForeground();
		}
		
		public function updateLayout():void
		{
			
		}
		
		protected function updateBackground():void
		{
			// Update background
			var g:Graphics = graphics;
			g.clear();
			g.beginFill( _backgroundColor, _backgroundAlpha );
			g.drawRect( 0, 0, _viewWidth, _viewHeight );
			g.endFill();
		}
		
		protected function updateForeground():void
		{
		}
		
		private function _fireResizedEvent():void
		{
			dispatchEvent( new UIViewEvent( UIViewEvent.RESIZED ) );
		}
		
	}

}