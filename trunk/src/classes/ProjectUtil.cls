public class ProjectUtil {

	public static Boolean isTest = false;
    
	public static void setIsTest( Boolean value ){
		ProjectUtil.isTest = value;
	}
	public static Boolean getIsTest(){
		return ProjectUtil.isTest;
	}
	
	public static Integer MAX_SIZE = 4194304;
	
	@future 
	public static void insertQueueSObjects (String projectQueueId, String projId ){
        
        // ### Allow SObjects to be managed by recently created queues ###
        List<QueueSobject> sobjectsQueueAllowed = new List<QueueSobject>();
        
        // Project Tasks - assignees
        QueueSobject allowAsignee = new QueueSobject(SobjectType = Schema.SObjectType.ProjectAssignee__c.getName() ,QueueId = projectQueueId);
        sobjectsQueueAllowed.add(allowAsignee);
        
        QueueSobject allowTasks = new QueueSobject(SobjectType = Schema.SObjectType.ProjectTask__c.getName() ,QueueId = projectQueueId);
        sobjectsQueueAllowed.add(allowTasks);
        
        QueueSobject allowProject = new QueueSobject(SobjectType = Schema.SObjectType.Project2__c.getName() ,QueueId = projectQueueId);
        sobjectsQueueAllowed.add(allowProject);
       
        QueueSobject allowProjectTaskPred = new QueueSobject(SobjectType = Schema.SObjectType.ProjectTaskPred__c.getName() ,QueueId = projectQueueId);
        sobjectsQueueAllowed.add(allowProjectTaskPred);
        
        QueueSobject allowProjectMembers = new QueueSobject(SobjectType = Schema.SObjectType.ProjectMember__c.getName() ,QueueId = projectQueueId);
        sobjectsQueueAllowed.add(allowProjectMembers);  
        
        // Insert all the allowed sobjects  
        insert sobjectsQueueAllowed;

		//
		ProjectUtil.upsertProjectOwner(projectQueueId, projId);

    }
    
	//@future
	public static void upsertProjectOwner (String projectQueueId, String projId){
		try{
			System.debug('tttt');
			//Upsert Team owner
		   	Project2__c tempProject = [select ownerId, Id, Name from Project2__c where Id =: projId limit 1];
		   	tempProject.ownerId = projectQueueId;
		   	// We set this to true becuase we dont want all the minifeed triggers and update 
		   	// triggers firing off when all we want to do is update the owner id.
		    update tempProject;
		}catch (Exception e){
			throw e;
		}
	}
	/*
	public static void aux(String projectQueueId, String projId){
		upsertProjectOwner(projectQueueId,projId);
		
	}
	*/
		
    
    /**
	* Return the Namespace Prefix
	*@return String
	*/
	public static String getNamespace () {
		String namespace = '';
        String fullName = Schema.SObjectType.Project2__c.getName();
        String localName = Schema.SObjectType.Project2__c.getLocalName();
        if (fullName != localName) {
           namespace = fullName.replaceAll(localName,'');
           namespace = namespace .replaceAll('__','');
        }
        return namespace;	
	}
	/**
	* Deletes a GroupMember record 
	*@param gmToDelete String that represents the id of the groupMember record to delete
	* Used at DiscussionForumAfterUpdate.trigger to avoid an Error
	* MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a non-setup object
	*/
	@future
	public static void deleteGroupMembers(List<String> gmToDelete){
	  	if( !ProjectUtil.getIsTest() ){
		    List<GroupMember> gm = [select UserOrGroupId, GroupId, id from GroupMember where id in : gmToDelete];
			delete gm;
	  	}
	}

	/**
	* Deletes a Group record 
	*@param grToDelete String that represents the id of the groupMember record to delete
	* Used at DiscussionForumAfterUpdate.trigger to avoid an Error
	* MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a non-setup object
	*/
	@future
	public static void deleteGroup(List<String> grToDelete){
	  	if( !ProjectUtil.getIsTest() ){
		    List<Group> gr = [select id from Group where id in : grToDelete];
			delete gr;
		}
	}
	
	/**
	* Validate file size for attachment list
	*@param List<Attachment> 
	*@return List<Integer> Indexes list with errors
	*/
	public static List<Integer> validateFileSize(List<Attachment> attachList){
		List<Integer> errorList = new List<Integer>();
		Integer iter = 1;
		for(Attachment att: attachList){
			if(att.BodyLength > MAX_SIZE){
				errorList.add(iter);
			}
			iter++;
		}
		return errorList;
	}
	
}