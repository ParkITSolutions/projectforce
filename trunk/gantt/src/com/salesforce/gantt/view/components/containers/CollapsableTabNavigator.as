/*

The MIT License

Copyright (c) 2007-2008 Ali Rantakari

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions: 

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

package com.salesforce.gantt.view.components.containers{
   
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    
    import mx.containers.TabNavigator;
    import mx.controls.TabBar;
    import mx.core.Container;
    import mx.core.EdgeMetrics;
    import mx.core.IFlexDisplayObject;
    import mx.core.IInvalidating;
    import mx.core.mx_internal;
    import mx.skins.ProgrammaticSkin;
   
    use namespace mx_internal;
   
    /**
    *  Vertical positioning of tabs at the side of this VerticalTabNavigator container.
    *  The possible values are <code>"top"</code>, <code>"middle"</code>,
    *  and <code>"bottom"</code>.
    *  The default value is <code>"top"</code>.
    *
    *  <p>If the value is <code>"top"</code>, the top edge of the tab bar
    *  is aligned with the top edge of the VerticalTabNavigator container.
    *  If the value is <code>"bottom"</code>, the bottom edge of the tab bar
    *  is aligned with the bottom edge of the VerticalTabNavigator container.
    *  If the value is <code>"middle"</code>, the tabs are centered on the side
    *  of the VerticalTabNavigator container.</p>
    *
    *  <p>To see a difference between the alignments,
    *  the total width of all the tabs must be less than
    *  the height of the VerticalTabNavigator container.</p>
    */
    [Style(name="verticalAlign", type="String", enumeration="top,middle,bottom", inherit="no")]
   
    /**
    * A TabNavigator that positions the tab bar to either side
    * (left or right) of the component instead of at the top.
    *
    * <p>The value of the <code>tabBarLocation</code> property determines
    * whether to position the tab bar to the left or the right side.</p>
    *
    * <p>The <code>verticalAlign</code> style property can be used to
    * align the tab bar with the top or the bottom of the component, or to
    * vertically center it.</p>
    *
    * @see mx.containers.TabNavigator
    *
    * @author Ali Rantakari
    * 
    * @modified Rodrigo Birriel
    */
	    
    public class CollapsableTabNavigator extends TabNavigator {
       
       // Define static constant for event type.
		private static const RESIZE_CLICK:String = "resizeClick";
		
		// copied from superclass:
        private static const MIN_TAB_WIDTH:Number = 30;
        private static const MIN_TAB_HEIGHT: Number = 29;
       
        private var _tabBarLocation:String = "left";
        
        private var _previousState : Container;
       	
        [Embed(source="../assets/imgs/resize_cursor.png")]
		private var resizeCursor : Class;
		
        
        // Global coordinates for initiating the drag.
		protected var initX:Number;
		protected var initY:Number;
		
		private var oldWidth:Number;
       
        /**
        * Constructor.
        */
        public function CollapsableTabNavigator():void {
            super();
            width = MIN_TAB_HEIGHT;
            resizeToContent = true;
            initX = 0;
            initY = 0;
        }
       
       
       
        // BEGIN: private methods           -----------------------------------------------------------
       
        protected function get tabBarHeight():Number {
            return tabBar.getExplicitOrMeasuredWidth();
        }
       
        protected function get tabBarWidth():Number {
            var tabWidth:Number = getStyle("tabHeight");
           
            if (isNaN(tabWidth))
                tabWidth = tabBar.getExplicitOrMeasuredHeight();
           
            return tabWidth - 1;
        }
       
		// --end--: private methods     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       
        // BEGIN: overridden methods            -----------------------------------------------------------
       
       
        /**
        * @private
        */
        override protected function createChildren():void {
            super.createChildren();
            if (tabBar) {
                tabBar.setStyle("paddingLeft", 5);
                tabBar.setStyle("paddingRight", 0);
                tabBar.addEventListener(MouseEvent.MOUSE_DOWN, resizeHandler);
				tabBar.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
				tabBar.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);       
            }
        }
       
        /**
        * @private
        */
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
           
            // determine the TabBar size based on the height of
            // the container instead of the width
            var vm:EdgeMetrics = viewMetrics;
            var h:Number = unscaledHeight - vm.top - vm.bottom;
           
            var th:Number = tabBarWidth + 1;
            var pw:Number = tabBar.getExplicitOrMeasuredWidth();
            tabBar.setActualSize(Math.min(h, pw), th);
           
           
            // rotate and position the TabBar based on the verticalAlign style
            // property and the tabBarLocation property
            var vAlign:String = getStyle("verticalAlign");
            var allowedVerticalAlignValues:Array = ["top", "bottom", "middle"];
            if (allowedVerticalAlignValues.indexOf(vAlign) == (-1)) vAlign="top";
           
            if (_tabBarLocation == "left") {
                tabBar.rotation = 270;
                if (vAlign == "top") tabBar.move(0,tabBar.width);
                else if (vAlign == "middle") tabBar.move(0,(unscaledHeight/2+tabBar.width/2));
                else if (vAlign == "bottom") tabBar.move(0,unscaledHeight);
            }else if(_tabBarLocation == "right"){
                tabBar.rotation = 90;                
                if (vAlign == "top") tabBar.move(unscaledWidth,0);
                else if (vAlign == "middle") tabBar.move(unscaledWidth,(unscaledHeight/2-tabBar.width/2));
                else if (vAlign == "bottom") tabBar.move(unscaledWidth,unscaledHeight-tabBar.width);
            }else if(_tabBarLocation == "bottom"){
            	tabBar.rotation = 0;
            	if (vAlign == "top") tabBar.move(0,unscaledHeight-tabBar.height);
                else if (vAlign == "middle") tabBar.move(unscaledWidth,(unscaledHeight/2-tabBar.width/2));
                else if (vAlign == "bottom") tabBar.move(0,unscaledHeight);
            }else if(_tabBarLocation == "top"){
            	tabBar.rotation = 0;
            }
        }
       
        /**
        * @private
        */
        override protected function measure():void {
            super.measure();
           
            // remove the height addition made by superclass (tabs are
            // now on the side, not the top)
            var removedHeight:Number = tabBarWidth;
            measuredMinHeight -= removedHeight;
            measuredHeight -= removedHeight;
           
            // add width (same reason as above)
            var addedWidth:Number = tabBarWidth;
            measuredMinWidth += addedWidth;
            measuredWidth += addedWidth;
           
           
           
            // Make sure there is at least enough room
            // to draw all tabs at their minimum size.
            var tabWidth:Number = getStyle("tabWidth");
            if (isNaN(tabWidth)) tabWidth = 0;
           
            var minTabBarWidth:Number = numChildren * Math.max(tabWidth, MIN_TAB_WIDTH);
           
            // Add view metrics.
            var vm:EdgeMetrics = viewMetrics;
            minTabBarWidth += (vm.top + vm.bottom);
           
            // Add horizontal gaps.
            if (numChildren > 1)
                minTabBarWidth += (getStyle("horizontalGap") * (numChildren - 1));
           
            if (measuredHeight < minTabBarWidth) measuredHeight = minTabBarWidth+tabBarWidth;
        }
       
        /**
        * @private
        */
        override protected function get contentHeight():Number {
            // undo content height adjustment made by superclass
            return super.contentHeight + tabBarWidth;
        }
       
        /**
        * @private
        */
        override protected function get contentWidth():Number {
            // adjust content width to accommodate the tab bar
            var vm:EdgeMetrics = viewMetricsAndPadding;
           
            var vmLeft:Number = vm.left;
            var vmRight:Number = vm.right;
           
            if (isNaN(vmLeft))
                vmLeft = 0;
            if (isNaN(vmRight))
                vmRight = 0;
           
            return unscaledWidth - tabBarWidth - vmLeft - vmRight;
        }
       
        /**
        * @private
        */
        override protected function get contentX():Number {
            // adjust content position to accommodate the tab bar
            var paddingLeft:Number = getStyle("paddingLeft");
           
            if (isNaN(paddingLeft))
                paddingLeft = 0;
           
            if (_tabBarLocation == "left") return tabBarWidth + paddingLeft - 5;
            else return paddingLeft - 5;
        }
       
        /**
        * @private
        */
        override protected function get contentY():Number {
            // undo content position adjustment made by superclass
            return super.contentY - tabBarWidth - 5;
        }
       
        /**
        * @private
        */
        override protected function adjustFocusRect(object:DisplayObject = null):void {
            super.adjustFocusRect(object);
           
            // Undo changes made by superclass:
            // "Adjust the focus rect so it is below the tabs"
            // - and redo the same thing with width instead of height
            var focusObj:IFlexDisplayObject = IFlexDisplayObject(getFocusObject());
           
            if (focusObj)
            {
                focusObj.setActualSize(focusObj.width - tabBarWidth, focusObj.height + tabBarWidth);
               
                if (_tabBarLocation == "left") focusObj.move(focusObj.x + tabBarWidth, focusObj.y - tabBarWidth);
                else focusObj.move(focusObj.x, focusObj.y - tabBarWidth);
               
                if (focusObj is IInvalidating)
                    IInvalidating(focusObj).validateNow();
               
                else if (focusObj is ProgrammaticSkin)
                    ProgrammaticSkin(focusObj).validateNow();
            }
        } 
       
        /**
        * @private
        */
        override protected function layoutChrome(unscaledWidth:Number, unscaledHeight:Number):void {
            super.layoutChrome(unscaledWidth, unscaledHeight);
           
            // Undo changes made by superclass:
            // "Move our border so it leaves room for the tabs"
            // - and redo the same thing with width instead of height
            if (border)
            {
                var borderOffset:Number = tabBarWidth;
                border.setActualSize(unscaledWidth - borderOffset, unscaledHeight);
                if (_tabBarLocation == "left"){
                	border.move(borderOffset, 0);
                }else if(_tabBarLocation == "right"){
                	border.move (0, 0);
                }else if(_tabBarLocation == "top"){
                	border.move (0,borderOffset);
                }else if(_tabBarLocation == "bottom"){
                	border.move(0,0);
                }
            }
        }
       
       
        // --end--: overridden methods      - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       
        // BEGIN: public methods            -------------------------------------------------------add----
       
        /**
        * The location of the TabBar (left or right). Possible
        * values are <code>"left"</code> and <code>"right"</code>.
        */
        public function get tabBarLocation():String {
            return _tabBarLocation;
        }
        /**
        * @private
        */
        public function set tabBarLocation(aValue:String):void {
            if (aValue == "left" || aValue == "right" || aValue == "top" || aValue == "bottom"){
            	_tabBarLocation = aValue;
            } 
            else throw new ArgumentError("Value for tabBarLocation must be \"left\" or \"right\" or\"top\" or \"bottom\"");
        }
       
        // --end--: public methods      - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       
       
       
       //  BEGIN: events handlers.
		/**
		 * Init the variable initX or initY depending on the tab bar location.
		 */
       	private function resizeHandler( event:MouseEvent ):void
		{
			// Determine if the mouse pointer is in the lower right 7x7 pixel
			// area of the panel. Initiate the resize if so.
			
			if(tabBarLocation == 'left' || tabBarLocation == 'right'){
				initX = event.localX;
				oldWidth = width
			}
			else if(tabBarLocation == 'top' || tabBarLocation == 'bottom'){
				initY = event.localY;
				oldWidth = height;
			}
			systemManager.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler,true);
			systemManager.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler,true);
	
		}
       
       /**
       * Updates the width or height depending on tab bar location.
       */ 
       private function mouseMoveHandler( event:MouseEvent) : void{
   			//event.stopPropagation();
       		
       		if(tabBarLocation == 'left' || tabBarLocation == 'right'){
				
				width += ((event.stageX - initX)%200);	
				initX = event.stageX;
			}
			else if(tabBarLocation == 'top' || tabBarLocation == 'bottom'){
				height += ((event.stageY - initY)%200);
				initY = event.stageY;	
			}	
       }
       
       /**
       * Simulate the collapsable/expandable effect changing the container width:
       */
       	private function collapseExpandTab(mouseEvent : MouseEvent) :void{
       		if(mouseEvent.target.parent is TabBar){
	       		if(_previousState && _previousState == selectedChild){
	       			width = MIN_TAB_HEIGHT;
	       			_previousState = null;
	       		}else{
	       			//hardcoded width set the selectedChild.width but it doesn't work.
	       			//TODO research about it ;)
	       			width = 1000;
	       			//width = selectedChild.width;
	       			_previousState = selectedChild;
	       		}	
       		}	
       	}
        
       private function mouseUpHandler( event:MouseEvent) : void{
   			var propagate : Boolean = false;
   			if(tabBarLocation == 'left' || tabBarLocation == 'right'){
				if(width < tabBarWidth){
					width = tabBarWidth + 5;
				}
				propagate = oldWidth == width;
			}
			else if(tabBarLocation == 'top' || tabBarLocation == 'bottom'){
				if(height < tabBarHeight){
					height = tabBarHeight + 5;
				}	
				propagate = oldWidth == height;
			}
			if(propagate){
				collapseExpandTab(event);	
			}
			systemManager.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler,true);
			systemManager.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler,true);	
       } 
       
       private function mouseOverHandler( event:MouseEvent) : void{
       		cursorManager.setCursor(resizeCursor);	
       }
       
       private function mouseOutHandler( event:MouseEvent) : void{
   			event.stopPropagation();
   			removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler,true);
   			cursorManager.removeAllCursors();	
       }
       
       //--- end events handlers.
    }
   
}