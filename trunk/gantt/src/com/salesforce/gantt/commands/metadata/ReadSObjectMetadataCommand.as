package com.salesforce.gantt.commands.metadata
{
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.controller.SMetadataController;
	import com.salesforce.results.DescribeSObjectResult;
	
	import flash.events.Event;

	/**
	 * Class responsible to encapsultate the read information about custom object metadata 
	 *
	 * @author Rodrigo Birriel
	 */	
	public class ReadSObjectMetadataCommand extends SimpleCommand
	{
		private var customObjectName : String;
		
		public function ReadSObjectMetadataCommand(customObjectName : String)
		{
			super();
			this.customObjectName = customObjectName;
		}
		
		override public function execute() : void{
			Components.instance.salesforceService.metadataDescriptorOperation.loadSObjectDescriptor(customObjectName,this);
		}
		
		override public function result(response : Object) : void{
			var describeSObjectResult : DescribeSObjectResult = response as DescribeSObjectResult;
			SMetadataController.instance.addSObjectDescriptor(customObjectName,describeSObjectResult);
			dispatchEvent(new Event(SimpleCommand.COMPLETE));
		}
	}
}