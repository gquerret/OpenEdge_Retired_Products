/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

TRIGGER PROCEDURE FOR DELETE OF gsm_session_type .

/* Created automatically using ERwin ICF Trigger template db/af/erw/afercustrg.i
   Do not change manually. Customisations to triggers should be placed in separate
   include files pulled into the trigger. ICF auto generates write trigger custom
   include files. Delete or create customisation include files need to be created
   manually. Be sure to put the hook in ERwin directly so as not to have you changes
   overwritten.
   User defined Macro (UDP) Summary (case sensitive)
   gsm_session_type           Expands to full table name, e.g. gsm_user
   %TableFLA            Expands to table unique code, e.g. gsmus
   %TableObj            If blank or not defined expands to table_obj with no prefix (framework standard)
                        If defined, uses this field as the object field
                        If set to "none" then indicates table does not have an object field
   XYZ                  Do not define so we can compare against an empty string

   See docs for explanation of replication macros 
*/   

&SCOPED-DEFINE TRIGGER_TABLE gsm_session_type
&SCOPED-DEFINE TRIGGER_FLA gsmse
&SCOPED-DEFINE TRIGGER_OBJ session_type_obj


DEFINE BUFFER lb_table FOR gsm_session_type.      /* Used for recursive relationships */
DEFINE BUFFER lb1_table FOR gsm_session_type.     /* Used for lock upgrades */

DEFINE BUFFER o_gsm_session_type FOR gsm_session_type.

/* Standard top of DELETE trigger code */
{af/sup/aftrigtopd.i}

  




/* Generated by ICF ERwin Template */
/* gsm_session_type  gst_session ON PARENT DELETE SET NULL */

&IF DEFINED(lbe_session) = 0 &THEN
  DEFINE BUFFER lbe_session FOR gst_session.
  &GLOBAL-DEFINE lbe_session yes
&ENDIF
FOR EACH gst_session NO-LOCK
   WHERE gst_session.session_type_obj = gsm_session_type.session_type_obj
   ON STOP UNDO, RETURN ERROR "AF^104^gsmsetrigd.p^update gst_session":U:
    FIND FIRST lbe_session EXCLUSIVE-LOCK
         WHERE ROWID(lbe_session) = ROWID(gst_session)
         NO-ERROR.
    IF AVAILABLE lbe_session THEN
      DO:
        
        ASSIGN lbe_session.session_type_obj = 0 .
      END.
END.



/* Generated by ICF ERwin Template */
/* gsm_session_type is extended by gsm_session_type ON PARENT DELETE SET NULL */


FOR EACH lb_table NO-LOCK
   WHERE lb_table.extends_session_type_obj = gsm_session_type.session_type_obj
   ON STOP UNDO, RETURN ERROR "AF^104^gsmsetrigd.p^update gsm_session_type":U:
    FIND FIRST lb1_table EXCLUSIVE-LOCK
         WHERE ROWID(lb1_table) = ROWID(lb_table)
         NO-ERROR.
    IF AVAILABLE lb1_table THEN
      DO:
        
        ASSIGN lb1_table.extends_session_type_obj = 0 .
      END.
END.


/* Generated by ICF ERwin Template */
/* gsm_session_type is modified by gsm_session_type_property ON PARENT DELETE CASCADE */
&IF DEFINED(lbe_session_type_property) = 0 &THEN
  DEFINE BUFFER lbe_session_type_property FOR gsm_session_type_property.
  &GLOBAL-DEFINE lbe_session_type_property yes
&ENDIF
FOR EACH gsm_session_type_property NO-LOCK
   WHERE gsm_session_type_property.session_type_obj = gsm_session_type.session_type_obj
   ON STOP UNDO, RETURN ERROR "AF^104^gsmsetrigd.p^delete gsm_session_type_property":U:
    FIND FIRST lbe_session_type_property EXCLUSIVE-LOCK
         WHERE ROWID(lbe_session_type_property) = ROWID(gsm_session_type_property)
         NO-ERROR.
    IF AVAILABLE lbe_session_type_property THEN
      DO:
        {af/sup/afvalidtrg.i &action = "DELETE" &table = "lbe_session_type_property"}
      END.
