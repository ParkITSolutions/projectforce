package com.salesforce.gantt.commands.project
{
	import com.salesforce.Util;
	import com.salesforce.gantt.commands.CompositeCommand;
	import com.salesforce.gantt.commands.attachment.ReadAttachmentCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.controller.Constants;
	import com.salesforce.gantt.model.Calendar;
	import com.salesforce.gantt.model.Project;
	import com.salesforce.gantt.util.CustomSObject;
	import com.salesforce.results.QueryResult;

	/**
	 * Class responsible to encapsultate the read information about a project.
	 *
	 * @author Rodrigo Birriel
	 */
	public class ReadProjectCommand extends CompositeCommand{
		private var project : Project;
		
		public function ReadProjectCommand(project : Project){
			super();
			this.project = project;
		}
		
		override public function execute():void{
			Components.instance.salesforceService.projectOperation.load(project,this);
		}
		
		override protected function actionCallBack(response : Object) : void{
			var queryResult : QueryResult = QueryResult(response);
			if(queryResult.size > 0){
				var record : CustomSObject = queryResult.records[0];
				var teamName : String =  String(record.getProperty('Name'));
				var startDateString : String = String(record.getProperty('CreatedDate'));
				var displayDuration : String = String(record.getProperty('DisplayDuration__c'));
				var daysInWorkWeek : int = int(record.getProperty('DaysInWorkWeek__c'));
				var workingHours : int = int(record.getProperty('WorkingHours__c'));
				var description : String = String(record.getProperty('Description__c'));
				var priority : String = String(record.getProperty('Priority__c'));
				var createdBy : String = String(record.getProperty('CreatedById'));
				var attachmentId : String = String(record.getProperty('Picture__c'));
				
				//TODO review this assign//
				Components.instance.salesforceService.dateStart = Util.stringToDateTime(startDateString);
//				//***********************//
				project.name = teamName;
			   	
			   	// Set working hours
			   	if(workingHours){
			   		project.hoursPerDay = workingHours;
			   	}else{
			   		project.hoursPerDay = Constants.DEFAULT_WORKING_HOURS;
			   	}
			   	
			   	// Set display duration 
			   	project.durationInHours = displayDuration == Constants.DURATION_HOURS;	
			   	project.description = description;
			   	project.priority = priority;
			   	project.createdBy = createdBy;
			   	
			   	// Set workd day to the calendar class
			   	if(daysInWorkWeek){
			   		Calendar.daysInWorkWeek = daysInWorkWeek;
			   		project.daysInWorkWeek = daysInWorkWeek;
			   	}else{
			   		Calendar.daysInWorkWeek = Constants.DEFAULT_DAYS_WORK_WEEK;
			   		project.daysInWorkWeek = Constants.DEFAULT_DAYS_WORK_WEEK;
			   	}
			   	
			   	if(attachmentId){
			   		addCommand(new ReadAttachmentCommand(attachmentId,project));	
			   	}
			   	
			   	super.execute();
			}
		}
	}
}