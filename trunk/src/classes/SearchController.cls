/**
* @author Matias Menafra
*/
public with Sharing class SearchController{
	
	public String labelName; 
	public String module 					{ set; get; }
	public String key 						{ set; get; }
	public String projectId 				{ set; get; }
	public String defaultText 				{ set; get; }
	public boolean isProperQueryLength 		{ set; get; }
	
	/**
	* Constructor
	*/
	public SearchController(){
		
		this.projectId 		= System.currentPageReference().getParameters().get( 'id' );
		this.defaultText 	= getDefaultText();	
		
		if( System.currentPageReference().getParameters().get( 'key' ) != null ){
			this.key = System.currentPageReference().getParameters().get( 'key' );
		}
		else{
			this.key = getDefaultText();	
		}
		
		this.isProperQueryLength = true;					
	}
	
	/**
	* Gets value for the label
	* @return String
	*/ 
	public String getLabelName(){
		
		if( System.currentPageReference().getParameters().get( 'id' ) == null ){
			return 'Projects';
		}
		else{
			return 'Tasks';
		}
	}
	
	/**
	* Sets the value for the label
	* @param value
	*/
	public void setLabelName( String value ){
		this.labelName = value;
	}
	
	/**
	* Gets value of default input field value
	* @return defaultText 
	*/
	public String getDefaultText(){
		
		if( this.getLabelName() == 'Projects' ){
			this.defaultText = 'Enter Project name...';
			return this.defaultText;
		}
		else{
			this.defaultText = 'Enter Task name...';
			return this.defaultText;
		}
	}
		
	/**
	* Performs validation on search term
	* Redirect results page
	* @return PageReference
	*/
	public PageReference searchKey(){
		
		this.isProperQueryLength = true;
		
		if( this.key.length() < 2 ){
			
			this.isProperQueryLength = false;
			
			PageReference pageRef = Page.projectOverview;
			pageRef.setRedirect( true );
						
			return pageRef;
		}
		
		if( this.module != null && this.module != '' && this.key != null ){
			
			PageReference pageRef = Page.SearchResults;
			pageRef.getParameters().put( 'key', this.key );
			
			if( this.projectId != null || this.projectId != '' ){
				pageRef.getParameters().put( 'id', this.projectId) ;
			}
			
			pageRef.setRedirect( true );	
					
			return pageRef;
						
		}else {
			
			return null;
		}
	}
	
	/**
    * Test Search Controller
    */
    public static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		Test.setCurrentPageReference( new PageReference( 'Page.ProjectDetail' ) );
		
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
		System.currentPageReference().getParameters().put( 'key', 'Project open' );
		
		SearchController search = new SearchController();
		
		search.setLabelName( 'Projects' );
		search.getLabelName();
		search.getDefaultText();
		
		search.setLabelName( 'Tasks' );
		search.getLabelName();
		search.getDefaultText();
		
		System.currentPageReference().getParameters().put( 'id', null );
		System.currentPageReference().getParameters().put( 'key', null );
		
		search = new SearchController();
		
		search.setLabelName( 'Projects' );
		search.getDefaultText();
		
		search.setLabelName( 'Tasks' );
		search.getDefaultText();
		
		System.currentPageReference().getParameters().put( 'id', '' );
		System.currentPageReference().getParameters().put( 'key', 'Project open' );
		search = new SearchController();
		search.module = 'module';
		search.searchKey();
		
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
		System.currentPageReference().getParameters().put( 'key', 'Project open' );
		search = new SearchController();
		search.module = 'module';
		search.searchKey();
		
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
		System.currentPageReference().getParameters().put( 'key', 'p' );
		search = new SearchController();
		search.module = 'module';
		search.searchKey();
		
		System.currentPageReference().getParameters().put( 'id', null );
		System.currentPageReference().getParameters().put( 'key', null );
		search = new SearchController();
		search.searchKey();
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
}