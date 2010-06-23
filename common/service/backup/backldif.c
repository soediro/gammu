
#include <string.h>
#include <ctype.h>

#include "../../../cfg/config.h"
#include "../../phone/nokia/nfunc.h"
#include "../../phone/nokia/dct3/n7110.h"
#include "../../misc/coding.h"
#include "../gsmlogo.h"
#include "../gsmmisc.h"
#include "backldif.h"

#ifdef GSM_ENABLE_BACKUP

static void SaveLDIFText(FILE *file, unsigned char *Name, unsigned char *Value)
{
	unsigned char Buffer[1000],Buffer2[1000];

	if (EncodeUTF8(Buffer, Value)) {
//		dprintf("%s\n",Buffer);
		EncodeBASE64(Buffer, Buffer2, strlen(Buffer));
		fprintf(file,"%s:: %s%c%c",Name,Buffer2,13,10);
	} else {
		fprintf(file,"%s: %s%c%c",Name,DecodeUnicodeString(Value),13,10);
	}
}

GSM_Error SaveLDIF(FILE *file, GSM_Backup *backup)
{
	int i, j;

	i=0;
	while (backup->PhonePhonebook[i]!=NULL) {
		for (j=0;j<backup->PhonePhonebook[i]->EntriesNum;j++) {
			switch (backup->PhonePhonebook[i]->Entries[j].EntryType) {
			case PBK_Name:
				SaveLDIFText(file, "dn", backup->PhonePhonebook[i]->Entries[j].Text);
				break;
			default:
				break;
			}
		}
		fprintf(file, "objectclass: top%c%c",13,10);
		fprintf(file, "objectclass: person%c%c",13,10);
		fprintf(file, "objectclass: organizationalPerson%c%c",13,10);
		fprintf(file, "objectclass: inetOrgPerson%c%c",13,10);
		fprintf(file, "objectclass: mozillaAbPersonObsolete%c%c",13,10);
		for (j=0;j<backup->PhonePhonebook[i]->EntriesNum;j++) {
			switch (backup->PhonePhonebook[i]->Entries[j].EntryType) {
			case PBK_Text_Postal:
				SaveLDIFText(file, "HomePostalAddress", backup->PhonePhonebook[i]->Entries[j].Text);
				break;
			case PBK_Text_URL:
				SaveLDIFText(file, "homeurl", backup->PhonePhonebook[i]->Entries[j].Text);
				break;
			case PBK_Name:
				SaveLDIFText(file, "givenName", backup->PhonePhonebook[i]->Entries[j].Text);
				SaveLDIFText(file, "cn", backup->PhonePhonebook[i]->Entries[j].Text);
				break;
			case PBK_Text_Note:
				SaveLDIFText(file, "Description", backup->PhonePhonebook[i]->Entries[j].Text);
				break;
			case PBK_Number_Work:
				SaveLDIFText(file, "workPhone", backup->PhonePhonebook[i]->Entries[j].Text);//not exist in Mozilla 1.4 win32
				break;
			case PBK_Number_Mobile:
				SaveLDIFText(file, "mobile", backup->PhonePhonebook[i]->Entries[j].Text);
				break;
			case PBK_Number_Pager:
				SaveLDIFText(file, "pager", backup->PhonePhonebook[i]->Entries[j].Text);
				break;
			case PBK_Number_Fax:
				SaveLDIFText(file, "fax", backup->PhonePhonebook[i]->Entries[j].Text);//facsimileTelephoneNumber
				break;
			case PBK_Number_Home:
				SaveLDIFText(file, "homePhone", backup->PhonePhonebook[i]->Entries[j].Text);
				break;
			case PBK_Number_General:
				SaveLDIFText(file, "telephoneNumber", backup->PhonePhonebook[i]->Entries[j].Text);//work in Mozilla 1.4 win32
				break;
			case PBK_Text_Email:
				SaveLDIFText(file, "mail", backup->PhonePhonebook[i]->Entries[j].Text);
				break;
			case PBK_Text_Email2:
				SaveLDIFText(file, "mozillaSecondEmail", backup->PhonePhonebook[i]->Entries[j].Text);
				break;
			case PBK_Text_Custom1:
				SaveLDIFText(file, "custom1", backup->PhonePhonebook[i]->Entries[j].Text);
				break;
			case PBK_Text_Custom2:
				SaveLDIFText(file, "custom2", backup->PhonePhonebook[i]->Entries[j].Text);
				break;
			case PBK_Text_Custom3:
				SaveLDIFText(file, "custom3", backup->PhonePhonebook[i]->Entries[j].Text);
				break;
			case PBK_Text_Custom4:
				SaveLDIFText(file, "custom4", backup->PhonePhonebook[i]->Entries[j].Text);
				break;
			case PBK_Text_Company:
				SaveLDIFText(file, "o", backup->PhonePhonebook[i]->Entries[j].Text);
				break;
			case PBK_Text_JobTitle:
				SaveLDIFText(file, "title", backup->PhonePhonebook[i]->Entries[j].Text);
				break;
			case PBK_Text_StreetAddress:
				SaveLDIFText(file, "homePostalAddress", backup->PhonePhonebook[i]->Entries[j].Text);
				break;
			case PBK_Text_City:
				SaveLDIFText(file, "mozillaHomeLocalityName", backup->PhonePhonebook[i]->Entries[j].Text);
				break;
			case PBK_Text_State:
				SaveLDIFText(file, "mozillaHomeState", backup->PhonePhonebook[i]->Entries[j].Text);
				break;
			case PBK_Text_Zip:
				SaveLDIFText(file, "mozillaHomePostalCode", backup->PhonePhonebook[i]->Entries[j].Text);
				break;
			case PBK_Text_Country:
				SaveLDIFText(file, "mozillaHomeCountryName", backup->PhonePhonebook[i]->Entries[j].Text);
				break;
			case PBK_Number_Other:
			case PBK_Caller_Group:
			case PBK_RingtoneID:
			case PBK_PictureID:
			case PBK_Date:
			case PBK_Category:
			case PBK_Private:
			case PBK_Text_LastName:
			case PBK_Text_FirstName:
				dprintf("Feature missed\n");
				break;
			}
		}
		fprintf(file, "%c%c",13,10);
		i++;
	}
	return GE_NONE;
}

