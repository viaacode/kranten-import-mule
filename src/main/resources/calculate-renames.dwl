%dw 1.0
%output application/java
%var fileFunctions = readUrl('classpath://file-functions.dwl')
%function destinationNameMets(original, type, ext, pid) (pid ++ '_' ++ type ++ '.' ++ ext)
%function filename(path) (path match /(.*\/)?([^\/]*)/)[2]
%function destinationPath(original, type, dir) (dir ++ '/_complex/' ++ type)

---
flowVars.data.files map using
(type = 'tif' when (lower $ contains 'tif') 
	otherwise (('alto') when (lower $ contains 'alto') 
	otherwise ('original_mets' when (lower $ contains 'xml')
	otherwise ('pdf' when (lower $ contains 'pdf') 
	otherwise ('jpg' when (lower $ contains 'jpg') 
	otherwise ('abbyy' when (lower $ contains 'abbyy')
	otherwise 'other')))))
) {
	'correlation_id' :flowVars.pid,
	'pid': flowVars.pid,
	'source_server': flowVars.request.host when flowVars.request.host != null otherwise p('hosted_at'),
	('username': flowVars.request.username) when flowVars.request.username != null,
	('password': flowVars.request.password) when flowVars.request.password != null,
	'destination_path': destinationPath($, type, flowVars.request.directory) when type != 'original_mets' otherwise destinationPath($, 'mets', flowVars.request.directory),
	'destination_file': fileFunctions.destinationName($, type, fileFunctions.getExtension($), flowVars.pid) when type != 'original_mets' and type != 'pdf' otherwise fileFunctions.destinationNameMets($, type, fileFunctions.getExtension($), flowVars.pid),
	'source_path': flowVars.request.directory ++ '/' ++ fileFunctions.basepath($),
	'source_file': filename($),
	'type': type,
	original: $
}