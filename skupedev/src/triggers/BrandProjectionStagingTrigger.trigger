trigger BrandProjectionStagingTrigger on Brand_Projection_Staging__c (after insert) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            //ProjectionHandler.handleInsert();
        }
    }
}