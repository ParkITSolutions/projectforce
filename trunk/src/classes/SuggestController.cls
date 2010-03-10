/**
* @author Matias Menafra 
* @createdDate 04/05/2008
*/
//TODO pasar consultas al DAO
public with Sharing class SuggestController {

	public List<Suggestions> suggestionList { set; get; }
	public List<String> selectedMembers 	{ get; set; }
	public String paramInput;
	public String paramClass;
	public String paramProjectId;
	
	/**
	* Constructor
	*/
	public SuggestController(){
		
		String inputValue 		= System.currentPageReference().getParameters().get( 'input' ).trim();
		
		this.suggestionList 	= new List<Suggestions>();
		this.selectedMembers 	= new List<String>();
		this.paramInput 		= '%' + inputValue + '%';
		this.paramClass 		= System.currentPageReference().getParameters().get( 'class' );		
		this.paramProjectId 	= System.currentPageReference().getParameters().get( 'teamId' );
		this.selectedMembers	= System.currentPageReference().getParameters().get( 'selectedMembers' ).split(',');
		
		if ( this.paramClass == 'Competency' ){
			List<ProjectMember__c> s = [select User__r.Name, Id 
											from ProjectMember__c 
											where Name like: this.paramInput];
			
			for( ProjectMember__c c : s ){
				Suggestions suggest = new Suggestions();
				
				suggest.Name 	= c.User__r.Name;
				suggest.Id 		= c.Id;
				
				suggestionList.add( suggest );				
			}
		}	

		if ( this.paramClass == 'colleagueNames' ){
			
			Map<Id, ProjectMember__c> teamMemberMap = new Map<Id, ProjectMember__c>();
			for ( ProjectMember__c iterMember : [select Id, User__c 
													from ProjectMember__c 
													where Project__c =: this.paramProjectId]) {
				teamMemberMap.put(iterMember.User__c, iterMember );
			} 
			
			for( User c : [select Name, Id from User where IsActive != false and Name like : this.paramInput and Name not in: selectedMembers  order by Name] ){
				if ( teamMemberMap.get( c.Id ) == null ) {
					
					Suggestions suggest = new Suggestions();
					
					suggest.Name 	= c.Name;
					suggest.Id 		= c.Id;
					
					suggestionList.add( suggest );
				}				
			}
		}
	}
	
	/**
	* Inner class for Suggestion's type
	* @class
	*/
	public class Suggestions {
		
		public String Name 	{ set; get; }
		public String Id	{ set; get; }
		
	}
	
	/**
    * Test Suggest Controller 
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		System.currentPageReference().getParameters().put( 'class', 'Competency' );
		System.currentPageReference().getParameters().put( 'teamId', GenerateEnvironmentTest.project.Id );
		System.currentPageReference().getParameters().put( 'input', 'member' );
		System.currentPageReference().getParameters().put( 'selectedMembers', 'member' );
		SuggestController suggest = new SuggestController();
		
		System.currentPageReference().getParameters().put( 'class', 'colleagueNames' );
		System.currentPageReference().getParameters().put( 'teamId', GenerateEnvironmentTest.project.Id );
		System.currentPageReference().getParameters().put( 'input', 'member' );
		System.currentPageReference().getParameters().put( 'selectedMembers', 'member' );
		suggest = new SuggestController();
		
		System.currentPageReference().getParameters().put( 'class', 'colleagueNames' );
		System.currentPageReference().getParameters().put( 'teamId', GenerateEnvironmentTest.project.Id );
		System.currentPageReference().getParameters().put( 'input', '' );
		System.currentPageReference().getParameters().put( 'selectedMembers', '' );
		suggest = new SuggestController();
				
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }	    
}