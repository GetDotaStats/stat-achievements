package achievements 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import ui.BaseView;
	import ui.LabelButton;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class ScopeRadioButton extends BaseView 
	{
		private var _activeLabelButtons:Vector.<LabelButton> = new Vector.<LabelButton>();
		private var _inactiveLabelButtons:Vector.<LabelButton> = new Vector.<LabelButton>();
		private var _activeBgImages:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		private var _inactiveBgImages:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		private var _buttonActive:SimpleButton;
		private var _buttonInactive:SimpleButton;
		
		public function ScopeRadioButton( text:String ) 
		{
			super();
			
			backgroundAlpha = 0;
			
			// Create button
			var createLabelImpl:Function = function ( isActive:Boolean, imgClass:Class, altTextAlpha:Boolean = false, altTextColor:Boolean = false ):LabelButton
			{
				var label:LabelButton = new LabelButton( text );
				label.backgroundAlpha = 0;
				
				// Text
				label.label.textColor = altTextColor ? 0xFF6A4D : 0xFFFFFF;
				label.label.alpha = altTextAlpha ? 1.0 : 0.75;
				label.label.filters = [ new DropShadowFilter( 0, 0, 0, 1, 4, 4, 1.5 ) ];
				
				label.label.setTextFormat( new TextFormat( null, 11 ) );
				
				// Background image
				var bgImage:DisplayObject = new imgClass();
				label.addChildAt( bgImage, 0 );
				
				// Store the instances for later use
				if ( isActive )
				{
					_activeLabelButtons.push( label );
					_activeBgImages.push( bgImage );
				}
				else
				{
					_inactiveLabelButtons.push( label );
					_inactiveBgImages.push( bgImage );
				}
				
				return label;
			};
			
			var createButtonImpl:Function = function ( up:Class, over:Class, down:Class, isActive:Boolean ):DisplayObject
			{
				var upButton:LabelButton = createLabelImpl( isActive, up );
				var overButton:LabelButton = createLabelImpl( isActive, over, true );
				var downButton:LabelButton = createLabelImpl( isActive, down, false, true );
				
				// Create simple button
				var simpleButton:SimpleButton = new SimpleButton( upButton, overButton, downButton, upButton );
				
				return simpleButton;
			};
			
			addChild( _buttonInactive = createButtonImpl( radioButton2ndUpClass, radioButton2ndOverClass, radioButton2ndDownClass, false ) );
			addChild( _buttonActive = createButtonImpl( radioButton2ndSelectedUpClass, radioButton2ndSelectedOverClass, radioButton2ndSelectedDownClass, true ) );
		}
		
		override protected function updateBackground():void 
		{
			//super.updateBackground();
			
			_buttonInactive.visible = !isSelected;
			_buttonActive.visible = isSelected;
			
			var heightDifference:Number = 4;
			
			var label:LabelButton
			for each ( label in _activeLabelButtons )
			{
				label.viewWidth = viewWidth;
				label.viewHeight = viewHeight;
			}
			for each ( label in _inactiveLabelButtons )
			{
				label.viewWidth = viewWidth;
				label.viewHeight = viewHeight - heightDifference;
				label.y = heightDifference;
			}
			
			var bgImage:DisplayObject
			for each ( bgImage in _activeBgImages )
			{
				bgImage.width = viewWidth;
				bgImage.height = viewHeight;
			}
			for each ( bgImage in _inactiveBgImages )
			{
				bgImage.width = viewWidth;
				bgImage.height = viewHeight - heightDifference;
				label.y = heightDifference;
			}
		}
		
		[Embed(source = "assets/RadioButton_2nd_up.png", scaleGridTop="3", scaleGridBottom="34", scaleGridLeft="3", scaleGridRight="144")]
		static private const radioButton2ndUpClass:Class;
		
		[Embed(source = "assets/RadioButton_2nd_over.png", scaleGridTop="3", scaleGridBottom="34", scaleGridLeft="3", scaleGridRight="144")]
		static private const radioButton2ndOverClass:Class;
		
		[Embed(source = "assets/RadioButton_2nd_down.png", scaleGridTop="3", scaleGridBottom="34", scaleGridLeft="3", scaleGridRight="144")]
		static private const radioButton2ndDownClass:Class;
		
		[Embed(source = "assets/RadioButton_2nd_selected_up.png", scaleGridTop="3", scaleGridBottom="34", scaleGridLeft="3", scaleGridRight="144")]
		static private const radioButton2ndSelectedUpClass:Class;
		
		[Embed(source = "assets/RadioButton_2nd_selected_over.png", scaleGridTop="3", scaleGridBottom="34", scaleGridLeft="3", scaleGridRight="144")]
		static private const radioButton2ndSelectedOverClass:Class;
		
		[Embed(source = "assets/RadioButton_2nd_selected_down.png", scaleGridTop="3", scaleGridBottom="34", scaleGridLeft="3", scaleGridRight="144")]
		static private const radioButton2ndSelectedDownClass:Class;
		
	}

}