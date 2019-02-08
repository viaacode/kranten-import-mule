%dw 1.0
%output application/java
---
{
	'tifs': payload filter $.type == 'tif',
	'altos': payload filter $.type == 'alto',
	'jp2s': payload filter $.type == 'tif' map using (host = $.source_server) ({
		correlation_id: $.correlation_id,
		service: {
    		jp2_creator: {
				extra_options: '-no_palette',
				src_path: $.source_path ++ '/' ++ $.source_file,
             	dest_path: ($.destination_path ++ '/' ++ $.destination_file) replace 'tif' with 'jp2',
             	result_vhost: '/kranten',
             	result_queue: 'jp2_responses'
			}
		}
	}),
	'pdfs': payload filter $.type == 'pdf',
	'mets': payload filter $.type == 'original_mets',
	'jpgs': payload filter $.type == 'jpg'
}