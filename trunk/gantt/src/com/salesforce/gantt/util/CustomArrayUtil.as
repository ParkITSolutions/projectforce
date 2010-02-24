package com.salesforce.gantt.util
{
	import com.salesforce.gantt.model.*;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ArrayUtil;
	import mx.utils.ObjectUtil;
	
	/**
	 *  Class used to operate over collection, 
	 *  they can be Array or ArrayCollection
	 *  
	 *  @author Rodrigo Birriel
	 */
	public class CustomArrayUtil extends ArrayUtil
	{
 		private static const ADDED : String = 'added';
 		private static const UPDATED : String = 'updated';
 		private static const DELETED : String = 'deleted';
 		
 		/**
 		 * Makes a copy of an array in depth
 		 */
		public static function copyArray(array : Array) : Array{
			var copyArray : Array = new Array();
			var copyObject : Object;
			var object : Object;
			for(var i : int=0; i< array.length; i++){
				object = array[i];
				copyObject = ObjectUtil.copy(object);
				copyArray.push(copyObject);
			}
			return copyArray;
		}
		
		/**
 		 * Makes a copy of an arraycollection in depth
 		 */ 
		public static function copyArrayCollection(arrayCollection : ArrayCollection) : ArrayCollection{
			var copyArray : Array = copyArray(arrayCollection.source);
			var copyArrayCollection : ArrayCollection = new ArrayCollection(copyArray);
			return copyArrayCollection;
		}
		
		
		/**
		 * Returns a collection about a specific attribute of a collection of elements
		 * @param elements is the collection to extract the data
		 * @param attribute is the attribute to obtain from each element into the array
		 * @returns a collection mentioned above
		 */ 
		public static function getAttributesArrayCollection(elements : ArrayCollection ,attribute : String) : ArrayCollection{
			var attributes : ArrayCollection = new ArrayCollection();
			var element : Object;
			var newAttribute : Object;
			for(var i:int;i<elements.length;i++){
				element = elements.getItemAt(i);
				if(element.hasOwnProperty(attribute)){
					attributes.addItem(element[attribute]);
				}
			}
			return attributes;
		}
		
		/**
		 * Idem getAttributesArrayCollection for array
		 */ 
		public static function getAttributesArray(elements : Array, attribute : String) : ArrayCollection{
			var arrayCollection : ArrayCollection = new ArrayCollection(elements);
			return getAttributesArrayCollection(arrayCollection,attribute);
		}
		
		/**
		 * Prints the elements of an array.
		 */ 
		public static function printArray(array : Array) : void{
			trace('length : '+ array.length);
			for(var i:int=0;i<array.length;i++){
				trace('Object.toString : '+array[i].name);
			}
		}
		
		/**
		 * Given two arrays compare them extracting the element following a criteria if
		 * there are added, updated, deleted elements.
		 * @param originalList 	: the original list to compare.
		 * @param newList 		: the new list to compare.
		 * @param type			: the criteria to compare.
		 * @return a ArrayCollection appliying the filter.
		 */ 
		private static function compare( originalList : ArrayCollection, newList : ArrayCollection, type: String) : ArrayCollection{
			var filter : Function;
			var auxList : ArrayCollection = new ArrayCollection();
			var arrayCollectionResult : ArrayCollection = new ArrayCollection();
			if(type == ADDED){
				for each(var element in newList){
					//if element has property id = '', the element is new
					if(element.hasOwnProperty('id') && element['id'] == ''){
						arrayCollectionResult.addItem(element);
					// generate a new list replacing the new list
					}else{
						auxList.addItem(element);
					}
				}
				// modify the newList removing the elements added.
				newList.list = auxList.list;
			} else if(type == DELETED){
				var existsElement : Boolean;
				for each(var element : Object in originalList){
					existsElement = false;
					for each(var origElement : Object in newList){
						existsElement = origElement['id'] == element['id'];
						if(existsElement){
							break;
						}
					}
					if(!existsElement){
						arrayCollectionResult.addItem(element);	
					}
				}
			} else if(type == UPDATED){
				arrayCollectionResult.addItem(new ArrayCollection());
				arrayCollectionResult.addItem(new ArrayCollection());
				var elementUpdated : Boolean;
				for each(var element : Object in originalList){
					elementUpdated = false;
					for each(var newElement : Object in newList){
						elementUpdated = newElement['id'] == element['id'];
						if(elementUpdated){
							elementUpdated = ObjectUtil.compare(newElement,element) != 0;
							if(elementUpdated){
								arrayCollectionResult.getItemAt(0).addItem(element);
								arrayCollectionResult.getItemAt(1).addItem(newElement);
							}
							break;
						}
					}
				}
			}
			return arrayCollectionResult;
		}
		
		/**
		 * Given two arrays compare them extracting the element added to the newList ArrayCollection.
		 * @param originalList 	: the original list to compare.
		 * @param newList 		: the new list to compare.
		 */
		public static function extractAdded(originalList : ArrayCollection, newList : ArrayCollection) : ArrayCollection{
			return compare(originalList,newList,ADDED);
		}
		
		/**
		 * Given two arrays compare them extracting the element updated to the newList ArrayCollection.
		 * @param originalList 	: the original list to compare.
		 * @param newList 		: the new list to compare.
		 * @return a list of list: 	the first element are the previous values and
		 * 							the second element are the updated values.
		 */
		public static function extractUpdated(originalList : ArrayCollection, newList : ArrayCollection) : ArrayCollection{
			return compare(originalList,newList,UPDATED);
		}
		
		/**
		 * Given two arrays compare them extracting the element deleted to the newList ArrayCollection.
		 * @param originalList 	: the original list to compare.
		 * @param newList 		: the new list to compare.
		 */
		public static function extractDeleted(originalList : ArrayCollection, newList : ArrayCollection) : ArrayCollection{
			return compare(originalList,newList,DELETED);
		}
		
	}
}