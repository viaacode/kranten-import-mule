package be.viaa.exceptions;

public class StepFailedException extends ViaaException {

	public StepFailedException() {
		super();
	}

	public StepFailedException(String message, Throwable cause) {
		super(message, cause);
	}

	public StepFailedException(String message) {
		super(message);
	}

	public StepFailedException(Throwable cause) {
		super(cause);
	}

}
