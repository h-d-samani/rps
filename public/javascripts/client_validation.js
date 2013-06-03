function allowNumbersOnly(elem) {
    var fld = document.getElementById(elem);
    var strng = fld.value;
    var stripped = strng.replace(/[^0-9]/g, '');
    //strip out non-numeric characters
    if (stripped.length == 0) {
        fld.value = 1;
    }
    else {
        fld.value = stripped;
    }
}