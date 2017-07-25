%dw 1.0
%output application/java
---
{
	'pid': flowVars.pid,
	'id': flowVars.request.id,
	'directory': p('sourcefiles.basepath') ++ payload.vol_cote ++ '/' ++ payload.vol_folder_name,
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
					//(lookup("organization", 'Soma')),
					(lookup("organization", payload.instelling)),
					'sp_name': { '#text': 'CEGESOMA' },
					'PID': { '#text': flowVars.pid },
					'dc_identifier_localid': { '#text': payload.vol_folder_name },
					//'dc_title': { '#text': payload.titre },
					'dc_titles': {
						'\$type': 'list',
						'archief': { '#text': 'OORLOG' },
						'deelarchief': { '#text': payload.type }
					},
					'dcterms_created': { '#text': (payload.datum_clean replace 'x' with 'u') },
					'dcterms_issued': { '#text': (payload.datum_clean replace 'x' with 'u') },
					'dc_subjects': {
						'\$type': 'list',
						Trefwoord: { '#text': payload.oorlog }
					},
					'dc_coverages': {
						'\$type': 'list',
						ruimte: { '#text': payload.plaats_van_uitgave }
					}
				}
			}
		}
	}
}