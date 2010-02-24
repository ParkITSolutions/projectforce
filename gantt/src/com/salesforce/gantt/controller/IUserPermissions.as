package com.salesforce.gantt.controller
{
	
	public interface IUserPermissions
	{
		function set userPermissions(id: String) : void; 
		function get userPermissions() : String;
		
		function genUserPermissions() : void;
		function getCanManage() : Boolean;
		function getCanCreate() : Boolean; 
	}
}