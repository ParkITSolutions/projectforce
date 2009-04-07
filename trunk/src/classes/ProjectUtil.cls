public class ProjectUtil {

	public static Boolean currentlyExeTrigger = false;
	public static Boolean isRunnig = false;
	private static Project2__c proj = new Project2__c();
	private static Group g = new Group();	
	private static String projectQueueId = '';
	private static Boolean flag = false;
    private static List<Group> go = new List<Group>();
    private static List<Group> portalGroup = new List<Group>();           
    private static List<Group> partnerGroup = new List<Group>();
	public static Boolean isTest = false;
	
    
	/**
	*@param boolean
	*/
	public static void setisRunnig( Boolean value ){
		ProjectUtil.isRunnig = value;
	}

	/**
	*@return Boolean
	*/
	public static Boolean getisRunnig(){
		return ProjectUtil.isRunnig;
	}
	
	public static void setIsTest( Boolean value ){
		ProjectUtil.isTest = value;
	}
	public static Boolean getIsTest(){
		return ProjectUtil.isTest;
	}
	
	public static Integer MAX_SIZE = 4194304;
	
	@future 
	public static void insertQueueSObjects ( String pQId, String Id ){
        

        // ### Allow SObjects to be managed by recently created queues ###
        List<QueueSobject> sobjectsQueueAllowed = new List<QueueSobject>();
        
        // Project Tasks - assignees
        QueueSobject allowAsignee = new QueueSobject(SobjectType = Schema.SObjectType.ProjectAssignee__c.getName() ,QueueId = pQId);
        sobjectsQueueAllowed.add(allowAsignee);
        
        QueueSobject allowTasks = new QueueSobject(SobjectType = Schema.SObjectType.ProjectTask__c.getName() ,QueueId = pQId);
        sobjectsQueueAllowed.add(allowTasks);
        
        QueueSobject allowProject = new QueueSobject(SobjectType = Schema.SObjectType.Project2__c.getName() ,QueueId = pQId);
        sobjectsQueueAllowed.add(allowProject);
       
        QueueSobject allowProjectTaskPred = new QueueSobject(SobjectType = Schema.SObjectType.ProjectTaskPred__c.getName() ,QueueId = pQId);
        sobjectsQueueAllowed.add(allowProjectTaskPred);
        
        QueueSobject allowProjectMembers = new QueueSobject(SobjectType = Schema.SObjectType.ProjectMember__c.getName() ,QueueId = pQId);
        sobjectsQueueAllowed.add(allowProjectMembers);  
        
        // Insert all the allowed sobjects  
        //Database.SaveResult[] lsr = Database.insert(sobjectsQueueAllowed);
		upsert sobjectsQueueAllowed;
		
                
    }
    
	public static void upsertProjectOwner (  String pQId, String Id ){
		try{
			//Upsert Team owner
		   	Project2__c tempProject = [select ownerId, Id, Name from Project2__c where Id =: Id limit 1];
		   	tempProject.ownerId = pQId;
		   	// We set this to true becuase we dont want all the minifeed triggers and update 
		   	// triggers firing off when all we want to do is update the owner id.
		    update tempProject;
		}catch (Exception e){
			throw e;
		}
	}	
    
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
	
	/**
	*@param Strign
	*/
    @future public static void sOType1( String projId ){

		proj = [ SELECT Id, PublicProfile__c, NewMemberProfile__c FROM Project2__c WHERE Id =: projId ];
			
		go = [ select g.Type, g.Name from Group g where Type = 'Organization' ];

        //Customer Portal Group            
        if(ProjectCreateNewProjectController.getAllowCustomerStatic()) 
        portalGroup = [ Select g.Type, g.Name from Group g where Type = 'AllCustomerPortal' ];
	           
        //Partner Portal Group
        if(ProjectCreateNewProjectController.getAllowPartnerStatic())
        partnerGroup = [ Select g.Type, g.Name from Group g where Type = 'PRMOrganization' ];

		// Group List To Insert.
		List<Group> newGroups = new List<Group>();
		
		// Create Sharing Group for current Team.		
		g.Name = 'projectSharing' + proj.Id;
		insert g;
		
		if(proj.PublicProfile__c != null || proj.NewMemberProfile__c != null){
            GroupMember gm = new GroupMember();
            gm.GroupId = g.Id;
            gm.UserOrGroupId = go[0].Id;
            insert gm;
            
            //If Customer Portal group exist a to GroupMember
            if(portalGroup.size() > 0){
                GroupMember gmPortal = new GroupMember();
                gmPortal.GroupId = g.Id;
                gmPortal.UserOrGroupId = portalGroup[0].Id;
                insert gmPortal;
            } 
                                     
			//If Partner Portal group exist add GroupMember
			if(partnerGroup.size() > 0 ){
				GroupMember gmPortal = new GroupMember(); 
                gmPortal.GroupId = g.Id;
                gmPortal.UserOrGroupId = partnerGroup[0].Id;
                insert gmPortal;
			}
        }  
        			
		/* ### Create Queues ###*/
		// Create Project Queue
		Group gdqproj = new Group();
		gdqproj.Type = 'Queue';
		gdqproj.Name = 'Project' + proj.Id;
		insert gdqproj;
		
		projectQueueId = gdqproj.id;
		
		ProjectUtil.insertQueueSObjects( projectQueueId, projId );
		sOType2( projId, g.Id, projectQueueId );
		
    }             			

	/**
	*
	*/
    public static void sOType2( String projectId, String groupId, String pQId ){
    	
		ProjectUtil.upsertProjectOwner( pQId, projectId );

		// Create __Shared object for team
		Project2__Share projectS = new Project2__Share();
		projectS.ParentId = projectId;
		projectS.UserOrGroupId = groupId;
	    projectS.AccessLevel = 'Read';
	    projectS.RowCause = 'Manual';
	    insert projectS;			    	    
		
		// Create the first project member (the founder)
		
		ProjectProfile__c defaultProfile = [select Id from ProjectProfile__c where Name = 'Project Administrator' limit 1];
		ProjectMember__c firstProjectMember = new ProjectMember__c();
		firstProjectMember.User__c = Userinfo.getUserId();
		firstProjectMember.Name = UserInfo.getName();
		firstProjectMember.Project__c = projectId;
		firstProjectMember.Profile__c = defaultProfile.Id;
		insert firstProjectMember;
		
    }
}