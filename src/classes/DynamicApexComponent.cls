public class DynamicApexComponent {
	
	public String output = '';
	
	public DynamicApexComponent (){
		Map<String, Schema.SObjectField> M = Schema.SObjectType.Project2__c.fields.getMap();
		for(Schema.SObjectField f : M.values()){
			output += f + '<br/>';	
		}
		System.debug (M);
	}	

	public String getOutput(){
		return output;
	}

}