
#include "../../common/service/gsmsms.h"

#define MAX_RETRIES 1

void SMSDaemon(int argc, char *argv[]);

typedef struct {
	CFG_Entry       *IncludeNumbers, *ExcludeNumbers;
	unsigned int    commtimeout, 	 sendtimeout,   receivefrequency;
	unsigned char   *inboxpath, 	 *outboxpath, 	*sentsmspath;
	unsigned char   *errorsmspath, 	 *inboxformat,  *transmitformat;
	unsigned char   *deliveryreport, *logfilename,  *PINCode;

	unsigned char 	SMSID[200],prevSMSID[200];
	unsigned int 	retries;
} GSM_SMSDConfig;

typedef struct {
	GSM_Error	(*Init) (void);
	GSM_Error	(*SaveInboxSMS)  (GSM_MultiSMSMessage sms, GSM_SMSDConfig *Config);
	GSM_Error	(*FindOutboxSMS) (GSM_MultiSMSMessage *sms, GSM_SMSDConfig *Config, unsigned char *ID);
	GSM_Error	(*MoveSMS)  	 (unsigned char *sourcepath, unsigned char *destpath, unsigned char *ID,
                             		  int alwaysDelete);
} GSM_SMSDService;

void WriteSMSDLog(unsigned char *format, ...);

/* How should editor hadle tabs in this file? Add editor commands here.
 * vim: noexpandtab sw=8 ts=8 sts=8:
 */