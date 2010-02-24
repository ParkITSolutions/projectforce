package com.salesforce.gantt.renderers
{
	import mx.binding.utils.BindingUtils;
	import mx.controls.Image;
	
	public class MilestoneImage extends Image
	{
		
		[Embed(source="assets/imgs/flag_green.png")]
		private var milestone_image_source : Class;
		
		public function MilestoneImage(w : Number = 32, h : Number = 32)
		{
			source = milestone_image_source;
			setActualSize(w,h);
			mouseEnabled = false;
		}
		
		public function normalSize(): void{
			setActualSize(32,32);
		}
		
		public function smallSize(): void{
			setActualSize(16,16);
		}

		override public function set name(value:String):void{
			super.name = "milestone_"+value;
		}
		
		static public function get name(): String{
			return "milestone_";
		}
		
	}
}