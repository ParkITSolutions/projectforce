/**
*@author Miguel Soares @ 04/14/2009
*/
public class ProjectUtil {
	
	//Important enables minimized JS and CSS files for Production Release
	public static Boolean isProduction = false;
	
	public static Boolean currentlyExeTrigger = false;
	public static Boolean isRunnig = false;
	private static Project2__c proj = new Project2__c();
	private static Group g = new Group();	
	private static String projectQueueId = '';
	private static Boolean flag = false;
    private static List<Group> go = new List<Group>();
    private static List<Group> portalGroup = new List<Group>();           
    private static List<Group> partnerGroup = new List<Group>();
	public static Boolean isTest = false;
	public static Integer MAX_SIZE = 4194304;
	public static Map<String,ProjectTask__c> BaseMap = new Map<String,ProjectTask__c>();
    public static Boolean DeleteTaskMailSent = false;
    public static Boolean flagAssignee = true;
    public static Boolean flagValidationParentTask = true;
    public static Boolean parentTaskUpdateIndent = true;
    public static List<ProjectTask__c> childrenTaskToDelete = new List<ProjectTask__c>();
    public static Map<Id,ProjectTask__c> childrenTaskToDelete2 = new Map<Id,ProjectTask__c>();
    public static Boolean taskDependenciesFlag = true;
    public static Map<String, Boolean> flags = new Map<String, Boolean>(); 
    public static Boolean inFuture = false;
    public static	Map<String,Integer> daysMap = new Map<String,Integer>{'Mon' => 1, 'Tue' => 2, 'Wed' => 3, 'Thu' => 4, 'Fri' => 5, 'Sat' => 6, 'Sun' => 7 };
    
    public static Integer maxLongWord = 30;
	public static Integer maxLongPhrase = 128;	
	
    /* Default task values */
    private static String defaultTaskPriority = 'Medium';
    
    private static Double defaultTaskPercentCompleted = 0.0;
    
    /* End Default task values*/
    
	/* Default task values getters */
	public static String getDefaultTaskPriority(){
		return ProjectUtil.defaultTaskPriority;
	}
	
	public static Double getDefaultTaskPercentCompleted(){
		return ProjectUtil.defaultTaskPercentCompleted;
	}
	
	/* End Default task values getters */
	
    public static void setTaskDependenciesFlag(Boolean value){
    	ProjectUtil.taskDependenciesFlag = value;
    }
    
    
    public static Boolean getTaskDependenciesFlag(){
    	return ProjectUtil.taskDependenciesFlag;
    }
    
    
    public static void setFlagValidationParentTask(Boolean value){
    	ProjectUtil.flagValidationParentTask = value;
    }
    
    public static Boolean getFlagValidationParentTask(){
    	return ProjectUtil.flagValidationParentTask;
    }
    
    public static void setParentTaskUpdateIndent(Boolean value){
    	ProjectUtil.parentTaskUpdateIndent = value;
    }
    
    public static Boolean getParentTaskUpdateIndent(){
    	return ProjectUtil.parentTaskUpdateIndent;
    }
    
    /**
    *@param Boolean b
    *@return void 
    */
    public static void setFlagAssignee( Boolean b){
    	ProjectUtil.flagAssignee = b;
    }
    
    /**
    *@return Boolean
    */
    public static Boolean getFlagAssignee(){
    	return ProjectUtil.flagAssignee;
    }
    
	/**
	*@param boolean value
	*@return void 
	*/
	public static void setisRunnig( Boolean value ){
		ProjectUtil.isRunnig = value;
	}

	/**
	*@return Boolean
	*/
	public static Boolean getisRunnig(){
		return ProjectUtil.isRunnig;
	}
	
	/*
	*@param boolean value
	*@return void 
	*/
	public static void setIsTest( Boolean value ){
		ProjectUtil.isTest = value;
	}
	public static Boolean getIsTest(){
		return ProjectUtil.isTest;
	}
    
    
    /**
	* Return the Namespace Prefix
	*@return String
	*/
	public static String getNamespace () {
		String namespace = '';
        String fullName = Schema.SObjectType.Project2__c.getName();
        String localName = Schema.SObjectType.Project2__c.getLocalName();
        if (fullName != localName) {
           namespace = fullName.replaceAll(localName,'');
           namespace = namespace .replaceAll('__','');
        }
        return namespace;	
	}
	
	/**
	* Deletes a GroupMember record 
	*@param gmToDelete String that represents the id of the groupMember record to delete
	* Used at DiscussionForumAfterUpdate.trigger to avoid an Error
	* MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a non-setup object
	*@return void 
	*/
	@future
	public static void deleteGroupMembers(List<String> gmToDelete){
	  	if( !ProjectUtil.getIsTest() ){
		    List<GroupMember> gm = [select UserOrGroupId, GroupId, id 
		    							from GroupMember 
		    							where GroupId in : gmToDelete OR id in: gmToDelete ];
			delete gm;
	  	}
	}

