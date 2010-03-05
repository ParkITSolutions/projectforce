public with sharing class TaskDependencies {

	BigListOfTasks bTaskList;
	BigListOfTaskPredecessors bPredList = new BigListOfTaskPredecessors();
	Map<id, ProjectTask__c> taskToModifyList = new Map<id, ProjectTask__c>();
	Project2__c project;
	Id firstTaskId = null;
	Integer interval = null;
	String  direction = '';
	Boolean goGoGo = null;
	Boolean cyclicDependencieChecked = false;
	
	public TaskDependencies( Id projectId ){
		bTaskList = new BigListOfTasks('SELECT Id, name, StartDate__c, EndDate__c, Duration__c, DurationUI__c, PercentCompleted__c, Milestone__c,ParentTask__c, Indent__c, Project__c  FROM ProjectTask__c WHERE Project__c =\'' + projectId + '\'');
		this.project = [ SELECT Id, DaysInWorkWeek__c FROM Project2__c WHERE Id =: projectId ][0];
	}
	
	
	/**
	*@return Boolean
	*@Param ProjectTask__c ProjectTask__c
	*
	* Check some condition for continue
	*/
	public Boolean goGoGo( ProjectTask__c taskOld, ProjectTask__c taskNew ){

		Boolean goGoGo = true;
		Integer localInteval = 0;  
		Integer nonWkDays = 0;  
		ProjectTask__c predTask = new ProjectTask__c();

		// Get relations for the current prokect.
		List<ProjectTaskPred__c> relationsList = new List<ProjectTaskPred__c>();  
		relationsList = bPredList.getListByPred( taskNew.id  , '2');

		//throw new CustomException('#' + relationsList.size() +':::'+ taskNew.name);
		if(relationsList.size() > 0 )
		for( Integer k = 0; k < relationsList.size() && goGoGo; k++ ){
			predTask = new ProjectTask__c();
			if( this.taskToModifyList.containsKey( relationsList[k].Parent__c )) 
				predTask = this.taskToModifyList.get( relationsList[k].Parent__c );
			else
				predTask = BigListOfTasks.getById( relationsList[k].Parent__c );
			
			if(predTask.Milestone__c == true)
			predTask.endDate__c = predTask.startDate__c;
			
			// Look if PredTask is a Milestone
			localInteval = Date.valueOf( predTask.Milestone__c == true ? predTask.startDate__c : predTask.endDate__c ).daysBetween( Date.valueOf( taskNew.startDate__c ));
			nonWkDays = this.getNonWDays(  Date.valueOf(predTask.endDate__c),  Date.valueOf(taskNew.startDate__c), Integer.valueOf(this.project.DaysInWorkWeek__c ));
			
			//throw new CustomException('#>' + localInteval +'>'+ (relationsList[k].Lag_Time__c.intValue() + nonWkDays));
			goGoGo = this.direction == 'right' ?  localInteval - 1 >= 0 : localInteval > relationsList[k].Lag_Time__c.intValue() + nonWkDays; 
		}
		
		// If can not continue restore odl values of the task in trigger (Before Update)
		// and empty the task list to modify.
 		//goGoGo = true;
 		if( !goGoGo ){
			this.taskToModifyList.clear();
			taskNew.StartDate__c = taskOld.StartDate__c;
			taskNew.EndDate__c = taskOld.EndDate__c;
		} 
		//throw new CustomException('#' + goGoGo );
	
		return goGoGo;
	}
	

	
	public void movingTask( ProjectTask__c taskOldParam, ProjectTask__c taskNewParam ){
		
		
		ProjectTask__c newTask = new ProjectTask__c();
		ProjectTask__c taskOld = new ProjectTask__c();
		ProjectTask__c taskNew = new ProjectTask__c();
		
		// Clone the params for modify EndDate__c value
		if( this.taskToModifyList.containsKey(taskOldParam.Id))
			taskNew = this.taskToModifyList.get(taskOldParam.Id);
		else
			taskNew = taskNewParam.clone();
		if( this.taskToModifyList.containsKey( taskOld.Id ))
			taskOld 	= this.taskToModifyList.get( taskOld.Id );		
		else
			taskOld = taskOldParam.clone();
		
		// Add the current new task to the list of task to modify
		this.taskToModifyList.put( taskNew.id, taskNew );
		
		// Backup the Id of the first task for remove this from the list of task to modify 
		// because this task is in the trigger.
		if( this.firstTaskId == null )
			this.firstTaskId = taskNew.Id;
		
		// Generate the big list of relationships for current project.	
		if( this.bPredList.size() == 0 )
			this.bPredList = new BigListOfTaskPredecessors( taskOld.Project__c );
		
		// Verifying if old or new task are milestone. If the task is a milestone then
		// the end date take the value of the star data for this script.
		if( taskOldParam.Milestone__c == true )
			taskOld.EndDate__c = taskOld.StartDate__c;
		if( taskNewParam.Milestone__c == true )
			taskNew.EndDate__c = taskNew.StartDate__c;
			
		// Calculate the interval to move the tasks.
		// 4 cases
		if( taskOld.StartDate__c != taskNew.StartDate__c && taskOld.endDate__c != taskNew.endDate__c){
			// Case 1: move the the task.Change the end and the start Date.
			if( this.interval == null )
				this.interval = Date.valueOf( taskOld.startDate__c ).daysBetween(Date.valueOf( taskNew.startDate__c ));
		}else if( taskOld.StartDate__c == taskNew.StartDate__c && taskOld.endDate__c != taskNew.endDate__c ){
			// Case 2: only change the end date of the task.
			if( this.interval == null )
				this.interval = Date.valueOf( taskOld.endDate__c ).daysBetween(Date.valueOf( taskNew.endDate__c ));			
		}else if( taskOld.StartDate__c != taskNew.StartDate__c && taskOld.endDate__c == taskNew.endDate__c){
			// Case 3: only change the start date of the task.
			if( this.interval == null )
				this.interval = 0;
		}else if( this.interval == null )
			// Case 4:
			this.interval = 0;

		

		// Determinate the direction of movement, that will be used in goGoGo() method
		this.direction = this.interval > 0 ? 'right' : 'left';
		this.goGoGo = this.goGoGo( taskOldParam, taskNewParam );
		Integer taskLarg;		
		List<ProjectTaskPred__c> relationsList = new List<ProjectTaskPred__c>();  
		relationsList = bPredList.getListByParent( taskOld.id  , '2');
		//if(this.goGoGo == false)
		//throw new CustomException('#' + this.goGoGo + '-'+taskNew.name);
		Integer inter = 0; 
		Integer daysToSubstract = 0;
		Date    oldStartDate;
		Boolean conditionCanMove;
		Boolean conditionMovePred;
		
		if(relationsList.size() > 0 && this.goGoGo )
			for( ProjectTaskPred__c r : relationsList){
				newTask = new ProjectTask__c();
				newTask = milestoneToTask( BigListOfTasks.getById( r.Predecessor__c ));
				
				oldStartDate = Date.valueOf( newTask.StartDate__c );
				taskLarg = newTask.milestone__c == true ? 1 : Math.abs(newTask.endDate__c.daysBetween(newTask.startDate__c));
				conditionCanMove  = newTask.startDate__c.addDays(-r.Lag_Time__c.intValue() -inter).daysBetween(taskNew.endDate__c) >= 0;
				conditionMovePred = this.isWorkingDay( taskNew.endDate__c.addDays(r.Lag_Time__c.intValue()));
				daysToSubstract = 0;
				if( newTask.Milestone__c || !conditionMovePred || conditionCanMove  ){
					newTask.startDate__c = Date.valueOf(taskNew.endDate__c).addDays( 1 + r.Lag_Time__c.intValue());				
					inter = getNonWDays( Date.valueOf(taskNew.endDate__c), Date.valueOf(newTask.startDate__c), Integer.valueOf( this.project.DaysInWorkWeek__c ));					
					newTask.StartDate__c = Date.valueOf(newTask.StartDate__c.addDays(inter));
					if( 0 <= getNonWDays( oldStartDate,Date.valueOf(newTask.EndDate__c), Integer.valueOf( this.project.DaysInWorkWeek__c )) &&  taskLarg > 1 )
					daysToSubstract = getNonWDays( oldStartDate, Date.valueOf(newTask.startDate__c), Integer.valueOf( this.project.DaysInWorkWeek__c ));
					newTask.endDate__c = Date.valueOf(newTask.startDate__c).addDays( taskLarg - daysToSubstract);
					//throw new CustomException( '#> ' +  newTask.name + ':'+ oldStartDate + ':'+newTask.startDate__c+ ':'+ daysToSubstract );
					this.movingTask( BigListOfTasks.getById( r.Predecessor__c ), newTask);
				}
			}
	}

	public ProjectTask__c milestoneToTask( ProjectTask__c t ){
		if( t.milestone__c == true )
			t.enddate__c = t.startdate__c;
			
		return t;
	}
	
	public void changeLag(ProjectTaskPred__c predObj){
		
		if( this.bPredList.size() == 0 )
		this.bPredList = new BigListOfTaskPredecessors( predObj.Project__c );
		
		ProjectTask__c newTask = new ProjectTask__c();
		ProjectTask__c oldTask = new ProjectTask__c();
		ProjectTask__c parentTask = new ProjectTask__c();
		
		parentTask = milestoneToTask( BigListOfTasks.getById( predObj.parent__c ));

		if( this.taskToModifyList.containsKey(predObj.Predecessor__c))
			newTask = this.taskToModifyList.get(predObj.Predecessor__c);
		else
			newTask = BigListOfTasks.getById( predObj.Predecessor__c );
		
		newTask = milestoneToTask ( newTask );
		
		oldTask = newTask.clone() ;

		Integer l = Date.valueOf(newTask.startDate__c).daysBetween(Date.valueOf(newTask.endDate__c))+1;
		newTask.StartDate__c = Date.valueOf(parentTask.Milestone__c==true ? parentTask.StartDate__c : parentTask.EndDate__c).addDays(predObj.Lag_Time__c.intValue()+1);		
		newTask.EndDate__c = Date.valueOf(parentTask.Milestone__c==true ? parentTask.StartDate__c : parentTask.EndDate__c).addDays(predObj.Lag_Time__c.intValue() + l);

		Integer inter = getNonWDays( Date.valueOf(parentTask.endDate__c), Date.valueOf(newTask.startDate__c), Integer.valueOf( this.project.DaysInWorkWeek__c ));
		newTask.StartDate__c = Date.valueOf(newTask.StartDate__c.addDays(inter));
		newTask.EndDate__c   = Date.valueOf(newTask.EndDate__c.addDays(inter));
		//throw new CustomException('#' + fooo );
		
		update newTask;
		
		//this.movingTask(oldTask, newTask); 
		
		//this.taskToModifyList.put( newTask.id, newTask );
	}	

	/**
	*@param Id, Id
	*@return Boolean
	*Check cyclic dependecie in a tree of tasks.
	*/
	public Boolean checkCyclicDependencie ( Id iniTaskId, Id endTaskId )  {
		
		// If exist cyclic dep. become true.
		Boolean result = false;
		
		ProjectTask__c currentTask = new ProjectTask__c();
		List<ProjectTaskPred__c> currentTaskPredList = new List<ProjectTaskPred__c>();
		
		currentTaskPredList = bPredList.getListByParent( iniTaskId  , '2');
		
		Integer count = 0; 
		while( currentTaskPredList.size() > 0 && count < currentTaskPredList.size()){
			currentTask = BigListOfTasks.getById( currentTaskPredList[ count ].Predecessor__c );
			if( currentTask.Id == endTaskId )
				result = true;
			else
				result = checkCyclicDependencie( currentTask.id, endTaskId );
			count ++;
		}
		return result;		
	}
	
	
	
	
	public void InsertinfPred( ProjectTaskPred__c predObj ){
		
		if( this.bPredList.size() == 0 )
		this.bPredList = new BigListOfTaskPredecessors( predObj.Project__c );
		
		ProjectTask__c predTask 	= new ProjectTask__c();
		ProjectTask__c parentTask 	= new ProjectTask__c();
		ProjectTask__c taskToModify = new ProjectTask__c();
		List<ProjectTaskPred__c> relationsList = new List<ProjectTaskPred__c>();  
		
		
		if( this.taskToModifyList.containsKey(predObj.Predecessor__c))
			predTask = this.taskToModifyList.get(predObj.Predecessor__c);
		else
			predTask 	= BigListOfTasks.getById( predObj.Predecessor__c );
		
		if( this.taskToModifyList.containsKey( predObj.Parent__c ))
			parentTask 	= this.taskToModifyList.get( predObj.Parent__c );		
		else
			parentTask 	= BigListOfTasks.getById( predObj.Parent__c );	

		if(this.checkCyclicDependencie( predTask.id, parentTask.id ))
			throw new CustomException(' ');
				
		if( predTask.Milestone__c == true )
			predTask.EndDate__c = predTask.StartDate__c;
		if( parentTask.Milestone__c == true )
			parentTask.EndDate__c = parentTask.StartDate__c;
		
		Integer parentInterval = Math.abs(Date.valueOf( predTask.endDate__c ).daysBetween(Date.valueOf( predTask.startDate__c )));
		
		Integer bla = Date.valueOf( parentTask.endDate__c ).daysBetween(Date.valueOf( predTask.startDate__c ));
		bla = bla > 0 ? bla-1 : 0;

		//
		Date newParentStartDate = Date.valueOf( parentTask.endDate__c ).addDays( predObj.Lag_Time__c.intValue() +1 );		
		Date newParentEndDate   = Date.valueOf( parentTask.endDate__c   ).addDays( predObj.Lag_Time__c.intValue() + parentInterval + 1);	
		Integer fooo = getNonWDays( Date.valueOf(predTask.StartDate__c), newParentStartDate, 5);
		//throw new CustomException('#' + fooo ); 
		newParentStartDate.addDays(fooo);
		newParentEndDate.addDays(fooo);
		
		//
		taskToModify = BigListOfTasks.getById( predObj.Predecessor__c );

		if(Date.valueOf( parentTask.endDate__c ).daysBetween( Date.valueOf(taskToModify.startDate__c )) <= 0 ){
			taskToModify.StartDate__c = newParentStartDate;
			taskToModify.EndDate__c   = newParentEndDate;
			
			this.taskToModifyList.put( taskToModify.id, taskToModify );
	
			relationsList = bPredList.getListByParent( taskToModify.id  , '2');
			if(relationsList.size() > 0 )
				for( ProjectTaskPred__c r : relationsList)
					this.InsertinfPred( r );
		}
	}
	
	public void updateNow(){
		//throw new CustomException('#' + this.taskToModifyList.size());
		
		if( this.taskToModifyList.size() > 0 ){
			ProjectUtil.setTaskDependenciesFlag( false );
			this.taskToModifyList.remove( firstTaskId );
			update this.taskToModifyList.values();
			this.taskToModifyList = new Map<id, ProjectTask__c>();
		}
	}

	public List<ProjectTask__c> listToUpdateNow(){
		//throw new CustomException('#' + this.taskToModifyList.size());
		if( this.taskToModifyList.size() > 0 ){
			ProjectUtil.setTaskDependenciesFlag( false );
			this.taskToModifyList.remove( firstTaskId );
			return this.taskToModifyList.values();
			this.taskToModifyList = new Map<id, ProjectTask__c>();
		}
		return null;
	}

	public List<ProjectTask__c> getListToUpdate(){
		return this.taskToModifyList.values();
	} 
	
	/**
	*@param ProjectTask__c
	*Delete all ralationships (ProjectTaskPred__c) from and to a task
	*/
	public void delAllRelsFromMe( ProjectTask__c task ){
		List<ProjectTaskPred__c> relsToDelete 	= new List<ProjectTaskPred__c>();
		List<ProjectTaskPred__c> relsToMe 		= new List<ProjectTaskPred__c>();
		List<ProjectTaskPred__c> relsFromMe 	= new List<ProjectTaskPred__c>();

		if( this.bPredList.size() == 0 )
		this.bPredList = new BigListOfTaskPredecessors( task.Project__c );
		
		// Get all parents
		relsToMe 	= this.bPredList.getListByParent( task.id, '2');
		
		// Get all predecessors
		relsFromMe	= this.bPredList.getListByPred( task.id, '2');
		
		if( relsToMe.size() > 0 )
			relsToDelete.addAll( relsToMe );
		
		if( relsFromMe.size() > 0 )
			relsToDelete.addAll( relsFromMe );

		if( relsToDelete.size() > 0 )
			delete relsToDelete;
	}	

	public Boolean isWorkingDay( Date d ){
		Set<String> workdays = new Set<String>();
		Integer rToReturn = 0;
		List<String> weekdays = new List<String>{'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'};
		
		for(Integer i = 0; i < Integer.valueOf( this.project.DaysInWorkWeek__c ); i++)
			workdays.add( weekdays[ i ]); 
			
		Datetime tempDate = Datetime.valueOf( d + '00:00:00' );	
		return workdays.contains( tempDate.format( 'EEE' ));	
	}
	
	public Integer getNonWDays( Date initD, Date endD, Integer workingDays ){
		Set<String> workdays = new Set<String>();
		Integer rToReturn = 0;
		List<String> weekdays = new List<String>{'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'};
		
		for(Integer i = 0; i < workingDays; i++){
			workdays.add(weekdays[i]);	
		}
		
		Integer dasyBet = Math.abs( initD.daysBetween( endD ));
		Datetime tempDate = Datetime.valueOf( initD + '00:00:00' );
		for( Integer k = 0; k < dasyBet; k ++){  
			tempDate = tempDate.addDays( 1 );
			rToReturn += workdays.contains( tempDate.format( 'EEE' )) == true ? 0 : 1;
		}
		
		
		Boolean c = !workdays.contains( tempDate.format( 'EEE' ));
		if( c ){
		//throw new CustomException('# ^|' + initD +'=' +tempDate.format( 'EEE' ) + '>>>' + c); 
			//rToReturn = 0;
			//tempDate = Datetime.valueOf( endD + '00:00:00' );
			rToReturn--;	
			while( c ){
				rToReturn++;
				tempDate = tempDate.addDays( 1 );
				c = !workdays.contains( tempDate.format( 'EEE' ));
			}
		}
		
		//if( rToReturn > 0)
		//throw new CustomException('#' + rToReturn +': :'+initD+': :'+endD);
		return rToReturn;
		
	}

	public class BigListOfTaskPredecessors{

		List<ProjectTaskPred__c> bList = new List<ProjectTaskPred__c>();
		Map<id, ProjectTaskPred__c> bMap   = new Map<id, ProjectTaskPred__c>();

		/**
		* Class constructor
		*/
		public BigListOfTaskPredecessors(){}
		
		/**
		* Class constructor
		* @param Id projectId
		*/
		public BigListOfTaskPredecessors( Id projectId ){
			for( ProjectTaskPred__c pT : [ SELECT Id, Name, Project__c, Parent__c, Predecessor__c, Lag_Time__c, Lag_Type__c, Lag_Unit__c FROM ProjectTaskPred__c WHERE Project__c =: projectId ])
				if( this.bList.size() < 1000 )
				this.bList.add( pT );
		}		
		
		/**
		* @param Integer 
		* Get element from list
		*/
		public ProjectTaskPred__c get( Integer i ){
			ProjectTaskPred__c rPred = new ProjectTaskPred__c();
			
			if(this.size() > 0)
			rPred = this.bList.get( i );
			
			return rPred;
		}
		
		/**
		* @param Id parentId
		* @return ProjectTaskPred__c
		*/
		public ProjectTaskPred__c getByParentId( Id parentId ){
			Integer k = 0;
			ProjectTaskPred__c rTask = new ProjectTaskPred__c();
			while( k < this.size()){
				if(this.bList[ k ].Parent__c == parentId){
					rTask = this.get(k);
					break;
				}
				k++;
			}
			return rTask;
		}
		
		/**
		* @param Id parent, String typeRel 
		* @return List<ProjectTaskPred__c>
		* Get a sublist of ProjectTaskPred__c objects by parent__c and relation type
		*/
		public List<ProjectTaskPred__c> getListByParent( Id parent, String typeRel ){
			List<ProjectTaskPred__c> rList = new List<ProjectTaskPred__c>();
			for(ProjectTaskPred__c ptp : this.bList)
				if( ptp.Parent__c == parent  )
				rList.add( ptp );
				
			return rList;
		}

		/**
		* @param Id predecessor, String typeRel 
		* @return List<ProjectTaskPred__c>
		* Get a sublist of ProjectTaskPred__c objects by predecessor__c and relation type
		*/
		public List<ProjectTaskPred__c> getListByPred( Id predecessor, String typeRel ){
			List<ProjectTaskPred__c> rList = new List<ProjectTaskPred__c>();
			for(ProjectTaskPred__c ptp : this.bList)
				if( ptp.Predecessor__c == predecessor  )
				rList.add( ptp );
				
			return rList;
		}
		
		/**
		* @param ProjectTaskPred__c
		* Add element to the list, qt the finish
		*/
		public void add( ProjectTaskPred__c pT ){	
			this.bList.add( pT );
		}

		/**
		* @param List<ProjectTaskPred__c>
		* Add ProjectTaskPred__c list
		*/
		public void addAll( List<ProjectTaskPred__c> pTList ){	
			this.bList.addAll( pTList );
		}
		
		/**
		* Return the sise of the list
		*/
		public Integer size(){
			return this.bList.size();
		}
		
		/**
		* Clear the list
		*/
		public void clear(){
			this.bList.clear();
		}
		
		/**
		* Perform an update with the list
		*/
		public void updateNow(){
			ProjectUtil.setTaskDependenciesFlag( false );
			update this.bList;
		}

	}
	
	
}