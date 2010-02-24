package com.salesforce.gantt.model
{
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.controller.SMetadataController;
	import com.salesforce.gantt.controller.SOTaskConstants;
	import com.salesforce.gantt.util.CustomArrayUtil;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	[Bindable]
	[RemoteClass(alias="com.salesforce.gantt.model.Task")]
	public class Task implements IDynamicObject
	{	
		
		private var _properties : Object;
		private var _heriarchy : Heriarchy;
		private var _children : ArrayCollection;
		
		public var positionVisible : int;
		public var successors : ArrayCollection;
		public var dependencies : ArrayCollection;
		public var taskResources : ArrayCollection;
		
		public var createdBy : User;
		public var lastModified : User;
		public var project : Project;
		
		public static var inDepth : Boolean = false;
		
		/*
		 * Costructor
		 */	
		public function Task(name : String = '', start : Date = null,end : Date = null, duration : Number = 1, 
								id : String = "", completed : Number = 0, isMilestone : Boolean = false,  
								priority : String = "", parentTaskId : String = null,description : String = "",
								otherProperties : Object = null)
		{	
			_properties = new Object();
			if(otherProperties){
				_properties = otherProperties;
			}
			//FIXME asap
			project = Components.instance.project;
			//
			successors = new ArrayCollection();
			dependencies = new ArrayCollection();
			taskResources = new ArrayCollection();
			_children = new ArrayCollection();
			_properties[SOTaskConstants.ID] 		= id;
			_properties[SOTaskConstants.NAME] 		= name;
			_properties[SOTaskConstants.DURATION] 	= duration;
			if(!start){
				start = new Date();
			}
			if(!end){
				end = new Date();
			}
			_properties[SOTaskConstants.STARTDATE] 	= start;
			_properties[SOTaskConstants.ENDDATE] 	= end;
			_properties[SOTaskConstants.COMPLETED] 	= completed;
			_properties[SOTaskConstants.ISMILESTONE]= isMilestone;
			_properties[SOTaskConstants.PRIORITY] 	= priority;
			_properties[SOTaskConstants.PARENT] 	= parentTaskId;	
			_properties[SOTaskConstants.DESCRIPTION] = description;
			_properties[SOTaskConstants.TYPE] = SMetadataController.TASK_CUSTOM_OBJECT;
			heriarchy = new Heriarchy();
			if(duration == 0 && project){
				duration = project.milestoneDuration();
			}
		}
		
		public function set id(value : String) : void{
			_properties[SOTaskConstants.ID] = value;
		}
		
		public function get id() : String{
			return _properties[SOTaskConstants.ID];
		}
		
		public function set name(value : String) : void{
			_properties[SOTaskConstants.NAME] = value;
		}
		
		public function get name() : String{
			return _properties[SOTaskConstants.NAME];
		}
		
		public function set startDate( startDate : Date) : void{
			_properties[SOTaskConstants.STARTDATE] = startDate;
		}
		
		public function get startDate() : Date{
			return _properties[SOTaskConstants.STARTDATE];
		}
		
		public function set endDate( endDate : Date) : void{
			_properties[SOTaskConstants.ENDDATE] = endDate;
		}
		
		public function get endDate() : Date{
			return _properties[SOTaskConstants.ENDDATE];
		}
		
		public function set duration( value : Number) : void{
			_properties[SOTaskConstants.DURATION] = value;
		}
		
		public function get duration() : Number{
			return _properties[SOTaskConstants.DURATION];
		}
		
		public function set position(value : int) : void{
			_properties[SOTaskConstants.POSITION] = value;
		}
		
		public function get position() : int{
			return _properties[SOTaskConstants.POSITION];
		}
		
		public function set completed(value : int) : void{
			_properties[SOTaskConstants.COMPLETED] = value;
		}
		
		public function get completed() : int{
			return _properties[SOTaskConstants.COMPLETED];
		}
		
		public function set isMilestone(value: Boolean) : void{
			_properties[SOTaskConstants.ISMILESTONE] = value;
		}
		
		public function get isMilestone(): Boolean{
			return _properties[SOTaskConstants.ISMILESTONE];
		}
		
		public function set priority(value: String ) : void{
			_properties[SOTaskConstants.PRIORITY] = value;
		}
		
		public function get priority(): String{
			return _properties[SOTaskConstants.PRIORITY];
		}
		
		public function set parent(value: String) : void{
			_properties[SOTaskConstants.PARENT] = value;
		}
		
		public function get parent(): String{
			return _properties[SOTaskConstants.PARENT];
		}
		
		public function set description(value: String) : void{
			_properties[SOTaskConstants.DESCRIPTION] = value;
		}
		
		public function get description(): String{
			return _properties[SOTaskConstants.DESCRIPTION];
		}
		
		public function set lastModifiedDate(value: String) : void{
			_properties[SOTaskConstants.LASTMODIFIEDDATE] = value;
		}
		
		public function get lastModifiedDate(): String{
			return _properties[SOTaskConstants.LASTMODIFIEDDATE];
		}
		
		
		public function set heriarchy(hierarchy : Heriarchy) : void{
			_heriarchy = hierarchy;
			_properties[SOTaskConstants.INDENT] = hierarchy.indent;
		}
		
		public function get heriarchy() : Heriarchy{
			return _heriarchy;
		}
		
		public function set properties(value :Object) : void{
			var valueMapped : Object;
			for(var property : String in value){
				valueMapped = value[property];
				if(property == SOTaskConstants.PARENT){
					updateHierarchy(valueMapped as Task);
				}else{
					_properties[property] = valueMapped;	
				}
			}
		}

		public function property(key : String) : Object{
			return _properties[key];
		}
		public function set stype(type : String) : void{
			_properties[SOTaskConstants.TYPE] = type;
		}
		
		public function get stype() : String{
			return _properties[SOTaskConstants.TYPE];	
		}		
			
		public function get properties() : Object{
			return _properties;
		}
		
		public function get children() : ArrayCollection{
			return _children;
		}
		
		public function addOrUpdateChildTask(task : Task) : void{
			var child : Task;
			for(var i:int=0; i<_children.length; i++){
				child = _children.getItemAt(i) as Task;
				if(child.id == task.id){
					break;
				}
			}
			if(child){
				child = task;
			}else{
				_children.addItem(task);	
			}
		}
		
		public function removeChildTask(task : Task) : void{
			var child : Task;
			for(var i :int =0; i<_children.length; i++){
				child = _children.getItemAt(i) as Task;
				if(child.id == task.id){
					_children.removeItemAt(i);
					break;
				}
			}
		}
		
		public function durationInDays() : Number {
			var days : Number = Calendar.durationInDays(startDate,endDate);
			return days;
		}
		
		public function durationInWorkingDays() : Number{
			var days : Number = Calendar.workingDays(startDate,endDate);	
			return days;
		}
		
		/**
		 * Add a dependency to the parent and child tasks
		 * This replace AssignDependencies
		 */
		public function addDependency(dependency : Dependency) : void
		{
			this.dependencies.addItem(dependency);
			if(dependency.id != ''){
				dependency.task.successors.addItem(this);	
			}
		}
		
		/**
		 * Update a dependency
		 */	
		public function updateDependency(dependency : Dependency) : void
		{
			var dependencyOld : Dependency;
			for(var i : int = 0; i < dependencies.length; i++)
			{
				dependencyOld = Dependency(dependencies.getItemAt(i));
				if(dependencyOld.id == dependency.id)
				{
					if(dependencyOld.task.id != dependency.task.id){
						dependencyOld.task.removeSuccessor(this);
						dependency.task.successors.addItem(this);
					}
					dependencies.setItemAt(dependency, i);
					
				}
			}
		}
		/**
		 * Delete a dependency from dependencies and successors
		 */				
		public function removeDependency(dependency : Dependency) : void
		{
			var dependencyDeleted : Dependency;
			for(var i : int = 0; i < dependencies.length; i++)
			{
				if(dependencies.getItemAt(i).id == dependency.id)
				{
					dependencyDeleted = Dependency(dependencies.removeItemAt(i));
					dependencyDeleted.task.removeSuccessor(this);
				}
			}
		}

		 /**
		 * Returns true if the parent task is an ancestor otherwise false
		 * @param parentTask: a task
		 * @return a Boolean 
		 */
		 public function isParent(parentTask : Task) : Boolean
		 {
		 	var dependency : Dependency;
		 	for(var i : int = 0; i < dependencies.length; i++)
			{
				dependency = Dependency(dependencies.getItemAt(i));
	    		if(dependency.task != null && parentTask != null){
					if(dependency.task.id == parentTask.id)
					{
						return true;
					}
					else
					{
						isParent(dependency.task);
					}
	    		}
			}
		 	return false;
		 }
		 

		/**
		 * Find a specific dependency among their dependencies
		 * @param value: dependency id
		 * @return an instance of Dependency
		 */
		public function getDependency(value : String, find : String = 'id') : Dependency
		{
			var dependency : Dependency;
			for(var i : int = 0; i < dependencies.length; i++)
			{
				dependency = Dependency(dependencies.getItemAt(i));
				if(find == 'id')
				{
					if(dependency.id == value)
					{
						return dependency;
					}
				}
				else if(find == 'idParent')
				{
					if(dependency.task.id == value)
					{
						return dependency;
					}
				}
			}
			return null;
		}
		
		/**
		 * Add a resource to the task
		 * 
		 * @param taskResource resource to be added.
		 */
		public function addTaskResource(taskResource : TaskResource) : void
		{
			this.taskResources.addItem(taskResource);
		}
		
		/**
		 * Return a taskResource object with id = taskResourceId 
		 *
		 * @param taskResourceId: taskResource id.
		 * @return a TaskResource instance
		 */
		 public function getTaskResource(taskResourceId : String = '', resource : Resource = null) : TaskResource
		 {
		 	var taskResource : TaskResource;
		 	for(var i : int = 0; i < this.taskResources.length; i++)
			{
				taskResource = TaskResource(this.taskResources.getItemAt(i));
				if(taskResourceId != '')
				{
					if(taskResource.id == taskResourceId)
					{
						return taskResource;		
					}
				}
				if(resource != null)
				{
					if(taskResource.resource.id == resource.id)
					{
						return taskResource;		
					}
				}
			}
			return null;
		 }
		 /**
		  * Replace a task resource
		  */
		 public function setTaskResource(taskResourceId : String, taskResource : TaskResource) : void
		 {
		 	for(var i : int = 0; i < this.taskResources.length; i++)
			{
				if(TaskResource(this.taskResources.getItemAt(i)).id == taskResourceId)
				{
					this.taskResources.setItemAt(taskResource,i);
				}
			}
		 }
		 
		 /**
		  * Set an array of task resources to the task
		  */
		 public function setTaskResources(taskResources : ArrayCollection) : void
		 {
			this.taskResources = taskResources;
		 }
		 
		 /**
		 * Delete a task resource from a task;
		 */				
		public function removeTaskResource(taskResourceId : String) : void
		{
			for(var i : int = 0; i < this.taskResources.length; i++)
			{
				if(this.taskResources.getItemAt(i).id == taskResourceId)
				{
					this.taskResources.removeItemAt(i);		
				}
			}
		}
		/*
	    * Retorna true si existe el recurso asignado en la tarea
	    *
	    * @param resource. Resource a buscar
	    */
	    public function hasResource(resource : Resource) : Boolean
	    {
	    	var exist : Boolean = false;
	    	for(var i : int = 0; i < this.taskResources.length ; i++)
	   		{
	   			if(this.taskResources.getItemAt(i).resource.id == resource.id)
	   			{
	   				exist = true;
	   				break;
	   			}
	    	}
	    	return exist;
	    }
	    
	    /*
	    * Retorna true si existe el recurso asignado en la tarea
	    *
	    * @param resourceID. resource id to find.
	    */
	    public function hasResourceID(resourceID : String){
	    	var resource : Resource = new Resource('',resourceID);
	    	return hasResource(resource);
	    }
		/*
		 * metodo toString
		 */		
		public function toString() : String
		{
			return this.position+') '+this.name +' completed :'+ completed.toString();
		}

		/*
		 * Actualiza el campo position de la tarea en la base de datos
		 * Es llamada cuando se crea, edita o mueve una tarea
		 */	
		public function resetPositions(index : int) : void
		{
			if(this.heriarchy.next != null)
       		{
       			index++;
				this.position = index;
				if(this.id != '')
				this.heriarchy.next.resetPositions(index);
			}
		}
		/*
		 * Validate the correct data.
		 * TODO please analyze the possibility to remove this method.
		 */
		public function validate () : Boolean
		{
  			if((this.completed >= 0 && this.completed <= 100) || (this.name != '' || this.name != null))
  			{
				return true;
  			}	
  			else
  			{
  				Alert.show('Please check the task data');
				return false;
  			}
		}
		/*
		 * Concat into a String the names of the dependencies contained.
		 */
		public function concatDependencies(separator : String) : String
		{
			var link : String = '';
			//var dependency : Dependency = null;
			
			if(this.dependencies.length>0)
			{
				link = (Dependency(this.dependencies.getItemAt(0))).toString();
				if(this.dependencies.length>1)
				{
					link += '...';
				}
			}
			return link;
		}
		/**
		 * Concatena en un string las dependencias de una tarea
		 */
		public function concatAlternatedDependencies(separator1 : String, separator2 : String, alternated : int) : String
		{
			var separatorTemp : String = '';
			var link : String = '';
			var dependency : Dependency = null;
			
			for(var i : int = 0; i < this.dependencies.length; i++)
			{
				separatorTemp = separator1;
				if((i+1) % alternated == 0)
				{
					separatorTemp = separator2;
				}
				dependency = Dependency(this.dependencies.getItemAt(i));
				link += dependency.toString() + separatorTemp;
			}
			if(link != '')
			{
				link = link.substr(0,link.length-separatorTemp.length);
			}
			return link;
		}
		/*
		 * Concatena en un string las dependencias
		 */
		public function concatTaskResouces(separator : String) : String
		{
			var link : String = '';
			var taskResource : TaskResource = null;
			
			for(var i : int = 0; i < this.taskResources.length; i++)
			{
				taskResource = TaskResource(this.taskResources.getItemAt(i));
				link += taskResource.resource.name + '('+taskResource.dedicated+')' + separator;
			}
			if(link != '')
			{
				link = link.substr(0,link.length-separator.length);
			}
			return link;
		}
		
		/**
		* Updates the indents of task children
		*/	
		public function updateChildren() : void{
			this.heriarchy.moveChildren(this);			
		}
		
		public function hasChildren() : Boolean{
			return this.heriarchy.hasChildren(this.id);
			//return subtasks.length > 0;
		}
		
		public function getDescendants() : ArrayCollection{
			var descendents : ArrayCollection = new ArrayCollection();
			getDescendantsRecursive(descendents);
			return descendents;
		}
		
		/**
		 * Adjusts the start and end dates depending if the range of dates contains weekend days.
		 */
		public function adjustDates(durationInHours : Boolean) : void{
			if(Calendar.isWeekend(startDate)){
				startDate = Calendar.addWorkDay(startDate,1);
			}
			var days : int;
			if(durationInHours){
				days = project.convertToDays(duration);
			}else{
				days = duration;
			}
			endDate = Calendar.nextWorkDate(startDate,days);
		}
		
		/**
		 * Returns a collection from whole tree of dependencies from a task.
		 * @return a collection of dependent tasks linked with dependencies.
		 */ 
		public function getSuccessorTasks() : ArrayCollection{
			var tasks : ArrayCollection = new ArrayCollection();
			successorTasksRecursive(tasks);
			return tasks;
		} 
		
		private function successorTasksRecursive(tasks : ArrayCollection) : void{
			for each(var successor : UiTask in successors){
				tasks.addItem(successor.clone());
				successor.successorTasksRecursive(tasks);
			}
		}
		
		/**
		 * Verify if a task is dependent directly or indirectly on another task.
		 * 
		 */
		public function isSuccessor(task : Task) : Boolean{
			var isSuccessor : Boolean = false;
			var successorsTasks : ArrayCollection = new ArrayCollection();
			successorTasksRecursive(successorsTasks);
			for each (var successorTask : Task in successorsTasks){
				if(task.id == successorTask.id){
					isSuccessor = true;
					break;
				}
			}
			return isSuccessor;
		} 
		
		/**
		* Verify if a task is ancestor of another task
		* @param task : the task to check if is ancestor
		* @returns true if task is ancestor of this task, otherwise false.
		*/ 
		public function isAncestor(task : Task) : Boolean{
			return this.heriarchy.isAncestor(this,task);
			/*if(parentTask){
				if(parentTask.id == task.id){
					return true;
				}else{
					return parentTask.isAncestor(task);
				}
			}else{
				return false;
			} */
			
		}
		
		/**
		 * Returns true if a task is a descendent
		 * @param child : task to verify if it is a descendent.
		 * @return true if it is an descendent, otherwise false.
		 */
		public function isDescendent(child : Task) : Boolean{
			/*var descendents : ArrayCollection = getDescendants();
			for each(var task : Task in subtasks){
				if(task.id == child.id){
					return true;
				}else{
					return task.isDescendent(child);
				}
			}
			return false;*/
			
			var descendents : ArrayCollection = heriarchy.getDescendants(this);
			var found : Boolean = false;
			var task : Task;
			for(var i:int=0;!found && i<descendents.length;i++){
				task = Task(descendents.getItemAt(i));
				found = task.id == child.id
			}
			return found;
		}
		
		/**
     	 * Returns the ancestors of this.
     	 * Uncomment this function when the heriarchy class may be removed it from the model.
     	 */
     	/* public function getAncestors() : ArrayCollection{
     		if(parentTask){
     			var ancestors : ArrayCollection = parentTask.getAncestors();
     			ancestors.addItem(parentTask);
     			return ancestors;
     		}else{
     			return new ArrayCollection();
     		}
     	} */
		
		/**
		 * Given this task return a collection of id, including ancestors , descendents and dependencies.
		 * @return an array containing these ids
		 */ 
		public function dependentTaskIds() : Array{
			
			var ancestorTasks : ArrayCollection;
			var descendantTasks : ArrayCollection;
			var successorTasks : ArrayCollection;
			var ancestorsIds : Array;
			var successorTasksIds : Array;
			var descendantIds : Array;
			var totalIds : Array;
			// ancestors calculated from parent attribute
		 	ancestorTasks = heriarchy.getAncestors();
		 	//ancestorTasks = getAncestors();

			// dependentTasks calculated by task dependencies.
			successorTasks = getSuccessorTasks();
			
			// descendants 
			descendantTasks = heriarchy.getDescendants(this);
			//descendantTasks = getDescendants();
			CustomArrayUtil.printArray(successorTasks.toArray());
			ancestorsIds = CustomArrayUtil.getAttributesArrayCollection(ancestorTasks,"id").toArray();
			successorTasksIds = CustomArrayUtil.getAttributesArrayCollection(successorTasks,"id").toArray();
			descendantIds = CustomArrayUtil.getAttributesArrayCollection(descendantTasks,"id").toArray();
			totalIds = ancestorsIds.concat(successorTasksIds);
			totalIds = totalIds.concat(descendantIds);
			return totalIds;			
		}
		
		private function removeSuccessor(task : Task) : void{
			var successor : Task;
			var deleted : Boolean = false;
			for(var i:int=0;!deleted && i<successors.length;i++){
				successor = Task(successors.getItemAt(i));
				if(successor.id == task.id){
					successors.removeItemAt(i);
					deleted = true;
				}
			}
		}
		
		private function updateHierarchy(parentTask : Task) : void{
			if(parentTask){
				if(parentTask.id == ''){
					heriarchy.indent = 0;
					_properties[SOTaskConstants.PARENT] = null;
					}else{
					heriarchy.indent = parentTask.heriarchy.indent + 1;
					_properties[SOTaskConstants.PARENT] = parentTask.id;	
				}	
			}	
		}
		
		private function getDescendantsRecursive(tasks : ArrayCollection) : ArrayCollection{
			for each(var task : Task in _children){
				tasks.addItem(task);
				task.getDescendantsRecursive(tasks);
			}
			return tasks;
		}
	}
}