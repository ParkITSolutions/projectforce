package com.salesforce.gantt.commands.ganttState
{
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.GanttState;

	/**
	 * Command responsible for updating the gantt's state. 
	 * 
	 * @author Rodrigo Birriel
	 */
	public class UpdateGanttStateCommand extends SimpleCommand
	{
		private var ganttState : GanttState;
		public function UpdateGanttStateCommand(ganttState : GanttState)
		{
			super();
			this.ganttState = ganttState;
		}
		
		override public function execute() : void{
			Components.instance.salesforceService.ganttStateOperation.update(ganttState);
		}
		
		override protected function actionCallBack(response : Object) : void{
		}
	}
}