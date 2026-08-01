;
; Default post-cleanup hook for BBC executables.
;
; An application may provide this symbol itself when returning to the current
; language is unsafe (for example, because it was loaded over language RAM).
;

        .export bbc_exit_hook

        .code

bbc_exit_hook:
        rts