	/**
	* Deletes a Group record 
	*@param grToDelete String that represents the id of the groupMember record to delete
	* Used at DiscussionForumAfterUpdate.trigger to avoid an Error
	* MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a non-setup object
	*@return void 
	*/
	//@future
	public static void deleteGroup(List<String> grToDelete){
	  	if( !ProjectUtil.getIsTest() ){
		    List<Group> gr = [select id from Group where name in : grToDelete];
			delete gr;
		}
	}
	
	/**
	* Validate file size for attachment list
	*@param List<Attachment> attachList
	*@return List<Integer> Indexes list with errors
	*/
	public static List<Integer> validateFileSize(List<Attachment> attachList){
		List<Integer> errorList = new List<Integer>();
		Integer iter = 1;
		for(Attachment att: attachList){
			if(att.BodyLength > MAX_SIZE){
				errorList.add(iter);
			}
			iter++;
		}
		return errorList;
	}
	
	/**
    * Get the organization Domain
    *@return String 
    */   
    public static String getDomain () {
        String domain = '';
        PageReference PR =  ApexPages.currentPage();
       
        String props = '';
        if(PR.getHeaders() != null){
            props = (PR.getHeaders()).get('Host');
        }
        if (props == '' || props == null) {
            domain = '';   
        }else {
            String [] path = props.split('</?[a-z][a-z0-9]*[^<>]*>');
            if(path.size() == 0){
                domain = path[0];
            }else{
                for(Integer i = 0; i < path.size(); i++){   
                    domain += path[i];
                }
            }
        }
        return domain;   
    }
    
    public static String getUrl(){
    	return 'https://'+getDomain();
    }
     
	public static Map<String, String> taskDescription( ProjectTask__c task ){ 
		Map<String, String> maping = new Map<String, String>();
		
		maping.put( 'id', task.Id );
		maping.put( 'project', task.Project__c );
		maping.put( 'name', task.Name );
		maping.put( 'description', task.Description__c );
		maping.put( 'endDate', task.EndDate__c.format() );
		maping.put( 'startDate', task.StartDate__c.format() );
		maping.put( 'priority', task.Priority__c );		
		
		return maping;
	}    
	
	
	/**
    *@return String
    */
    public static String joinStrListByToken( List<String> listToJoin, String token ){
 		String joinedStr = '';
 		Integer listSize = listToJoin.size();
 		
		if( listSize > 0 ){ 	
	 		for( Integer k = 0; k < listSize - 1; k++ )
	 			joinedStr += listToJoin[ k ] + token;
	 			
			joinedStr += listToJoin[ listSize - 1 ];
		}
		
		return joinedStr;
 		   	
    }
    
	public static String chopWord( String word ){
		if( word != null && word.length() > ProjectUtil.maxLongWord )
			return word.substring( 0, ProjectUtil.maxLongWord -1 ) + '...';
			
		return word;
	}
    
    
	public static String chopWords( String words ){
    	return ProjectUtil.chopWords( words, ProjectUtil.maxLongWord );
    }
    public static String chopWords( String words, Integer len ){
    	String strToReturn = '';
    	if( words != null && words.length() > 0 ){
	    	List<String> listOfWords = new List<String>();
	    	listOfWords = words.split( ' ' );
	    	
	    	for( Integer k = 0; k < listOfWords.size(); k++ )
	    		if( listOfWords[ k ].length() > len )
	    			listOfWords[ k ] = listOfWords[ k ].substring( 0, len ) + '.';
	    			
	    	strToReturn = ProjectUtil.joinStrListByToken( listOfWords, ' ' );
    	}
    	
    	return strToReturn;
    }
    
    public static String chopPhrase( String phrase ){
    	return ProjectUtil.chopPhrase( phrase, ProjectUtil.maxLongPhrase );
    }
    
    public static String chopPhrase( String phrase, Integer len ){
    	
    	List<String> cPhrase = new List<String>();
    	String rPhrase = '';
    	if( phrase != null ){
	    	if( phrase.length() > len ){
		    	cPhrase = phrase.substring( 0, len ).split( ' ' );

		    	rPhrase = ProjectUtil.joinStrListByToken( cPhrase, ' ' ) + '...';
	    	}else
	    		rPhrase = phrase;
    	}
    	return rPhrase;
    }
    
    public static String chopPhraseTo30Chs( String w ){
    	return ProjectUtil.chopPhraseTo30Chs( w, ProjectUtil.maxLongWord );
	}    
	
	public static String chopPhraseTo30Chs( String w, Integer c ){
    	if( w != null && w.length() > c )
    		return w.substring( 0, c ) + '...';
    	else 
    		return w;
    	
    }    
    
