/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

TRIGGER PROCEDURE FOR DELETE OF gsc_session_property .

/* Created automatically using ERwin ICF Trigger template db/af/erw/afercustrg.i
   Do not change manually. Customisations to triggers should be placed in separate
   include files pulled into the trigger. ICF auto generates write trigger custom
   include files. Delete or create customisation include files need to be created
   manually. Be sure to put the hook in ERwin directly so as not to have you changes
   overwritten.
   User defined Macro (UDP) Summary (case sensitive)
   gsc_session_property           Expands to full table name, e.g. gsm_user
   %TableFLA            Expands to table unique code, e.g. gsmus
   %TableObj            If blank or not defined expands to table_obj with no prefix (framework standard)
                        If defined, uses this field as the object field
                        If set to "none" then indicates table does not have an object field
   XYZ                  Do not define so we can compare against an empty string

   See docs for explanation of replication macros 
*/   

&SCOPED-DEFINE TRIGGER_TABLE gsc_session_property
&SCOPED-DEFINE TRIGGER_FLA gscsp
&SCOPED-DEFINE TRIGGER_OBJ session_property_obj


DEFINE BUFFER lb_table FOR gsc_session_property.      /* Used for recursive relationships */
DEFINE BUFFER lb1_table FOR gsc_session_property.     /* Used for lock upgrades */

DEFINE BUFFER o_gsc_session_property FOR gsc_session_property.

/* Standard top of DELETE trigger code */
{af/sup/aftrigtopd.i}

  




/* Generated by ICF ERwin Template */
/* gsc_session_property has session specific values defined by gsm_session_type_property ON PARENT DELETE CASCADE */
&IF DEFINED(lbe_session_type_property) = 0 &THEN
  DEFINE BUFFER lbe_session_type_property FOR gsm_session_type_property.
  &GLOBAL-DEFINE lbe_session_type_property yes
&ENDIF
FOR EACH gsm_session_type_property NO-LOCK
   WHERE gsm_session_type_property.session_property_obj = gsc_session_property.session_property_obj
   ON STOP UNDO, RETURN ERROR "AF^104^gscsptrigd.p^delete gsm_session_type_property":U:
    FIND FIRST lbe_session_type_property EXCLUSIVE-LOCK
         WHERE ROWID(lbe_session_type_property) = ROWID(gsm_session_type_property)
         NO-ERROR.
    IF AVAILABLE lbe_session_type_property THEN
      DO:
        {af/sup/afvalidtrg.i &action = "DELETE" &table = "lbe_session_type_property"}
      END.
END.














/* Update Audit Log */
IF CAN-FIND(FIRST gsc_entity_mnemonic
            WHERE gsc_entity_mnemonic.entity_mnemonic = 'gscsp':U
              AND gsc_entity_mnemonic.auditing_enabled = YES) THEN
  RUN af/app/afauditlgp.p (INPUT "DELETE":U, INPUT "gscsp":U, INPUT BUFFER gsc_session_property:HANDLE, INPUT BUFFER o_gsc_session_property:HANDLE).

/* Standard bottom of DELETE trigger code */
{af/sup/aftrigendd.i}


/* Place any specific DELETE trigger customisations here */
