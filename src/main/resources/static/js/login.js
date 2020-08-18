let token = document.querySelector('input[name="_csrf"]').value;
let loginForm = document.getElementById("login-form");
let uname;
function authenticate() {
    fetch("/authenticate", {
        method: "POST",
        headers: {
            // "Content-Type": "multipart/form-data",
            'X-CSRF-Token': token
        },
        body: new FormData(loginForm)
    }).then(
        function (result) {
            console.log('res:' +JSON.stringify(result, null, 2));
            uname = document.getElementById("inputEmail").value;

            getCurrUser().then(currUser => {
                if (currUser.username == "Guest" || currUser.username != uname) {
                    document.getElementById("fail-alert").style.display = 'block';
                } else {
                    document.getElementById("fail-alert").style.display = 'none';
                    document.getElementById("submit-btn").disabled = true;
                    document.getElementById("inputEmail").disabled = true;
                    document.getElementById("inputPassword").disabled = true;
                    document.getElementById("loggedin-alert").style.display = 'block';
                    
                }
            });
    });
}
function logout() {
    fetch("/logout", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            'X-CSRF-Token': token
        },
    }).then(
        function (result) {
            console.log('res:' +JSON.stringify(result, null, 2));
    });
}

async function getCurrUser() {
    try {
        let result =  await fetch("/currentUser", {
            method: "GET",
            headers: {},
        }).then(result => result.json());
        return result;
    } catch (error) {
        console.log(error);
    }
}

document.addEventListener("DOMContentLoaded", () => {

    document.getElementById("submit-btn").addEventListener("click", authenticate);
    // document.getElementById("logout-btn").addEventListener("click", logout);
    
    getCurrUser().then(currUser => {
        if (currUser.username == "Guest") {

        } else {
            document.getElementById("submit-btn").disabled = true;
            document.getElementById("inputEmail").disabled = true;
            document.getElementById("inputPassword").disabled = true;
            document.getElementById("loggedin-alert").style.display = 'block';
        }
    });

});