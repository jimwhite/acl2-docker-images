(in-package "ACL2")

(acl2::ld "centaur/bridge/package.lsp" :dir :system)
(acl2::ld "hacking/hacker-pkg.lsp" :dir :system)
(acl2::ld "hacking/rewrite-code-pkg.lsp" :dir :system)

;;; Basic definitions for the ACL2 bridge

(include-book "centaur/bridge/top" :dir :system :load-compiled-file nil)

;;; To reason about arithmetic

(include-book "arithmetic-5/top" :dir :system)

;;; ACL2s features (CCG termination and Counterexample generation)

(include-book "acl2s/ccg/ccg" :ttags ((:ccg)) :dir :system :load-compiled-file nil)
(acl2::ld "acl2s/ccg/ccg-settings.lsp" :dir :system)

(include-book "acl2s/cgen/top" :dir :system :ttags :all)
(acl2s-defaults :set testing-enabled T)

(include-book "acl2s/definec" :dir :system :ttags :all)

;;; Some testing support

(in-package "ACL2S")

; (defmacro check-true (form)
;   `(with-output
;     :off :all
;     (make-event 
;       (b* (((er res) (with-output! :on error (trans-eval ,form 'check state t)))
;            ((when (not (equal (cdr res) t)))
;             (prog2$
;              (cw "~%Error in CHECK-TRUE: The form evaluates to: ~x0, not T!~%"
;                  (cdr res))
;              (mv nil nil state))))
;         (value '(value-triple :passed)))
;       :check-expansion t)))

; (defmacro check-expect (form1 form2 &key (equiv 'equal))
;   `(with-output
;     :off :all
;     (make-event 
;       (b* (((er res1) (with-output! :on error (trans-eval ,form1 'check= state t)))
;            ((er res2) (with-output! :on error (trans-eval ,form2 'check= state t)))
;            ((when (not (equal (car res1) (car res2))))
;             (prog2$
;              (cw "~%Error in CHECK-EXPECT: The forms return a different number or stobj types.~%")
;              (value '(value-triple :failed))))
;            ((when (not (,equiv (cdr res1) (cdr res2))))
;             (prog2$
;              (cw "~%Error in CHECK-EXPECT: Check failed (values not equal).~
;                    ~%Returned value: ~x0~
;                    ~%Expected value: ~x1~%" (cdr res1) (cdr res2))
;              (value '(value-triple :failed)))))
;         (value '(value-triple :passed)))
;       :check-expansion t)))

(defmacro check-true (form)
  `(with-output
    :off :all
    (make-event 
      (b* ((res ,form)
           ((when (not (equal res t)))
            (prog2$
             (cw "~%Error in CHECK-TRUE: The form evaluates to: ~x0, not T!~%"
                 res)
             (mv nil nil state))))
        (value '(value-triple :passed)))
      :check-expansion t)))

(defmacro check-expect (form1 form2 &key (equiv 'equal))
  `(with-output
    :off :all
    (make-event 
      (b* ((res1 ,form1)
           (res2 ,form2)
           ((when (not (,equiv res1 res2)))
           (prog2$
             (cw "~%Error in CHECK-EXPECT: Check failed (values not equal).~
                   ~%Returned value: ~x0~
                   ~%Expected value: ~x1~%" res1 res2)
             (value '(value-triple :failed)))))
        (value '(value-triple :passed)))
      :check-expansion t)))

(defmacro check-property (form)
  `(thm ,form))

(defmacro defsnapshot (label)
  `(er-progn
    (ubt! (quote ,label))
    (deflabel ,label)))

(deflabel from-the-top)

 ;;; Start bridge

(bridge::start nil)

