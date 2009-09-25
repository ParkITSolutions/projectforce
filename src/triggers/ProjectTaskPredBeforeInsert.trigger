trigger ProjectTaskPredBeforeInsert on ProjectTaskPred__c (Before Insert, Before Update, Before Delete, After Insert, After Update, After Delete) {

   if(Trigger.isBefore){

       if(Trigger.isInsert){

			TaskDependencies td = new TaskDependencies(Trigger.new[0].project__c);
			for(ProjectTaskPred__c p :  Trigger.new  )
				td.InsertinfPred(p);
		    td.updateNow();

       }else if(Trigger.isUpdate){

			TaskDependencies td = new TaskDependencies(Trigger.new[0].project__c);
			for(ProjectTaskPred__c p :  Trigger.new  )
				td.InsertinfPred(p);
		    td.updateNow();

       }else if(Trigger.isDelete){

       }
   }else if(Trigger.isAfter){

       if(Trigger.isInsert){

       }else if(Trigger.isUpdate){

       }else if(Trigger.isDelete){

       }
   }



}