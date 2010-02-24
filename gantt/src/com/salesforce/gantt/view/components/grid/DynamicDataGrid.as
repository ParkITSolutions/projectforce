package com.salesforce.gantt.view.components.grid
{
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridBase;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.events.DragEvent;
	
	/**
	 * Customized data grid to support specific funcionalities as 
	 * selecting cell with double-click event 
	 * or edit a cell pressing enter key
	 * 
	 * @author Rodrigo Birriel	
	 */ 
	public class DynamicDataGrid extends AdvancedDataGrid{
		
		private var _selectedCell:Object = null;
        private var _clickCount:uint;
        public var dummyCell : Boolean;
 		
 		/**
 		 * Constructor
 		 * 
 		 * By default the selection mode is setting to single cell.
 		 */ 
		public function DynamicDataGrid(){
			super();
			//selectionMode = AdvancedDataGridBase.SINGLE_CELL;
			selectionMode = AdvancedDataGridBase.SINGLE_ROW;
		}
		
		override protected function mouseUpHandler(event:MouseEvent):void{
            editable = (_clickCount == 2).toString();
 
            super.mouseUpHandler( event );
        }
 
 		/**
 		 * Override to update the click count for editing.
 		 */
        override protected function selectItem( item:IListItemRenderer, shiftKey:Boolean, ctrlKey:Boolean, transition:Boolean=true ):Boolean{
            var returnValue:Boolean = super.selectItem( item, shiftKey, ctrlKey, transition );
 
 			//if(selectionMode == AdvancedDataGridBase.SINGLE_CELL){
 				if (equalCells(selectedCells[0],_selectedCell)){
                	_clickCount = 2;
	            }
	            else{
	                _selectedCell = selectedCells[0];
	                _clickCount = 1;
	            }  	
 			//}
 
            return returnValue;
        }
        
        override protected function keyDownHandler(event:KeyboardEvent):void{
        	if((editable == "" || editable == (false).toString()) && event.keyCode == Keyboard.ENTER){
        		editable = (true).toString();
        	}	
        	super.keyDownHandler(event);
        }
        
        override protected function dragStartHandler(event:DragEvent):void{
        	//selectionMode = AdvancedDataGridBase.SINGLE_ROW;
        	super.dragStartHandler(event);
        }
        
        override protected function dragCompleteHandler(event:DragEvent):void{
        	super.dragCompleteHandler(event);
        	//selectionMode = AdvancedDataGridBase.SINGLE_CELL;
        }
        
        /**
        * Depending on the dataprovider type, cast this to its 
        * specific type, returning the size.
        * 
        * @return the size of dataprovider
        */ 
        public function dataProviderSize(): int{
        	var size : int= 0;
        	if(dataProvider is Array){
        		size = (dataProvider as Array).length;		
        	}else if(dataProvider is ArrayCollection){
        		size = (dataProvider as ArrayCollection).length
        	}
        	return size;
        }
        
        private function equalCells(cellA : Object, cellB : Object) : Boolean{
        	var equals : Boolean = false;
        	if(	cellA && cellB ){
        		equals = (cellA.columnIndex == cellB.columnIndex) && 
        				(cellA.rowIndex == cellB.rowIndex);
        	}
        	return equals;
        }
	}
}