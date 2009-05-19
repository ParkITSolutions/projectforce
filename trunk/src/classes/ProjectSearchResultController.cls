/**
*@author Nicolas Gunther - 04/13/2009
*/
public with sharing class ProjectSearchResultController {
	
	public String criteria;
	public Integer totalItemsNumber = 0;
	public Boolean noMatches;
	public String teamId;
	public List<SearchResult> searchResultList = new List<SearchResult>();
	public List<ProjectTask__c> resultsProjectTask = new List<ProjectTask__c>();
	public List<Project2__c> resultsProjectSearch = new List<Project2__c>();
	   	
   	// Set of Integers to control pagination
   	public Integer numberOfItemsToShow = 10;
   	public Integer cntPagination;
   	public Integer currentPagination = 1;
   	public Integer firstRow = 0;
   	
   	// Set of Booleans to show or not prev / next links
   	public boolean prevPageLinkShow = false;
   	public boolean prevPageShow  = false;
   	public boolean nextPageLinkShow  = false;
   	public boolean nextPageShow  = false;
   	public Integer jumpPage = 1;
   	
	/**
	* Load 'key' parameter
	*@Constructor
	*/
	public ProjectSearchResultController(){
		criteria = System.currentPageReference().getParameters().get('key');
		teamId = System.currentPageReference().getParameters().get('id');
	}	
	
	/**
	*@return String
	*/
	public String getCriteria () {
		return criteria;
	}
	
	/**
	*@param String
	*/
	public void setCriteria (String criteria) {
		this.criteria = criteria;
	}
	
	/**
	*@return Integer
	*/
	public Integer getTotalItemsNumber () {
		return totalItemsNumber;
	}
	
	/**
	*@return Boolean
	*/	
	public Boolean getNoMatches () {
		return noMatches;	
	}	
	/**
	*@param String teamId
	*/
	public void setTeamId (String team){
		teamId = team;
	}
	
	/**
	*@return String teamId
	*/
	public String getTeamId () {
		return teamId;
	}		
	
	/**
	*@return List<SearchResult>
	*/	
	public List<SearchResult> getSearchResultList () {
		return searchResultList;
	}
	
	/**
	* Makes the search
	*@void
	*/
	public void search() {
		
		List<SearchResult> tempResultList = new List<SearchResult>();	
		String namespace = (ProjectUtil.getNamespace() != '' ) ? ProjectUtil.getNamespace() + '__' : '';		

		System.debug( '#>' + teamId );

 		if(teamId != null){ //Searching project TASKS	
		System.debug( '2#>' + teamId );

			String sosl = 'FIND \'' + criteria + '*\' IN ALL FIELDS RETURNING ' + namespace + 'ProjectTask__c (Id, Name, Description__c, Project__c where Project__c = \'' + teamId + '\')';
			List<List<SObject>> resultList = search.query(sosl);
			resultsProjectTask = (List<ProjectTask__c>) resultList[0];
			
			// PARSE THE PROJECT TASK RESULT LIST
			for(ProjectTask__c iter: resultsProjectTask){
				SearchResult currentResult = new SearchResult();
				
				currentResult.setName(iter.Name, criteria);
				currentResult.setRealName(iter.Name);
				currentResult.setId(iter.Id);
				currentResult.setResultType('Project Task');
				currentResult.setMatches(iter.Description__c, criteria);
				
				tempResultList.add(currentResult);
			}
		}else{
			List<List<SObject>> resultList = search.query('FIND \'' + criteria + '*\' IN ALL FIELDS RETURNING ' + namespace + 'Project2__c (Id, Name, Description__c)');
			resultsProjectSearch = (List<Project2__c>) resultList[0];
			
			// PARSE THE Projects RESULT LIST
			for(Project2__c iter: resultsProjectSearch){
				SearchResult currentResult = new SearchResult();
				
				currentResult.setName(iter.Name, criteria);
				currentResult.setRealName(iter.Name);
				currentResult.setId(iter.Id);
				currentResult.setResultType('Project');
				currentResult.setMatches(iter.Description__c, criteria);
				
				tempResultList.add(currentResult);
			}
			
		}

		// ORDER THE MULTI OBJECT RESULT BY NAME
		Integer n;
 		Integer i;
 		Integer j;
 		n = tempResultList.size() - 1;	
 		
 		for (i = 1; i <= n; i++) {	
 			for (j = n; j >= i ; j--) {
 				if (tempResultList.get(j).realName <= tempResultList.get(j - 1).realName) {
 					SearchResult tempResult = new SearchResult();
 					tempResult = tempResultList.get(j - 1);
 					tempResultList.set(j - 1, tempResultList.get(j));
 					tempResultList.set(j, tempResult); 	
 				}
 			}
 		}
 		
		searchResultList = tempResultList;
		totalItemsNumber = searchResultList.size();
		if (totalItemsNumber == 0 ) {
			noMatches = true;
			cntPagination = 0;	
			firstRow = 0;
			currentPagination = 1;
			jumpPage = 1;
		}else {
			noMatches = false;
			firstRow = 0;
			currentPagination = 1;
			jumpPage = 1;
			genCntPagination();	
		}
		
	}
	

   	/**
   	* Count number of result pages
   	*@void
   	*/
   	public void genCntPagination () {
   		cntPagination = (totalItemsNumber - (Math.mod(totalItemsNumber, numberOfItemsToShow))) / numberOfItemsToShow;	
   		if (Math.mod(totalItemsNumber, numberOfItemsToShow) != 0 ) {
   			cntPagination++;
   		}
   	}
   	
   	/**
   	* Go next result page
   	*/
   	public void nextPage () {
   		currentPagination++;
   		jumpPage = currentPagination;
   		firstRow = firstRow + numberOfItemsToShow;   		
   	}
   	
   	/**
   	* Go previus result page
   	*/
   	public void prevPage () {
   		currentPagination--;
   		jumpPage = currentPagination;
   		firstRow = firstRow - numberOfItemsToShow;	
   	}

	/**
   	* Go last result page
   	*/
   	public void lastPage () {
   		currentPagination = cntPagination;
		jumpPage = cntPagination;
		firstRow = (jumpPage - 1)* numberOfItemsToShow;		
   	}
   	
   	/**
   	* Go first result page
   	*/
   	public void firstPage () {
   		currentPagination = 1;
   		jumpPage = 1;
   		firstRow = (jumpPage - 1)* numberOfItemsToShow;	
   	}
	
	/**
	* Empty function for refresh result list
	*/
   	public void refreshPages () {
   		
   	}
   	
   	/**
   	* Pagination Integer Getters
   	*@return Integer
   	*/
   	public Integer getFirstItem () {
		return (firstRow + 1);
	}
	
	/**
	* Assign a number to the last page's result
	*@return Integer
	*/
	public Integer getLastItem () {
		Integer lastItem;
		if ((currentPagination == cntPagination) || (currentPagination == 1 && (totalItemsNumber < numberOfItemsToShow))) {
			lastItem = firstRow + Math.mod(totalItemsNumber, numberOfItemsToShow);
		}else {
			lastItem = firstRow + 10;
		}
		return lastItem;
	}
   	
   	/**
   	* Return current page number
   	*@return Integer
   	*/
   	public Integer getCurrentPagination () {
   		return currentPagination;
   	}
   	
   	/**
   	* Return number of result pages
   	*@return Integer
   	*/
   	public Integer getCntPagination () {
   		return cntPagination;
   	}
   	
   	/**
   	* Return number of results
   	*@return Integer
   	*/
   	public Integer getNumberOfItemsToShow () {
   		return numberOfItemsToShow;
   	}
   	
   	/**
   	* Return the number of the first item of page
   	*@return Integer
   	*/
   	public Integer getFirstRow () {
   		return firstRow;
   	}
   	
   	/**
   	* Return if show Prev Link
   	*@return boolean
   	*/
	public boolean getPrevPageLinkShow () {
		if(currentPagination == 1){ prevPageLinkShow = false;		
		} else {prevPageLinkShow = true;}
		
   		return prevPageLinkShow;
   	}
   	
   	/**
   	* Return if show Prev Link
   	*@return boolean
   	*/
   	public boolean getPrevPageShow () {
   		if(currentPagination == 1){	
   			prevPageShow = true; 
   		} else {
   			prevPageShow = false;
   		}
   		return prevPageShow;
   	}
   	
   	/**
   	* Return if show Next Link
   	*@return boolean
   	*/
   	public boolean getNextPageLinkShow () {
   		if((currentPagination == cntPagination) || (cntPagination == 0)){	
   			nextPageLinkShow = false; 
		} else { 
			nextPageLinkShow = true;
		}   		
   		return nextPageLinkShow;
   	}
   	
   	/**
   	* Return if show Next Link
   	*@return boolean
   	*/
   	public boolean getNextPageShow () {
   		if((currentPagination == cntPagination) || (cntPagination == 0)){ 
   			nextPageShow = true; 
		} else { 
			nextPageShow = false;
		} 
   		return nextPageShow;
   	}	
   	
	
	
	
	/**
	* Jump to page
	*@return Integer jumpPage
	*/   
	public Integer getJumpPage () {
		return jumpPage;
	}
	
    /**
    * Set jumpo to page
    *@param Integer jumpPage
    */
	public void setJumpPage (Integer jumpPage) {
		this.jumpPage = jumpPage;
	}
	
    /**
    * Jump to page
    */
	public void JumpToPage () {
		if (jumpPage > cntPagination) {
			currentPagination = cntPagination;
			jumpPage = cntPagination;
		}else {
			if (jumpPage < 1) {
				currentPagination = 1;
				jumpPage = 1;
			}else {	
				currentPagination = jumpPage;
			}
		}
		firstRow = (jumpPage - 1)* numberOfItemsToShow;
	}
	
	/**
	*@return String ID
	*/
	public String getCurrentUser () {
		return UserInfo.getUserId();
	}
	
	/**
	* Inner class for SearchResult type
	*@class
	*/
	public class SearchResult {
		String name;
		String matches;
		Id id;
		String resultType;
		String realName;
		
		/**
		*@param Id id
		*/
		public void setId (Id id) {
			this.id = id;
		}
		
		/**
		* Apply hightlight class to searched string
		*@param String name
		*@param String criteria
		*/
		public void setName (String name, String criteria) {
			String highlight = '';
			if (name != null) {
			
				String nameLow = name.toLowerCase();
				String criteriaLow = criteria.toLowerCase();
				
				if (criteria != null && criteria != '' && nameLow.indexOf(criteriaLow) != -1) {
					highlight = name.replaceAll('(?i)' + criteria, '<span class="highlight">$0</span>');
				}else{
					highlight = name;
				}
			}
			this.name = highlight;	
		}	
		
		/**
		* Make a result's string, highlight the matches and show the context of resultant string
		*@param String matches
		*@param String criteria
		*/
		public void setMatches (String matches, String criteria) {
			String highlight = '';
			Integer maxLength = 50;
			if (matches != null) {
				String matchesLow = matches.toLowerCase();
				String criteriaLow = criteria.toLowerCase();
				matches = matches.replaceAll('(?i)<[^>]*>', '');
				if (criteria != null && criteria != '' && matchesLow.indexOf(criteriaLow) != -1) {
					Integer msjLength = matches.length();
					Integer iniHighLight = matchesLow.indexOf(criteriaLow) - 50;
					Integer criteriaLength = criteria.length();
					Integer endHighLight = matchesLow.indexOf(criteriaLow) + criteriaLength + 50;
					if (iniHighLight < 0) {
						if (endHighLight > msjLength) {
							highlight = matches.substring(0,msjLength);	
						}else {
							highlight = matches.substring(0,endHighLight) + '...';	
						}
					}else {
						if (endHighLight > msjLength) {
							highlight = '...' + matches.substring(iniHighLight,msjLength);	
						}else {
							highlight = '...' + matches.substring(iniHighLight,endHighLight) + '...';	
						}		
					}
					
					highlight = highlight.replaceAll('(?i)' + criteria, '<span class="highlight">$0</span>');
				}else {
					if(matches.length() <= maxLength*2) {
						highlight = matches;	
					}else {
						
						highlight = matches.substring(0,maxLength*2) + '...';	
					}	
				}
			}
			this.matches = highlight;
		}
		
		/**
		*@param String Type
		*/
		public void setResultType (String resultType) {
			this.resultType = resultType;	
		}
		
		/**
		*@param String Name
		*/
		public void setRealName (String realName) {
			this.realName = realName;
		}
		
		/**
		*@return Id
		*/	
		public Id getId () {
			return id;
		}
		
		/**
		*@return String
		*/
		public String getResultType () {
			return resultType;
		}
		
		/**
		*@return String
		*/
		public String getMatches () {
			return matches;
		}
		
		/**
		*@return String
		*/
		public String getName () {
			return name; 
		}	
		
		/**
		*@return String
		*/	
		public String getRealName () {
			return realName;
		}	
			
	}
}