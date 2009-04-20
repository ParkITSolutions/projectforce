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
		
	// Map with action=>PageReference
	private Map<String, PageReference> searchIn = new Map<String, PageReference>{
		'project' => Page.ProjectSearchResult
	};
		
	/**
	* Redirect to the specific result
	*@return PageReference
	*/
	public PageReference searchKey(){
		
		if(this.module != null && this.module != ''){
			PageReference pageRef = searchIn.get(module);
			pageRef.getParameters().put('key', this.key);
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
	*@param String action
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
	*@param String
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
	*@param String
	*/
	public void setTeamId(String id){
		this.teamId = id;
	}
	
	/**
	* Get value of label
	*@return String label
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
	* @param String
	*/
	public void setLabelName(String s){
		this.labelName = s;
	}
	
	/**
	* Get value of default input field value
	* @return String text
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
}