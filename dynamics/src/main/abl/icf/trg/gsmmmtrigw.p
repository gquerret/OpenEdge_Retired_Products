/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/

TRIGGER PROCEDURE FOR WRITE OF gsm_multi_media OLD BUFFER o_gsm_multi_media.

/* Created automatically using ERwin ICF Trigger template db/af/erw/afercustrg.i
   Do not change manually. Customisations to triggers should be placed in separate
   include files pulled into the trigger. ICF auto generates write trigger custom
   include files. Delete or create customisation include files need to be created
   manually. Be sure to put the hook in ERwin directly so as not to have you changes
   overwritten.
   User defined Macro (UDP) Summary (case sensitive)
   gsm_multi_media           Expands to full table name, e.g. gsm_user
   %TableFLA            Expands to table unique code, e.g. gsmus
   %TableObj            If blank or not defined expands to table_obj with no prefix (framework standard)
                        If defined, uses this field as the object field
                        If set to "none" then indicates table does not have an object field
   XYZ                  Do not define so we can compare against an empty string

   See docs for explanation of replication macros 
*/   

&SCOPED-DEFINE TRIGGER_TABLE gsm_multi_media
&SCOPED-DEFINE TRIGGER_FLA gsmmm
&SCOPED-DEFINE TRIGGER_OBJ multi_media_obj


DEFINE BUFFER lb_table FOR gsm_multi_media.      /* Used for recursive relationships */
DEFINE BUFFER lb1_table FOR gsm_multi_media.     /* Used for lock upgrades */



/* Standard top of WRITE trigger code */
{af/sup/aftrigtopw.i}

/* properform fields if enabled for table */
IF CAN-FIND(FIRST gsc_entity_mnemonic
            WHERE gsc_entity_mnemonic.entity_mnemonic = 'gsmmm':U
              AND gsc_entity_mnemonic.auto_properform_strings = YES) THEN
  RUN af/app/afpropfrmp.p (INPUT BUFFER gsm_multi_media:HANDLE).
  



/* Generated by ICF ERwin Template */
/* gsc_multi_media_type  gsm_multi_media ON CHILD UPDATE RESTRICT */
IF NEW gsm_multi_media OR  gsm_multi_media.multi_media_type_obj <> o_gsm_multi_media.multi_media_type_obj  THEN
  DO:
    IF NOT(CAN-FIND(FIRST gsc_multi_media_type WHERE
        gsm_multi_media.multi_media_type_obj = gsc_multi_media_type.multi_media_type_obj)) THEN
              DO:
                /* Cannot update child because parent does not exist ! */
                ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 103 lv-include = "gsm_multi_media|gsc_multi_media_type":U.
                RUN error-message (lv-errgrp, lv-errnum, lv-include).
              END.
    
    
  END.

/* Generated by ICF ERwin Template */
/* gsm_category of gsm_multi_media ON CHILD UPDATE RESTRICT */
IF NEW gsm_multi_media OR  gsm_multi_media.category_obj <> o_gsm_multi_media.category_obj  THEN
  DO:
    IF NOT(CAN-FIND(FIRST gsm_category WHERE
        gsm_multi_media.category_obj = gsm_category.category_obj)) THEN
              DO:
                /* Cannot update child because parent does not exist ! */
                ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 103 lv-include = "gsm_multi_media|gsm_category":U.
                RUN error-message (lv-errgrp, lv-errnum, lv-include).
              END.
    
    
  END.








IF NOT NEW gsm_multi_media AND gsm_multi_media.{&TRIGGER_OBJ} <> o_gsm_multi_media.{&TRIGGER_OBJ} THEN
    DO:
        ASSIGN lv-error = YES lv-errgrp = "AF":U lv-errnum = 13 lv-include = "table object number":U.
        RUN error-message (lv-errgrp,lv-errnum,lv-include).
    END.

/* Customisations to WRITE trigger */
{icf/trg/gsmmmtrigw.i}



/* Update Audit Log */
IF CAN-FIND(FIRST gsc_entity_mnemonic
            WHERE gsc_entity_mnemonic.entity_mnemonic = 'gsmmm':U
              AND gsc_entity_mnemonic.auditing_enabled = YES) THEN
  RUN af/app/afauditlgp.p (INPUT "WRITE":U, INPUT "gsmmm":U, INPUT BUFFER gsm_multi_media:HANDLE, INPUT BUFFER o_gsm_multi_media:HANDLE).

/* Standard bottom of WRITE trigger code */
{af/sup/aftrigendw.i}



