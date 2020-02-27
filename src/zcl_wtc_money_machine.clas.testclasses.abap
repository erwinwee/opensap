*"* use this source file for your ABAP unit test classes
*"* use this source file for your ABAP unit test classes
CLASS lcl_wtc_money_machine_cut DEFINITION FOR TESTING
    RISK LEVEL HARMLESS
    DURATION SHORT.

  PRIVATE SECTION.
    DATA: cut TYPE REF TO zcl_wtc_money_machine.
    METHODS setup.

    METHODS assert_change
      IMPORTING iv_amount   TYPE i
                iv_highnote TYPE i
                iv_highcoin TYPE i.

    METHODS verify_notes FOR TESTING RAISING cx_static_check.

    METHODS verify_coins FOR TESTING RAISING cx_static_check.

    METHODS verify_complex FOR TESTING RAISING cx_static_check.

    METHODS verify_negative FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS lcl_wtc_money_machine_cut IMPLEMENTATION.
  METHOD setup.
    cut = NEW zcl_wtc_money_machine( ).
  ENDMETHOD.

  METHOD assert_change.
    DATA(lt_change) = cut->get_change( im_amount = iv_amount ).

    "check conversion
    cl_abap_unit_assert=>assert_not_initial( act = lt_change ).

    CHECK lt_change[] IS NOT INITIAL.
    SORT lt_change BY amount DESCENDING.
    "Check the highest note
    IF iv_highnote NE 0.
      READ TABLE lt_change ASSIGNING FIELD-SYMBOL(<fs_change>)
      WITH KEY type = 'NOTE'.
      "expecting a record
      cl_abap_unit_assert=>assert_equals( act = sy-subrc
                                    exp = 0 ).

      "expecting correct value
      cl_abap_unit_assert=>assert_equals( act = <fs_change>-amount
                                         exp = iv_highnote ).
    ENDIF.

    "check highest coin
    IF iv_highcoin NE 0.
      READ TABLE lt_change ASSIGNING <fs_change>
      WITH KEY type = 'COIN'.

      "expecting a record
      cl_abap_unit_assert=>assert_equals( act = sy-subrc
                                          exp = 0 ).

      "expecting a value
      cl_abap_unit_assert=>assert_equals( act = <fs_change>-amount
                                           exp = iv_highcoin ).

    ENDIF.

    REFRESH lt_change[].
  ENDMETHOD.

  METHOD verify_notes.
    assert_change( iv_amount = 5
                    iv_highnote = 5
                    iv_highcoin = 0 ).

    assert_change( iv_amount = 10
                    iv_highnote = 10
                    iv_highcoin = 0 ).

    assert_change( iv_amount = 20
                    iv_highnote = 20
                    iv_highcoin = 0 ).

    assert_change( iv_amount = 30
                    iv_highnote = 20
                    iv_highcoin = 0 ).

    assert_change( iv_amount = 40
                    iv_highnote = 20
                    iv_highcoin = 0 ).

    assert_change( iv_amount = 50
                    iv_highnote = 50
                    iv_highcoin = 0 ).

    assert_change( iv_amount = 60
                    iv_highnote = 50
                    iv_highcoin = 0 ).

    assert_change( iv_amount = 90
                    iv_highnote = 50
                    iv_highcoin = 0 ).

    assert_change( iv_amount = 100
                    iv_highnote = 100
                    iv_highcoin = 0 ).

    assert_change( iv_amount = 200
                    iv_highnote = 200
                    iv_highcoin = 0 ).

    assert_change( iv_amount = 500
                    iv_highnote = 500
                    iv_highcoin = 0 ).

    assert_change( iv_amount = 550
                    iv_highnote = 500
                    iv_highcoin = 0 ).

    assert_change( iv_amount = 600
                    iv_highnote = 500
                    iv_highcoin = 0 ).

    assert_change( iv_amount = 750
                    iv_highnote = 500
                    iv_highcoin = 0 ).

    assert_change( iv_amount = 1200
                    iv_highnote = 500
                    iv_highcoin = 0 ).

  ENDMETHOD.

  METHOD verify_coins.
    assert_change( iv_amount = 1
                    iv_highnote = 0
                    iv_highcoin = 1 ).
    assert_change( iv_amount = 2
                    iv_highnote = 0
                    iv_highcoin = 2 ).
    assert_change( iv_amount = 3
                    iv_highnote = 0
                    iv_highcoin = 2 ).
    assert_change( iv_amount = 4
                    iv_highnote = 0
                    iv_highcoin = 2 ).
  ENDMETHOD.

  METHOD verify_complex.
    assert_change( iv_amount = 6
                   iv_highnote = 5
                   iv_highcoin = 1 ).
    assert_change( iv_amount = 8
                   iv_highnote = 5
                   iv_highcoin = 2 ).
    assert_change( iv_amount = 15
                   iv_highnote = 10
                   iv_highcoin = 0 ).
    assert_change( iv_amount = 19
                   iv_highnote = 10
                   iv_highcoin = 2 ).
    assert_change( iv_amount = 23
                   iv_highnote = 20
                   iv_highcoin = 2 ).
    assert_change( iv_amount = 86
                   iv_highnote = 50
                   iv_highcoin = 1 ).

    assert_change( iv_amount = 186
                   iv_highnote = 100
                   iv_highcoin = 1 ).

    assert_change( iv_amount = 187
                   iv_highnote = 100
                   iv_highcoin = 2 ).

    assert_change( iv_amount = 171
                   iv_highnote = 100
                   iv_highcoin = 1 ).

    assert_change( iv_amount = 389
                   iv_highnote = 200
                   iv_highcoin = 2 ).

    assert_change( iv_amount = 861
                   iv_highnote = 500
                   iv_highcoin = 1 ).

    assert_change( iv_amount = 894
                   iv_highnote = 500
                   iv_highcoin = 2 ).

    assert_change( iv_amount = 50674
                   iv_highnote = 500
                   iv_highcoin = 2 ).

    assert_change( iv_amount = 30231
                   iv_highnote = 500
                   iv_highcoin = 1 ).

  ENDMETHOD.

  METHOD verify_negative.
    assert_change( iv_amount = -11
                   iv_highnote = 0
                   iv_highcoin = 0 ).

    assert_change( iv_amount = 0
                   iv_highnote = 0
                   iv_highcoin = 0 ).
  ENDMETHOD.

ENDCLASS.
