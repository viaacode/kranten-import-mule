%dw 1.0
%output application/java
---
{
	'pid': flowVars.pid,
	'id': flowVars.row.id,
	'directory': flowVars.request.basedir, // ++ '/' ++ payload.vol_cote ++ '/' ++ payload.vol_folder_name,
	'fileUse': {
	    'essence': 'TAPE-SHARE-EVENTS',
	    'browse': 'DISK-SHARE-EVENTS',
	    'metadata': 'DISK-SHARE-EVENTS',
	    'video': 'TAPE-SHARE-EVENTS',
	    'archive': 'TAPE-SHARE-EVENTS'
	},
	'createOriginalZip': flowVars.request.createOriginalZip,
	'agents': [{
		'roles': [ 'CUSTODIAN' ],
		'type': 'ORGANIZATION',
		'name': 'Cegesoma'
	},{
		'roles': [ 'ARCHIVIST' ],
		'type': 'ORGANIZATION',
		'name': 'VIAA'
	}],

	'metadata': {
		'digital_object': {
			'MediaHAVEN_external_metadata': {
				'title': { '#text': payload.titre },
				'MDProperties': {
					'dc_titles': {
						'\$type': 'list',
						'archief': { '#text': 'OORLOG' },
						'deelarchief': { '#text': payload.type }
					},
					'date': { '#text': (payload.datum_clean replace 'x' with 'u') },
					'original_carrier_id': { '#text': payload.vol_folder_name },
					'sp_name': { '#text': 'CEGESOMA' },
					'PID': { '#text': flowVars.pid },
					//(lookup("organization", 'Soma')),
					(lookup("organization", payload.instelling)),
					'type': { '#text': 'Paper' },
					'subject': {
						'\$type': 'list',
						subject: { '#text': payload.oorlog }
					},

					placeoforigin: { "#text": payload.plaats_van_uitgave },
					carrier_date: { '#text': payload.datum_clean }
				}
			}
		}
	}
}