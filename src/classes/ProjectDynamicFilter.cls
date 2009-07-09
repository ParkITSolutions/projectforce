public class ProjectDynamicFilter {

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
		
		return this.fieldList;
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
	private List<SelectOption> genRelationshipOptions(Schema.DescribeFieldResult pickListField){
		List<SelectOption> relationshipOptions = new List<SelectOption>();
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
		Set<String>   outFields  = new Set<String>{ 'IsExpanded', 'System Modstamp', 'Deleted', 'Id', 'Record ID', 'TaskPosition', 'TaskSyncId', 'Last Modified Date', 'Indent'  };  
		
		fieldList = new List<SFField>();
	   	for (String fldName: fieldMap.keySet()) {
	    	SFField newField = new SFField();
	    	fldDescRes = fieldMap.get(fldName).getDescribe();
	    	newField.name = fldDescRes.getName();
	    	newField.fieldType = fldDescRes.getType().name().replaceAll('Schema.fieldtype.','');
	    	newField.label = fldDescRes.getLabel(); 
	    	
	    	if (newField.fieldType.toLowerCase() == 'picklist'){
	    		newField.options = genRelationshipOptions(fldDescRes);
	    		picklists.add( newField );
	    	}	
	    	else if (  newField.fieldType.toLowerCase() == 'boolean' ){
	    		checkboxes.add( newField );
	    	}
	    	else if (  newField.fieldType.toLowerCase() != 'reference' ){
	    		others.add( newField );
	    	}
		}

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
		for( SFField f : this.fieldList )
			
			if( f.fieldType.toLowerCase() == 'picklist'){
				if( f.opSelected.size() > 0 )
				fieldsName += ' AND ' + f.name + ' = ' + f.opSelected[0] + ' ';
			}else if( f.fieldType.toLowerCase() == 'bolean')
				fieldsName += ' AND ' + f.name + ' = ' + true + ' ';
			else
				fieldsName += ' AND ' + f.name + ' = ' + f.value + ' ';
					
		return fieldsName;
	
	}
	
	/*
	* Inner Class
	*/
	public class SFField {
		
		List<SelectOption> options = new List<SelectOption>();
		public List<SelectOption> getOptions() {return options;}
		
		public String[]	opSelected 	= new String[]{};
		public String[] getOpSelected(){return opSelected;}
		public void     setOpSelected( String[] opS ){ opSelected = opS;}
		
		public String 	name 		{get; set;}
		public String 	fieldType 	{get; set;}
		public String 	value 		{get; set;}
		public String 	label 		{get; set;}
		public Integer 	index		{get; set;}
	
	}
}