/*
   Copyright (C) Cfengine AS

   This file is part of Cfengine 3 - written and maintained by Cfengine AS.

   This program is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by the
   Free Software Foundation; version 3.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA

  To the extent this program is licensed as part of the Enterprise
  versions of Cfengine, the applicable Commerical Open Source License
  (COSL) may apply to this file if you as a licensee so wish it. See
  included file COSL.txt.

*/

#ifndef CFENGINE_CONVERSION_H
#define CFENGINE_CONVERSION_H

#include "cf3.defs.h"

MeasurePolicy MeasurePolicyFromString(char *s);
EnvironmentState EnvironmentStateFromString(char *s);
InsertMatchType InsertMatchTypeFromString(char *s);
Interval IntervalFromString(char *s);

char *EscapeQuotes(const char *s, char *out, int outSz);
char *MapAddress(char *addr);
long Months2Seconds(int m);



int SyslogPriority2Int(char *s);
enum cfdbtype Str2dbType(char *s);
char *Rlist2String(Rlist *list, char *sep);
int Signal2Int(char *s);
OutputLevel String2ReportLevel(char *typestr);
enum cfcomparison String2Comparison(char *s);
enum cflinktype String2LinkType(char *s);
DataType Typename2Datatype(char *name);
DataType GetControlDatatype(const char *varname, const BodySyntax *bp);
enum cfsbundle Type2Cfs(char *name);
enum representations String2Representation(char *s);
int GetBoolean(const char *val);
long Str2Int(const char *s);
long TimeAbs2Int(char *s);
double Str2Double(const char *s);
void IntRange2Int(char *intrange, long *min, long *max, const Promise *pp);
int Month2Int(char *string);
int MonthLen2Int(char *string, int len);
void TimeToDateStr(time_t t, char *outStr, int outStrSz);
const char *GetArg0(const char *execstr);
void CommPrefix(char *execstr, char *comm);
int NonEmptyLine(char *s);
int Day2Number(char *datestring);
void UtcShiftInterval(time_t t, char *out, int outSz);
enum action_policy Str2ActionPolicy(char *s);
enum version_cmp Str2PackageSelect(char *s);
enum package_actions Str2PackageAction(char *s);
enum cf_acl_method Str2AclMethod(char *string);
enum cf_acl_type Str2AclType(char *string);
enum cf_acl_inherit Str2AclInherit(char *string);
enum cf_srv_policy Str2ServicePolicy(char *string);
char *Dtype2Str(DataType dtype);
const char *DataTypeShortToType(char *short_type);
char *Item2String(Item *ip);
int IsRealNumber(char *s);
enum cfd_menu String2Menu(const char *s);

#ifndef __MINGW32__
UidList *Rlist2UidList(Rlist *uidnames, const Promise *pp);
GidList *Rlist2GidList(Rlist *gidnames, const Promise *pp);
uid_t Str2Uid(char *uidbuff, char *copy, const Promise *pp);
gid_t Str2Gid(char *gidbuff, char *copy, const Promise *pp);
#endif /* !__MINGW32__ */

#ifdef HAVE_NOVA

const char *Nova_LongArch(const char *arch);
const char *Nova_ShortArch(const char *arch);
int Nova_CoarseLaterThan(const char *key, const char *from);
int Nova_YearSlot(const char *day, const char *month, const char *lifecycle);
int Nova_LaterThan(const char *bigger, const char *smaller);
bool BundleQualifiedNameSplit(const char *qualified_bundle_name, char namespace_out[CF_MAXVARSIZE], char bundle_name_out[CF_MAXVARSIZE]);

/* Timestamp-functions are not standardised across SQL databases - provide a standard layer for simple functions */
char *SqlVariableExpand(const char *query);
#endif

#endif
