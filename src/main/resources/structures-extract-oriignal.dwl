%dw 1.0
%output application/json
---
{
	"correlation_id": flowVars.pid,
	"directory": flowVars.request.directory,
	"destination": flowVars.request.directory ++ '/_complex/original.zip',
	"excludes": [ flowVars.request.directory ++ '_complex/' ]
}