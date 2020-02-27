*"* use this source file for your ABAP unit test classes
CLASS lcl_wtc_roman_conv_unit DEFINITION FOR TESTING
    RISK LEVEL HARMLESS
    DURATION SHORT.

  PRIVATE SECTION.
    DATA: cut TYPE REF TO zcl_wtc_roman_converter.
    METHODS setup.
    methods i_to_1 for testing RAISING cx_static_check.
    METHODS ii_to_2 FOR TESTING RAISING cx_static_check.
    METHODS iii_to_3 FOR TESTING RAISING cx_static_check.
    METHODS iv_to_4 FOR TESTING RAISING cx_static_check.
    METHODS v_to_5 FOR TESTING RAISING cx_static_check.
    METHODS vi_to_6 FOR TESTING RAISING cx_static_check.
    METHODS vii_to_7 FOR TESTING RAISING cx_static_check.
    METHODS viii_to_8 FOR TESTING RAISING cx_static_check.
    METHODS ix_to_9 FOR TESTING RAISING cx_static_check.
    METHODS x_to_10 FOR TESTING RAISING cx_static_check.
    METHODS l_to_50 FOR TESTING RAISING cx_static_check.
    METHODS c_to_100 FOR TESTING RAISING cx_static_check.
    METHODS d_to_500 FOR TESTING RAISING cx_static_check.
    METHODS m_to_1000 FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS lcl_wtc_roman_conv_unit IMPLEMENTATION.
  METHOD setup.
    "given
    cut = NEW zcl_wtc_roman_converter( ).
  ENDMETHOD.

    method i_to_1.
        data(lv_arabic) = cut->to_arabic( 'I' ).
        cl_Abap_Unit_Assert=>assert_equals( act = lv_arabic
                                            exp = 1 ).
    endmethod.

    method ii_to_2.
        data(lv_arabic) = cut->to_arabic( 'II' ).
        cl_Abap_Unit_Assert=>assert_equals( act = lv_arabic
                                            exp = 2 ).
    endmethod.

  METHOD c_to_100.
        data(lv_arabic) = cut->to_arabic( 'C' ).
        cl_Abap_Unit_Assert=>assert_equals( act = lv_arabic
                                            exp = 100 ).
  ENDMETHOD.

  METHOD d_to_500.
        data(lv_arabic) = cut->to_arabic( 'D' ).
        cl_Abap_Unit_Assert=>assert_equals( act = lv_arabic
                                            exp = 500 ).
  ENDMETHOD.

  METHOD iii_to_3.
        data(lv_arabic) = cut->to_arabic( 'III' ).
        cl_Abap_Unit_Assert=>assert_equals( act = lv_arabic
                                            exp = 3 ).
  ENDMETHOD.

  METHOD iv_to_4.
        data(lv_arabic) = cut->to_arabic( 'IV' ).
        cl_Abap_Unit_Assert=>assert_equals( act = lv_arabic
                                            exp = 4 ).
  ENDMETHOD.

  METHOD ix_to_9.
        data(lv_arabic) = cut->to_arabic( 'IX' ).
        cl_Abap_Unit_Assert=>assert_equals( act = lv_arabic
                                            exp = 9 ).
  ENDMETHOD.

  METHOD l_to_50.
        data(lv_arabic) = cut->to_arabic( 'L' ).
        cl_Abap_Unit_Assert=>assert_equals( act = lv_arabic
                                            exp = 50 ).
  ENDMETHOD.

  METHOD m_to_1000.
        data(lv_arabic) = cut->to_arabic( 'M' ).
        cl_Abap_Unit_Assert=>assert_equals( act = lv_arabic
                                            exp = 1000 ).
  ENDMETHOD.

  METHOD viii_to_8.
        data(lv_arabic) = cut->to_arabic( 'VIII' ).
        cl_Abap_Unit_Assert=>assert_equals( act = lv_arabic
                                            exp = 8 ).
  ENDMETHOD.

  METHOD vii_to_7.
        data(lv_arabic) = cut->to_arabic( 'VII' ).
        cl_Abap_Unit_Assert=>assert_equals( act = lv_arabic
                                            exp = 7 ).
  ENDMETHOD.

  METHOD vi_to_6.
        data(lv_arabic) = cut->to_arabic( 'VI' ).
        cl_Abap_Unit_Assert=>assert_equals( act = lv_arabic
                                            exp = 6 ).
  ENDMETHOD.

  METHOD v_to_5.
        data(lv_arabic) = cut->to_arabic( 'V' ).
        cl_Abap_Unit_Assert=>assert_equals( act = lv_arabic
                                            exp = 5 ).
  ENDMETHOD.

  METHOD x_to_10.
        data(lv_arabic) = cut->to_arabic( 'X' ).
        cl_Abap_Unit_Assert=>assert_equals( act = lv_arabic
                                            exp = 10 ).
  ENDMETHOD.

ENDCLASS.
