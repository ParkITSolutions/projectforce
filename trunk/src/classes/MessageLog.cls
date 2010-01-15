/**
* @author Matias Menafra 1/11/2010
*/
public class MessageLog {
	
	/**
	* Constructor
	*/
	public MessageLog(){
	}
	
	/**
	* Method in charge of retrieving the message log for each activity
	* @param sObject activity
	* @return String
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
	*
	* @param ProjectActivity__c activity
	* @return String
	*/
	private String messageProject( ProjectActivity__c activity ){
		
		String msg = '';
		
		if( activity.ChangeType__c == 1 ){
			msg = '';
		}
		
		if( activity.ChangeType__c == 2 ){
			msg = '';
		}
		
		return msg;
	}
	
	/**
	*
	* @param TaskActivity__c activity
	* @return String
	*/
	private String messageTask( TaskActivity__c activity ){
		
		String msg = '';
		
		if( activity.ChangeType__c == 1 ){
			msg = '';
		}
		
		if( activity.ChangeType__c == 2 ){
			msg = '';
		}
		
		if( activity.ChangeType__c == 1 ){
			msg = '';
		}
		
		if( activity.ChangeType__c == 2 ){
			msg = '';
		}
		
		return msg;
	}
	
	/**
	*
	* @param TaskAssigneeActivity__c activity
	* @return String
	*/
	private String messageAssignee( TaskAssigneeActivity__c activity ){
		
		String msg = '';
		
		if( activity.ChangeType__c == 1 ){
			msg = '';
		}
		
		if( activity.ChangeType__c == 2 ){
			msg = '';
		}
		
		return msg;
	}
	
	/**
	*
	* @param TaskCommentActivity__c activity
	* @return String
	*/
	private String messageTaskComment( TaskCommentActivity__c activity ){
		
		String msg = '';
		
		if( activity.ChangeType__c == 1 ){
			msg = '';
		}
		
		if( activity.ChangeType__c == 2 ){
			msg = '';
		}
		
		return msg;
	}
	
	/**
	*
	* @param MemberActivity__c activity
	* @return String
	*/
	private String messageMember( MemberActivity__c activity ){
		String msg = '';
		
		if( activity.ChangeType__c == 1 ){
			msg = '';
		}
		
		if( activity.ChangeType__c == 2 ){
			msg = '';
		}
		
		return msg;
	}
	
	/**
	*
	* @param 
	* @return String
	*/
	private String messageAttachment(){
		return '';
	}
}