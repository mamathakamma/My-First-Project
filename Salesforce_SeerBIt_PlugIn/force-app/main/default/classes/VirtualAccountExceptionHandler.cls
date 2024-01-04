public class VirtualAccountExceptionHandler {
    private static String exceptionMessage;

    public static String getExceptionMessage() {
        String message = exceptionMessage;
        // Clear the exception message to avoid displaying it multiple times
        exceptionMessage = null;
        return message;
    }

    public static void setExceptionMessage(String message) {
        exceptionMessage = message;
    }
}