%dw 1.0
%output application/json
---
{
	'correlation_id': flowVars.pid,
	'pid': flowVars.pid,
	'directory': flowVars.request.directory,
	'source_server': '',
	'source_path': flowVars.request.directory,
	'destination_server': '',
	'destination_path': flowVars.request.directory ++ '/' ++ p('private_dir'),
	'destination_file': flowVars.pid ++ '_original.zip',
	'excludes': [ p('private_dir') ]
}
