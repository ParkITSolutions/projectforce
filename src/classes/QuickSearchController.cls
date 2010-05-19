public with sharing class QuickSearchController {
	
	public String error {set; get;}
	public String taskCustomID { set; get;}
	
	public PageReference action(){
	
		PageReference pR = null;
		
		if( this.taskCustomID.trim() != '' ){		
			List<ProjectTask__c> taskSearched = new List<ProjectTask__c>();
			String localCustomTaskID = this.taskCustomID.contains('#') ? this.taskCustomID : '#' + this.taskCustomID;
			taskSearched = [ SELECT id FROM ProjectTask__c WHERE id__c =: localCustomTaskID.trim() LIMIT 1 ];
			
			if( taskSearched.size() == 1 )
				pR = new PageReference( '/' + taskSearched[ 0 ].id );
			else
				this.error = 'No task found witn this custom ID: ' + this.taskCustomID;
		}else{
			this.error = 'Inser a task custom ID.';
		}
		return pR;
	}
	
    public static testMethod void test(){
    
		GenerateEnvironmentTest.gen();
		
		QuickSearchController qS = new QuickSearchController();
		
    	Test.startTest();    
    	
    	ProjectTask__c pT = [ SELECT id__c FROM ProjectTask__c WHERE id =: GenerateEnvironmentTest.task2.id ]; 
    
    	qS.taskCustomID = '';
    	qS.action();
    	System.assertEquals(qS.error, 'Inser a task custom ID.');
    	
    	qS.taskCustomID = 'invaldID';
    	qS.action();
    	System.assertEquals(qS.error, 'No task found witn this custom ID: ' + 'invaldID');
    	
    	qS.taskCustomID = pT.id__c;
    	PageReference pR = qS.action();
    	System.assert( pR != null, 'Error: no task found but a task must be founded.');
		System.assert( pR.getURL().contains( GenerateEnvironmentTest.task2.id ), 'Error: no task found but a task must be founded.');
		
		Test.stopTest();		 
    
    }	
}