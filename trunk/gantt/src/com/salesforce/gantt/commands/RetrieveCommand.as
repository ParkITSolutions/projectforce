package com.salesforce.gantt.commands
{
	import com.salesforce.gantt.commands.authentication.ReadUserCommand;
	import com.salesforce.gantt.commands.dependency.ReadDependencyCommand;
	import com.salesforce.gantt.commands.metadata.ReadLayoutMetadataCommand;
	import com.salesforce.gantt.commands.metadata.ReadSObjectMetadataCommand;
	import com.salesforce.gantt.commands.profile.ReadProfilesCommand;
	import com.salesforce.gantt.commands.project.ReadProjectCommand;
	import com.salesforce.gantt.commands.resource.ReadResourcesCommand;
	import com.salesforce.gantt.commands.task.ReadTasksCommand;
	import com.salesforce.gantt.commands.taskResource.ReadTaskResourceCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.controller.SMetadataController;
	import com.salesforce.gantt.model.Project;
	import com.salesforce.gantt.model.Resource;
	
	/**
	 * Container class containing the commands to retrieve
	 * the information to be used.
	 * 
	 * @author Rodrigo Birriel.
	 */
	public class RetrieveCommand extends CompositeCommand{
		private var project : Project;
		private var resourceLogged : Resource;
		
		public function RetrieveCommand(project : Project){
			super();
			this.project = project;
			this.resourceLogged = Components.instance.resourceLogged;
		}
		
		override public function execute():void{
			
			// retrieve the metadata ProjectTask__c and Project2__c
			addCommand(new ReadSObjectMetadataCommand(SMetadataController.TASK_CUSTOM_OBJECT));
			addCommand(new ReadSObjectMetadataCommand(SMetadataController.PROJECT_CUSTOM_OBJECT));
			
			// retrieve the layout ProjectTask__c and Project2__c
			addCommand(new ReadLayoutMetadataCommand(SMetadataController.PROJECT_CUSTOM_OBJECT))
			addCommand(new ReadLayoutMetadataCommand(SMetadataController.TASK_CUSTOM_OBJECT))
			
			// retrieve the gantt state
			//addCommand(new ReadGanttStateCommand());
			
			// retrieve the project information
			addCommand(new ReadProjectCommand(project));
			
			// retrieve the profiles's information
			addCommand(new ReadProfilesCommand());
			
			// retrieve the resources's information
			addCommand(new ReadResourcesCommand(project));
			
			// retrieve the user information
			addCommand(new ReadUserCommand(Components.instance.resourceLogged.user));
						
			// retrieve the tasks's information
			addCommand(new ReadTasksCommand(project));
			
			// retrieve the tasks's resources information
			addCommand(new ReadTaskResourceCommand(project));
			
			// retrieve the dependencies's information
			addCommand(new ReadDependencyCommand(project));
			
			super.execute();
		}
		
	}
}