    public  static Set<String> objOfSetTolowerCase( Set<String> s ){
    	Set<String> auxSet = new Set<String>();
    	for( String  e : s)
    		auxSet.add( e.toLowercase());
    		
    	return auxSet;
    } 
    
    public static Integer isWorkingDayThisDay( Date day , Integer workingDays ){
    	System.debug( '#### dia : ' + Datetime.valueOf( day + '00:00:00').format( 'EEE' ) +  ' wd ' + workingDays );
    	return ProjectUtil.daysMap.get(Datetime.valueOf( day + '00:00:00').format( 'EEE' )) <= workingDays ? 1 : 0;
    	
    }
    
    /**
    *@author Miguel Soares de Lima and Nicolas Dominguez
    */
    public static Integer calulateDurationUntilBigCrash( Date startDate, Date endDate, Integer workingDays ){
    	
    	Integer daysBetween;
    	if( endDate == null ){
    		endDate = startDate;
    	}
    	
    	daysBetween = startDate.daysBetween( endDate ) + 1;
    	Integer quotient = daysBetween / 7;
    	Integer rest = Math.mod( daysBetween, 7 );
    	Integer duration = 0;
    	Date dateAux;
    	
    	duration = quotient * workingDays;    	
    	for( Integer k = 0; k < rest; k++ ){
    		dateAux = endDate;
    		duration += ProjectUtil.isWorkingDayThisDay( dateAux.addDays( -k ), workingDays );
    	}	
    	return duration;
    }
    
    public static Date calculateEndDateWithEndDateAndDuration( Date startDate, Integer wdays, Integer days ){
    
    	if( days == 1 )
    		return startDate;
    
    	Integer totalDays =  ( days / wdays ) * 7;
    	Date endDateCalculated = startDate;    		
	   	Date dateAux = endDateCalculated;
    	Integer restDays = Math.mod( days, wdays );
    	
    	//////////////////////////////
    	//D/W == 0
    	if( totalDays == 0){
	 		if( restDays != 0){
		    	dateAux = endDateCalculated;
		    	Integer k = 0;
		    	for( k = 1; k <= restDays && 1 == ProjectUtil.isWorkingDayThisDay( dateAux.addDays( k-1 ), wdays ); k ++ ){
		    		if (k!=1)
		    			endDateCalculated = endDateCalculated.addDays( 1 );
		    		System.debug( ':::> dentrooo - ' + endDateCalculated + '  , k ='+ k);
		    	}
		    	
		    	System.debug('\n :::> ' + (7 - wdays + 1 + restDays - k) );
System.debug(':::>   if( 0 == '+ProjectUtil.isWorkingDayThisDay( dateAux.addDays( k-1 ), wdays )+'   && k <= '+restDays +'), k='+k);
		    	if( 0 == ProjectUtil.isWorkingDayThisDay( dateAux.addDays( k-1 ), wdays ) && k <= restDays ){
		    		System.debug('\n :::> DENTRO FOR ' + (7 - wdays + 1 + restDays - k) );
					endDateCalculated = endDateCalculated.addDays(7 - wdays + 1 + restDays - k );
			    	System.debug( ':::> mas adelante' + endDateCalculated );
		    	}
	 		}    	
	 		
	 		return endDateCalculated;
	 			
    	}
    	
    	///////////////////////////////
    	//D/W != 0
    	if( totalDays != 0){
    		endDateCalculated = startDate.addDays( totalDays -1 );
			//System.debug( '###> Totaldays : ' + totalDays + ' > enddate ' +endDateCalculated );
	    	
	    	if( 0 == ProjectUtil.isWorkingDayThisDay( endDateCalculated, wdays ))
	    		endDateCalculated = endDateCalculated.addDays( wdays - 7 );
			//System.debug( '###> Totaldays : ' + totalDays + ' > enddate ' +endDateCalculated );
    	} 
	    	
    	
    	
 		if( restDays != 0){
	    	dateAux = endDateCalculated;
	    	Integer k = 0;
	    	for( k = 1; k <= restDays && 1 == ProjectUtil.isWorkingDayThisDay( dateAux.addDays( k ), wdays ); k ++ ){
	    		//System.debug( '#for: k ' + k );
	    		endDateCalculated = endDateCalculated.addDays( 1 );
	    	}
				
	    	 
	    	if( 0 == ProjectUtil.isWorkingDayThisDay( dateAux.addDays( k ), wdays ) && k <= restDays ){
	    		//System.debug( '#if: k ' + k );
				endDateCalculated = endDateCalculated.addDays(7 - wdays + 1 + restDays - k );
	    	}
 		}
			
			
		return endDateCalculated;
    }
    
 	
}