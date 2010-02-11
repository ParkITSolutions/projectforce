/**
* @author Andres Canavesi
* @createdDate 02/08/2010
*/
public class MembersListController {
	
	public List<ProjectMember> 	member;	
	public String projectId 			{ set; get; }
	public String url 					{ set; get; }
	public Project project 				{ set; get; }
	public Project exceptionMessage 	{ set; get; }
	public Paginator paginator 			{ set; get; }
	
	/**
	* Constructor
	*/
	public MembersListController(){
		
		this.member 	= new List<ProjectMember>();
		this.projectId 	= System.currentPageReference().getParameters().get( 'id' );
		
		if( this.projectId == null || this.projectId == '' ){
			throw new CustomException('There is not a project selected');
		}
		
		this.project 	= new Project( this.projectId );
		this.url 		= ProjectUtil.getUrl();
		
		this.paginator 	= new Paginator();
		this.paginator.orderBy 		= 'name';
		this.paginator.orderAsc 	= true;
		this.paginator.project.id 	= this.projectId;
		
		paginator.loadMembersByProject();
	}
	
	/**
	* @return options the filter options
	*/
	public List<SelectOption> getFilterItems() {
		
		List<SelectOption> options = new List<SelectOption>();
		
		options.add(new SelectOption( '1','All' ) );
		options.add(new SelectOption( '2','All members' ) );
		options.add(new SelectOption( '3','All administrators' ) );
		
		return options;
	}
}