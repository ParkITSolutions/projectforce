/**
*@author Matias Menafra 
*/
public class ProjectMember {

	public String id 			{ set; get; }
	public String profile 		{ set; get; }
	public String projectId 	{ set; get; }
	public String userId 		{ set; get; }
	public String username 		{ set; get; }
	public String name 			{ set; get; }
	public Date createdBy 		{ set; get; }
	public Boolean isAdmin		{ set; get; }
	public DateTime CreatedDate	{ set; get; }
	
	/**
	* Constructor
	*/
	public ProjectMember(){
	}
}