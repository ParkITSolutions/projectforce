/**
* @author Matias Menafra 
* @createdDate 1/11/2010
*/
public class MessageLog {
	
	/**
	* Constructor
	*/
	public MessageLog(){
	}
	
	/**
	* Method in charge of retrieving the message log for each activity
	* @param activity
	* @return message
	*/
	public String getMessage( sObject activity ){
		
		String message = '';
		
		if( activity instanceOf ProjectActivity__c ){
			ProjectActivity__c obj = ( ProjectActivity__c )activity;
			message = this.messageProject( obj );
		}
		
		if( activity instanceOf MemberActivity__c ){
			MemberActivity__c obj = ( MemberActivity__c )activity;
			message = this.messageMember( obj );
		}
		
		if( activity instanceOf TaskActivity__c ){
			TaskActivity__c obj = ( TaskActivity__c )activity;
			message = this.messageTask( obj );
		}
		
		if( activity instanceOf TaskAssigneeActivity__c ){
			TaskAssigneeActivity__c obj = ( TaskAssigneeActivity__c )activity;
			message = this.messageAssignee(obj);
		}
		
		if( activity instanceOf TaskCommentActivity__c ){
			TaskCommentActivity__c obj = ( TaskCommentActivity__c )activity;
			message = this.messageTaskComment( obj );
		}
		/*
		if(activity instanceOf AttachmentActivity__c){
		
		}
		*/
		
		return message;
	}
	
	/**
	* Method for generating specific messages for the Project logs
	* @param activity
	* @return msg
	*/
	private String messageProject( ProjectActivity__c activity ){
		
		String msg = '';
		
		if( activity.ChangeType__c == 'Project_Name' ){
			msg = 'Projects Name has changed to ' + activity.name__c;
		}
		
		if( activity.ChangeType__c == 'Project_Access' ){
			msg = 'Projects Access level has changed to '+ activity.Access__c;
		}
		
		return msg;
	}
	
	/**
	* Method for generating specific messages for the Task logs
	* @param activity
	* @return msg
	*/
	private String messageTask( TaskActivity__c activity ){
		
		String msg = '';
		
		if( activity.ChangeType__c == 'Task_Insert' ){
			msg = activity.NewName__c + ' has been added to Project';
		}
		
		if( activity.ChangeType__c == 'Task_Delete' ){
			msg = activity.NewName__c + ' has been removed from Project';
		}
		
		if( activity.ChangeType__c == 'Task_Name' ){
			msg = 'Task ' + ProjectUtil.chopPhrase( activity.Name, 30 ) + ' has been renamed to ' + ProjectUtil.chopPhrase( activity.NewName__c, 30 );
		}
		
		if( activity.ChangeType__c == 'Task_Duration' ){
			msg = 'Tasks ' + activity.NewName__c + ' duration changed to ' + activity.Duration__c;
		}
		
		if( activity.ChangeType__c == 'Task_Complete' ){
			msg = 'Task ' + activity.NewName__c + ' completed';
		}
		
		if( activity.ChangeType__c == 'Task_Status' ){
			msg = 'Tasks ' + activity.NewName__c + ' status changed to ' + activity.Status__c;
		}
		
		return msg;
	}
	
	/**
	* Method for generating specific messages for the Task Assignee logs
	* @param activity
	* @return msg
	*/
	private String messageAssignee( TaskAssigneeActivity__c activity ){
		
		String msg = '';
		
		if( activity.ChangeType__c == 'TaskAssignee_Insert' ){
			msg = activity.AssigneeName__c + ' has been assigned to Task ' + ProjectUtil.chopPhrase( activity.TaskName__c, 30 );
		}
		
		if( activity.ChangeType__c == 'TaskAssignee_Delete' ){
			msg = activity.AssigneeName__c + ' has been removed from Task ' + ProjectUtil.chopPhrase( activity.TaskName__c, 30 );
		}
		
		return msg;
	}
	
	/**
	* Method for generating specific messages for the Task Comment logs
	* @param activity
	* @return msg
	*/
	private String messageTaskComment( TaskCommentActivity__c activity ){
		
		String msg = '';
		
		if( activity.ChangeType__c == 'TaskComment_Insert' ){
			msg = 'Comment added to Task ' + ProjectUtil.chopPhrase( activity.TaskName__c, 30 );
		}
		
		if( activity.ChangeType__c == 'TaskComment_Delete' ){
			msg = 'Comment removed from Task ' + ProjectUtil.chopPhrase( activity.TaskName__c, 30 );
		}
		
		return msg;
	}
	
	/**
	* Method for generating specific messages for the Member logs
	* @param activity
	* @return msg
	*/
	private String messageMember( MemberActivity__c activity ){
		String msg = '';
		
		if( activity.ChangeType__c == 'Member_Insert' ){
			msg = activity.MemberName__c + ' has been added to Project';
		}
		
		if( activity.ChangeType__c == 'Member_Delete' ){
			msg = activity.MemberName__c + ' has been removed  from Project';
		}
		
		return msg;
	}
	
	/**
	* Method for generating specific messages for the Attachment logs
	* @param 
	* @return String
	*/
	private String messageAttachment(){
		return '';
	}
	
	/**
    * Test 
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		Test.setCurrentPageReference(new PageReference('Page.ProjectDetail'));
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );

		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
}