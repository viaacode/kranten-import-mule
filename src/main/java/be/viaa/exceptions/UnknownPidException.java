package be.viaa.exceptions;

public class UnknownPidException extends ViaaException {

	public UnknownPidException() {
		super();
	}

	public UnknownPidException(String message, Throwable cause) {
		super(message, cause);
	}

	public UnknownPidException(String message) {
		super("Unknown pid: " + message);
	}

	public UnknownPidException(Throwable cause) {
		super(cause);
	}

}
