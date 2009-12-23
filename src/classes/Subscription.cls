/**
*@author Matias Menafra @ 12/18/2009
*/
public class Subscription {

	public String 	project 						{ set; get; }
	public Boolean 	ProjectMemberJoinLeave 			{ set; get; }
	public Boolean	ProjectTaskAssignedToMe 		{ set; get; }
	public Boolean 	ProjectTaskAssignToMeChanged 	{ set; get; }
	public Boolean 	ProjectTaskChanged 				{ set; get; }
	public Boolean 	ProjectTaskDeleted 				{ set; get; }
	public String 	UserId 							{ set; get; }
	
	/**
	* Constructor
	*/
	public Subscription(){
	
	}

}