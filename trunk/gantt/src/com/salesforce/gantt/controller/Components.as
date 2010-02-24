package com.salesforce.gantt.controller
{
	
	import com.salesforce.gantt.commands.InitiateCommand;
	import com.salesforce.gantt.model.GanttState;
	import com.salesforce.gantt.model.Project;
	import com.salesforce.gantt.model.Resource;
	import com.salesforce.gantt.model.TaskResource;
	import com.salesforce.gantt.services.SalesforceService;
	import com.salesforce.gantt.util.FakeDataLoader;
	
	import flash.events.Event;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;
	
	/**
	 * 
	 */
	 
	public class Components extends UIComponent
	{	
		private static var logger : ILogger = Log.getLogger("Components");	
		
		/** a singleton reference to this class **/
		private static var _instance : Components;
		
		/** the GanttStare **/		
		public var ganttState : GanttState;
		
		/** the database connection **/
		public var salesforceService : SalesforceService;
		
		/** the controller has all UI functionality **/
		public var controller : IController;
		
		/** the list of Tasks to populate the task grid and gantt chart **/
		[Bindable]
		public var tasks : ITasks;
		
		/** the list of project's resources**/
		public var resources : IResources;
		
		public var users : IUsers;
		
		
		public var dependencies : IDependencies;
		
		public var profiles : IProfiles;
		
		public var project : Project;
		
		[Bindable]
		public var resourceLogged : Resource;
				
		private var fakeDataLoader : FakeDataLoader;
		
		/**
		 * Constructor
		 * initializes the class references
		 */
		public function Components() : void
		{ 
			if (Log.isDebug())
				logger.log(LogEventLevel.DEBUG, "Components entry");
			_instance = this;
			this.salesforceService =  new SalesforceService();
			this.controller = new Controller();
			this.tasks = new Tasks();
			this.resources = new Resources();
			
			this.users = new Users();
			this.dependencies = new Dependencies();
			this.profiles = new Profiles();
			this.project = new Project();
			this.resourceLogged = new Resource();
			
			if (Log.isDebug())
				logger.log(LogEventLevel.DEBUG, "Components exit");
				
			// assign fake user and project loaded from an external xml
			fakeDataLoader = new FakeDataLoader();
			fakeDataLoader.addEventListener(Event.COMPLETE,init);
			fakeDataLoader.load();
			
		}
		
		
		/**
		 * TODO move this method to an apppropiate place :)
		 */
		public function getUserTaskResource() : TaskResource{
			var resource : Resource = resources.findByUser(resourceLogged.user.id);
			var taskResource : TaskResource = new TaskResource('',resource);
			return taskResource;
		}
		
		/**
		 * get instance makes sure we have only one instance of Components
		 * returns a reference to this class
		 */
		public static function get instance() : Components
        {
			if (Log.isDebug())
				logger.log(LogEventLevel.DEBUG, "instance entry");
        	if(_instance == null)
        	{
        		new Components();
        	}
			if (Log.isDebug())
				logger.log(LogEventLevel.DEBUG, "instance exit " + _instance.toString());
            return _instance;
        }
        
        // load the fake data in developer mode.
        private function init(event : Event) : void {
        	var username : String = fakeDataLoader.username();
			var password : String = fakeDataLoader.password();
			var serverUrl : String = Application.application.parameters.server_url;
			var sessionId : String = Application.application.parameters.session_id;
			if(Application.application.parameters.Project){
				project.id = Application.application.parameters.Project; 
			}else{
				project.id = fakeDataLoader.projectId();
			};
			
			// initiate the loading data from Server
			 var initiateCommand : InitiateCommand = new InitiateCommand(project,username,password,serverUrl,sessionId);
			initiateCommand.execute();
			initiateCommand.success = function(){
				// TODO dispatch an event to close the swirling.
				Application.application.mainView.endLoad();
				Application.application.mainView.visibilityLoadingProgress(false);
				//dispatchEvent(new Event(Constants.LOADING_END,true));
			} 
        }
	}
}