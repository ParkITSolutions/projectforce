public class ProjectDynamicFilter {
 
	private Boolean loadingFilter = false;
	private Id projectId = System.currentPageReference().getParameters().get('id');
	private String filterName;
	public List<SFField> fieldList = new List<SFField>();

  
	/**
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
	
	/**
	private List<SelectOption> genPicklistValues(Schema.DescribeFieldResult pickListField){
		List<SelectOption> relationshipOptions = new List<SelectOption>();
       	relationshipOptions.add(new SelectOption('', '-- Any --'));
       	for (Schema.PicklistEntry iter : pickListField.getPicklistValues()) 
      		relationshipOptions.add(new SelectOption(iter.getValue(), iter.getLabel()));
       	
       	return relationShipOptions;
   	}
	*/
	/**
	* Generate Salesforce Fields
	*@return void
	*/
	private void genSalesforceFields() {
	}
	
	/*
	* 
	*/
	public String genStrWithFieldsName(){
		String fieldsName = '';
		/**
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
		*/
		return fieldsName;
	}
	
	/**
	* Save the current filter values
	*/
	public void saveFilter(){
		/**
		String fieldToSave  = ''; 
		String filterToSave = '';
		for( SFField f : this.fieldList ){ 
			if( f.value != null && f.value != ''){
				fieldToSave = f.name + '::' + f.fieldType + '::' + f.value;
				filterToSave += fieldToSave + '#';
			}
		}
		*/
	}
	/**
	*Load filter values for a filter
	*@param Id projectId, Id filterId
	*/
	
	
	public void loadFilter(){
		
	}
	
	/**
	*@return saved filters options
	*/
	public List<SelectOption> getSavedFilters(){
		return null;
	}

	/**
	*@return members asoc. to project options 
	*/
	public List<SelectOption> getAssignees(){
		
		List<ProjectMember__c> members = new List<ProjectMember__c>(); 
		List<SelectOption> options = new List<SelectOption>();
		return options;
	}

	/**
	* Delete Filter
	*/
	/*
	public void deleteFilter(){
	}
	*/

	
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