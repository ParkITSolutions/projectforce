trigger ProjectTaskPredBeforeInsert on ProjectTaskPred__c (Before Insert, Before Update, Before Delete, After Insert, After Update, After Delete) {

	TaskDependencies td = new TaskDependencies();


	
   if(Trigger.isBefore){

       if(Trigger.isInsert){

			for(ProjectTaskPred__c p :  Trigger.new  )
				td.InsertinfPred(p);

       }else if(Trigger.isUpdate){

			for(ProjectTaskPred__c p :  Trigger.new  )
				td.InsertinfPred(p);

       }else if(Trigger.isDelete){

       }
   }else if(Trigger.isAfter){

       if(Trigger.isInsert){

       }else if(Trigger.isUpdate){

       }else if(Trigger.isDelete){

       }
   }


   td.updateNow();

}