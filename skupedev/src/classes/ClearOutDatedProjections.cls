public class ClearOutDatedProjections {
	
    public PageReference clear(){
        Database.executeBatch(new DeleteProjectedSKUs());
        Database.executeBatch(new DeleteProjectedBrands());
        Database.executeBatch(new ResetBrandDiscoProjections());
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info,'Jobs have been submitted to clear projections older than today. '+
			'You will receive an email when they are done'));
        return null;
    }
}