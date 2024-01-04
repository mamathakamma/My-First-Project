public class HandleCustomException extends Exception {
    public static void LogException(Exception e) {
        LogException(e, '', '', null);
    }
    
    // Log Exception in CustomException object.
    // relatedToId: Case/object for which this error is logged.
    public static void LogException(Exception e, String recordId, String request, String response) {
            try {
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.');
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            // Governer Limit of executingQuery
            String QueryLimit = '1. SOQL Queries used / SOQL Queries allowed: ' + Limits.getQueries() + '/' + Limits.getLimitQueries();
            String DMLimit = '2. Number of records queried so far / Number allowed: ' + Limits.getDmlRows() + '/' + Limits.getLimitDmlRows();
            String DMLStat = '3. Number of DML statements used so far / Number allowed: ' + Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements();
            String CPUT = '4. Amount of CPU time (in ms) used so far / CPU usage time (in ms) allowed: ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime();
            // Log information in object
            Seerbit_Exception__c exc = new Seerbit_Exception__c();
            exc.Name = recordId;
            exc.Govt_Limit_in_Executing_Code__c = String.format('{0}\n{1}\n{2}\n{3}', new List<String> { QueryLimit, DMLimit, DMLStat, CPUT });
            exc.Exception_Message__c = e.getMessage();
            exc.Exception_Type__c = e.getTypeName();
            exc.Line_Number__c = e.getLineNumber();
            exc.StackTrace__c = e.getStackTraceString();
            exc.MethodName__c = methodName;
            exc.Class_Name__c = className;
            exc.Request__c = request;
            exc.Response__c = response;
            database.insert(exc);
        } finally {
        }
    }

    // Overloaded method to handle DmlException
   /* public static void LogException(DmlException e, String recordId, String request, String response) {
        try {
            // Extract relevant information from DmlException if needed
            String dmlExceptionMessage = e.getDmlMessage(0); // Replace 0 with the appropriate index
            LogException((Exception) e, recordId, request, response + '\nDmlException Message: ' + dmlExceptionMessage);
        } finally {
        }
    }*/
}