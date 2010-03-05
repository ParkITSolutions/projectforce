/**
* @author Matias Menafra
* @createdDate 02/02/2010
*/
public with sharing class SearchResultsController{
	
	public String searchTerm	{ set; get; }
	public String projectId		{ set; get; }
	private String namespace	{ set; get; }
	public Paginator paginator 	{ set; get; }
	
	public List<SearchResults> searchResultList { set; get; }
   	
	/**
	* Constructor
	*/
	public SearchResultsController(){
		
		this.searchTerm 		= System.currentPageReference().getParameters().get( 'key' );
		this.projectId 			= System.currentPageReference().getParameters().get( 'id' );
		this.namespace 			= ( ProjectUtil.getNamespace() != '' ) ? ProjectUtil.getNamespace() + '__' : '';	
		this.searchResultList 	= new List<SearchResults>();
		
		//Initialization of Paginator for search Results
		this.paginator 				= new Paginator();
		this.paginator.project.id 	= this.projectId;
	}	
	
	/**
	* Makes the search against Projects or Tasks 
	* Populates a List of type SearchResults
	*/
	public void search(){
		
		//TODO correct decoding for special characters
		this.searchTerm = this.searchTerm.replaceAll( 'cde38;', '&' );
		this.searchTerm = this.searchTerm.replaceAll( 'cde37;', '%' );
		this.searchTerm = this.searchTerm.replaceAll( 'cde35;', '#' );	
	
 		if( this.projectId != null ){ 
 			paginator.loadTaskSearchResults( this.searchTerm, this.namespace );
		}
		else{
			paginator.loadProjectSearchResults( this.searchTerm, this.namespace );
		}
	}
	
	/**
    * Test Search Results Controller
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		Test.setCurrentPageReference( new PageReference( 'Page.SearchResults' ) );
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
		System.currentPageReference().getParameters().put( 'key', 'Project' );

		SearchResultsController searchResults = new SearchResultsController();
		searchResults.search();
		
		System.currentPageReference().getParameters().put( 'id', null );
		System.currentPageReference().getParameters().put( 'key', '' );

		searchResults = new SearchResultsController();
		searchResults.search();
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
}