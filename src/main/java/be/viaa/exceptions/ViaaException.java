package be.viaa.exceptions;

public class ViaaException extends RuntimeException {

	public ViaaException() {
		super();
	}

	public ViaaException(String message, Throwable cause) {
		super(message, cause);
	}

	public ViaaException(String message) {
		super(message);
	}

	public ViaaException(Throwable cause) {
		super(cause);
	}

}
