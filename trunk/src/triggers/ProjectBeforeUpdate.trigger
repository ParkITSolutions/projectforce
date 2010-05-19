trigger ProjectBeforeUpdate on Project2__c (before update) {
    if( !ProjectUtil.currentlyExeTrigger ){
        //for (Project2__c project : Trigger.new) {
        Project2__c projectOld = new Project2__c();
        Project2__c project = new Project2__c();
        for( Integer k = 0; k < Trigger.new.size(); k++ ){
            
            project = Trigger.new.get( k );
            projectOld = Trigger.old.get( k );
            
            //Set Profile according Project Access
            if(project.Access__c != null){
                if(project.Access__c.equals('Open')){
                    project.PublicProfile__c = [SELECT id FROM ProjectProfile__c WHERE Name =: 'Public Profile' limit 1].Id;
                                                    
                    project.Type__c = 'open';            
                }else if (project.Access__c.equals('Close')) {
                    project.NewMemberProfile__c = [SELECT id FROM ProjectProfile__c WHERE Name =: 'Member Profile' limit 1 ].Id;
                                                    
                    project.PublicProfile__c = null;
                    project.Type__c = 'close';           
                }else if (project.Access__c.equals('Private')){
                    project.Type__c = 'private';
                    project.PublicProfile__c = null;
                    project.NewMemberProfile__c = null;
                }
            }   
            
            //List<ProjectTask__c> taskList = [ select Id, Project__c from ProjectTask__c where Project__c=: projectOld.Id limit 1000 ];
            if(( projectOld.Tasks__c != null && projectOld.Milestones__c != null ) && projectOld.Tasks__c == 0 && projectOld.Milestones__c == 0 ){
                // Verefying modified fields. This fields can't be modified once a project its created.
                if( projectOld.DisplayDuration__c != project.DisplayDuration__c )
                    project.DisplayDuration__c.addError('This value can\'t be modified, restore value to ' + projectOld.DisplayDuration__c);
                
                if( projectOld.DaysInWorkWeek__c != project.DaysInWorkWeek__c )
                    project.DaysInWorkWeek__c.addError('This value can\'t be modified, restore value to ' + projectOld.DaysInWorkWeek__c);
                
                if( projectOld.WorkingHours__c != project.WorkingHours__c )
                    project.WorkingHours__c.addError('This value can\'t be modified, restore value to ' + projectOld.WorkingHours__c);
            }
        }
    }
}