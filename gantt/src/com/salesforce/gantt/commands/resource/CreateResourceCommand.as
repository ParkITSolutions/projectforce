package com.salesforce.gantt.commands.resource
{
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Project;
	import com.salesforce.gantt.model.Resource;
	import com.salesforce.gantt.util.ErrorHandler;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	/**
	 * Class responsible to add new resources to the project. 
	 * 
	 * @author Rodrigo Birriel
	 */	
	public class CreateResourceCommand extends SimpleCommand{
		
		private var resources : ArrayCollection;
		private var project : Project;
		
		public function CreateResourceCommand(resources : ArrayCollection, project : Project ){
			super();
			this.resources = resources;
			this.project = project;
		}
		
		override public function execute() : void{
			Components.instance.salesforceService.resourceOperation.create(resources,project,this);
		}	
		
		override protected function actionCallBack(response : Object) : void{
			for each(var resource : Resource in resources){
				Components.instance.resources.resources.addItem(resource);
			}	
		}
	}
}