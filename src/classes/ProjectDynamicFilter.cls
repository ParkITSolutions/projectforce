public class ProjectDynamicFilter {

	private Boolean loadingFilter = false;
	private Id projectId = System.currentPageReference().getParameters().get('id');
	private String filterName;
	public List<SFField> fieldList = new List<SFField>();


	/*
	* Constructor
	*/
	public ProjectDynamicFilter(){}
	
	
	
	/*
	*  
	*@return List<SFField>
	*/
	public List<SFField> getFieldList(){
		
		if( this.fieldList == null || this.fieldList.size() == 0)
			this.genSalesforceFields();
		
		if( this.loadingFilter )
			this.loadFilter();
				
		return this.fieldList;
	}
	
	/**
	*
	*/
	public Boolean getLoadingFilter(){
		return this.loadingFilter;
	}

	/**
	*
	*/
	public void setFilterName( String fName ){
		this.filterName = fName;
	}
	
	/**
	*
	*/
	public String getFilterName(){
		return this.filterName;
	}
	
	/**
	*
	*/
	public Id getProjectId(){
		return this.projectId;
	}

	/**
	*
	*/
	public void setLoadingFilter( Boolean v ){
		this.loadingFilter = v;
	}
	
	/*
	*@param List<SFField> lst
	*@return void
	*/
	public void setFieldList( List<SFField> lst ){
		this.fieldList = lst;
	}
	
	/**
	*@param Schema.DescribeFieldResult pickListField
	*@return List<SelectOption>
	*/
	private List<SelectOption> genPicklistValues(Schema.DescribeFieldResult pickListField){
		List<SelectOption> relationshipOptions = new List<SelectOption>();
       	relationshipOptions.add(new SelectOption('', '-- Any --'));
       	for (Schema.PicklistEntry iter : pickListField.getPicklistValues()) 
      		relationshipOptions.add(new SelectOption(iter.getValue(), iter.getLabel()));
       	
       	return relationShipOptions;
   	}

	/**
	* Generate Salesforce Fields
	*@return void
	*/
	private void genSalesforceFields() {
		Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
		Schema.DescribeSObjectResult descRes;
		Map<String, Schema.SObjectField> fieldMap;

		descRes = schemaMap.get('ProjectTask__c').getDescribe();
		fieldMap = descRes.fields.getMap();
		Schema.DescribeFieldResult fldDescRes;
		List<Schema.PicklistEntry> pickValList;
		String tempStr,currFldName;

		List<SFField> picklists  = new List<SFField>();
		List<SFField> checkboxes = new List<SFField>();
		List<SFField> others     = new List<SFField>();
		// Add to this set the field who can't be shown
		Set<String>   outFields  = new Set<String>{ 'IsExpanded', 'System Modstamp', 'Deleted', 'Id', 'Record ID', 'TaskPosition', 'TaskSyncId', 'Last Modified Date', 'Indent', 'Duration Display', 'RawDuration'  };  
		
		fieldList = new List<SFField>();
	   	for (String fldName: fieldMap.keySet()) {
	    	SFField newField = new SFField();
	    	fldDescRes = fieldMap.get(fldName).getDescribe();
	    	newField.name = fldDescRes.getName();
	    	newField.fieldType = fldDescRes.getType().name().replaceAll('Schema.fieldtype.','');
	    	newField.label = fldDescRes.getLabel(); 
	    	
	    	if (newField.fieldType.toLowerCase() == 'picklist'){
	    		newField.options = genPicklistValues(fldDescRes);
	    		picklists.add( newField );
	    	}	
	    	else if (  newField.fieldType.toLowerCase() == 'boolean' ){
	    		checkboxes.add( newField );
	    	}
	    	else if (  newField.fieldType.toLowerCase() != 'reference' && newField.fieldType.toLowerCase() != 'textarea'){
	    		others.add( newField );
	    	}
		}

		// Add assignees
    	SFField newField = new SFField();
    	newField.options = getAssignees();
    	newField.name = 'assignee';


		Integer count = 0;
		for( SFField ssf: picklists){
			if( !outFields.contains(ssf.label)){
				ssf.index = count;
				this.fieldList.add( ssf );
				count++;
			}
		}
		for( SFField ssf: checkboxes ){
			if( !outFields.contains(ssf.label)){
				ssf.index = count;
				this.fieldList.add( ssf );
				count++;
			}
		}
		for( SFField ssf: others){
			if( !outFields.contains(ssf.label)){
				ssf.index = count;
				this.fieldList.add( ssf );
				count++;
			}
		}

	}
	
	/*
	* 
	*/
	public String genStrWithFieldsName(){
		String fieldsName = '';
		List<String> auxDateStr = new List<String>();
		
		for( SFField f : this.fieldList ){
			if( f.name != 'assignee' && f.value != null && f.value != '' && f.value != 'false' ){
				System.debug( '*_***' + f.name +':' + f.fieldType);
				if( f.fieldType.toLowercase() == 'date' ){
					//auxDateStr = f.value.split( '/', 0 );
					fieldsName += ' AND ' + f.name + ' = ' + f.value;//+ auxDateStr[2] + '-' + auxDateStr[0] + '-' + auxDateStr[1];
				}else if(f.fieldType.toLowercase() == 'datetime'){
					String foo = f.value + 'T' + '00:00:00Z';
					fieldsName += ' AND ' + f.name + ' = ' + foo;
				}
				else if( f.fieldType == 'BOOLEAN' ) 
					fieldsName += ' AND ' + f.name + ' = ' + f.value + ' ';
				else if( f.fieldType == 'PERCENT' )
					fieldsName += ' AND ' + f.name + ' = ' + f.value + ' ';
				else if( f.fieldType == 'TEXTAREA' )
					fieldsName += ' AND (' + f.name + ' LIKE \'%' + f.value + '%\') ';
				else 
					fieldsName += ' AND ' + f.name + ' = \'' + f.value + '\' ';
			}
		}
		return fieldsName;
	}
	/**
	* Save the current filter values
	*/
	public void saveFilter(){
		String fieldToSave  = ''; 
		String filterToSave = '';
		for( SFField f : this.fieldList ){ 
			if( f.value != null && f.value != ''){
				fieldToSave = f.name + '::' + f.fieldType + '::' + f.value;
				filterToSave += fieldToSave + '#';
			}
		}
		List<ProjectFilter__c> filter = new List<ProjectFilter__c>();
		filter = [ select id, filter__c from ProjectFilter__c where Project__c =: this.projectId and Name =: this.getFilterName() ];
		if( filter.size() > 0 ){
			filter[0].filter__c = filterToSave;
			update filter;
		}else{
			ProjectFilter__c newFilter = new ProjectFilter__c();
			newFilter.filter__c = filterToSave;
			newFilter.name = this.getFilterName();
			newFilter.project__c = this.projectId;
			insert newFilter;
		}
	}
	/**
	*Load filter values for a filter
	*@param Id projectId, Id filterId
	*/
	public void loadFilter(){
		List<ProjectFilter__c> filter = new List<ProjectFilter__c>();
		filter = [ select id, filter__c from ProjectFilter__c where Project__c =: projectId and Id =: getFilterName()  ];
		this.loadingFilter = true;		
		
		if( filter.size() > 0 ){
			
			// Parser
			List<String> fields = new List<String>();
			fields  = filter[0].filter__c.split( '#' );
			List<String> tempVals = new List<String>();
			Map<String, String> valuesOfFields = new Map<String,String>();
			
			for( String fv : fields){
			
				tempVals = fv.split( '::' );
				
				valuesOfFields.put( tempVals.get( 0 ), tempVals.get( 2 ) );
				
				tempVals.clear();
			
			}
			
			for( SFField f : this.fieldList ){
				if( valuesOfFields.get( f.name ) != null )
					f.value = valuesOfFields.get( f.name );
				
			}
		}
		
	}

	/**
	*@return saved filters options
	*/
	public List<SelectOption> getSavedFilters(){
		List<ProjectFilter__c> filters = new List<ProjectFilter__c>();
		List<SelectOption> filterOptions = new List<SelectOption>();
		
		filters = [select Id, Filter__c, Name from ProjectFilter__c where Project__c =: this.projectId ];
		filterOptions.add(new SelectOption('', '-- Select Filter --'));
		for(ProjectFilter__c filter : filters){
			filterOptions.add(new SelectOption(filter.Id, filter.Name));	
		}
		return filterOptions;	
	}

	/**
	*@return members asoc. to project options 
	*/
	public List<SelectOption> getAssignees(){
		List<ProjectMember__c> members = new List<ProjectMember__c>();
		List<SelectOption> options = new List<SelectOption>();
		
		members = [select m.Id, m.Name, User__r.Id from ProjectMember__c m where m.Project__c =: projectId order by m.Name asc];
		options.add(new SelectOption('', '-- Any --'));
		for (ProjectMember__c member : members){
			options.add(new SelectOption(member.User__r.Id, member.Name));		
		}	
		return options;
	}

	/**
	* Delete Filter
	*/
	public void deleteFilter(){
		List<ProjectFilter__c> filter = new List<ProjectFilter__c>();  
		filter = [select Id from ProjectFilter__c where Id =: getFilterName()];
		if( filter.size() > 0 )
		delete filter;
	}

	
	/*
	* Inner Class
	*/
	public class SFField {
		
		List<SelectOption> options = new List<SelectOption>();
		public List<SelectOption> getOptions() {return options;}
		public Date		valueDate;
		public String[]	opSelected 	= new String[]{};
		public String[] getOpSelected(){return opSelected;}
		public void     setOpSelected( String[] opS ){ opSelected = opS;}
		
		public String 	name 		{get; set;}
		public String 	fieldType 	{get; set;}
		public String 	value 		{get; set;}
		public String 	label 		{get; set;}
		public Integer 	index		{get; set;}
		
		public Date getValueDate(){
			return valueDate;
		}
		public void setValuieDate( Date d ){
			valueDate = d;
		}
	
	}
}