END.





/* Generated by ICF ERwin Template */
/* gsm_session_type has access to gsm_session_service ON PARENT DELETE CASCADE */
&IF DEFINED(lbe_session_service) = 0 &THEN
  DEFINE BUFFER lbe_session_service FOR gsm_session_service.
  &GLOBAL-DEFINE lbe_session_service yes
&ENDIF
FOR EACH gsm_session_service NO-LOCK
   WHERE gsm_session_service.session_type_obj = gsm_session_type.session_type_obj
   ON STOP UNDO, RETURN ERROR "AF^104^gsmsetrigd.p^delete gsm_session_service":U:
    FIND FIRST lbe_session_service EXCLUSIVE-LOCK
         WHERE ROWID(lbe_session_service) = ROWID(gsm_session_service)
         NO-ERROR.
    IF AVAILABLE lbe_session_service THEN
      DO:
        {af/sup/afvalidtrg.i &action = "DELETE" &table = "lbe_session_service"}
      END.
END.





/* Generated by ICF ERwin Template */
/* gsm_session_type is responsible for starting gsm_required_manager ON PARENT DELETE CASCADE */
&IF DEFINED(lbe_required_manager) = 0 &THEN
  DEFINE BUFFER lbe_required_manager FOR gsm_required_manager.
  &GLOBAL-DEFINE lbe_required_manager yes
&ENDIF
FOR EACH gsm_required_manager NO-LOCK
   WHERE gsm_required_manager.session_type_obj = gsm_session_type.session_type_obj
   ON STOP UNDO, RETURN ERROR "AF^104^gsmsetrigd.p^delete gsm_required_manager":U:
    FIND FIRST lbe_required_manager EXCLUSIVE-LOCK
         WHERE ROWID(lbe_required_manager) = ROWID(gsm_required_manager)
         NO-ERROR.
    IF AVAILABLE lbe_required_manager THEN
      DO:
        {af/sup/afvalidtrg.i &action = "DELETE" &table = "lbe_required_manager"}
      END.
END.





/* Generated by ICF ERwin Template */
/* gsm_session_type initializes with gsm_startup_flow ON PARENT DELETE CASCADE */
&IF DEFINED(lbe_startup_flow) = 0 &THEN
  DEFINE BUFFER lbe_startup_flow FOR gsm_startup_flow.
  &GLOBAL-DEFINE lbe_startup_flow yes
&ENDIF
FOR EACH gsm_startup_flow NO-LOCK
   WHERE gsm_startup_flow.session_type_obj = gsm_session_type.session_type_obj
   ON STOP UNDO, RETURN ERROR "AF^104^gsmsetrigd.p^delete gsm_startup_flow":U:
    FIND FIRST lbe_startup_flow EXCLUSIVE-LOCK
         WHERE ROWID(lbe_startup_flow) = ROWID(gsm_startup_flow)
         NO-ERROR.
    IF AVAILABLE lbe_startup_flow THEN
      DO:
        {af/sup/afvalidtrg.i &action = "DELETE" &table = "lbe_startup_flow"}
      END.
END.














/* Update Audit Log */
IF CAN-FIND(FIRST gsc_entity_mnemonic
            WHERE gsc_entity_mnemonic.entity_mnemonic = 'gsmse':U
              AND gsc_entity_mnemonic.auditing_enabled = YES) THEN
  RUN af/app/afauditlgp.p (INPUT "DELETE":U, INPUT "gsmse":U, INPUT BUFFER gsm_session_type:HANDLE, INPUT BUFFER o_gsm_session_type:HANDLE).

/* Standard bottom of DELETE trigger code */
{af/sup/aftrigendd.i}


/* Place any specific DELETE trigger customisations here */
