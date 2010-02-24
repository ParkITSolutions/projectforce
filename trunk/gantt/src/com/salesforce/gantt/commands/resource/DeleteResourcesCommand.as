package com.salesforce.gantt.commands.resource
{
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Resource;
	import com.salesforce.gantt.util.ErrorHandler;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	public class DeleteResourcesCommand extends SimpleCommand
	{
		private var resources : ArrayCollection;
		
		public function DeleteResourcesCommand(resources : ArrayCollection)
		{
			super();
			this.resources = resources;
		}
		
		override public function execute():void{
			Components.instance.salesforceService.resourceOperation.remove(resources,this);
		}
		
		override protected function actionCallBack(response : Object) : void{
			for each(var resource : Resource in resources){
				Components.instance.resources.remove(resource);
			}	
		}
	}
}