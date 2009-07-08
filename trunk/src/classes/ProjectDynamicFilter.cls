public class ProjectDynamicFilter {

	public List<SFField> fieldList = new List<SFField>();



	public ProjectDynamicFilter(){}

	public List<SFField> getFieldList(){
		
		if( this.fieldList == null || this.fieldList.size() == 0)
			this.genSalesforceFields();
		
		return this.fieldList;
	}
	
	public void setFieldList( List<SFField> l ){
		this.fieldList = l;
	}
	
	
	
	   /**
		newProject.name = 'foo';
		newProject.set('name', 'foo');
		
		
		newProject.set(name, value)
		*/


	// Private methods
	
	/**
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
	*/
	private void genSalesforceFields() {
		Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
		Schema.DescribeSObjectResult descRes;
		Map<String, Schema.SObjectField> fieldMap;
		//String name = objectMapping;
		descRes = schemaMap.get('Project2__c').getDescribe();
		fieldMap = descRes.fields.getMap();
		Schema.DescribeFieldResult fldDescRes;
		List<Schema.PicklistEntry> pickValList;
		String tempStr,currFldName;
		
		
		fieldList = new List<SFField>();

	   	for (String fldName: fieldMap.keySet()) {
	    	SFField newField = new SFField();
	    	fldDescRes = fieldMap.get(fldName).getDescribe();
	    	newField.name = fldDescRes.getName();
	    	newField.fieldType = fldDescRes.getType().name().replaceAll('Schema.fieldtype.','');
	    	newField.label = fldDescRes.getLabel(); 
	    	
	    	if (newField.fieldType.toLowerCase() == 'picklist'){
	    		newField.options = genRelationshipOptions(fldDescRes);	
	    		this.fieldList.add( newField );
	    	}	
	    	else if (  newField.fieldType.toLowerCase() == 'string' )
	    		this.fieldList.add( newField );
	          
		}
	}
	
	public String genStrWithFieldsName(){
		String fieldsName = '';
		for( SFField f : this.fieldList ){
			/*
			if( f.fieldType == 'Picklist' ){}
			else{}
			*/
			fieldsName += f.value;
		}		
		
		return fieldsName;
	
	}
	
	//Inner class
	
	public class SFField {
		List<SelectOption> options = new List<SelectOption>();
		public List<SelectOption> getOptions() {return options;}
		public String name 		{get; set;}
		public String fieldType {get; set;}
		public String value 	{get; set;}
		public String label 	{get; set;}
	}
	   
}