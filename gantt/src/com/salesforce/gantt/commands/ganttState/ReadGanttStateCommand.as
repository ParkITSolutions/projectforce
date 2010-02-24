package com.salesforce.gantt.commands.ganttState
{
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.util.CustomSObject;

	/**
	 * Class responsible to encapsultate the read information about gantt state 
	 * after user leave the application.
	 * 
	 * @author Rodrigo Birriel
	 */	
	public class ReadGanttStateCommand extends SimpleCommand
	{
		public function ReadGanttStateCommand()
		{
			super();
		}
		
		override public function execute(): void{
			Components.instance.salesforceService.ganttStateOperation.load();
		}
		
		override protected function actionCallBack(response : Object) : void{
			var queryResutl : QueryResult = response as QueryResult;
			var record : CustomSObject;
			if(queryResult.records!=null){
				record = queryResult.records[0];
				var id : String = record.Id;
				var arrayDate : Array = record.getProperty('date__c').split('-');
				var startDate : Date = new Date(arrayDate[0],arrayDate[1]-1,arrayDate[2]);
				var scale : String = record.getProperty('scale__c');
				var y : String = record.getProperty('y__c');
				var user : User = Components.instance.resourceLogged.user;
				
				//var lastDate  : Date = Calendar.add(new Date(), -30);
				Components.instance.ganttState = new GanttState(scale,startDate,y,user,id);
	    	}
		}
	}
}