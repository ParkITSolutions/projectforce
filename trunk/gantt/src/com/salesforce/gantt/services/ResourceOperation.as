package com.salesforce.gantt.services
{
	import com.salesforce.*;
	import com.salesforce.events.*;
	import com.salesforce.gantt.model.Project;
	import com.salesforce.gantt.model.Resource;
	import com.salesforce.gantt.util.CustomArrayUtil;
	import com.salesforce.gantt.util.CustomSObject;
	import com.salesforce.objects.*;
	import com.salesforce.results.*;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	
	public class ResourceOperation extends BaseOperation{
		
		/*
		 * Constructor
		 */
		public function ResourceOperation() : void{
		}
		
		public function loadProyectResources(project : Project, ar : IResponder) : void{
			var query : String = "SELECT Id,User__r.Id,User__r.Name,User__r.FirstName,User__r.LastName,User__r.CompanyName,User__r.title,Profile__r.Id,CreatedDate FROM ProjectMember__c WHERE Project__c = '" + project.id + "'";
			connection.query(query,ar);
		}

		public function loadUsersOnDemand(pattern : String,filteredElements : ArrayCollection, ar : IResponder) : void{
			if(!filteredElements){
				filteredElements = new ArrayCollection();
			}
			var filteredIdsString : String = filteredElements.source.join("','");
			var query : String = "SELECT Id,Name,FirstName,LastName,CompanyName,Title FROM User WHERE Name LIKE '%"+pattern+"%' AND "+
								 " Id NOT IN ('"+filteredIdsString+"')";	
			connection.query(query,ar);
		}
		
		public function create(resources : ArrayCollection,project : Project, ar : IResponder) : void{
			var arraySObject : Array = new Array();
			var resourceSObject : CustomSObject;
			for each(var resource : Resource in resources){
				resourceSObject = new CustomSObject('ProjectMember__c');
				resourceSObject.setProperty('User__c',resource.user.id);
				resourceSObject.setProperty('Project__c',project.id);
				resourceSObject.setProperty('Name',resource.name);
				arraySObject.push(resourceSObject);
			}
			connection.create(arraySObject,ar);
		}
		
		public function remove(resources : ArrayCollection, ar : IResponder) : void{
			var arraySObject : Array = CustomArrayUtil.getAttributesArrayCollection(resources,'id').toArray();
			connection.deleteIds(arraySObject,ar);
		}
	}
}