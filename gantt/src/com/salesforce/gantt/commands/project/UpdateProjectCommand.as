package com.salesforce.gantt.commands.project
{
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Project;
	import com.salesforce.gantt.util.ErrorHandler;
	
	import flash.events.Event;

	public class UpdateProjectCommand extends SimpleCommand
	{
		private var project : Project;
		public function UpdateProjectCommand(project : Project)
		{
			super();
			this.project = project;
		}
		
		override public function execute(): void{
			Components.instance.salesforceService.projectOperation.update(project,this);
		}
		
		override protected function actionCallBack(response : Object):void{
		}
		
	}
}
