function successalert() {
    swal({
        title: 'Uspešno uneta faktura.',
        text: '',
        type: 'OK'
    });
};

function erroralertLogin() {
    swal({
        title: 'Greška prilikom logovanja.',
        text: 'Ispravite podatke i pokušajte ponovo.',
        type: 'OK'
    });
}

function erroralert() {
    swal({
        title: 'Greška prilikom unosa.',
        text: 'Ispravite podatke i pokušajte ponovo.',
        type: 'OK'
    });
};

function changepassOK() {
    swal({
        title: 'Lozinka uspešno promenjena.',
        text: 'Lozinka je uspešno promenjena.',
        type: 'OK'
    });
};

function changepassFalse() {
    swal({
        title: 'Greška prilikom promene lozinke.',
        text: 'Ispravite podatke i pokušajte ponovo.',
        type: 'OK'
    });
};

function modalVisibleHide() {
    $("#divModal").hide();
};

function modalVisibleShow() {
    $("#divModal").show();
};
