package com.salesforce.gantt.commands.resource
{
	import com.salesforce.gantt.commands.CompositeCommand;
	import com.salesforce.gantt.model.Project;
	import com.salesforce.gantt.util.CustomArrayUtil;
	
	import mx.collections.ArrayCollection;

	/**
	 * Commands's class container responsible to merge 
	 * the new resources with the old resources.
	 * 
	 * @author Rodrigo Birriel
	 */
	public class MergeResourcesCommand extends CompositeCommand
	{
		private var project : Project;
		private var newResources : ArrayCollection;
		private var oldResources : ArrayCollection;
		
		public function MergeResourcesCommand(resources : ArrayCollection, originalResources : ArrayCollection, project : Project)
		{
			super();
			newResources = resources;
			oldResources = originalResources;
			this.project = project;
			//TODO add undo command
		}
		
		/**
		 * create the necessaries command to add and delete resources from the project.
		 */ 
		override public function execute():void{
			var addedResources : ArrayCollection = CustomArrayUtil.extractAdded(oldResources,newResources);
			var deletedResources : ArrayCollection = CustomArrayUtil.extractDeleted(oldResources,newResources);
			
			if(addedResources.length > 0){
				addCommand(new CreateResourceCommand(addedResources,project));
			}
			if(deletedResources.length > 0){
				addCommand(new DeleteResourcesCommand(deletedResources));
			}
			super.execute();
		}
	}
}