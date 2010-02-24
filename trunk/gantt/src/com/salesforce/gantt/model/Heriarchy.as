package com.salesforce.gantt.model
{
	import com.salesforce.gantt.util.CustomArrayUtil;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.utils.ObjectUtil;
	
	[Bindable]
	[RemoteClass(alias="com.salesforce.gantt.model.Heriarchy")]
	public class Heriarchy
	{
		public var indent : int;
		public var parent : Task;
		public var next : Task;
		
		public function Heriarchy(indent : int = 0, parent : Task = null, next : Task = null)
		{
			this.indent		= indent;
			this.parent		= parent;
			this.next		= next;
		}
		
		
		
		/**
        * If the task has children
        * @Deprecated added function to Task class.
        */
		public function hasChildren(id : String) : Boolean
		{
			var hasChildren : Boolean = false;
			if(next != null)
			{
				if(next.heriarchy.parent != null)
		        {
		        	if(next.heriarchy.parent.id == id){
			  			hasChildren = true;
			  		}
			    }
			}
		    return hasChildren;
		}
		
		private function getDescendantsRecursive(task : Task, tasks : ArrayCollection) : ArrayCollection
		{
			
			if(next != null)
       		{
				if(task.heriarchy.isAncestor(task,next))
				{
					tasks.addItem(next);
				}
				return next.heriarchy.getDescendantsRecursive(task, tasks);				
       		}
			return tasks;
		}
		
		/**
		 * Return the descendents of a task
		 */
		public function getDescendants(task : Task) : ArrayCollection{
			var descendants : ArrayCollection = new ArrayCollection();
			return task.heriarchy.getDescendantsRecursive(task,descendants);
		}
		
		/**
		 * Returns true if a task has an ancestor
		 * @param parentTask : task to verify if it is an ancestor task.
		 * @param task : task to verify is an descendent.
		 * @return true if parentTask is an ancestor of task, otherwise false.
		 */
		public function isAncestor(parentTask : Task, task : Task) : Boolean
		{
			if(task != null)
			{
				if(parentTask != null)
				{
					if(parentTask.id == task.id)
					{
						return true;
					}
					else
					{
						return this.isAncestor(parentTask,task.heriarchy.parent);
					}
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * Returns true if a task is a descendent
		 * @param parentTask : task to verify if it is an ancestor task.
		 * @param task : task to verify is an descendent.
		 * @return true if parentTask is an ancestor of task, otherwise false.
		 */
		public function isDescendent(child : Task, parentTask : Task) : Boolean{
			var descendents : ArrayCollection = getDescendants(parentTask);
			var found : Boolean = false;
			var task : Task;
			for(var i:int=0;!found && i<descendents.length;i++){
				task = Task(descendents.getItemAt(i));
				found = task.id == child.id
			}
			return found;
		}
		
        /**
		 * Indent all his children from left to right
		 * TODO Probably deprecated. 
		 */
        public function moveChildren(task : Task, type : String = null) : void
        {
        	var children : ArrayCollection = task.heriarchy.getDescendants(task);
        	for(var i : int = 0; i < children.length; i++)
        	{
        		var child : Task = Task(children.getItemAt(i));
				if(type=='left'){
					child.heriarchy.indent--;
				} 
				else if(type=='right'){
					child.heriarchy.indent++;
				}
				else if(type==null){
					child.heriarchy.indent = task.heriarchy.indent + 1;
				}
        	}
        }
        /**
         * Check if a task should be have a hierarchy parent to assign it ,
         * otherwise assign null
		 */
        public function setParent(taskParent : Task) : Boolean
        {
        	var isParent : Boolean = false;
        	if(this.indent-1 == taskParent.heriarchy.indent)
			{
			 	this.parent = taskParent;
			 	isParent = true;
			}
			else if(this.indent == taskParent.heriarchy.indent)
			{
				if(this.parent != null)
				{
					if(this.parent.id == taskParent.id)
					{
						this.parent = null;
					}
				}
			}
			return isParent;
        }
     
     	/**
     	 * Returns true if the task is the last child of the parent task ,
     	 * otherwise returns false 
     	 */
     	public function isLastChild(parentTask : Task) : Boolean 
     	{
     		if(this.next == null)
     		{
     			return true;
     		}
     		else if(this.next.heriarchy.parent != null && this.next.heriarchy.parent.id == parentTask.id){
     			return false;
     		}
     		else
     		{
     			return this.next.heriarchy.isLastChild(parentTask);	
     		}
     	}   
     	
     	/**
     	 * Returns the ancestors of a given task.
     	 */
     	public function getAncestors() : ArrayCollection{
     		return getAncestorsRecursive(parent,new ArrayCollection());
     	}
     	
     	public function clone() : Heriarchy{
     		var clone : Heriarchy = Heriarchy(ObjectUtil.copy(this));
     		return clone;
     	}
     	
     	private function getAncestorsRecursive(task : Task, ancestors : ArrayCollection) : ArrayCollection{
     		if(task == null){
     			return ancestors;
     		}else{
     			ancestors.addItem(task);
     			return task.heriarchy.getAncestorsRecursive(task.heriarchy.parent,ancestors);
     		}
     	}
     	
	}
}