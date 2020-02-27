CLASS zcl_wtc_money_machine DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_change,
             amount TYPE i,
             type   TYPE string,
           END OF ty_change.

    TYPES tt_change TYPE STANDARD TABLE OF ty_change WITH DEFAULT KEY.

    METHODS get_amount_in_coins
      IMPORTING
        !i_amount      TYPE i
      RETURNING
        VALUE(r_value) TYPE i .
    METHODS get_amount_in_notes
      IMPORTING
        i_amount       TYPE i
      RETURNING
        VALUE(r_value) TYPE i .
    METHODS get_change
      IMPORTING
        im_amount       TYPE i
      RETURNING
        VALUE(r_result) TYPE tt_change.

    METHODS get_notes
      IMPORTING
        i_amount        TYPE i
      EXPORTING
        VALUE(e_result) TYPE tt_change
        VALUE(e_remain) TYPE i.

    METHODS get_coins
      IMPORTING
        i_amount        TYPE i
      EXPORTING
        VALUE(e_result) TYPE tt_change
        VALUE(e_remain) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_wtc_money_machine IMPLEMENTATION.


  METHOD get_amount_in_coins.
    r_value = COND #( WHEN i_amount <= 0
                      THEN -1
                      ELSE i_amount MOD 5 ).
  ENDMETHOD.


  METHOD get_amount_in_notes.
    r_value = get_amount_in_coins( i_amount ).
    IF r_value >= 0.
      r_value = i_amount - r_value.
    ENDIF.
  ENDMETHOD.


  METHOD get_change.
    DATA: ls_change    TYPE ty_change,
          lv_amount    TYPE i,
          lv_remainder TYPE i,
          lt_result    TYPE tt_change.

    CLEAR: ls_change,
           lv_amount,
           lv_remainder.

    REFRESH: lt_result[].

    "get the amount in coins
    lv_amount = me->get_amount_in_coins( i_amount = im_amount ).
    IF lv_amount GT 1.
      me->get_coins( EXPORTING
                      i_amount = lv_amount
                     IMPORTING
                      e_result = lt_result
                      e_remain = lv_remainder ).
      APPEND LINES OF lt_result[] TO r_result[].

      WHILE lv_remainder GT 0.
        REFRESH lt_result[].
        lv_amount = lv_remainder.
        lv_remainder = 0.
        me->get_coins( EXPORTING
                        i_amount = lv_amount
                       IMPORTING
                        e_result = lt_result
                        e_remain = lv_remainder ).
        APPEND LINES OF lt_result[] TO r_result[].
      ENDWHILE.
    ELSE.
      ls_change-amount = 1.
      ls_change-type = 'COIN'.
      APPEND ls_change TO r_result[].
      CLEAR ls_change.
    ENDIF.


    CLEAR: ls_change,
           lv_amount,
           lv_remainder.

    REFRESH: lt_result[].

    "get the amount in notes
    lv_amount = me->get_amount_in_notes( i_amount = im_amount ).
    IF lv_amount GT 0.
      me->get_notes( EXPORTING
                      i_amount = lv_amount
                     IMPORTING
                      e_result = lt_result
                      e_remain = lv_remainder ).
      APPEND LINES OF lt_result[] TO r_result[].

      WHILE lv_remainder GT 0.
        REFRESH lt_result[].
        lv_amount = lv_remainder.
        lv_remainder = 0.
        me->get_notes( EXPORTING
                        i_amount = lv_amount
                       IMPORTING
                        e_result = lt_result
                        e_remain = lv_remainder ).
        APPEND LINES OF lt_result[] TO r_result[].
      ENDWHILE.
    ENDIF.
  ENDMETHOD.

  METHOD get_notes.
    DATA: ls_change TYPE ty_change,
          lv_denom  TYPE i,
          lv_iter   TYPE i.
    CLEAR: ls_change,
           lv_denom,
           lv_iter.

    "there can only be on 5 if amount is less than 10
    IF i_amount GE 5 AND i_amount LT 10.

      ls_change-amount = 5.
      ls_change-type = 'NOTE'.
      APPEND ls_change TO e_result[].

      e_remain = i_amount - 5.

      "There can only be one ten in less than 20
    ELSEIF i_amount GE 10 AND i_amount LT 20.

      ls_change-amount = 10.
      ls_change-type = 'NOTE'.
      APPEND ls_change TO e_result[].

      e_remain = i_amount - 10.

      "There can be more than 1 20 in less than 50
    ELSEIF i_amount GE 20 AND i_amount LT 50.
      lv_denom = i_amount DIV 20.

      "iterate for every denomination of 20
      WHILE lv_iter LT lv_denom.
        ls_change-amount = 20.
        ls_change-type = 'NOTE'.
        APPEND ls_change TO e_result[].
        CLEAR ls_change.
        ADD 1 TO lv_iter.
      ENDWHILE.

      e_remain = i_amount - ( lv_denom * 20 ).

      "There can only be one 50 in 99
    ELSEIF i_amount GE 50 AND i_amount LT 100.

      ls_change-amount = 50.
      ls_change-type = 'NOTE'.
      APPEND ls_change TO e_result[].

      e_remain = i_amount - 50.

      "There can only be on 100 in 199
    ELSEIF i_amount GE 100 AND i_amount LT 200.

      ls_change-amount = 100.
      ls_change-type = 'NOTE'.
      APPEND ls_change TO e_result[].

      "Remainder is whatever amount less 100
      e_remain = i_amount - 100.

      "There can be more than one 200 in 499
    ELSEIF i_amount GE 200 AND i_amount LT 500.

      lv_denom = i_amount DIV 200.

      "iterate for every denomination of 20
      WHILE lv_iter LT lv_denom.
        ls_change-amount = 200.
        ls_change-type = 'NOTE'.
        APPEND ls_change TO e_result[].
        CLEAR ls_change.
        ADD 1 TO lv_iter.
      ENDWHILE.

      e_remain = i_amount - ( lv_denom * 200 ).

      "All above 500
    ELSEIF i_amount GE 500.

      lv_denom = i_amount DIV 500.

      "iterate for every denomination of 20
      WHILE lv_iter LT lv_denom.
        ls_change-amount = 500.
        ls_change-type = 'NOTE'.
        APPEND ls_change TO e_result[].
        ADD 1 TO lv_iter.
        CLEAR ls_change.
      ENDWHILE.

      e_remain = i_amount - ( lv_denom * 500 ).

    ENDIF.
  ENDMETHOD.

  METHOD get_coins.
    DATA: ls_change TYPE ty_change,
          lv_denom  TYPE i,
          lv_iter   TYPE i.
    CLEAR: ls_change,
           lv_denom,
           lv_iter.

    IF i_amount GE 2.
      lv_denom = i_amount DIV 2.

      "iterate for every denomination of 20
      WHILE lv_iter LT lv_denom.
        ls_change-amount = 2.
        ls_change-type = 'COIN'.
        APPEND ls_change TO e_result[].
        CLEAR ls_change.
        ADD 1 TO lv_iter.
      ENDWHILE.

      e_remain = i_amount - ( lv_denom * 2 ).
    ELSE.
      ls_change-amount = 1.
      ls_change-type = 'COIN'.
      APPEND ls_change TO e_result[].
      CLEAR ls_change.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
