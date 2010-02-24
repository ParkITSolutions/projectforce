package com.salesforce.gantt.view.components.form.scomponent
{
	import com.salesforce.results.Field;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.managers.PopUpManager;

	/**
	 * Class to represent the Reference component used in Salesforce.
	 * It contains two component : a label to show the selected option and
	 * a image to display the magnifying glass icon, which has assigned a action
	 * when user click on it.
	 * 
	 * @author : Rodrigo Birriel
	 */ 
	public class SReference extends HBox implements SComponent
	{	
		
		[Embed(source="../img/search_icon.png")]
	    private var search : Class;
	    
		var labelRef : Label;
		var image : Image;
		var sReferenceList : SReferenceList;
		var selectedItem : Object;
		
		public var title : String;
		public var headerColumn : String;
		public var dataProvider : ArrayCollection;
		
		public function SReference()
		{
			super();
			labelRef = new Label();
			styleName = "sReference";
			labelRef.width = 100;
			labelRef.truncateToFit = true;
			image = new Image();
			image.source = search;
			addChild(labelRef); 
			addChild(image);  
			image.addEventListener(MouseEvent.CLICK,showItemList);
		}
			
		public function get value():Object
		{
			return selectedItem;
		}
		
		public function set value(value : Object):void{
			selectedItem = value;
			if(selectedItem && selectedItem.hasOwnProperty("name")){
				labelRef.text = selectedItem.name;
			}		
		}
		
		public function set customField(value : Object) : void{
		}
		
		public function get customField() : Object{
			return null;
		}
		
		public function setAction(eventType : String,listener : Function) : void{
			image.addEventListener(eventType,listener);
		}
		
		
		private function showItemList(event : MouseEvent) : void{
			sReferenceList = SReferenceList(PopUpManager.createPopUp(this,SReferenceList,true));
 			PopUpManager.centerPopUp(sReferenceList);
			sReferenceList.init(title,headerColumn);
			sReferenceList.dataProvider = dataProvider;
			event.stopPropagation();
			sReferenceList.addEventListener(MouseEvent.CLICK,setSelectedItemList);
		}
		
		private function setSelectedItemList(event : Event) : void{
			if(sReferenceList && sReferenceList.selectedItem()){
				selectedItem = sReferenceList.selectedItem();
				labelRef.text = selectedItem.name;
				PopUpManager.removePopUp(sReferenceList);
				sReferenceList = null;
			}
		}
	}
}