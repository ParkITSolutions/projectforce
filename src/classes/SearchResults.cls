/**
* @author Matias Menafra
* @createdDate 02/02/2010
*/
public class SearchResults {
	
	public String name;
	public String matches;
	public Boolean  isProduction 	{ set; get; }
	public Id     id				{ set; get; }
	public String resultType		{ set; get; }
	public String realName			{ set; get; }
	public String url				{ set; get; }
		
	/**
	* Constructor
	*/
	public SearchResults(){
		this.isProduction = ProjectUtil.isProduction;
	}
	
	/**
	* Apply hightlight class to searched string
	* @param name
	* @param criteria
	*/
	public void setName( String name, String criteria ){
		
		String highlight = '';
		if( name != null ){
		
			String nameLow 		= name.toLowerCase();
			String criteriaLow 	= criteria.toLowerCase();
			
			if( criteria != null && criteria != '' && nameLow.indexOf( criteriaLow ) != -1 ){
				highlight = name.replaceAll( '(?i)' + criteria, '<span class="highlight">$0</span>' );
			}
			else{
				highlight = name;
			}
		}
		
		this.name = highlight;	
	}	
	
	/**
	* Make a result's string, highlight the matches and show the context of resultant string
	* @param matches
	* @param criteria
	*/
	public void setMatches( String matches, String criteria ){
		
		String highlight 	= '';
		Integer maxLength 	= 50;
		
		if( matches != null ){
			
			String matchesLow 	= matches.toLowerCase();
			String criteriaLow 	= criteria.toLowerCase();
			matches = matches.replaceAll( '(?i)<[^>]*>', '' );
			
			if( criteria != null && criteria != '' && matchesLow.indexOf( criteriaLow ) != -1 ){
				Integer msjLength 		= matches.length();
				Integer iniHighLight 	= matchesLow.indexOf( criteriaLow ) - 50;
				Integer criteriaLength 	= criteria.length();
				Integer endHighLight 	= matchesLow.indexOf( criteriaLow ) + criteriaLength + 50;
				
				if( iniHighLight < 0 ){
					if( endHighLight > msjLength ){
						highlight = matches.substring( 0,msjLength );	
					}
					else{
						highlight = matches.substring( 0,endHighLight ) + '...';	
					}
				}
				else{
					if ( endHighLight > msjLength ) {
						highlight = '...' + matches.substring( iniHighLight, msjLength );	
					}else {
						highlight = '...' + matches.substring( iniHighLight, endHighLight ) + '...';	
					}		
				}
				
				highlight = highlight.replaceAll( '(?i)' + criteria, '<span class="highlight">$0</span>' );
			}else{
				if( matches.length() <= maxLength * 2 ){
					highlight = matches;	
				}
				else{
					highlight = matches.substring( 0,maxLength * 2 ) + '...';	
				}	
			}
		}
		
		this.matches = highlight;
	}
	
	/**
	*
	*@return String
	*/
	public String getMatches(){
		return matches;
	}
	
	/**
	*
	*@return String
	*/
	public String getName(){
		return name; 
	}	
	
	/**
	*
	*@return String
	*/	
	public String getRealName(){
		return realName;
	}
	
	/**
    * Test Search Result Page
    */
    public static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		Test.setCurrentPageReference( new PageReference( 'Page.SearchResults' ) );
		
		SearchResults searchRes = new SearchResults();
		
		searchRes.setName( '', '' );
		searchRes.setMatches( '', '' );
		
		searchRes.setName( 'proj', 'proj' );
		searchRes.setName( 'proj', '' );
		searchRes.setMatches( 'proj', 'proj' );
		
		searchRes.getMatches();
		searchRes.getName();
		searchRes.getRealName();
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }	
}