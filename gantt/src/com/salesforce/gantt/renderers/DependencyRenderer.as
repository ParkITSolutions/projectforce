package com.salesforce.gantt.renderers
{
	import com.salesforce.gantt.model.UI;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.gantt.model.Dependency;
	
	import flash.display.Graphics;
	
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.utils.GraphicsUtil;
	
	[Event(name="dataChange", type="mx.events.FlexEvent")]
	
	/*
	 * The comments of the methods to draw have divided in sections to describe the steps
	 *      	  ______________________________________
	 *	      _A_|           Parent Task                |
	 *		 |   |______________________________________|    
	 *		B|_____________________________________________
	 *						      C						   |
	 *													   |D
	 * 													 _\/___________________________________
	 *	     											|             Child Task               |
	 *		 											|______________________________________|   
	 * 
	 */
	
	
	public class DependencyRenderer extends UIComponent implements IDataRenderer, IListItemRenderer
	{
		private var task : UiTask = null;				
		private var _graphics : Graphics;
		
		private var _x : int = 0;
		private var _y : int = 0;
		private var _width : int = 0;
		private var _height : int = 0;
		
		// The variables named xOffset and yOffset are used to center the lines 
		// otherwise they would be alignated to the borders.
    	private static var X_OFFSET : int = 5;
    	private static var Y_OFFSET : int = 5;
    	
    	// Variable used as grid top which sums to all the measures and the lines.
    	private var headerHeight : int = 20;
	    
	    [Bindable("dataChange")]
		public function get data():Object
		{
			return task;	
		}
		public function set data(value : Object):void
		{
			this.task = UiTask(value);
			this.invalidateProperties();
			this.invalidateDisplayList();
			dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
		}
		
		override protected function updateDisplayList(width : Number, height : Number) : void
		{
			super.updateDisplayList(width, height);
			
			_graphics = graphics;		
			_graphics.clear();
			_graphics.lineStyle(1, 0x000000, 1);
			
			if ( task != null)
			{
				draw();
			}
			_graphics.endFill();
		}
		
		private function draw() : void
		{
			var scale : Number = UI.scale;
			
			// indicate the number of lines multiplied per ROW_HEIGHT constant.
			var row : int = -5;// task.position * ROW_HEIGHT;//row * ROW_HEIGHT;
			for(var j : int = 0; j < task.dependencies.length; j++)
    		{
    			_x = 0;
    			_y = 0;
				_width = 0;
				_height = 0;
			
    			var dependency : Dependency = Dependency(task.dependencies.getItemAt(j));
    			
    			
    			if(dependency.task != null)
    			{
   					if(UiTask(dependency.task).isVisible())
		    		{
		    			var sumWidth : int = 0;
		    			var sumHeight : int = 0;
		    			var sumX : int = 0;
		    			var sumY : int = 0;
		    			if(task.isMilestone)
		    			{
		    				sumWidth = 0.5 * scale;
		    			}
		    			else if(dependency.task.isMilestone)
		    			{
		    				sumX = 0.5 * scale;
		    				sumY = 10;
		    			}
		    			
		    			//Inside the switch structure calculates the variables named: x,y,width,height 
		    			//to call drawing functions with parameters
			    		switch (dependency.lagType)
						{
							case Dependency.SS:
							case Dependency.SF:
								//if the child task is below of its parent
								if(dependency.lineHeight(task)>0)
								{
					    			_x = dependency.lineX() * scale - X_OFFSET;
					    			
					    			
					    			if(dependency.lagType == Dependency.SF)
					    			{
					    				_width = (dependency.lineWidth(task) * scale) + _x;
					    			}
					    			else if(dependency.lagType == Dependency.SS)
					    			{
					    				_width = (dependency.lineWidth(task) * scale) + _x + (X_OFFSET * 2);
					    			}
					    			
					    			_y = row - (dependency.lineHeight(task) * UI.ROW_HEIGHT) + headerHeight + 2;
					    			_height = (dependency.lineHeight(task) * UI.ROW_HEIGHT) + _y - headerHeight;
		
									_width+=sumWidth;
					    			_x+=sumX;
					    			_y+=sumY;
					    			
									//draw a dependency
					    			if(dependency.lineWidth(task) >= 0)
					    			{
					    				drawSXDownFordward();
					    			}
					    			else
					    			{
					    				drawSXDownBack();
					    			}
					 			}
					 			// it never happens for now
					 			else//if the parent task is below of its child
					 			{
									_x = dependency.lineX() * scale;
									
									if(dependency.lagType == Dependency.SF)
					    			{
					    				_width = (dependency.lineWidth(task) * scale) + _x - X_OFFSET;
					    			}
					    			else if(dependency.lagType == Dependency.SS)
					    			{
					    				_width = (dependency.lineWidth(task) * scale) + _x + X_OFFSET;
					    			}
					    			
					    			_height = row + headerHeight + Y_OFFSET;
					    			_y = row + (dependency.lineHeight(task) * (-1) * UI.ROW_HEIGHT) + headerHeight - Y_OFFSET;
									
									_width+=sumWidth;
					    			_x+=sumX;
					    			_y+=sumY;
					    			
					    			//draws the dependency
					    			if(dependency.lineWidth(task) >= 0)
					    			{
					    				drawSXUpFordward();
					    			}
					    			else
					    			{
					    				drawSXUpBack();
					    			}
					 			}
								break;
								
							case Dependency.FS:
							case Dependency.FF:
								//if the child task is below its parent
								if(dependency.lineHeight(task)>0)
								{
									_x = dependency.lineX() * scale;
									
									if(dependency.lagType == Dependency.FS)
					    			{
					    				_width = (dependency.lineWidth(task) * scale) + _x + X_OFFSET;
					    			}
					    			else if(dependency.lagType == Dependency.FF)
					    			{
					    				_width = (dependency.lineWidth(task) * scale) + _x - X_OFFSET;
					    			}
					    			
					    			_y = row - (dependency.lineHeight(task) * UI.ROW_HEIGHT) + headerHeight - Y_OFFSET;
					    			_height = (dependency.lineHeight(task) * UI.ROW_HEIGHT) + _y - Y_OFFSET;
					    			
					    			_width+=sumWidth;
					    			_x+=sumX;
					    			_y+=sumY;
					    			
					    			//draws a dependency
					    			if(dependency.lineWidth(task) > 0)
					    			{
					    				drawFXDownFordward();
					    			}
					    			else
					    			{
					    				drawFXDownBack();
					    			}
					    		}
					    		//it never happens for now
					 			else//if the parent task is below its child
					 			{
					    			_x = dependency.lineX() * scale;
					    			
					    			if(dependency.lagType == Dependency.FF)
					    			{
					    				_width = (dependency.lineWidth(task) * scale) + _x;
					    			}
					    			else if(dependency.lagType == Dependency.FS)
					    			{
					    				_width = (dependency.lineWidth(task) * scale) + _x + (X_OFFSET * 2);
					    			}
					    			
					    			_height = row + headerHeight + Y_OFFSET;
					    			_y = row + (dependency.lineHeight(task) * (-1) * UI.ROW_HEIGHT);
									
									_width+=sumWidth;
					    			_x+=sumX;
					    			_y+=sumY;
					    			
									//draws a dependency
					    			if(dependency.lineWidth(task) > 0)
					    			{
					    				drawFXUpFordward();
					    			}
					    			else
					    			{
					    				drawFXUpBack();
					    			}
					 			}
								break;
						}
		    		}
		    	}
    		}
		}
		
		/*
	     * Draws a vertical line
	     */
		private function drawVerticalLine(x : int, top : int, bottom : int) : void 
		{
			drawPoint(x, top);
			drawPoint(x, bottom);
		}
		
		/*
	     * Draws a horizontal line
	     */
		private function drawHorizontalLine(y : int, left : int, right : int) : void 
		{
			drawPoint(left, y);
			drawPoint(right, y);
		}
		
		/*
	     * Draws an downward arrow
	     */
		private function drawDownArrow(x : int, y : int) : void
		{
			var length : int = 3;
			movePoint(x - length, y - length);
			
			_graphics.beginFill(0x000000);
			
			drawPoint(x - length, y - length);
			drawPoint(x, y);
			drawPoint(x + length + 1, y - length);
			drawPoint(x - length, y - length);
			
			_graphics.endFill();
		}
		
		/*
		 * Draws a upward arrow
	     */
		private function drawUpArrow(x : int, y : int) : void
		{
			var length : int = 3;
			movePoint(x - length, y + length);
			
			_graphics.beginFill(0x000000);
			
			drawPoint(x - length, y + length);
			drawPoint(x, y);
			drawPoint(x + length + 1, y + length);
			drawPoint(x - length, y + length);
			
			_graphics.endFill();
		}
		
	    /*
	     * Draws a line from SS to SF
	     * when the arrow has direction from up to down and right.
	     */
	    private function drawSXDownFordward () : void
	    {
	    	movePoint(_x + X_OFFSET, _y - Y_OFFSET);
	    	drawHorizontalLine(_y - Y_OFFSET, _x + X_OFFSET, _x);//draw A
	    	//B is automatically drawn in the intersection between line A and C.
	    	drawHorizontalLine(_height, _x, _width);//draw C
	    	
	    	drawVerticalLine(_width, _height, _height + Y_OFFSET);//draw D
	    	drawDownArrow(_width, _height + Y_OFFSET);
	    	//drawVerticalLine(_width, _height, _height + (Y_OFFSET/2));//draw D
	    	//drawDownArrow(_width, _height + (Y_OFFSET/2));
	    }
	    /*
	     * Draws a line from SS to SF
	     * when the arrow has direction from up to down and left.
	     */
	    private function drawSXDownBack () : void
	    {
	    	movePoint(_x + X_OFFSET, _y - Y_OFFSET);
	    	drawHorizontalLine(_y - Y_OFFSET, _x + X_OFFSET, _width);//draw C
	    	drawVerticalLine(_width, _y - Y_OFFSET, _height + Y_OFFSET);//draw D
	    	drawDownArrow(_width, _height + Y_OFFSET);
	    }
	    /*
	     * 
	     * Draws a line from SS to SF
	     * when the arrow has direction from down to up and left.
	     */
	    private function drawSXUpBack () : void
	    {
	    	movePoint(_width, _height + Y_OFFSET);
	    	drawVerticalLine(_width, _height + Y_OFFSET, _y + (Y_OFFSET / 2));//draw D
	    	drawHorizontalLine(_y + (Y_OFFSET / 2), _width, _x);//draw C
	    	drawUpArrow(_width, _height + Y_OFFSET);
	    }
	    
	    /*
	     *
	     * Draws a line from SS to SF
	     * when the arrow has direction from down to up and right.
	     */  
	    private function drawSXUpFordward () : void
	    {
	    	movePoint(_width, _height + Y_OFFSET);
	    	drawVerticalLine(_width, _height + Y_OFFSET, _y - (Y_OFFSET * 2));//draw D
	    	drawHorizontalLine(_y - (Y_OFFSET * 2), _width, _x - X_OFFSET);//draw C
	    	drawVerticalLine(_x - X_OFFSET, _y, _y + (Y_OFFSET / 2));//draw B
	    	drawHorizontalLine(_y + (Y_OFFSET / 2), _x - X_OFFSET, _x);//draw A
	    	drawUpArrow(_width, _height + Y_OFFSET);
	    }
	    
	    /*
	     * draws a line from FS to FF
	     * when the arrow has direction from down to up and left.
	     */    
	    private function drawFXUpBack () : void
	    {
	    	movePoint(_x, _y + (Y_OFFSET * 3) + (Y_OFFSET / 2));
	    	drawHorizontalLine(_y + (Y_OFFSET * 3) + (Y_OFFSET / 2), _x, _x + X_OFFSET);//draw A
	    	//B es creado automaticamente al unirse las verticales A y C
	    	drawHorizontalLine(_y + Y_OFFSET, _x + X_OFFSET, _width - X_OFFSET);//draw C
	    	drawVerticalLine(_width - X_OFFSET, _y + Y_OFFSET, _height + Y_OFFSET);//draw D
	    	drawUpArrow(_width - X_OFFSET, _height + Y_OFFSET);
	    }
	    
	    /*
	     * Draws a line from FS to FF
	     * when the arrow has direction from down to up and right.
	     */    
	    private function drawFXUpFordward () : void
	    {
	    	movePoint(_x, _y + (Y_OFFSET * 3) + (Y_OFFSET / 2));
	    	drawHorizontalLine(_y + (Y_OFFSET * 3) + (Y_OFFSET / 2), _x, _width - X_OFFSET);//draw C
	    	drawVerticalLine(_width - X_OFFSET, _y + (Y_OFFSET * 3) + (Y_OFFSET / 2), _height + Y_OFFSET);//draw D
	    	drawUpArrow(_width - X_OFFSET, _height + Y_OFFSET);
	    }
	    
	    /*
	     * Draws a line from FS to FF
	     * when the arrow has direction from up to down and right.
	     */
	    private function drawFXDownFordward () : void
	    {
	    	movePoint(_x, _y);
	    	drawHorizontalLine(_y, _x, _width);//draw C
	    	drawVerticalLine(_width, _y, _height - Y_OFFSET);//draw D  
	    	drawDownArrow(_width, _height - Y_OFFSET);
	    }
	    
	    /*
	     * Draws a line from FS to FF
	     * when the arrow has direction from up to down and left.
	     */
	    private function drawFXDownBack () : void
	    {
	    	movePoint(_x, _y + (Y_OFFSET / 2));
	    	drawHorizontalLine(_y + (Y_OFFSET / 2), _x, _x + X_OFFSET);//draw A
	    	//B es creado automaticamente al unirse las verticales A y C
	    	drawHorizontalLine(_y + (Y_OFFSET * 3), _x + X_OFFSET, _width);//draw C
	    	drawVerticalLine(_width, _y + (Y_OFFSET * 3), _height - Y_OFFSET);//draw D
	    	drawDownArrow(_width, _height - Y_OFFSET);
	    }
	    
	    /*
	    * Assigns a point in the graphics to draw lines.
	    * It used to move everything 10 pixels to the left.
	    */
	    private function drawPoint(x : int, y : int) : void
	    {
	    	_graphics.lineTo(x + UI.MARGIN, y);
	    }
	    
	    /*
	    * Moves the pointer to draw in the graphics.
		* It used to move everything 10 pixels to the left.
	    */
	    private function movePoint(x : int, y : int) : void
	    {
	    	_graphics.moveTo(x + UI.MARGIN, y);
	    }
	    
	   	private function print() : void
	    {
	    	//trace('x: '+_x);
	    	//trace('width: '+_width);
	    	//trace('y: '+_y);
	    	//trace('height: '+_height);
	    }

	}
}