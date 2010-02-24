package com.salesforce.gantt.commands.metadata
{
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.controller.SMetadataController;
	import com.salesforce.results.DescribeLayoutResult;
	
	import flash.events.Event;

	/**
	 * Class responsible to encapsultate the read information about salesforce's layout.
	 * 
	 * @author Rodrigo Birriel
	 */	
	public class ReadLayoutMetadataCommand extends SimpleCommand
	{
		private var layoutName : String;
		
		public function ReadLayoutMetadataCommand(layoutName : String){
			super();
			this.layoutName = layoutName;
		}
		
		override public function execute(): void{
			Components.instance.salesforceService.metadataDescriptorOperation.loadLayoutDescriptor(layoutName,this);
		}
		
		override public function result(data:Object):void{
			var describeLayoutResult : DescribeLayoutResult = data as DescribeLayoutResult;
			SMetadataController.instance.addLayoutDescriptor(layoutName,describeLayoutResult);
			dispatchEvent(new Event(SimpleCommand.COMPLETE))
		}
	}
}