package com.salesforce.gantt.model
{
	import com.salesforce.gantt.controller.SMetadataController;
	import com.salesforce.gantt.util.SNSUtil;
	
	import mx.controls.Image;
	
	[Bindable]
	[RemoteClass(alias="com.salesforce.gantt.model.Project")]
	public class Project implements IDynamicObject,IAttachmentProperty
	{
		public var id : String;
		public var name : String;
		public var hoursPerDay : int;
		public var durationInHours : Boolean;
		public var daysInWorkWeek : int;
		public var description : String;
		public var priority : String;
		public var createdBy : String;
		
		private var image : Image;
		
		public function Project ()
		{
			
		}
		
		public function convertToHours(value : Number) : Number{
			return value * hoursPerDay;
		}
		
		public function convertToDays(value : Number, precision :Boolean = false) : Number{
			var days : Number = value/hoursPerDay;
			if(!precision){
				days = Math.ceil(days);
			}
			
			return days;
		}
		
		public function milestoneDuration() : Number {
			return durationInHours?hoursPerDay:1;
		}
		
		//TODO hardcoded by lacking of properties map as attribute of this class,
		//this break the eyes please pay not atention.
		//fixme asap.
		public function property(key : String) : Object{
			var value : Object;
			switch(key){
				case 'Id':
						value = id;
					break;
				case 'Name':
						value = name;
					break;
				case 'CreatedBy':
						value = createdBy;
					break;
				case SNSUtil.nameSpace+'DisplayDuration__c' :
						value = durationInHours?'Hours':'Days';
					break;
				case SNSUtil.nameSpace+'DaysInWorkWeek__c' :
						value = hoursPerDay;
					break;
				case SNSUtil.nameSpace+'WorkingHours__c' :
						value = daysInWorkWeek;
					break;
				case SNSUtil.nameSpace+'Description__c' :
						value = description;
					break;
				case SNSUtil.nameSpace+'Priority__c' :
						value = priority;
					break;
			}
			return value;
		}
		
		//TODO hardcoded SObject type, fixme asap
		public function get stype() : String{
			return SMetadataController.PROJECT_CUSTOM_OBJECT;
		}
		
		public function set attachment(image : Image) : void{
			this.image = image;
		}
		
		public function get attachment() : Image{
			return image;	
		}
		
	}
}