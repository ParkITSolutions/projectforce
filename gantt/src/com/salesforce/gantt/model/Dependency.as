package com.salesforce.gantt.model
{
	import com.salesforce.gantt.controller.Components;
	[Bindable]
	[RemoteClass(alias="com.salesforce.gantt.model.Dependency")]
	public class Dependency 
	{	
		public var id : String;
		/*
		 *  lagType
		 *	1 = SF when parent starts the child finishes
		 *	2 = FS when parent finishes the child starts
		 *	3 = SS when parent starts the child starts
		 *	4 = FF when parent finished the child finishes
		 */
		public static const SF : int = 1; 
		public static const FS : int = 2; 
		public static const SS : int = 3; 
		public static const FF : int = 4; 
		
		public var lagType : int;
		
		
		/*
		 *  (numero de horas, dias, semenas)
		 */
		public var lagTime : int;
		
		/*
		 *  (hours, days, weeks)
		 */
		public static const HOURS : int = 1; 
		public static const DAYS : int = 2; 
		public static const WEEKS : int = 3; 
		
		public var lagUnits : int;
		
		public var type : int;
		
		/*
		* Parent object
		*/
		
		public var task : Task = null;

		/*
		 * Constructor
		 */	
		public function Dependency(task : Task = null, lagType : int= 1, lagTime : int =-1, lagUnits : int =1, id : String = '')
		{
			this.id			= id;			                  
			this.task		= task;
			this.lagType	= lagType;
			this.lagTime	= lagTime;
			this.lagUnits	= lagUnits;
			this.type		= type;
		}
		public function toString() : String
		{
			var lagType : String = '';
			var lagUnits : String = '';
			var sign : String  = '';
			var lagTime : String = '';
			
			switch (this.lagType)
			{
				case 1:
					lagType = 'SF';
					break;
				case 2:
					lagType = 'FS';
					break;
				case 3:
					lagType = 'SS';
					break;
				case 4:
					lagType = 'FF';
					break;	
			}
			
			if(this.lagTime != 0)
			{
				lagTime = String(this.lagTime);
				
				if(this.lagTime>0) sign='+';
							
				switch (this.lagUnits)
				{
					case 1:
						lagUnits = 'H';
						break;
					case 2:
						lagUnits = 'D';
						break;
					case 3:
						lagUnits = 'W';
						break;
				}
			}			
			return this.task.position + lagType + sign + lagTime + lagUnits;
		}
		/**
		 * Clona una dependencia
		 */
		public function clone() : Dependency
		{
			var dependency : Dependency = new Dependency(null, 0, 0, 0, '');		
			dependency.id		= id;
	    	dependency.lagType	= lagType;
	    	dependency.lagTime	= lagTime;
	    	dependency.lagUnits	= lagUnits;
	    	dependency.type		= type;
	    	dependency.task		= task;
	    	return dependency;
		}
		/**
		 * Retorna el width de la flecha que la dependencia ocupa en el gantt
		 */
		public function lineWidth(child : Task) : int
		{
			var start : int = 0;
			var end : int = 0;
		  if (this.task != null)
		  {
		  	var durationChild : int = child.durationInDays();
		  	if(child.isMilestone)
		  	{
		  		durationChild = 1;
		  	}
			switch (this.lagType)
			{
				case SF:
					start = Calendar.toDay(this.task.startDate);
					end = Calendar.toDay(child.startDate) + durationChild;
					break;
				case FS:
					start = Calendar.toDay(this.task.startDate) + this.task.durationInDays();
					end = Calendar.toDay(child.startDate);
					break;
				case SS:
					start = Calendar.toDay(this.task.startDate);
					end = Calendar.toDay(child.startDate);
					break;
				case FF:
					start = Calendar.toDay(this.task.startDate) + this.task.durationInDays();
					end = Calendar.toDay(child.startDate) + durationChild;
					break;
			}
			return end - start;
		  }
		  return 0;
		}
		/**
		 * Retorna el height de la flecha que la dependencia ocupa en el gantt
		 */
		public function lineHeight(child : Task) : int
		{
			if(this.task != null)
			{
			   return child.positionVisible - this.task.positionVisible;
			}
			return 0;   
		}
		/**
		 * Retorna el x de la flecha que la dependencia tiene en el gantt
		 */
		public function lineX() : int
		{
			var lineX : int = 0;
			if (this.task != null)
			{
			   switch (this.lagType)
			   {
				  case SF:
				  case SS:
					   lineX = Calendar.toDay(this.task.startDate);
					   break;
				  case FS:
				  case FF:
					   lineX = Calendar.toDay(this.task.startDate) + (this.task.durationInDays());
					   break;
			    }
			    return lineX ;
			}
			return 0;
		}
	}
}