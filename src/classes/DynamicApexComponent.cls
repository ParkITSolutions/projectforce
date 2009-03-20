public class DynamicApexComponent {
	
	public String output = '';
	public String projectId = 'a003000000BvAH7AAN';
	
	public DynamicApexComponent (){
		Map<String, Schema.SObjectField> fields = Schema.SObjectType.Project2__c.fields.getMap();
		for(Schema.SObjectField field : fields.values()){
			Schema.DescribeFieldResult f = field.getDescribe();
			output += f.isAccessible() + ' - ' + f.getName() + '<br />';
		}

	}	

	public String getOutput(){
		return output;
	}
	
	public String getProjectId(){
		return projectId;
	}
	
}