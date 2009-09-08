public with sharing class TaskDependencies {

	BigListOfTask bL = new BigListOfTask('SELECT Id FROM ProjectTask__c');
	BigListOfTaskPredecessors bLP = new BigListOfTaskPredecessors('');

	List<ProjectTaskPred__c> relsList = new List<ProjectTaskPred__c>();
	BigListOfTask taskList = new BigListOfTask();

	ProjectTask__c task = new ProjectTask__c();
	ProjectTaskPred__c pred = new ProjectTaskPred__c();
	ProjectTask__c predTask = new ProjectTask__c();

	
	public TaskDependencies(){}
	
	
	public Boolean canModifySToS( Id taskId, Date newStartDate ){
		
		this.task = bL.getById( taskId );
		this.pred = bLP.getByParentId( task.id );
		this.predTask = bL.getById( pred.Predecessor__c );
				
		return predTask.StartDate__c >= newStartDate;
	} 
	
	public void genTaskWithRels(){
		for( ProjectTaskPred__c ptp : this.relsList)
			this.taskList.add( bL.getById( ptp.Parent__c ));
	}
	
	public void gentRelList( Id taskId ){
		Integer ind = 0;
		relsList = this.bLP.getListPred( taskId, 'Start-to-Start' );
		
		while( ind < relsList.size()){
			relsList.addAll( this.bLP.getListPred( relsList[ ind ].Parent__c, 'Start-to-Start' ));
			ind++;
		}
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
	}

	public class BigListOfTaskPredecessors{
		List<ProjectTaskPred__c> bList = new List<ProjectTaskPred__c>();
		Map<Id, ProjectTaskPred__c> bMapPred   = new Map<Id, ProjectTaskPred__c>(); 
		Map<Id, ProjectTaskPred__c> bMapParent = new Map<Id, ProjectTaskPred__c>(); 
		
		public BigListOfTaskPredecessors( Id projectId ){
			for( ProjectTaskPred__c pT : [ SELECT Id, Project__c, Parent__c, Predecessor__c, Lag_Time__c, Lag_Type__c, Lag_Unit__c 
										   FROM ProjectTaskPred__c where id =: projectId ])
				if( this.bList.size() < 1000 ){
					this.bList.add( pT );
					this.bMapPred.put( pT.Parent__c, pT );
					this.bMapParent.put( pT.Predecessor__c, pT );
				}
		}		
		
		public ProjectTaskPred__c get( Integer i ){
			return this.bList.get( i );
		}
		
		public ProjectTaskPred__c getByPredId( Id i ){
			return this.bMapPred.get( i );
		}
		
		public ProjectTaskPred__c getByParentId( Id i ){
			return this.bMapParent.get( i );
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
		
		public Integer size(){
			return this.bList.size();
		}
	}

}