static bool ReadLDIFText(char *Buffer, char *Start, char *Value)
{
	unsigned char 	Buffer2[1000],buff[200];
	int 		i;

	Value[0] = 0x00;

	strcpy(buff,Start);
	strcat(buff,":: ");
	if (!strncmp(Buffer,buff,strlen(buff))) {
		i = DecodeBASE64(Buffer+strlen(Start)+3, Buffer2, strlen(Buffer)-(strlen(Start)+3));
		dprintf("Text after DecodeBASE64 is \"%s\"\n",Buffer2);
		DecodeUTF8(Value, Buffer2, i);
		dprintf("Text after DecodeUTF8 is \"%s\"\n",DecodeUnicodeString(Value));
		return true;
	}
	strcpy(buff,Start);
	strcat(buff,": ");
	if (!strncmp(Buffer,buff,strlen(buff))) {
		EncodeUnicode(Value,Buffer+strlen(Start)+2,strlen(Buffer)-(strlen(Start)+2));
		dprintf("Text after EncodeUnicode is \"%s\"\n",DecodeUnicodeString(Value));
		return true;
	}
	return false;
}

static GSM_Error GSM_DecodeLDIFEntry(unsigned char *Buffer, int *Pos, GSM_PhonebookEntry *Pbk)
{
	unsigned char 	Line[2000],Buff[2000],Buff2[2000];
	int		Level = 0;

	Buff[0] 	= 0;
	Pbk->EntriesNum = 0;

	while (1) {
		MyGetLine(Buffer, Pos, Line);
		if (strlen(Line) == 0) break;
		switch (Level) {
		case 0:
			if (ReadLDIFText(Line, "objectclass", Buff)) {
				sprintf(Buff2,"%s",DecodeUnicodeString(Buff));
				if (!strcmp("mozillaAbPersonObsolete",Buff2)) {
					dprintf("level1\n");
					Level = 1;
				}
			}
			break;
		case 1:
			if (ReadLDIFText(Line, "dn", Buff)) {
				dprintf("entries num is %i\n",Pbk->EntriesNum);
				if (Pbk->EntriesNum == 0) return GE_EMPTY;
				return GE_NONE;
			}
			if (ReadLDIFText(Line, "givenName", Buff)) {
				CopyUnicodeString(Pbk->Entries[Pbk->EntriesNum].Text,Buff);
				Pbk->Entries[Pbk->EntriesNum].EntryType = PBK_Name;
				Pbk->EntriesNum++;
			}
			if (ReadLDIFText(Line, "telephoneNumber", Buff)) {
				CopyUnicodeString(Pbk->Entries[Pbk->EntriesNum].Text,Buff);
				Pbk->Entries[Pbk->EntriesNum].EntryType = PBK_Number_General;
				Pbk->EntriesNum++;
			}
			if (ReadLDIFText(Line, "mobile", Buff)) {
				CopyUnicodeString(Pbk->Entries[Pbk->EntriesNum].Text,Buff);
				Pbk->Entries[Pbk->EntriesNum].EntryType = PBK_Number_Mobile;
				Pbk->EntriesNum++;
			}
			if (ReadLDIFText(Line, "workPhone", Buff)) {
				CopyUnicodeString(Pbk->Entries[Pbk->EntriesNum].Text,Buff);
				Pbk->Entries[Pbk->EntriesNum].EntryType = PBK_Number_Work;
				Pbk->EntriesNum++;
			}
			if (ReadLDIFText(Line, "fax", Buff)) {
				CopyUnicodeString(Pbk->Entries[Pbk->EntriesNum].Text,Buff);
				Pbk->Entries[Pbk->EntriesNum].EntryType = PBK_Number_Fax;
				Pbk->EntriesNum++;
			}
			if (ReadLDIFText(Line, "homePhone",Buff)) {
				CopyUnicodeString(Pbk->Entries[Pbk->EntriesNum].Text,Buff);
				Pbk->Entries[Pbk->EntriesNum].EntryType = PBK_Number_Home;
				Pbk->EntriesNum++;
			}
			if (ReadLDIFText(Line, "Description", Buff)) {
				CopyUnicodeString(Pbk->Entries[Pbk->EntriesNum].Text,Buff);
				Pbk->Entries[Pbk->EntriesNum].EntryType = PBK_Text_Note;
				Pbk->EntriesNum++;
			}
			if (ReadLDIFText(Line, "HomePostalAddress", Buff)) {
				CopyUnicodeString(Pbk->Entries[Pbk->EntriesNum].Text,Buff);
				Pbk->Entries[Pbk->EntriesNum].EntryType = PBK_Text_Postal;
				Pbk->EntriesNum++;
			}
			if (ReadLDIFText(Line, "mail", Buff)) {
				CopyUnicodeString(Pbk->Entries[Pbk->EntriesNum].Text,Buff);
				Pbk->Entries[Pbk->EntriesNum].EntryType = PBK_Text_Email;
				Pbk->EntriesNum++;
			}
			if (ReadLDIFText(Line, "homeurl", Buff)) {
				CopyUnicodeString(Pbk->Entries[Pbk->EntriesNum].Text,Buff);
				Pbk->Entries[Pbk->EntriesNum].EntryType = PBK_Text_URL;
				Pbk->EntriesNum++;
			}
			/* FIXME: add rest */
			break;
		}
	}

	dprintf("entries num is %i\n",Pbk->EntriesNum);
	if (Pbk->EntriesNum == 0) return GE_EMPTY;
	return GE_NONE;
}

