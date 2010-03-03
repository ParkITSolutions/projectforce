/**
* @author Matias Menafra 
* @createdDate 1/15/2010
*/
public class Activity {
	
	public String modifiedBy	{ set; get; }
	public String changeType 	{ set; get; }
	public String action 		{ set; get; }
	public String message 		{ set; get; }
	public String imagePath		{ set; get; }
	public String header		{ set; get; }
	public DateTime timestamp;
	
	/**
	* Constructor
	*/
	public Activity(){
	
	}
	
	/**
	* Setter method for timestamp
	* @param value
	*/
	public void setTimestamp( Datetime value ){
		this.timestamp = value;
	}
	
	/**
	* Getter method for timestamp, includes date format
	* @return timestamp
	*/
	public String getTimestamp(){
		return this.timestamp.format('EEE, d MMM yyyy HH:mm');
	}
	
	/**
	* Method for setting the string containing the path to the action image to be displayed in the widget
	*/
	public void setImagePath(){
		
		if( this.changeType == 'Project_Name' || this.changeType == 'Project_Access' ){
			this.imagePath = 'document-new.png';
		}
		
		if( this.changeType == 'Member_Insert' || this.changeType == 'Member_Delete' ){
			if( this.action == 'insert' ){
				this.imagePath = 'add-user.png';
			}
			if( this.action == 'delete' ){
				this.imagePath = 'remove-user.png';
			}
		}
		
		if( this.changeType == 'Task_Insert' || this.changeType == 'Task_Delete' || this.changeType == 'Task_Name' || this.changeType == 'Task_Duration'  || this.changeType == 'Task_Complete' || this.changeType == 'Task_Status' ){
			if( this.action == 'insert' ){
				this.imagePath = 'ticket.png';
			}
			if( this.action == 'update' ){
				this.imagePath = 'ticket_edit.png';
			}
			if( this.action == 'delete' ){
				this.imagePath = 'ticket.png';
			}
		}
		
		if( this.changeType == 'TaskAssignee_Insert' || this.changeType == 'TaskAssignee_Delete' ){
			if( this.action == 'insert' ){
				this.imagePath = 'add-user.png';
			}	
			if( this.action == 'delete' ){
				this.imagePath = 'remove-user.png';
			}
		}
		
		if( this.changeType == 'TaskComment_Insert' || this.changeType == 'TaskComment_Delete' ){
			if( this.action == 'insert' ){
				this.imagePath = 'comments.png';
			}
			if( this.action == 'delete' ){
				this.imagePath = 'comments.png';
			}
		}
	}
	
	/**
	* Method for setting the activity header inside the widget. 
	*/
	public void setHeader(){
		
		if( this.changeType == 'Project_Name' || this.changeType == 'Project_Access' ){
			this.header = 'Project Updated';
		}
		
		if( this.changeType == 'Member_Insert' || this.changeType == 'Member_Delete' ){
			if( this.action == 'insert' ){
				this.header = 'Member Added';
			}
			if( action == 'delete' ){
				this.header = 'Member Removed';
			}
		}
		
		if( this.changeType == 'Task_Insert' || this.changeType == 'Task_Delete' || this.changeType == 'Task_Name' || this.changeType == 'Task_Duration'  || this.changeType == 'Task_Complete' || this.changeType == 'Task_Status' ){
			if( this.action == 'insert' ){
				this.header = 'Task Added';
			}
			if( this.action == 'update' ){
				this.header = 'Task Updated';
			}
			if( this.action == 'delete' ){
				this.header = 'Task Removed';
			}
		}
		
		if( this.changeType == 'TaskAssignee_Insert' || this.changeType == 'TaskAssignee_Delete' ){
			if( this.action == 'insert' ){
				this.header = 'Assignee Added';
			}	
			if( this.action == 'delete' ){
				this.header = 'Assignee Removed';
			}
		}
		
		if( this.changeType == 'TaskComment_Insert' || this.changeType == 'TaskComment_Delete' ){
			if( this.action == 'insert' ){
				this.header = 'Comment Added';
			}
			if( this.action == 'delete' ){
				this.header = 'Comment Removed';
			}
		}
	}
	
	/**
    * Test 
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		Activity activity = new Activity();
		
		activity.setTimestamp( Datetime.Now() );
		activity.getTimestamp();
		
		activity.action 	= '';
		activity.changeType = 'Project_Name';
		activity.setImagePath(); 
		activity.setHeader();
		System.assertEquals( 'document-new.png', activity.imagePath );
		System.assertEquals( 'Project Updated', activity.header );
		
		activity.action 	= 'insert';
		activity.changeType = 'Member_Insert';
		activity.setImagePath(); 
		activity.setHeader();
		System.assertEquals( 'add-user.png', activity.imagePath );
		System.assertEquals( 'Member Added', activity.header );
		
		activity.action 	= 'delete';
		activity.changeType = 'Member_Delete';
		activity.setImagePath(); 
		activity.setHeader();
		System.assertEquals( 'remove-user.png', activity.imagePath );
		System.assertEquals( 'Member Removed', activity.header );
		
		activity.action 	= 'insert';
		activity.changeType = 'Task_Insert';
		activity.setImagePath(); 
		activity.setHeader();
		System.assertEquals( 'ticket.png', activity.imagePath );
		System.assertEquals( 'Task Added', activity.header );
		
		activity.action 	= 'update';
		activity.changeType = 'Task_Insert';
		activity.setImagePath(); 
		activity.setHeader();
		System.assertEquals( 'ticket_edit.png', activity.imagePath );
		System.assertEquals( 'Task Updated', activity.header );
		
		activity.action 	= 'delete';
		activity.changeType = 'Task_Insert';
		activity.setImagePath(); 
		activity.setHeader();
		System.assertEquals( 'ticket.png', activity.imagePath );
		System.assertEquals( 'Task Removed', activity.header );
		
		activity.action 	= 'insert';
		activity.changeType = 'TaskAssignee_Insert';
		activity.setImagePath(); 
		activity.setHeader();
		System.assertEquals( 'add-user.png', activity.imagePath );
		System.assertEquals( 'Assignee Added', activity.header );
		
		activity.action 	= 'delete';
		activity.changeType = 'TaskAssignee_Delete';
		activity.setImagePath(); 
		activity.setHeader();
		System.assertEquals( 'remove-user.png', activity.imagePath );
		System.assertEquals( 'Assignee Removed', activity.header );
		
		activity.action 	= 'insert';
		activity.changeType = 'TaskComment_Insert';
		activity.setImagePath(); 
		activity.setHeader();
		System.assertEquals( 'comments.png', activity.imagePath );
		System.assertEquals( 'Comment Added', activity.header );
		
		activity.action 	= 'delete';
		activity.changeType = 'TaskComment_Delete';
		activity.setImagePath(); 
		activity.setHeader();
		System.assertEquals( 'comments.png', activity.imagePath );
		System.assertEquals( 'Comment Removed', activity.header );
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
}