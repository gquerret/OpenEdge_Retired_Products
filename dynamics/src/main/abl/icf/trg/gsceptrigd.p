/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

TRIGGER PROCEDURE FOR DELETE OF gsc_entity_mnemonic_procedure .

/* Created automatically using ERwin ICF Trigger template db/af/erw/afercustrg.i
   Do not change manually. Customisations to triggers should be placed in separate
   include files pulled into the trigger. ICF auto generates write trigger custom
   include files. Delete or create customisation include files need to be created
   manually. Be sure to put the hook in ERwin directly so as not to have you changes
   overwritten.
   User defined Macro (UDP) Summary (case sensitive)
   gsc_entity_mnemonic_procedure           Expands to full table name, e.g. gsm_user
   %TableFLA            Expands to table unique code, e.g. gsmus
   %TableObj            If blank or not defined expands to table_obj with no prefix (framework standard)
                        If defined, uses this field as the object field
                        If set to "none" then indicates table does not have an object field
   XYZ                  Do not define so we can compare against an empty string

   See docs for explanation of replication macros 
*/   

&SCOPED-DEFINE TRIGGER_TABLE gsc_entity_mnemonic_procedure
&SCOPED-DEFINE TRIGGER_FLA gscep
&SCOPED-DEFINE TRIGGER_OBJ entity_mnemonic_procedure_obj


DEFINE BUFFER lb_table FOR gsc_entity_mnemonic_procedure.      /* Used for recursive relationships */
DEFINE BUFFER lb1_table FOR gsc_entity_mnemonic_procedure.     /* Used for lock upgrades */

DEFINE BUFFER o_gsc_entity_mnemonic_procedure FOR gsc_entity_mnemonic_procedure.

/* Standard top of DELETE trigger code */
{af/sup/aftrigtopd.i}

  













/* Update Audit Log */
IF CAN-FIND(FIRST gsc_entity_mnemonic
            WHERE gsc_entity_mnemonic.entity_mnemonic = 'gscep':U
              AND gsc_entity_mnemonic.auditing_enabled = YES) THEN
  RUN af/app/afauditlgp.p (INPUT "DELETE":U, INPUT "gscep":U, INPUT BUFFER gsc_entity_mnemonic_procedure:HANDLE, INPUT BUFFER o_gsc_entity_mnemonic_procedure:HANDLE).

/* Standard bottom of DELETE trigger code */
{af/sup/aftrigendd.i}


/* Place any specific DELETE trigger customisations here */




