package com.salesforce.gantt.controller
{
	import com.salesforce.results.DescribeLayout;
	import com.salesforce.results.DescribeLayoutResult;
	import com.salesforce.results.DescribeLayoutSection;
	import com.salesforce.results.DescribeSObjectResult;
	import com.salesforce.results.Field;
	import com.salesforce.results.PicklistForRecordType;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Class responsible to manage the sobjects , pages's layouts
	 * metadatas available in the server.
	 * 
	 * @author Rodrigo Birriel
	 */
	public class SMetadataController
	{
		private var sObjectDescriptors : Array = new Array();
		private var layoutDescriptors : Array = new Array();
		private var layouts : Array = new Array();
		private var pickLists : Array = new Array();
		
		private static var _instance : SMetadataController;
		
		public static const DATE : String 		= "date";
		public static const TEXTAREA : String 	= "textarea";
		public static const BOOLEAN : String	= "boolean";
		public static const PICKLIST : String 	= "picklist";
		public static const REFERENCE : String  = "reference";
		public static const STRING : String		= "string";
		public static const PERCENT : String	= "percent";
		public static const DOUBLE : String		= "double";
		public static const CURRENCY : String 	= "currency";
		public static const DATETIME : String 	= "datetime";
		public static const EMAIL : String		= "email";
		public static const PHONE : String		= "phone";
		public static const URL : String		= "url";
		
		public static const TASK_CUSTOM_OBJECT : String  			= "ProjectTask__c";
		public static const DEPENDENCY_CUSTOM_OBJECT : String 		= "Dependency__c";
		public static const TASKRESOURCE_CUSTOM_OBJECT : String 	= "ProjectAssignee__c";
		public static const PROJECT_CUSTOM_OBJECT : String			= "Project2__c";
		
		public static const FIELD : String		= "Field";
		
		public static const CREATETABLE : String 	= 'createable';
		public static const UPDATEABLE : String 	= 'updateable';
		public static const MERGEABLE : String		= 'mergeable';
		public static const DELETEABLE : String		= 'deleteable';
		public static const UNDELETEABLE : String	= 'undeleteable';
		
		public function SMetadataController(){
			
		}
		
		public static function get instance() : SMetadataController{
			if(!_instance){
				_instance = new SMetadataController();
			}
			return _instance;
		}
		
		public function addSObjectDescriptor(key : String, sObjectDescriptor : DescribeSObjectResult) : void{
			sObjectDescriptors[key] = sObjectDescriptor;	
		}
		public function addLayoutDescriptor(key : String, layoutDescriptor : DescribeLayoutResult) : void{
			layoutDescriptors[key] = layoutDescriptor;
			// adding new picklist to the collection
			for each(var recordType in layoutDescriptor.recordTypeMappings){
				for each(var pickListRecordType : PicklistForRecordType in recordType.picklistsForRecordType){
					addPickList(pickListRecordType.picklistName,pickListRecordType.picklistValues);
				}
			}
		}
		
		public function editLayoutSectionRows(sobjectName : String) : ArrayCollection{
			//return layouts[0];
			var describeLayoutResult : DescribeLayoutResult = layoutDescriptors[sobjectName];
			var describeLayout : DescribeLayout = describeLayoutResult.layouts[0];
			var describeLayoutSection : DescribeLayoutSection = describeLayout.editLayoutSections[0];
			return describeLayoutSection.layoutRows;
		}
		
		public function detailLayoutSectionRows(sobjectName : String) : ArrayCollection{
			var describeLayoutResult : DescribeLayoutResult = layoutDescriptors[sobjectName];
			var describeLayout : DescribeLayout = describeLayoutResult.layouts[0];
			var describeLayoutSection : DescribeLayoutSection = describeLayout.detailLayoutSections[0];
			return describeLayoutSection.layoutRows;
		}
		
		public function getFieldValue(sobjectName : String, field : String): Field{
			var fieldResult : Field = (sObjectDescriptors[sobjectName].fields)[field];
			return fieldResult;
		}
		
		public function getFieldNames(sobjectName : String) : Array{
			var fieldNames : Array = new Array();
			for each(var field : Field in sObjectDescriptors[sobjectName].fields){
				fieldNames.push(field.name);
			}
			return fieldNames;
		}
		
		public function getFieldsCreatebleAndUpdatable(sobjectName : String) : ArrayCollection{
			var fields : ArrayCollection = new ArrayCollection();
			var createable : Boolean;
			var updatable : Boolean;
			for each(var field : Field in sObjectDescriptors[sobjectName].fields){
				createable = field[CREATETABLE];
				updatable = field[UPDATEABLE];
				if(createable && updatable){
					fields.addItem(field);	
				}
			}
			return fields;
		}
		
		public function getPickList(sojbectName : String) : ArrayCollection{
			var pickListValues : ArrayCollection = new ArrayCollection();
			if(pickLists[sojbectName]){
				pickListValues.source = pickLists[sojbectName];
			}
			return pickListValues;
		}
		
		public function filterFields(properties : Object ,sObjectType : String, operationType : String) : Object{
			var newProperties : Object = new Object();
			var cObjectMetadata : Object = sObjectDescriptors[sObjectType].fields;
			var cObjectMetadataProperty : Object;
			var validProperty : Boolean;
			for (var property : String in properties){
				cObjectMetadataProperty = cObjectMetadata[property];
				if(cObjectMetadataProperty){
					validProperty = cObjectMetadataProperty[operationType];
					//hardcoded the field for parent task.
					if(validProperty){
						newProperties[property] = properties[property];
					}	
				}else{
					newProperties[property] = properties[property];
				}
				
			}
			// set the id to the new properties of object;
			if(operationType == UPDATEABLE){
				newProperties['Id'] = properties['Id'];	
			}
			return newProperties;
		}
		
		private function addPickList(field : String, options : Array) : void{
			pickLists[field] = options;
		}
	
	}
}