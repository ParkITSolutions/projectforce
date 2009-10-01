/**
*@author Matias Menafra - Sept 23 2009
*/
public Class BigListOfTasks{
		//List which will contain all tasks for a given project
		public static List<List<ProjectTask__c>> bList = new List<List<ProjectTask__c>>();
		
		/**
		* Class Constructor
		* @param String param
		*/
		public BigListOfTasks(String param){
			if( param.toLowerCase().contains('select') && param.toLowerCase().contains('from'))
				for( List<ProjectTask__c> ptList : Database.query( param ))
				BigListOfTasks.bList.add(ptList);			
			else
				for( List<ProjectTask__c> ptList : [ select Id, Name, Duration__c,Indent__c, DurationUI__c,  ParentTask__c, PercentCompleted__c,Project__c,  StartDate__c, EndDate__c, Milestone__c from ProjectTask__c where Project__c =: param ])
				BigListOfTasks.bList.add(ptList); 
		}
	
		/**
		* adds a task to the list of tasks
		* @param ProjectTask__c task
		* @return void
		*/
		public static void add( ProjectTask__c task){
			
			if( bList[bList.size() - 1 ].size() < 200)
				bList[bList.size() - 1 ].add( task );
			else
				bList[bList.size()].add( task ); 
		}
		
		/**
		* method for returning a element inside the list by index value
		* @param Integer ind
		* @return ProjectTask__c
		*/
		public static ProjectTask__c get( Integer ind ){
			return bList[  ind / 200 ][ ind - Math.mod( ind, 200 )*200];
		}
		
		/**
		* Replaces a task withing teh task list by Task Id
		* @param ProjectTask__c newTask
		* @return void
		*/
		public static void setById( ProjectTask__c newTask ){
			Integer count = 0;
			for( List<ProjectTask__c> ptList : bList ){
				count = 0;
				for(ProjectTask__c pt :ptList ){
					if( pt.id == newTask.id ){
						ptList[ count ] = newTask;
						break;
						break;
					}	
					count++;
				}
			}
		}
		
		/**
		* Method which returns a task by ID
		* @param Id taskId
		* @return ProjectTask__c
		*/
		public static ProjectTask__c getById( Id taskId ){			
			ProjectTask__c ret = new ProjectTask__c();
			for( List<ProjectTask__c> ptList : bList ){
				for(ProjectTask__c pt :ptList ){
					if( pt.id == taskId ){
						ret =  pt;
						break;
						break;
					}	
				}
			}
			
			return ret;
		}		
		
		/**
		* Method returns a lista children from a parent tasks ID
		* @param Id parentTaskId
		* @return List<ProjectTask__c> 
		*/
		public static List<ProjectTask__c> getByParentId( Id parentTaskId ){
	
			List<ProjectTask__c> r = new List<ProjectTask__c>();
			for( List<ProjectTask__c> ptList : bList )
				for(ProjectTask__c pt :ptList )
					if( pt.ParentTask__c == parentTaskId )
					r.add( pt );
			
			return r;
		}		
		
		/**
		* Method which returns the count of elements withing the big list of tasks
		* @return Integer
		*/
		public static Integer size(){
			
			Integer length = 0; 
			for( List<ProjectTask__c> ptList : bList )
				length =+ ptList.size();
				
			return length;
		}
}