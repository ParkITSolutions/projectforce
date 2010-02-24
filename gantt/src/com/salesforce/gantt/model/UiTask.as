package com.salesforce.gantt.model
{	
	import mx.utils.ObjectUtil;
	import mx.utils.UIDUtil;
	
	[Bindable]
	[RemoteClass(alias="com.salesforce.gantt.model.UiTask")]
	public dynamic class UiTask extends Task  
	{	
		public var isExpanded : Boolean;
		public var alphaCut : Number = 0.1;
		public var redrawed : int = 0;
		public var isDeleted : Boolean = false;
		public var isHidden : Boolean = false;
		
		/*
		 * Costructor
		 */		
		public function UiTask(name : String='none', startDate : Date=null,endDate : Date=null, duration : Number = 1, 
								id : String = "", completed : int = 0, isExpand : Boolean = true, 
								isMilestone : Boolean = false, priority : String = '' ,
								parentTaskId : String= null,description : String = null, properties : Object = null)
		{
			super(name, startDate, endDate, duration, id, completed, isMilestone, priority, parentTaskId,description,properties);
			this.isExpanded = true;
			
		}
		public function clone() : UiTask 
		{
	    	var taskCloned : UiTask = UiTask(ObjectUtil.copy(this));
	    	taskCloned.mx_internal_uid = UIDUtil.createUID();
	    	return taskCloned; 
		}
		/*
        * Returns true if a task is visible at the grid
        */
        public function isVisible() : Boolean
        {
        	if(this.heriarchy.parent != null)
        	{
        		if(!UiTask(this.heriarchy.parent).isExpanded)
        		{
        			return false;
        		}
        		else
        		{
        			return UiTask(this.heriarchy.parent).isVisible();
        		}
        	}
           return true;
        }
		public function isEditable() : Boolean
		{
			if(this.heriarchy != null)	{
				return (!this.heriarchy.hasChildren(this.id));
			}
			return true;
		}
        public function imageSign() : int
		{
			if(this.heriarchy.hasChildren(this.id))
			{
				if(this.isExpanded)
				{
					return 0;
				}
				else
				{
					return 1;
				}
			}
			return -1;
		}
       
		public function update(task : Task) : void{
			id 				= task.id;
			name 			= task.name;
			description		= task.description;
			startDate		= task.startDate;
			endDate			= task.endDate;
			duration 		= task.duration;
			position 		= task.position ;
			positionVisible = task.positionVisible ;  
			completed 		= task.completed ; 
			heriarchy 		= task.heriarchy ;  
			dependencies 	= task.dependencies ;  
			taskResources 	= task.taskResources ;
			successors		= task.successors ;  
			isMilestone 	= task.isMilestone ;
			createdBy 		= task.createdBy ;
			lastModified 	= task.lastModified ;  
			priority 		= task.priority ;
			parent 			= task.parent ;
			heriarchy 		= task.heriarchy;
			stype 			= task.stype;  
			lastModifiedDate = task.lastModifiedDate;	
		}
       
	}
}