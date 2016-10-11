%dw 1.0
%output application/java
%var getPageNumber = (path) -> (path match  /(.*[^0-9])?(\d+).*/)[2]
%var filename = (path) -> (path match /(.*\/)?([^\/]*)/)[2]
%var basepath = (path) -> '' when not (path contains '/') otherwise (path match /(.*)\/[^\/]*/)[1]
%var destinationPath = (original, type) -> flowVars.request.directory ++ '/_complex/' ++ type
%var destinationName = (original, type, ext) -> flowVars.pid ++ '_' ++ getPageNumber (original) ++ '_' ++ type ++ '.' ++ ext
---
flowVars.data.files map using (type = 'tif' when ($ contains 'tif') otherwise 'alto' when ($ contains 'alto') otherwise 'other') {
	'correlation_id' :flowVars.pid,
	'pid': flowVars.pid,
	'source_server': flowVars.request.host when flowVars.request.host != null otherwise p ('hosted_at'),
	('username': flowVars.request.username) when flowVars.request.username != null,
	('password': flowVars.request.password) when flowVars.request.password != null,
	'destination_path': destinationPath ($, type),
	'destination_file': destinationName ($, type, ('xml' when type == 'alto' otherwise type)),
	'source_path': flowVars.request.directory ++ '/' ++ basepath ($),
	'source_file': filename ($),
	'type': type
}