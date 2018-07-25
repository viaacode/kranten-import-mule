%dw 1.0
%output application/java
%function getPageNumber(path) (path match /(.*[^0-9])?(\d+).*/)[2]
%function getExtension(path) (path match /.*\.(.*)/)[1]
%function basepath(path) '' when not (path contains '/') otherwise (path match /(.*)\/[^\/]*/)[1]
%function destinationName(original, type, ext, pid) pid ++ '_' ++ getPageNumber(original) ++ '_' ++ type ++ '.' ++ ext
%function destinationNameMets(original, type, ext, pid) pid ++ '_' ++ type ++ '.' ++ ext
%function getType(filename) 'tif' when (lower filename contains 'tif') 
			otherwise (('alto') when (lower filename contains 'alto') 
			otherwise ('original_mets' when (lower filename contains 'xml')
			otherwise ('pdf' when (lower filename contains 'pdf') 
			otherwise ('jpg' when (lower filename contains 'jpg') 
			otherwise ('abbyy' when (lower filename contains 'abbyy')
			otherwise 'other')))))
---
{
	getPageNumber: getPageNumber,
	getExtension: getExtension,
	basepath: basepath,
	destinationName: destinationName,
	destinationNameMets: destinationNameMets,
	getType: getType
}