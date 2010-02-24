package com.salesforce.gantt.commands.ganttState
{
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.GanttState;
	
	/**
	 * @author Rodrigo Birriel
	 */
	public class CreateGanttStateCommand extends SimpleCommand
	{
		private var ganttState : GanttState;
		
		public function CreateGanttStateCommand(ganttState : GanttState)
		{
			super();
			this.ganttState = ganttState;
		}
		
		override public function execute(): void{
			Components.instance.salesforceService.ganttStateOperation.create(ganttState);
		}
		
		override protected function actionCallBack(response : Object) : void{
		  	ganttStare.id = response[0].id;	
		}
	}
}