GSM_Error LoadLDIF(char *FileName, GSM_Backup *backup)
{
	GSM_File 		File;
	GSM_Error		error;
	GSM_PhonebookEntry	Pbk;
	int			numPbk = 0, Pos;

	File.Buffer = NULL;
	error = GSM_ReadFile(FileName, &File);
	if (error != GE_NONE) return error;

	Pos = 0;
	while (1) {
		error = GSM_DecodeLDIFEntry(File.Buffer, &Pos, &Pbk);
		if (error == GE_EMPTY) break;
		if (error != GE_NONE) return error;
		if (numPbk < GSM_BACKUP_MAX_PHONEPHONEBOOK) {
			backup->PhonePhonebook[numPbk] = malloc(sizeof(GSM_PhonebookEntry));
		        if (backup->PhonePhonebook[numPbk] == NULL) return GE_MOREMEMORY;
			backup->PhonePhonebook[numPbk + 1] = NULL;
		} else {
			dprintf("Increase GSM_BACKUP_MAX_PHONEPHONEBOOK\n");
			return GE_MOREMEMORY;
		}
		memcpy(backup->PhonePhonebook[numPbk],&Pbk,sizeof(GSM_PhonebookEntry));
		backup->PhonePhonebook[numPbk]->Location 	= numPbk + 1;
		backup->PhonePhonebook[numPbk]->MemoryType 	= GMT_ME;
		numPbk++;
	}

	return GE_NONE;
}

#endif

/* How should editor hadle tabs in this file? Add editor commands here.
 * vim: noexpandtab sw=8 ts=8 sts=8:
 */