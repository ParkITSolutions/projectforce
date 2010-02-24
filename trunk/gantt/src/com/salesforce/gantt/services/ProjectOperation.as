package com.salesforce.gantt.services
{
	import com.salesforce.gantt.model.Project;
	import com.salesforce.gantt.util.CustomSObject;
	import com.salesforce.objects.CustomObject;
	
	import mx.rpc.IResponder;
	
	/**
	* Class responsible to persist the project's information into DB.
	* @author Rodrigo Birriel
	*/
	public class ProjectOperation extends BaseOperation{
		
		public function ProjectOperation(){	
		}
		
		/**
		 * Load information about the project
		 * @param project the instance to be read
		 * @param responder object responsible to receive the callback.
		 */
		public function load(project : Project,responder : IResponder) : void
		{
			var query : String = "Select Name,CreatedDate,CreatedById,DisplayDuration__c, DaysInWorkWeek__c, WorkingHours__c,Description__c,Priority__c,Image__c,Picture__c From Project2__c Where Id = '"+project.id+"'";
			connection.query(query,responder);	
		}
		
		/**
		 * Update the infomation about the project
		 * @param project the instance to be updated
		 * @param responder object responsible to receive the callback.
		 */ 
		public function update(project : Project, responder : IResponder) : void{
			var upd : CustomSObject = new CustomSObject("Project2__c");
			upd.setProperty('Id',project.id);
			upd.setProperty('Name',project.name);
			upd.setProperty('DisplayDuration__c',project.durationInHours);
			upd.setProperty('DaysInWorkWeek__c',project.daysInWorkWeek);
			upd.setProperty('WorkingHours_c',project.hoursPerDay);
			upd.setProperty('Priority__c',project.priority);
			upd.setProperty('Description__c',project.description); 
			connection.update([upd],responder); 
		}
	}
}