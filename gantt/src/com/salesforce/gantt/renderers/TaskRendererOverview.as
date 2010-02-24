package  com.salesforce.gantt.renderers
{	
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.controller.Constants;
	import com.salesforce.gantt.model.Calendar;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.UI;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.gantt.view.event.TaskEvent;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.utils.GraphicsUtil;
		
	[Event(name="dataChange", type="mx.events.FlexEvent")]
	public class TaskRendererOverview extends UIComponent implements IDataRenderer, IListItemRenderer
	{
		private var task : UiTask = null;
		
		private var milestone_image :MilestoneImage = new MilestoneImage();
		
		public function TaskRendererOverview(){
			milestone_image = new MilestoneImage(16,16);
			milestone_image.setVisible(true);
			milestone_image.mouseEnabled = false;
			addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		[Bindable("dataChange")]
		public function get data():Object
		{
			return task;	
		}
		public function set data(value : Object):void
		{
			this.task = UiTask(value);
			this.invalidateProperties();			
			dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
		}
		
	    override protected function updateDisplayList(width : Number, height : Number) : void
		{

				super.updateDisplayList(width, height);
				
				milestone_image.name = "milestone_image_"+task.id;
				height = (150 / Components.instance.tasks.allTasks.length) - ((150 / Components.instance.tasks.allTasks.length)/4);
					
				if(height<0)
				{
					height = 1;
				}
				else if(height>14)
				{
					height = 14;
				}
				var _graphics : Graphics = graphics;		
				_graphics.clear();
				if ( task != null)
				{

					var scale : Number = parentDocument.getScaleOverview();
					
					if(Components.instance.tasks.length()==0){
						clearChildren();
					}
					
					if(!task.isHidden)
					{

						if(task.position==1)
						{
							var child : int = parent.numChildren;
							for (var i : int = 0; i < child; i++)
							{	
							if(parent.getChildAt(i).name.toString().substr(0,9)=="milestone")
								{
									parent.removeChildAt(i);
									child--;i--;
								}
							}
						}
						var taskRectangle : Rectangle = null;
						var completedRectangle : Rectangle = null;
						if(task.isMilestone)//milestone
						{
							taskRectangle = getTaskRectangle(height, task);
							
							_graphics.beginFill(Constants.COLOR_TASK_MILESTONE_FONT, 1);
							
							var size : int = 1;
							if(height>1)
							{
								size = height / 2;
							}
							var hypotenuse : Number = size * 2;	
							var x : Number = taskRectangle.x + (scale / 2) - (hypotenuse / 2);
							
							milestone_image.x = taskRectangle.x;
							milestone_image.y = this.y;
							milestone_image.setActualSize(height,height);
							
							// it doesn't matter the color because the alpha number is set in 0.
							_graphics.beginFill(Constants.COLOR_TASK_NORMAL_COMPLETED_FONT, 0);
							taskRectangle = getTaskRectangle(height, task);
							GraphicsUtil.drawRoundRectComplex(_graphics, taskRectangle.x, taskRectangle.y, taskRectangle.width, taskRectangle.height, 2, 2, 2, 2);
							// check if not exist the child milestone image, otherwise added it to the parent 
							if(parent.getChildByName(milestone_image.name)==null){
								parent.addChild(milestone_image);		
							}
							
						}
						else if(task.imageSign() != -1)
						{
							// check if exist the child milestone image, otherwise remove it from parent
								if(parent.getChildByName(milestone_image.name)!=null){
									parent.removeChild(parent.getChildByName(milestone_image.name));
								}	
								
							var cut : int = 2;
							var triangle : int = height + 2;
							taskRectangle = getTaskRectangle(height, task);
							
							_graphics.beginFill(Constants.COLOR_TASK_PARENT_INCOMPLETED_FONT, 1);
							if(task.completed > 0)
							{
								_graphics.beginFill(Constants.COLOR_TASK_PARENT_COMPLETED_FONT, 1);
							}
							_graphics.moveTo(taskRectangle.x-triangle,taskRectangle.y);
							_graphics.lineTo(taskRectangle.x-triangle,taskRectangle.y);
							_graphics.lineTo(taskRectangle.x+triangle,taskRectangle.y);
							_graphics.lineTo(taskRectangle.x,taskRectangle.y+triangle);
							
							if(task.completed < 100)
							{
								_graphics.beginFill(Constants.COLOR_TASK_PARENT_INCOMPLETED_FONT, 1);
							}
							_graphics.moveTo(taskRectangle.width+taskRectangle.x-triangle,taskRectangle.y);
							_graphics.lineTo(taskRectangle.width+taskRectangle.x-triangle,taskRectangle.y);
							_graphics.lineTo(taskRectangle.width+taskRectangle.x+triangle,taskRectangle.y);
							_graphics.lineTo(taskRectangle.width+taskRectangle.x,taskRectangle.y+triangle);
							
							_graphics.beginFill(Constants.COLOR_TASK_PARENT_INCOMPLETED_FONT, 1);
							var taskX : int = taskRectangle.x + cut;
							var taskWidth : int = taskRectangle.width - (cut * 2);
							if(taskWidth >= 0)
							{
								GraphicsUtil.drawRoundRectComplex(_graphics, taskX, taskRectangle.y, taskWidth, taskRectangle.height, 0, 0, 0, 0);
							}
							if(task.completed > 0 )
							{
								_graphics.beginFill(Constants.COLOR_TASK_PARENT_COMPLETED_FONT, 1);
								completedRectangle = getCompletedRectangle(height, task);
								taskX = completedRectangle.x + cut;
								taskWidth = completedRectangle.width - (cut * 2);
								if(taskWidth < 0)
								{
									taskWidth = completedRectangle.width;
								}
								GraphicsUtil.drawRoundRectComplex(_graphics, taskX, completedRectangle.y, taskWidth, completedRectangle.height, 0, 0, 0, 0);
							}
						}
						else
						{
							// check if exist the child milestone image, otherwise remove it from parent
								if(parent.getChildByName(milestone_image.name)!=null){
									parent.removeChild(parent.getChildByName(milestone_image.name));
								}
							_graphics.beginFill(Constants.COLOR_TASK_NORMAL_COMPLETED_FONT, .4);
							taskRectangle = getTaskRectangle(height, task);
							GraphicsUtil.drawRoundRectComplex(_graphics, taskRectangle.x, taskRectangle.y, taskRectangle.width, taskRectangle.height, 2, 2, 2, 2);
							_graphics.beginFill(Constants.COLOR_TASK_NORMAL_COMPLETED_FONT, 1);
							completedRectangle = getCompletedRectangle(height, task);
							GraphicsUtil.drawRoundRectComplex(_graphics, completedRectangle.x, completedRectangle.y, completedRectangle.width, completedRectangle.height, 0, 0, 0, 0);
						}
					}
				}
			//}
		}
		/**
		 * Returns a rectangle to represent the task bar in the overview pane
		 */
		private function getTaskRectangle(height : Number, task : Task) : Rectangle
		{
			var scale : Number = this.parentApplication.mainView.barChartOverview.getScaleOverview();
			if(scale == 0)
			{
				scale = 1;
			}
			var width : Number = (task.durationInDays() * scale);
			return getRectangle(width, height, task);
		}
		/**
		 * Returns a rectangle to represent the completion percentage of a task in the overview pane
		 */
		private function getCompletedRectangle(height : Number, task : Task) : Rectangle
		{
			var scale : Number = this.parentApplication.mainView.barChartOverview.getScaleOverview();
			/*if(scale == 0)
			{
				scale = 1;
			}*/
			var width : Number = ((task.durationInDays() * task.completed/100) * scale);
			return getRectangle(width, height, task);
		}
		/**
		 * Returns a rectangle
		 */
		private function getRectangle(width : Number, height : Number, task : Task) : Rectangle
		{
			var scale : Number = this.parentApplication.mainView.barChartOverview.getScaleOverview();
			if(scale == 0)
			{
				scale = 1;
			}
			var x : Number = ((Calendar.toDay(task.startDate) * scale)) + UI.MARGIN;
			var y : int = 0;	
			return new Rectangle(x, y, width, height);
		}
		
		/**
		 * Delete the sprite which its name start with BarSprite,
		 * this after a synchronization and there are no tasks.
		 */
		private function clearChildren() : void
		{
			if(parent != null)
			{
				var child : int = parent.numChildren;
				for (var i : int = 0; i < child; i++)
				{	
					if(parent.getChildAt(i).name.toString().substr(0,9)=="milestone")
					{
						parent.removeChildAt(i);
						child--;i--;
					}
				}
			}
   		}
   		
   		private function clickHandler(event:Event) : void{
   			dispatchEvent(new TaskEvent(TaskEvent.SELECT,task));
   		}
   		
   		
	}
}