&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Include _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* ICF Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Include _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Include _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/* Copyright � 2000-2006 by Progress Software Corporation.  All rights 
   reserved.  Prior versions of this work may contain portions 
   contributed by participants of Possenet.  */   
/*---------------------------------------------------------------------------------

  File: gscsqtrigw.i

  Description:  ICF Template write trigger customisation

  Purpose:      This file is originally generated by ERwin from the template
                af/sup/aftemtrigw.i
                to hold customisations to the table write trigger for additional
                validation, etc.
                Once the file has been customised, it can no longer be regenerated
                from ERwin. 

  Parameters:

  History:
  --------
  (v:010000)    Task:   90000034    UserRef:    POSSE
                Date:   26/03/2001  Author:     Anthony Swindells

  Update Notes: Convert to make work for POSSE

-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       aftemtrigw.i
&scop object-version    010000

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 1.99
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

    DEFINE VARIABLE lv_counter   AS INTEGER      NO-UNDO.
    
    /* (1) If we had multi transaction set, but have changed it back, delete the sequences 
       and update the next sequence.

       (2) If we are using multi_transaction sequences, and the value of the 
       sequence next_value has changed, then also delete the next sequence records
       so that we can re-create them,

       (3) If the number of sequences changes, then delete the existing values so
       that we can create the correct number of next sequence records. */
    IF  ( NOT gsc_sequence.multi_transaction or
          gsc_sequence.next_value ne o_gsc_sequence.next_value or
          gsc_sequence.number_of_sequences ne o_gsc_sequence.number_of_sequences )
    AND CAN-FIND(FIRST gsc_next_sequence
                 WHERE gsc_next_sequence.sequence_obj = gsc_sequence.sequence_obj)
    THEN DO:
        /* if we've turned the multi_transaction flag off, then
           set the sequence record's next_value to the next available value
           in the set of next sequence records, before deleting the next
           sequence records. 
           
           do NOT do this in the case of a changed next_sequence value,
           since this would kinda invalidate the change we've just made.
         */
        if not gsc_sequence.multi_transaction then
        do:    
            FIND FIRST gsc_next_sequence EXCLUSIVE-LOCK
                WHERE gsc_next_sequence.sequence_obj = gsc_sequence.sequence_obj
                NO-WAIT NO-ERROR.
            IF LOCKED gsc_next_sequence
            THEN locked-blk:
            REPEAT:
                FIND FIRST gsc_next_sequence EXCLUSIVE-LOCK
                     WHERE gsc_next_sequence.sequence_obj = gsc_sequence.sequence_obj
                     NO-WAIT NO-ERROR.
                IF AVAILABLE gsc_next_sequence
                THEN LEAVE locked-blk.
            END.
            
            ASSIGN
                gsc_sequence.next_value = gsc_next_sequence.next_sequence_value.
    
            {af/sup/afvalidtrg.i &action = "VALIDATE" 
                                 &table  = "gsc_next_sequence"
            }
        end.    /* not multi_transaction */
        
        FOR EACH gsc_next_sequence EXCLUSIVE-LOCK
           WHERE gsc_next_sequence.sequence_obj = gsc_sequence.sequence_obj:

            {af/sup/afvalidtrg.i &action = "DELETE" 
                                 &table  = "gsc_next_sequence"
            }

        END.    /* actual delete next sequence records */
    END.    /* deletion of next sequence records coming ...  */

    IF  gsc_sequence.multi_transaction
    AND NOT CAN-FIND(FIRST gsc_next_sequence
                     WHERE gsc_next_sequence.sequence_obj = gsc_sequence.sequence_obj)
    THEN DO lv_counter = gsc_sequence.next_value TO gsc_sequence.next_value + gsc_sequence.number_of_sequences - 1: /* -1, otherwise creates 1 extra */
        IF lv_counter > gsc_sequence.max_value
        THEN DO:
            ASSIGN
                lv-error   = YES
                lv-errgrp  = "AF":U
                lv-errnum  = 36
                lv-include = "next sequence value|the specified maximum value has been exceeded":U.
            &IF DEFINED(WRITE_TRIGGER)
            &THEN
                RUN error-message (lv-errgrp,lv-errnum,lv-include).
            &ENDIF
        END.
    
        {af/sup/afvalidtrg.i &action = "CREATE" 
                             &table  = "gsc_next_sequence"
        }

        ASSIGN
            gsc_next_sequence.sequence_obj        = gsc_sequence.sequence_obj
            gsc_next_sequence.next_sequence_value = lv_counter.

        {af/sup/afvalidtrg.i &action = "VALIDATE" 
                             &table  = "gsc_next_sequence"
        }

    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


