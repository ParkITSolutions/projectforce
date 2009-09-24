public Class BigListOfTasks{
	
		public static List<List<ProjectTask__c>> bList = new List<List<ProjectTask__c>>();
		
		public BigListOfTasks(String projectId){
			
			for( List<ProjectTask__c> ptList : [ select Id, Duration__c,Indent__c, DurationUI__c,  ParentTask__c, PercentCompleted__c,Project__c,  StartDate__c, EndDate__c, Milestone__c from ProjectTask__c where Project__c =: projectId ]){
				BigListOfTasks.bList.add(ptList); 
			}
		}

		public static void add( ProjectTask__c task, Integer ind ){
			
			if( bList[bList.size() - 1 ].size() < 200)
				bList[bList.size() - 1 ].add( task );
			else
				bList[bList.size()].add( task ); 
		}
		
		public static ProjectTask__c get( Integer ind ){
			return bList[  ind / 200 ][ ind - Math.mod( ind, 200 )*200];
		}

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
		
		public static List<ProjectTask__c> getByParentId( Id parentTaskId ){
	
			List<ProjectTask__c> r = new List<ProjectTask__c>();
			for( List<ProjectTask__c> ptList : bList )
				for(ProjectTask__c pt :ptList )
					if( pt.ParentTask__c == parentTaskId )
					r.add( pt );
			
			return r;
		}		
		
		
		public static Integer size(){
			
			Integer length = 0; 
			for( List<ProjectTask__c> ptList : bList )
				length =+ ptList.size();
				
			return length;
		}
}