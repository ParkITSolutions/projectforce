public with sharing class TaskDependencies {

	BigListOfTask bTaskList = new BigListOfTask('SELECT Id, name, StartDate__c, EndDate__c, Duration__c FROM ProjectTask__c');
	BigListOfTaskPredecessors bPredList = new BigListOfTaskPredecessors();
	List<ProjectTask__c> taskToModifyList = new List<ProjectTask__c>();


	/**
	Integer boo = 0;
	List<ProjectTaskPred__c> relsList = new List<ProjectTaskPred__c>();
	BigListOfTask taskList = new BigListOfTask();

	ProjectTask__c task = new ProjectTask__c();
	ProjectTask__c newTask = new ProjectTask__c();
	ProjectTaskPred__c pred = new ProjectTaskPred__c();
	ProjectTask__c predTask = new ProjectTask__c();
	*/
	public TaskDependencies(){}
	
	public void InsertinfPred( ProjectTaskPred__c predObj ){
		
		ProjectTask__c predTask 	= new ProjectTask__c();
		ProjectTask__c parentTask 	= new ProjectTask__c();
		
		predTask 	= this.bTaskList.getById( predObj.Predecessor__c );
		parentTask 	= this.bTaskList.getById( predObj.Parent__c );
		
		// Days between  parentTask.endDate__c and parentTask.startDate__c
		Integer parentInterval = Math.abs(Date.valueOf( parentTask.endDate__c ).daysBetween(Date.valueOf( parentTask.startDate__c )));
		
		//
		Date newParentStartDate = Date.valueOf( predTask.endDate__c ).addDays( Integer.valueOf( predObj.Lag_Unit__c == null ? '0' : predObj.Lag_Unit__c ));		
		Date newParentEndDate = Date.valueOf( predTask.endDate__c ).addDays( Integer.valueOf( predObj.Lag_Unit__c == null ? '0' : predObj.Lag_Unit__c ) + parentInterval);		
		
		//
		ProjectTask__c taskToModify = new ProjectTask__c();
		taskToModify = this.bTaskList.getById( predObj.Parent__c );
		taskToModify.StartDate__c = newParentStartDate;
		taskToModify.EndDate__c = newParentEndDate;
		
		this.taskToModifyList.add( taskToModify );

		List<ProjectTaskPred__c> relationsList = new List<ProjectTaskPred__c>();  
		relationsList = bPredList.getListPred( taskToModify.id, 'Finish-to-Start');
		if(relationsList.size() > 0 )
		for( ProjectTaskPred__c r : relationsList)
			this.InsertinfPred( r );
		
				
		
		
		
	}
	
	public void updateNow(){
		if( this.taskToModifyList.size() > 0 )
		update this.taskToModifyList;	
	}

	public class BigListOfTask{
		List<ProjectTask__c> bList = new List<ProjectTask__c>();
		Map<Id, ProjectTask__c>  bMap = new Map<Id, ProjectTask__c>();
		public bigListOfTask(){}
		 
		public bigListOfTask( String soql ){
			for( ProjectTask__c pT : Database.query( soql ))
				if( this.bList.size() < 1000 ){
					this.bList.add( pT );
					this.bMap.put( pT.id, pT);
				}
		}		
		
		public ProjectTask__c get( Integer i){
			return this.bList.get( i );
		}
		
		public ProjectTask__c getById( Id i){
			return this.bMap.get( i );
		}
		
		public void add( ProjectTask__c pT ){	
			this.bList.add( pT );
			this.bMap.put( pT.Id, pT );
		}
		
		public Integer size(){
			return this.bList.size();
		}

		public void updateNow(){
			ProjectUtil.setTaskDependenciesFlag( false );
			update this.bList;
		}
		public void debugg( String token ){
			System.debug('\n\n' + token + '\n\n');
			System.debug('Size -->' + this.size() + '\n\n');
			System.debug('List --> ' + this.bList );
		}
	}

	public class BigListOfTaskPredecessors{

		List<ProjectTaskPred__c> bList = new List<ProjectTaskPred__c>();
		Map<id, ProjectTaskPred__c> bMap   = new Map<id, ProjectTaskPred__c>();

		public BigListOfTaskPredecessors(){}
		
		public BigListOfTaskPredecessors( Id projectId ){
			for( ProjectTaskPred__c pT : [ SELECT Id, Name, Project__c, Parent__c, Predecessor__c, Lag_Time__c, Lag_Type__c, Lag_Unit__c FROM ProjectTaskPred__c WHERE Project__c =: projectId ])
				if( this.bList.size() < 1000 )
				this.bList.add( pT );
		}		
		
		public ProjectTaskPred__c get( Integer i ){
			ProjectTaskPred__c rPred = new ProjectTaskPred__c();
			
			if(this.size() > 0)
			rPred = this.bList.get( i );
			
			return rPred;
		}
		
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
		
		public List<ProjectTaskPred__c> getListPred( Id predecessor, String typeRel ){
			List<ProjectTaskPred__c> rList = new List<ProjectTaskPred__c>();
			for(ProjectTaskPred__c ptp : this.bList)
				if( ptp.Predecessor__c == predecessor && ptp.Lag_Type__c == typeRel )
				rList.add( ptp );
				
			return rList;
		}
		
		public void add( ProjectTaskPred__c pT ){	
			this.bList.add( pT );
		}

		public void addAll( List<ProjectTaskPred__c> pTList ){	
			this.bList.addAll( pTList );
		}
		
		public Integer size(){
			return this.bList.size();
		}
		
		public void clear(){
			this.bList.clear();
		}
		
		public void updateNow(){
			ProjectUtil.setTaskDependenciesFlag( false );
			update this.bList;
		}

		public void debugg( String token ){
			System.debug('\n\n' + token + '\n\n');
			System.debug('Size -->' + this.size() + '\n\n');
			System.debug('List --> ' + this.bList );
		}
	}
	
}