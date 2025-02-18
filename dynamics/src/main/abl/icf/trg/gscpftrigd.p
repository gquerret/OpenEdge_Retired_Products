/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

TRIGGER PROCEDURE FOR DELETE OF gsc_profile_type .

/* Created automatically using ERwin ICF Trigger template db/af/erw/afercustrg.i
   Do not change manually. Customisations to triggers should be placed in separate
   include files pulled into the trigger. ICF auto generates write trigger custom
   include files. Delete or create customisation include files need to be created
   manually. Be sure to put the hook in ERwin directly so as not to have you changes
   overwritten.
   User defined Macro (UDP) Summary (case sensitive)
   gsc_profile_type           Expands to full table name, e.g. gsm_user
   %TableFLA            Expands to table unique code, e.g. gsmus
   %TableObj            If blank or not defined expands to table_obj with no prefix (framework standard)
                        If defined, uses this field as the object field
                        If set to "none" then indicates table does not have an object field
   XYZ                  Do not define so we can compare against an empty string

   See docs for explanation of replication macros 
*/   

&SCOPED-DEFINE TRIGGER_TABLE gsc_profile_type
&SCOPED-DEFINE TRIGGER_FLA gscpf
&SCOPED-DEFINE TRIGGER_OBJ profile_type_obj


DEFINE BUFFER lb_table FOR gsc_profile_type.      /* Used for recursive relationships */
DEFINE BUFFER lb1_table FOR gsc_profile_type.     /* Used for lock upgrades */

DEFINE BUFFER o_gsc_profile_type FOR gsc_profile_type.

/* Standard top of DELETE trigger code */
{af/sup/aftrigtopd.i}

  




/* Generated by ICF ERwin Template */
/* gsc_profile_type consists of gsc_profile_code ON PARENT DELETE CASCADE */
&IF DEFINED(lbe_profile_code) = 0 &THEN
  DEFINE BUFFER lbe_profile_code FOR gsc_profile_code.
  &GLOBAL-DEFINE lbe_profile_code yes
&ENDIF
FOR EACH gsc_profile_code NO-LOCK
   WHERE gsc_profile_code.profile_type_obj = gsc_profile_type.profile_type_obj
   ON STOP UNDO, RETURN ERROR "AF^104^gscpftrigd.p^delete gsc_profile_code":U:
    FIND FIRST lbe_profile_code EXCLUSIVE-LOCK
         WHERE ROWID(lbe_profile_code) = ROWID(gsc_profile_code)
         NO-ERROR.
    IF AVAILABLE lbe_profile_code THEN
      DO:
        {af/sup/afvalidtrg.i &action = "DELETE" &table = "lbe_profile_code"}
      END.
END.














/* Update Audit Log */
IF CAN-FIND(FIRST gsc_entity_mnemonic
            WHERE gsc_entity_mnemonic.entity_mnemonic = 'gscpf':U
              AND gsc_entity_mnemonic.auditing_enabled = YES) THEN
  RUN af/app/afauditlgp.p (INPUT "DELETE":U, INPUT "gscpf":U, INPUT BUFFER gsc_profile_type:HANDLE, INPUT BUFFER o_gsc_profile_type:HANDLE).

/* Standard bottom of DELETE trigger code */
{af/sup/aftrigendd.i}


/* Place any specific DELETE trigger customisations here */
