global class CreateInventoryTasks implements Database.Batchable<Inventory__c>,Database.Stateful{

     global Map<String,Inventory_Steam_Task__c> skuPlantTaskMap = new Map<String,Inventory_Steam_Task__c>();

     global Iterable<Inventory__c> start(Database.BatchableContext bc){
        return [Select Plant__c, Plant__r.Name,Brand__r.SKU__c,Brand__r.Brand_Code__c,Brand__r.SKU__r.SKU__c,Batch_Number__c,Total_Value__c from Inventory__c where Status__c='Ready for Steaming' and Inventory_Steam_Task__c=null and Is_Inventory_Missing__c=false];
    }

    global void execute(Database.BatchableContext bc,Inventory__c[] inventories){
        //Task[] tasksToCreate = new Task[]{};
        List<Inventory_Steam_Task__c> invTasksToCreate = new List<Inventory_Steam_Task__c>();
        Set<String> tasksInThisBatch = new Set<String>();
        
        /*Map<Id,Task> skuTaskMap = new Map<Id,Task>();
        for(Inventory__c inv: inventories){
            skuIds.add(inv.Brand__r.SKU__c);
        }
        for(Task t: [Select Id,whatid from Task where WhatId in :skuIds and Type='Steaming Request']){
            skuTaskMap.put(t.whatid,t);
        }*/

        for(Inventory__c inv: inventories){
           /* if(!skuTaskMap.containsKey(inv.Brand__r.SKU__c)){
                tasksToCreate.add(new Task(WhatId=inv.Brand__r.SKU__c,Plant__c=inv.Plant__c,Description=inv.Batch_Number__c+'-'+inv.Total_Value__c,InventorySteamTask__r=new Inventory_Steam_Task__c(Inventory_Task_Unique_Id__c=inv.Brand__r.SKU__r.SKU__c+'-'+inv.Plant__r.Name+'-'+System.today()),Status='Not Started',ActivityDate=System.today()+7) );
            }*/
            if(skuPlantTaskMap.containsKey(''+inv.Brand__r.SKU__c+inv.Plant__c)){
            // Task t = skuPlantTaskMap.get(''+inv.Brand__r.SKU__c+inv.Plant__c);
                Inventory_Steam_Task__c  invTask = skuPlantTaskMap.get(''+inv.Brand__r.SKU__c+inv.Plant__c);
                invTask.Description__c+='\n'+inv.Brand__r.Brand_Code__c+'-'+inv.Batch_Number__c+'-'+inv.Total_Value__c;
                if(!tasksInThisBatch.contains(''+inv.Brand__r.SKU__c+inv.Plant__c)){
                    invTasksToCreate.add(invTask);
                    tasksInThisBatch.add(''+inv.Brand__r.SKU__c+inv.Plant__c);
                }
            }else{
                Inventory_Steam_Task__c  invTask = new Inventory_Steam_Task__c  (Name='Inv Task for '+inv.Brand__r.SKU__r.SKU__c+'-'+inv.Plant__r.Name+'-'+System.today(),Inventory_Task_Unique_Id__c=inv.Brand__r.SKU__r.SKU__c+'-'+inv.Plant__r.Name+'-'+System.today(),Status__c='Not Started',SKU__c=inv.Brand__r.SKU__c,Plant__c=inv.Plant__c,Description__c=inv.Brand__r.Brand_Code__c+'-'+inv.Batch_Number__c+'-'+inv.Total_Value__c);
                /*Task t = new Task(WhatId=inv.Brand__r.SKU__c,Plant__c=inv.Plant__c,Description=inv.Batch_Number__c+'-'+inv.Total_Value__c,InventorySteamTask__r=new Inventory_Steam_Task__c(Inventory_Task_Unique_Id__c=inv.Brand__r.SKU__r.SKU__c+'-'+inv.Plant__r.Name+'-'+System.today()),Status='Not Started',ActivityDate=System.today()+7);*/
                skuPlantTaskMap.put(''+inv.Brand__r.SKU__c+inv.Plant__c,invTask);
                //tasksToCreate.add(t);
                invTasksToCreate.add(invTask);
                tasksInThisBatch.add(''+inv.Brand__r.SKU__c+inv.Plant__c);
            }
            inv.Inventory_Steam_Task__r = new Inventory_Steam_Task__c(Inventory_Task_Unique_Id__c=inv.Brand__r.SKU__r.SKU__c+'-'+inv.Plant__r.Name+'-'+System.today()); 
        }
        if(invTasksToCreate.size()>0){
            upsert invTasksToCreate Inventory_Task_Unique_Id__c;
        }
        if(inventories.size()>0){
            update inventories;
        }
        /*if(tasksToCreate.size()>0){
            insert tasksToCreate;
        }*/
    }
    
    global void finish(Database.BatchableContext bc){
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
       /* AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob WHERE Id =
            :BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Create Inventory Steaming Tasks ' + a.Status);
        mail.setPlainTextBody
        ('The batch Apex job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        */
    }

}