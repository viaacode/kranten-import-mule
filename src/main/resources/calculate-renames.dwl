%dw 1.0
%output application/json
%function getPageNumber(path) (path match /(.*[^0-9])?(\d+).*/)[2]
%function getDynamicPageNumber(path, regex, index) extractRegexGroup(path, regex, index)
%function getExtension(path) (path match /.*\.(.*)/)[1]
%function basepath(path) '' when not (path contains '/') otherwise (path match /(.*)\/[^\/]*/)[1]
%function destinationName(original, type, ext, pid, pagenumberregex, index) (pid ++ '_' ++ getDynamicPageNumber(original, pagenumberregex, index) ++ '_' ++ type ++ '.' ++ ext) when (pagenumberregex != null and index != null) otherwise (pid ++ '_' ++ getPageNumber(original) ++ '_' ++ type ++ '.' ++ ext)
%function destinationNameMets(original, type, ext, pid) pid ++ '_' ++ type ++ '.' ++ ext
%function getType(filename) 'tif' when (lower filename contains 'tif') 
			otherwise (('alto') when (lower filename contains 'alto') 
			otherwise ('original_mets' when (lower filename contains 'xml')
			otherwise ('pdf' when (lower filename contains 'pdf') 
			otherwise ('jpg' when (lower filename contains 'jpg') 
			otherwise ('abbyy' when (lower filename contains 'abbyy')
			otherwise 'other')))))
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
	//								call destinationName with the 2 last params being (regex, matchinggroup) to get the page number.
	//								both can be null to use default matching
	'destination_file': destinationName($, type, getExtension($), flowVars.pid, "(.*)?-(\\d{3})-.*", flowVars.request.getPageNumberMatchingGroup) when type != 'original_mets' and type != 'pdf' otherwise fileFunctions.destinationNameMets($, type, fileFunctions.getExtension($), flowVars.pid),
	'source_path': flowVars.request.directory ++ '/' ++ basepath($),
	'source_file': filename($),
	'type': type,
	original: $
}