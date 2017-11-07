%dw 1.0
%output application/java
%var getPageNumber = (path) -> (path match /(.*[^0-9])?(\d+).*/)[2]
%var getExtension = (path) -> (path match /.*\.(.*)/)[1]
%var filename = (path) -> (path match /(.*\/)?([^\/]*)/)[2]
%var basepath = (path) -> '' when not (path contains '/') otherwise (path match /(.*)\/[^\/]*/)[1]
%var destinationPath = (original, type) -> flowVars.request.directory ++ '/_complex/' ++ type
%var destinationName = (original, type, ext) -> flowVars.pid ++ '_' ++ flowVars.mets_date ++ '_' ++ getPageNumber(original) ++ '_' ++ type ++ '.' ++ ext
%var destinationNameMets = (original, type, ext) -> flowVars.pid ++ '_' ++ flowVars.mets_date ++ '_' ++ type ++ '.' ++ ext
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
	'destination_path': destinationPath($, type) when type != 'original_mets' otherwise destinationPath($, 'mets'),
	'destination_file': destinationName($, type, getExtension($)) when type != 'original_mets' and type != 'pdf' otherwise destinationNameMets($, type, getExtension($)),
	'source_path': flowVars.request.directory ++ '/' ++ basepath($),
	'source_file': filename($),
	'type': type,
	original: $
}