/**
* @author Miguel Soares
* @createDate 04/08/2009
*/
@isTest private class ProjectDynamicFilterTest {

	/**
    * Test customException
    */
    public static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();

		System.currentPageReference().getParameters().put('id', GenerateEnvironmentTest.project.id );
		ProjectDynamicFilter dyn = new ProjectDynamicFilter();

		// Inner class
		ProjectDynamicFilter.SFField innCls = new ProjectDynamicFilter.SFField();
		
		innCls.name    = 'name' ; 			//Set
		String bugOfHolding = innCls.name;	//Get
		
		innCls.fieldType =	'type';
		bugOfHolding= innCls.fieldType;
		
		innCls.value =	'value';
		bugOfHolding =	innCls.value;
		
		innCls.label =	'label';
		bugOfHolding =	innCls.label;
		
		innCls.index =	1;
		innCls.index =	innCls.index;
		
		innCls.setValuieDate( innCls.getValueDate());
		innCls.setOpSelected(innCls.getOpSelected());
		innCls.getOptions();		
		

		// Class
		
		List<ProjectDynamicFilter.SFField> fieldList = new List<ProjectDynamicFilter.SFField>();
		dyn.getProjectId();
		
		dyn.getFieldList();
		
		dyn.setFieldList( fieldList );
		dyn.getFieldList();

		dyn.getLoadingFilter();		
		
		dyn.setFilterName('filter_name');
		dyn.getFilterName();
		
		dyn.setLoadingFilter(true);
		fieldList = dyn.getFieldList();
		dyn.setLoadingFilter(false);
		
		String aux = dyn.genStrWithFieldsName();
		dyn.saveFilter();
		dyn.loadFilter();
		
		List<SelectOption> retValue = dyn.getSavedFilters();
		List<SelectOption> retValue1 = dyn.getAssignees();
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }    	
}