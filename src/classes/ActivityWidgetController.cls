/**
* @author Matias Menafra 
* @createdDate 1/15/2010
*/
public class ActivityWidgetController {
	
	public String 			projectId 		{ set; get; }
	private MessageLog 		messageObj; 			
	private List<Activity> 	resultActivities; 
	
	/**
	* Constructor
	*/
	public ActivityWidgetController(){
		
		this.messageObj 		= new MessageLog();
		this.resultActivities 	= new List<Activity>();
		
		//call to method for getting and parsing all activities for a project
		this.parseActivities();
	}
	
	/**
	* Method which collects the latest 10 project activities and parses them.
	*/
	public void parseActivities(){
		
		List<Activity__c> allActivities = new List<Activity__c>();
		allActivities = DAOFactory.getInstance().getActivityForProjectWidget( this.projectId );
		
		for( Activity__c row : allActivities ){
			
			Activity auxActivity = new Activity();
			
			auxActivity.modifiedBy 	= row.ModifiedBy__c;
			auxActivity.action 		= row.Action__c;
			auxActivity.timestamp	= row.TimeStamp__c;
			
			if (row.ProjectActivities__r.size() != 0 ){
				auxActivity.changeType 	= row.ProjectActivities__r[0].ChangeType__c;
				auxActivity.message 	= this.messageObj.getMessage( row.ProjectActivities__r[0] );
			}
			
			if( row.MemberActivities__r.size() != 0 ){
				auxActivity.changeType 	= row.MemberActivities__r[0].ChangeType__c;
				auxActivity.message 	= this.messageObj.getMessage( row.MemberActivities__r[0] );
			}
			
			if( row.TaskActivites__r.size() != 0 ){
				auxActivity.changeType 	= row.TaskActivites__r[0].ChangeType__c;
				auxActivity.message 	= this.messageObj.getMessage( row.TaskActivites__r[0] );
			}
			
			if( row.TaskAssigneeActivites__r.size() != 0 ){
				auxActivity.changeType 	= row.TaskAssigneeActivites__r[0].ChangeType__c;
				auxActivity.message 	= this.messageObj.getMessage( row.TaskAssigneeActivites__r[0] );
			}
			
			if(row.TaskCommentActivites__r.size() != 0 ){
				auxActivity.changeType 	= row.TaskCommentActivites__r[0].ChangeType__c;
				auxActivity.message 	= this.messageObj.getMessage( row.TaskCommentActivites__r[0] );
			}
			
			auxActivity.setImagePath();
			auxActivity.setHeader();
			
			this.resultActivities.add( auxActivity );
		}
	}
	
	/**
	* Getter for returning the list with the 10 latest activities for the widget.
	* @return resultActivities
	*/
	public List<Activity> getResultActivities(){
		return this.resultActivities;
	}
	
	/**
    * Test 
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
}