public class AuswalkUtilsApexClass {

    /**This Method Would get the record type
RCTName-> pass recordtype name
return : list of recordtype
*/
    public static list<RecordType> getRecordType(string RCTName){
        
		list<RecordType> rtList = [SELECT id, Name FROM RecordType WHERE Name =:RCTName];
        system.debug('rtList: '+rtList);
        Return rtList;
    }
    
    /**
This Method would get a list of record types
objectName-> object name
*/
    public static Map<Id,RecordType> getObjectRecordType(string objectName){
        Map<Id,RecordType> rtMap = new Map<Id,RecordType>();
        
        list<RecordType> rtList = [SELECT Id,Name,sObjectType, IsActive From RecordType WHERE sObjectType=:objectName];
        system.debug('rtList: '+rtList);
        
        for(RecordType rt:rtList){
			    rtMap.put(rt.Id,rt);        
        }
        Return rtMap;
    }
    
    
}