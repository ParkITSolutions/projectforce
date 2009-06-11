/**
*@author Miguel Soares @ 04/14/2009
*/
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
	public static Integer MAX_SIZE = 4194304;
	public static Map<String,ProjectTask__c> BaseMap = new Map<String,ProjectTask__c>();
    public static Boolean DeleteTaskMailSent = false;
    public static Boolean flagAssignee = true;
    
    /**
    *@param Boolean
    */
    public static void setFlagAssignee( Boolean b){
    	ProjectUtil.flagAssignee = b;
    }
    
    /**
    *@return Boolean
    */
    public static Boolean getFlagAssignee(){
    	return ProjectUtil.flagAssignee;
    }
    
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
    *
    * Get the organization Domain
    */   
    public static String getDomain () {
        String domain = '';
        PageReference PR =  ApexPages.currentPage();
       
        String props = '';
        if(PR.getHeaders() != null){
            props = (PR.getHeaders()).get('Host');
        }
        if (props == '' || props == null) {
            domain = '';   
        }else {
            String [] path = props.split('</?[a-z][a-z0-9]*[^<>]*>');
            if(path.size() == 0){
                domain = path[0];
            }else{
                for(Integer i = 0; i < path.size(); i++){   
                    domain += path[i];
                }
            }
        }
        return domain;   
    }	
}