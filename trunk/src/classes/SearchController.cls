/**
*@author Alvaro Scuccimarra @ 03/16/2009
*/
public class SearchController {
	
	// Parameter with action
	private String module = null;
	// Parameter with search string
	private String key = null;
	// Parameter for seach in team
	private String teamId = System.currentPageReference().getParameters().get('id');
	// Text of search label
	private String labelName = null;
	// Default input field text value
	private String defText = '';
	
	private boolean isCriteriaLengthProperly = true;
	
	// Map with action=>PageReference
	private Map<String, PageReference> searchIn = new Map<String, PageReference>{
		'project' => Page.ProjectSearchResult
	};
	
	/**
	*@param String mod
	*@return void
	*/
	public void setModule(String mod){
		this.module = mod;
	}
	
	/**
	*@return String
	*/
	public String getModule(){
		return this.module;
	}
	
	/**
	*@return String
	*/
	public String getKey(){
		return this.key;
	}
	
	/**
	*@param String k
	*@return void
	*/
	public void setKey(String k){
		this.key = k;
	}
	
	/**
	*@return String
	*/
	public String getTeamId(){
		return this.teamId;
	}
	
	/**
	*@param String id
	*@return void
	*/
	public void setTeamId(String id){
		this.teamId = id;
	}
	
	/**
	* Get value of label
	*@return String
	*/ 
	public String getLabelName(){
		if(System.currentPageReference().getParameters().get('id') == null){
			return 'Projects';
		}
		else{
			return 'Tasks';
		}
	}
	
	/**
	* Set value of label
	*@param String s
	*@return void
	*/
	public void setLabelName(String s){
		this.labelName = s;
	}
	
	/**
	* Get value of default input field value
	* @return String 
	*/
	public String getDefaultText(){
		if(this.getLabelName() == 'Projects'){
			this.defText = 'Enter Project name...';
			return this.defText;
		}
		else{
			this.defText = 'Enter Task name...';
			return this.defText;
		}
	}
		
	/**
	* Redirect to the specific result
	*@return PageReference
	*/
	public PageReference searchKey(){
		
		isCriteriaLengthProperly = true;
		
		if(this.key.length() < 2){
			
			isCriteriaLengthProperly = false;
			
			PageReference pageRef = Page.projectOverview;
			pageRef.setRedirect(true);			
			return pageRef;
		}
		
		if(this.module != null && this.module != '' && this.key != null ){
			PageReference pageRef = searchIn.get(module);
			pageRef.getParameters().put('key', this.key );
			if(this.teamId != null || this.teamId != ''){
				pageRef.getParameters().put('id', this.teamId);
			}
			pageRef.setRedirect(true);			
			return pageRef;
			
		}else {
			return null;
		}
	}
	
	/**
	*@return boolean
	*/	
	public boolean getIsCriteriaLengthProperly() {
			
		return isCriteriaLengthProperly;
	}
}