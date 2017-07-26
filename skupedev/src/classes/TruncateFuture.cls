public class TruncateFuture{
    @future
    public static void truncate(Set<Id> recIds,String sobjName){
        delete Database.query('Select Id from '+sobjname+' where ID in :recIds');
    }
}