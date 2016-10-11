%dw 1.0
%output application/java
---
{
	'tifs': payload filter $.type == 'tif',
	'altos': payload filter $.type == 'alto',
	'jp2s': payload filter $.type == 'tif' map using (host = $.source_server) ($ mapObject {
		('$$': $) when not ('$$' contains 'destination'),
		('$$': $ replace 'tif' with 'jp2') when (('$$' contains 'destination') and ($ != null)),
		'destination_server': host,
		'extra_options': '-no_palette'
	})
}
