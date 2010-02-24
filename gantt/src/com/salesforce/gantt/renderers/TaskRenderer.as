package  com.salesforce.gantt.renderers
{	
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.controller.Constants;
	import com.salesforce.gantt.model.Calendar;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.UI;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.gantt.view.event.PopUpEvent;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.IDataRenderer;
	import mx.core.IToolTip;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.utils.GraphicsUtil;
		
	
        
	[Event(name="dataChange", type="mx.events.FlexEvent")]
	
	public class TaskRenderer extends UIComponent implements IDataRenderer, IListItemRenderer
	{
		private var moveSelect : String = '';
		private var task : UiTask = null;
		private var scale : Number = 0;
		private var taskToolTip : IToolTip;		
		
		private var milestone_image : MilestoneImage;
		private var barSprite : Sprite;
		public function TaskRenderer(){
		}
		
		[Bindable("dataChange")]
		public function get data():Object{
			return task;	
		}
		
		public function set data(value : Object):void{
			this.task = UiTask(value);
			this.invalidateProperties();
			this.invalidateDisplayList();
			dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
		}
		
		override protected function createChildren():void{
			super.createChildren();
			if(!barSprite){
				barSprite = new Sprite();
				if(parentDocument.zoom != Constants.YEAR)
				{
					barSprite.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
					barSprite.addEventListener(MouseEvent.MOUSE_DOWN, drag);
					barSprite.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
					barSprite.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
					barSprite.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
					barSprite.doubleClickEnabled = true;
				}
			}
			addChild(barSprite);
			if(!milestone_image){
				milestone_image = new MilestoneImage();
				milestone_image.visible = false;	
			}
			addChild(milestone_image);	
			
		}
		
	   	override protected function updateDisplayList(width : Number, height : Number) : void{
			super.updateDisplayList(width, height);
			// added an id to the milestone image			
			milestone_image.name = task.id;
			height -= 2;
			if (task != null)
			{
				var _graphics : Graphics = graphics;
				_graphics.clear();
				clearBarSprite();		
				
				if(!task.isHidden)
				{
					scale = UI.scale;
					
					var taskRectangle : Rectangle = null;
					var completedRectangle : Rectangle = null;
					milestone_image.visible = task.isMilestone;
					if(task.isMilestone)//milestone
					{
						taskRectangle = getTaskRectangle(height, task);
						
						var size : int = 12;
						
						var label : Sprite = getLabel(task, taskRectangle, null);
						
						milestone_image.x = taskRectangle.x +scale/2 - 16;
						milestone_image.y = 0;
						milestone_image.setVisible(true);
						
						// check if not exist the child milestone image, otherwise added it to the parent 	
						
					}
					else if(!task.isEditable())
					{
						taskRectangle = getTaskRectangle(height, task);
						completedRectangle = getCompletedRectangle(height, task);
						
						var heightReduce : int = 4;
						var triangle : int = 19;
						var cut : int = 5;
						
						if(task.alphaCut==1)
						{
							_graphics.beginFill(Constants.COLOR_TASK_PARENT_INCOMPLETED_CUT_FONT, 1);
						}
						else
						{
							_graphics.beginFill(Constants.COLOR_TASK_PARENT_INCOMPLETED_FONT, 1);
						}
						if(task.completed > 0)
						{
							if(task.alphaCut==1)
							{
								_graphics.beginFill(Constants.COLOR_TASK_PARENT_COMPLETED_CUT_FONT, 1);
							}
							else
							{
								_graphics.beginFill(Constants.COLOR_TASK_PARENT_COMPLETED_FONT, 1);
							}
						}
						_graphics.moveTo(taskRectangle.x-triangle,taskRectangle.y);
						_graphics.lineTo(taskRectangle.x-triangle,taskRectangle.y);
						_graphics.lineTo(taskRectangle.x+triangle,taskRectangle.y);
						_graphics.lineTo(taskRectangle.x,taskRectangle.y+triangle+5);
						
						if(task.completed < 100)
						{
							if(task.alphaCut==1)
							{
								_graphics.beginFill(Constants.COLOR_TASK_PARENT_INCOMPLETED_CUT_FONT, 1);
							}
							else
							{
								_graphics.beginFill(Constants.COLOR_TASK_PARENT_INCOMPLETED_FONT, 1);
							}
						}
						_graphics.moveTo(taskRectangle.width+taskRectangle.x-triangle,taskRectangle.y);
						_graphics.lineTo(taskRectangle.width+taskRectangle.x-triangle,taskRectangle.y);
						_graphics.lineTo(taskRectangle.width+taskRectangle.x+triangle,taskRectangle.y);
						_graphics.lineTo(taskRectangle.width+taskRectangle.x,taskRectangle.y+triangle+5);
						
						if(task.alphaCut==1)
						{
							_graphics.beginFill(Constants.COLOR_TASK_PARENT_INCOMPLETED_CUT_FONT, 1);
						}
						else
						{
							_graphics.beginFill(Constants.COLOR_TASK_PARENT_INCOMPLETED_FONT, 1);
						}
						var taskX : int = taskRectangle.x + cut;
						var taskWidth : int = taskRectangle.width - (cut * 2);
						if(taskWidth >= 0)
						{
							GraphicsUtil.drawRoundRectComplex(_graphics, taskX, taskRectangle.y, taskWidth, taskRectangle.height, 0, 0, 0, 0);
						}
						if(task.completed > 0 )
						{
							if(task.alphaCut==1)
							{
								_graphics.beginFill(Constants.COLOR_TASK_PARENT_INCOMPLETED_CUT_FONT, 1);
							}
							else
							{
								_graphics.beginFill(Constants.COLOR_TASK_PARENT_COMPLETED_FONT, 1);
							}
							
							completedRectangle.height -= heightReduce;
							
							taskX = completedRectangle.x + cut;
							taskWidth = completedRectangle.width - (cut * 2);
							if(taskWidth < 0)
							{
								taskWidth = completedRectangle.width;
							}
							GraphicsUtil.drawRoundRectComplex(_graphics, taskX, completedRectangle.y, taskWidth, completedRectangle.height, 0, 0, 0, 0);
						}
						getLabel(task, taskRectangle, completedRectangle);
					}
					else
					{
						taskRectangle = getTaskRectangle(height, task);
						completedRectangle = getCompletedRectangle(height, task);
						
						if(task.alphaCut==1)
						{
							_graphics.beginFill(Constants.COLOR_TASK_NORMAL_INCOMPLETED_CUT_FONT, .4);
						}
						else
						{
							_graphics.beginFill(Constants.COLOR_TASK_NORMAL_COMPLETED_FONT, .4);
						}
						GraphicsUtil.drawRoundRectComplex(_graphics, taskRectangle.x, taskRectangle.y, taskRectangle.width, taskRectangle.height, 3, 3, 3, 3);
						if(task.alphaCut==1)
						{
							_graphics.beginFill(Constants.COLOR_TASK_NORMAL_COMPLETED_CUT_FONT, 1);
						}
						else
						{
							_graphics.beginFill(Constants.COLOR_TASK_NORMAL_COMPLETED_FONT, 1);
						}
						if(task.completed < 100)
						{
							GraphicsUtil.drawRoundRectComplex(_graphics, completedRectangle.x, completedRectangle.y, completedRectangle.width, completedRectangle.height, 3, 0, 3, 0);
						}
						else
						{
							GraphicsUtil.drawRoundRectComplex(_graphics, completedRectangle.x, completedRectangle.y, completedRectangle.width, completedRectangle.height, 3, 3, 3, 3);
						}
						getLabel(task, taskRectangle, completedRectangle);
					}
				}
			}
		}
		
		/**
		 * Return a rectangle representative of a task
   		 */
		private function getTaskRectangle(height : Number, task : Task) : Rectangle
		{
			var width : Number = 0;
			if(task.isMilestone)
			{
				width = (1 * scale);
				if(width < 200)
				{
					width = 1000;
				}
			}
			else
			{
				var durationT : Number = (task.durationInDays());
				width = (durationT * scale);
			}
			return getRectangle(width, height, task);
		}
		/**
		 * Returns a rectanble representative of the completed percen of a task
   		 */
		private function getCompletedRectangle(height : Number, task : Task) : Rectangle
		{
			var durationT : Number = (task.durationInDays());
			var width : Number = ((durationT * task.completed/100) * scale);
			
			return getRectangle(width, height, task);
		}
		/**
		 * Returns a rectangle
   		 */
		private function getRectangle(width : Number, height : Number, task : Task) : Rectangle
		{
			var x : int = (Calendar.toDay(task.startDate)* scale) + UI.MARGIN;
			var y : int = 2;	
			height = height - 4;
			return new Rectangle(x, y, width, height);
		}
		/**
		 * Returns a label with appropiate format and attached events
   		 */
		private function getLabel(task : Task, taskRectangle : Rectangle, completedRectangle : Rectangle = null) : Sprite
		{	
			var id : String = task.id;
			//trace (task.id);
			var text : String = task.name;
			var completed : String = task.completed.toString()+'%';
			
			var x : int = taskRectangle.x;
			var y : int = 0;//taskRectangle.y;
			var width : int = taskRectangle.width;
			var height : int = 25;
			
			barSprite.name = 'BarSprite'+id;
			
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = "verdana";
			if(!task.isMilestone)
			{
				textFormat.color = 0xffffff;
			}
			else
			{
				if(UiTask(task).alphaCut==1)
				{
					textFormat.color = 0xaaaaaa;
				}
				else
				{
					textFormat.color = 0x000000;
				}
			}
			textFormat.bold = "bold";
			textFormat.size = 11;
			
			var textFieldName : TextField = new TextField();
			textFieldName.name = id; 
			textFieldName.text = text;
			textFieldName.selectable = false;
			if(!task.isMilestone)
			{
				textFieldName.width = width;
				textFieldName.x = x;
			}
			else
			{
				textFieldName.width = width;
				textFieldName.x = +x;// + (scale / 2) + 12
				
				textFieldName.text = '       '+ text;
			}
			textFieldName.setTextFormat(textFormat,-1,-1);
			textFieldName.y = y + 5;
			textFieldName.height = height;
			textFieldName.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClick);
			textFieldName.doubleClickEnabled = true;
			
			barSprite.addChild(textFieldName);
			
			
			if(completedRectangle != null)
			{
				var textFormatCompleted : TextFormat = new TextFormat();
				textFormatCompleted.font = "verdana";
				if(UiTask(task).alphaCut==1)
				{
					textFormatCompleted.color = 0xaaaaaa;
				}
				else
				{
					if(UiTask(task).isEditable())
					{
						// old color: 0xff0000
						textFormatCompleted.color = 0x5398AD;
					}
					else
					{
						textFormatCompleted.color = 0x77b900;
					}
				}
				textFormatCompleted.size = 9;
				textFormatCompleted.bold = "bold";
				
				var textFieldCompleted : TextField = new TextField();
				textFieldCompleted.text = completed;
				textFieldCompleted.name = id;
				textFieldCompleted.width = 30;
				textFieldCompleted.height = 15;
				textFieldCompleted.setTextFormat(textFormatCompleted,-1,-1);
				textFieldCompleted.x = x + completedRectangle.width - 5;
				textFieldCompleted.y = y + 20;
				textFieldCompleted.selectable = false;
				barSprite.addChild(textFieldCompleted);
			}
			
			return barSprite;
		}
		/**
		 * Double click event 
		 */
		private function doubleClick(event : MouseEvent) : void
		{
			//if(this.parentApplication.mainView.barChart.mouseIsOverTask(task,event, 'y'))
	    	//{
	    		if(this.parentApplication.mainView.resourceLogged.canModifyTask(task)){
	    			//TODO dispatchEvent open overlay
	    			//this.parentApplication.mainView.editTaskOverlay();
	    			dispatchEvent(new PopUpEvent(PopUpEvent.TASK_DETAIL_OPEN));
	    		}
	    	//}
		}

		/**
		 * This is call when the cursor moves out of a task
		 */
		private function mouseOut(event : MouseEvent) : void
		{
			//ToolTipManager.destroyToolTip(taskToolTip);	
			//taskToolTip.visible = false;
			if(!parentDocument.isDraging)
			{
				parentDocument.setCursor('cursorHandUp');
			}
		}
		/**
		 * This is call to chenge the cursor when it moves over a task.
		 */
		private function mouseMove(event : MouseEvent) : void
		{	    
			var cursorNone : Boolean = true;
			if(!parentDocument.isDraging)
			{
				if(task != null)
				{
					var duration : int = (task.durationInDays());
					var taskWidth : int = duration * scale;
					var taskCompletedWidth : int = taskWidth * (task.completed/100);
					var taskX : int = (Calendar.toDay(task.startDate) * scale) + parentDocument.barChartCanvas.x;
					var taskY : int = (task.positionVisible * UI.ROW_HEIGHT) + 30 + (parentDocument.barChartCanvas.y);
					var taskHeight : int = UI.ROW_HEIGHT;
					
					//si el raton esta sobre la tarea
					if( ((event.stageX - 5) > taskX) && ((event.stageX - 5) <= (taskX + taskWidth)) && 
						( event.stageY > taskY ) && ( event.stageY < (taskY + taskHeight) ) )
					{
						//TODO perhaps each uitask has your permission
						if(Components.instance.resourceLogged.canModifyTask(task))
						{
							//TODO dispatch a event to show status task preview
							this.parentApplication.mainView.statusTaskPreview(task, event.stageX, taskY, true);
							if(!task.isMilestone && UiTask(task).isEditable())
							{
								if(event.localX > 0 && event.localX <= 2)//start
								{
									parentDocument.setCursor('cursorLeftUp');
									moveSelect = Constants.LEFT;
									cursorNone = false;
								}
								else if(event.localX >= (taskWidth - 15) && event.localX <= taskWidth)//end
								{
									parentDocument.setCursor('cursorRightUp');
									moveSelect = Constants.RIGHT;
									cursorNone = false;
								}
								else if(event.localX > 5 && event.localX < (taskWidth - 5))//center
								{
									
									parentDocument.setCursor('cursorCenterUp');
									moveSelect = Constants.CENTER;
									
									if(task.completed > 90){
										if(Math.abs(event.localX - taskCompletedWidth) < 20){
											parentDocument.setCursor('cursorResizeComplete');
											moveSelect =Constants.RESIZE_COMPLETED_PERCENT;
										}
									}else{
										if(Math.abs(event.localX - taskCompletedWidth) < 15){
											parentDocument.setCursor('cursorResizeComplete');
											moveSelect =Constants.RESIZE_COMPLETED_PERCENT;
										}
									}
									
									cursorNone = false;
								}
							}
							else
							{
								parentDocument.setCursor('cursorCenterUp');
								moveSelect = Constants.CENTER;
								cursorNone = false;
							}
						}
						else{
							parentDocument.defaultCursor();
						}
					}
				}
			}
		}
		
		private function mouseUp(event : MouseEvent) :void{
			if(task){
				dispatchEvent(new ListEvent(ListEvent.ITEM_CLICK,true));	
			}
		}
		/**
		 * Mousedown event
		 */
		private function drag(event : MouseEvent) : void 
		{
			if(task != null)
			{
				//if the mouse is over the task.
				var clonedTask : UiTask = task.clone();
				if(parentDocument.mouseIsOverTask(clonedTask,event, 'y'))
				{
					parentDocument.dragAndDropBar(clonedTask, moveSelect,event);
				}
				else
				{
					parentDocument.dragAndDropBar(null, '',event);
				}		    	
			}
			else
			{
				parentDocument.dragAndDropBar(null, '',event);
			}
		}
		
		private function mouseOver(event : MouseEvent) : void{
			/* if(taskToolTip){
				// Very Strange the tooltip can't be removed with ToolTipManager.destroyToolTip method.
				taskToolTip.visible = false;
			}
			taskToolTip = ToolTipManager.createToolTip(task.name,event.stageX,event.stageY); */	
		}
		
   		
   		private function clearBarSprite() : void{
   			if(barSprite){
   				var size : int = barSprite.numChildren;
   				for(var i : int = 0;i<size-1;i++){
   					barSprite.removeChildAt(i);
   				}	
   			}
   		}
   		
	}
}