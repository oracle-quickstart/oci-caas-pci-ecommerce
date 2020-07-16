let token = document.querySelector('input[name="_csrf"]').value
document.getElementById("submit-btn").addEventListener("click", authenticate);
function authenticate() {
    let uname = document.getElementById("username").value;
    let psw = document.getElementById("password").value;
    let user_auth = {username: uname, password: psw};
    console.log(JSON.stringify(user_auth));
    fetch("/register", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            'X-CSRF-Token': token
        },
        body: JSON.stringify(user_auth)
    }).then(
        function (result) {
            console.log('res:' +JSON.stringify(result, null, 2));
        });
}